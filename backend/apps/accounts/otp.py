"""Phone OTP (ARCHITECTURE §6.2). Used by accounts.services only.

| Rule        | Value                                                                  |
|-------------|------------------------------------------------------------------------|
| Code        | 6 digits from `secrets`                                                |
| Storage     | only an HMAC in the cache (Redis): `otp:{purpose}:{phone}`, 5 min       |
| Wrong tries | 5 per code, then a new code is needed                                  |
| Resend      | after 30 s, then 60 s, then 120 s                                       |
| Limits      | 5/phone/hour, 10/phone/day, 20/IP/hour, 10/device/hour                  |
| Lockout     | 10 wrong codes for a phone in 1 h → locked for 1 h + admin alert event |
| Test numbers| accept OTP_TEST_CODE, no SMS (dev/staging; prod: one store-review no.)  |

The plain code exists only in memory while the SMS is sent, inside the request. It is never
queued, stored or logged.
"""

import hashlib
import hmac
import logging
import secrets
import time
from dataclasses import dataclass

from django.conf import settings
from django.core.cache import cache

from common import events
from common.errors import ApiError
from common.phone import mask_phone
from common.ratelimit import Limit
from common.sms import SMSError, send_sms

logger = logging.getLogger(__name__)

HOUR = 3600
DAY = 24 * HOUR


class OtpError(ApiError):
    status = 400


class OtpLocked(ApiError):
    status = 429
    code = "OTP_LOCKED"
    message = "Too many wrong codes. Try again in an hour."


class OtpRateLimited(ApiError):
    status = 429
    code = "OTP_RATE_LIMITED"
    message = "Too many code requests. Please try again later."


class OtpResendTooSoon(ApiError):
    status = 429
    code = "OTP_RESEND_TOO_SOON"
    message = "Please wait before asking for a new code."


class SmsNotSent(ApiError):
    status = 503
    code = "SMS_NOT_SENT"
    message = "We couldn't send the SMS. Please try again."


def _limits() -> dict[str, Limit]:
    return {
        "phone_hour": Limit("otp:phone:h", settings.OTP_LIMIT_PER_PHONE_HOUR, HOUR),
        "phone_day": Limit("otp:phone:d", settings.OTP_LIMIT_PER_PHONE_DAY, DAY),
        "ip_hour": Limit("otp:ip:h", settings.OTP_LIMIT_PER_IP_HOUR, HOUR),
        "device_hour": Limit("otp:device:h", settings.OTP_LIMIT_PER_DEVICE_HOUR, HOUR),
    }


def _failure_limit() -> Limit:
    return Limit("otp:fail", settings.OTP_LOCK_FAILURES, HOUR)


def _code_key(purpose: str, phone: str) -> str:
    return f"otp:{purpose}:{phone}"


def _attempts_key(purpose: str, phone: str) -> str:
    return f"otp:{purpose}:{phone}:attempts"


def _resend_key(purpose: str, phone: str) -> str:
    return f"otp:{purpose}:{phone}:resend"


def _lock_key(phone: str) -> str:
    return f"otp:lock:{phone}"


def _digest(purpose: str, phone: str, code: str) -> str:
    message = f"{purpose}:{phone}:{code}".encode()
    return hmac.new(settings.OTP_HMAC_KEY.encode(), message, hashlib.sha256).hexdigest()


def is_test_number(phone: str) -> bool:
    return phone in settings.OTP_TEST_NUMBERS


def _check_lock(phone: str) -> None:
    locked_until = cache.get(_lock_key(phone))
    if locked_until:
        raise OtpLocked(details={"retryAfterSeconds": max(1, int(locked_until - time.time()))})


@dataclass(frozen=True)
class OtpSent:
    expires_in_seconds: int
    resend_after_seconds: int
    length: int


def send_code(*, phone: str, purpose: str, device_id: str, ip: str, app_hash: str = "") -> OtpSent:
    """Create, store (as HMAC) and send a new code. `phone` must already be E.164."""
    _check_lock(phone)
    waits: list[int] = settings.OTP_RESEND_WAITS_SECONDS
    now = time.time()

    resend = cache.get(_resend_key(purpose, phone)) or {"count": 0, "last": 0.0}
    if resend["count"] > 0:
        wait = waits[min(resend["count"] - 1, len(waits) - 1)]
        remaining = int(resend["last"] + wait - now)
        if remaining > 0:
            raise OtpResendTooSoon(details={"retryAfterSeconds": remaining})

    limits = _limits()
    idents = {
        "phone_hour": phone,
        "phone_day": phone,
        "ip_hour": ip,
        "device_hour": device_id,
    }
    for name, limit in limits.items():
        if limit.exceeded(idents[name]):
            raise OtpRateLimited(details={"retryAfterSeconds": limit.retry_after()})
    for name, limit in limits.items():
        limit.hit(idents[name])

    test_number = is_test_number(phone)
    code = settings.OTP_TEST_CODE if test_number else f"{secrets.randbelow(10**6):06d}"
    cache.set(
        _code_key(purpose, phone),
        _digest(purpose, phone, code),
        timeout=settings.OTP_TTL_SECONDS,
    )
    cache.delete(_attempts_key(purpose, phone))

    if test_number:
        if settings.APP_ENV == "prod":
            logger.warning("OTP requested for the store-review number %s", mask_phone(phone))
    else:
        try:
            send_sms(phone, "LOGIN_OTP", {"otp": code, "app_hash": app_hash})
        except SMSError:
            cache.delete(_code_key(purpose, phone))
            raise SmsNotSent() from None
    del code

    count = resend["count"] + 1
    cache.set(_resend_key(purpose, phone), {"count": count, "last": now}, timeout=HOUR)
    return OtpSent(
        expires_in_seconds=settings.OTP_TTL_SECONDS,
        resend_after_seconds=waits[min(count - 1, len(waits) - 1)],
        length=settings.OTP_LENGTH,
    )


def verify_code(*, phone: str, purpose: str, code: str) -> None:
    """Raises an ApiError unless `code` is right. A right code can be used once."""
    _check_lock(phone)
    stored = cache.get(_code_key(purpose, phone))
    if stored is None:
        raise OtpError(code="OTP_EXPIRED", message="This code has expired. Ask for a new one.")

    attempts_key = _attempts_key(purpose, phone)
    cache.add(attempts_key, 0, timeout=settings.OTP_TTL_SECONDS)
    attempts = int(cache.incr(attempts_key))
    if attempts > settings.OTP_MAX_ATTEMPTS:
        cache.delete(_code_key(purpose, phone))
        raise OtpError(
            code="OTP_TOO_MANY_ATTEMPTS", message="Too many wrong tries. Ask for a new code."
        )

    if hmac.compare_digest(stored, _digest(purpose, phone, code)):
        if is_test_number(phone) and settings.APP_ENV == "prod":
            logger.warning("Store-review number %s logged in", mask_phone(phone))
        for key in (
            _code_key(purpose, phone),
            attempts_key,
            _resend_key(purpose, phone),
        ):
            cache.delete(key)
        return

    failures = _failure_limit().hit(phone)
    if failures >= settings.OTP_LOCK_FAILURES:
        cache.set(
            _lock_key(phone),
            time.time() + settings.OTP_LOCK_SECONDS,
            timeout=settings.OTP_LOCK_SECONDS,
        )
        cache.delete(_code_key(purpose, phone))
        logger.warning("Phone %s locked after %s wrong OTPs", mask_phone(phone), failures)
        events.publish("otp.locked", {"phone_masked": mask_phone(phone), "purpose": purpose})
        raise OtpLocked(details={"retryAfterSeconds": settings.OTP_LOCK_SECONDS})

    attempts_left = settings.OTP_MAX_ATTEMPTS - attempts
    if attempts_left <= 0:
        cache.delete(_code_key(purpose, phone))
        raise OtpError(
            code="OTP_TOO_MANY_ATTEMPTS", message="Too many wrong tries. Ask for a new code."
        )
    raise OtpError(
        code="OTP_INVALID",
        message="That code isn't right. Check the SMS and try again.",
        details={"attemptsLeft": attempts_left},
    )
