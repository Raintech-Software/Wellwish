"""Email verification codes for partners (ARCHITECTURE §6.3 step 4).

Same rules as phone OTPs (§6.2): 6 digits from `secrets`, only an HMAC is stored (in the
cache, 10 min), 5 tries, resend after 30/60/120 s, at most 5 codes an hour per partner.
The code goes out by email (SES; the console outbox in dev) and is never logged.
"""

import hashlib
import hmac
import secrets
import time
from typing import Any

from django.conf import settings
from django.core.cache import cache

from common.errors import ApiError
from common.ratelimit import Limit

CODE_TTL_SECONDS = 10 * 60
MAX_ATTEMPTS = 5
HOUR = 3600


class EmailCodeError(ApiError):
    status = 400
    code = "EMAIL_CODE_INVALID"
    message = "That code isn't right. Check the email and try again."


class EmailCodeTooSoon(ApiError):
    status = 429
    code = "EMAIL_RESEND_TOO_SOON"
    message = "Please wait before asking for another code."


def _key(user_id: str) -> str:
    return f"partner:email-code:{user_id}"


def _resend_key(user_id: str) -> str:
    return f"partner:email-code:{user_id}:resend"


def _limit() -> Limit:
    return Limit("email-code:user:h", 5, HOUR)


def _digest(user_id: str, email: str, code: str) -> str:
    message = f"email:{user_id}:{email}:{code}".encode()
    return hmac.new(settings.OTP_HMAC_KEY.encode(), message, hashlib.sha256).hexdigest()


def new_code(*, user_id: str, email: str) -> tuple[str, int]:
    """Create and store a code for `email`. Returns (code, seconds before a resend).
    The caller sends it and must not keep or log it."""
    waits: list[int] = settings.OTP_RESEND_WAITS_SECONDS
    now = time.time()
    resend = cache.get(_resend_key(user_id)) or {"count": 0, "last": 0.0}
    if resend["count"] > 0:
        wait = waits[min(resend["count"] - 1, len(waits) - 1)]
        remaining = int(resend["last"] + wait - now)
        if remaining > 0:
            raise EmailCodeTooSoon(details={"retryAfterSeconds": remaining})
    limit = _limit()
    if limit.exceeded(user_id):
        raise EmailCodeTooSoon(
            code="EMAIL_RATE_LIMITED", details={"retryAfterSeconds": limit.retry_after()}
        )
    limit.hit(user_id)
    code = f"{secrets.randbelow(10**6):06d}"
    cache.set(
        _key(user_id),
        {
            "email": email,
            "digest": _digest(user_id, email, code),
            "attempts": 0,
            "expires_at": now + CODE_TTL_SECONDS,
        },
        timeout=CODE_TTL_SECONDS,
    )
    count = resend["count"] + 1
    cache.set(_resend_key(user_id), {"count": count, "last": now}, timeout=HOUR)
    return code, waits[min(count - 1, len(waits) - 1)]


def check_code(*, user_id: str, code: str) -> str:
    """Returns the verified email, or raises. A right code works once."""
    stored: dict[str, Any] | None = cache.get(_key(user_id))
    remaining = int(stored["expires_at"] - time.time()) if stored else 0
    if stored is None or remaining <= 0:
        raise EmailCodeError(
            code="EMAIL_CODE_EXPIRED", message="This code has expired. Ask for a new one."
        )
    stored["attempts"] += 1
    if stored["attempts"] > MAX_ATTEMPTS:
        cache.delete(_key(user_id))
        raise EmailCodeError(
            code="EMAIL_CODE_TOO_MANY_ATTEMPTS", message="Too many wrong tries. Ask for a new code."
        )
    if hmac.compare_digest(stored["digest"], _digest(user_id, stored["email"], code)):
        cache.delete(_key(user_id))
        cache.delete(_resend_key(user_id))
        return str(stored["email"])
    cache.set(_key(user_id), stored, timeout=remaining)  # keeps the original expiry
    raise EmailCodeError(details={"attemptsLeft": MAX_ATTEMPTS - stored["attempts"]})
