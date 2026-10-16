"""All writes for staff: admin login with password + TOTP, sessions, staff users (§6.4, §9.2).

Login takes two steps:
1. `login(email, password)` → a challenge token (5 min). The first time, also a new TOTP secret
   to scan as a QR code (`TOTP_SETUP`).
2. `verify_totp(challenge, code)` → access token + refresh token (sent as an httpOnly cookie).

Every login, failed login and 2FA setup is written to the audit log.

Sign-in recovery (v2.16): "Trust this browser for 30 days" (the password alone signs in there),
10 one-time recovery codes (using one sets up a new authenticator), a Super Admin's 2FA reset,
and `ww.ps1 manage reset_staff_2fa` on the server when even the last Super Admin is locked out.
"""

import hashlib
import hmac
import logging
import secrets
import time
import uuid
from dataclasses import dataclass, replace
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

import pyotp
from django.conf import settings
from django.contrib.auth.hashers import make_password
from django.contrib.auth.password_validation import validate_password
from django.core.cache import cache
from django.core.exceptions import ValidationError
from django.db import transaction
from django.utils import timezone

from apps.audit.services import record
from apps.staff.models import (
    StaffRecoveryCode,
    StaffRole,
    StaffSession,
    StaffTrustedBrowser,
    StaffUser,
)
from common import crypto
from common.errors import ApiError, NotFound
from common.mail import send_mail
from common.ratelimit import Limit
from common.realtime import send_to_group, session_group
from common.tokens import (
    AccessClaims,
    InvalidToken,
    hash_token,
    issue_access_token,
    issue_challenge,
    new_refresh_token,
    read_challenge,
)

logger = logging.getLogger(__name__)

CHALLENGE_TTL_SECONDS = 5 * 60
RECOVERY_CODE_COUNT = 10
# no 0/o, 1/l/i: easy to read off paper
_RECOVERY_ALPHABET = "abcdefghjkmnpqrstuvwxyz23456789"
TRUSTED_BROWSERS_KEPT = 10
TOTP_ISSUER = "WellWish Admin"
TOTP_INTERVAL = 30
# Only bump last_seen_at once a minute, so every request doesn't write to the database.
TOUCH_EVERY = timedelta(seconds=60)


class InvalidCredentials(ApiError):
    status = 401
    code = "INVALID_CREDENTIALS"
    message = "Wrong email or password."


class LoginLocked(ApiError):
    status = 429
    code = "LOGIN_LOCKED"
    message = "Too many failed sign-in attempts. Try again in 15 minutes."


class LoginExpired(ApiError):
    status = 401
    code = "LOGIN_EXPIRED"
    message = "Sign-in took too long. Please start again."


class TotpInvalid(ApiError):
    status = 401
    code = "TOTP_INVALID"
    message = "That code isn't right. Check your authenticator app."


class RecoveryCodeInvalid(ApiError):
    status = 401
    code = "RECOVERY_CODE_INVALID"
    message = "That recovery code isn't right, or it was used already."


class WrongPassword(ApiError):
    status = 422
    code = "WRONG_PASSWORD"
    message = "That password isn't right."


class StaffSessionInvalid(ApiError):
    status = 401
    code = "SESSION_INVALID"
    message = "Please sign in again."


class StaffSessionIdle(ApiError):
    status = 401
    code = "SESSION_IDLE"
    message = "You were signed out after 30 minutes without activity."


class InvalidStaffUser(ApiError):
    status = 422
    code = "INVALID_STAFF_USER"
    message = "Please check the staff user's details."


LOCK_WINDOW_SECONDS = 15 * 60


def _login_limit() -> Limit:
    """Wrong passwords per email."""
    return Limit("staff:login", settings.STAFF_LOGIN_MAX_FAILURES, LOCK_WINDOW_SECONDS)


def _totp_limit() -> Limit:
    """Wrong 2FA codes per staff member, across all sign-in attempts (so starting a new
    sign-in never gives fresh guesses)."""
    return Limit("staff:totp", settings.STAFF_TOTP_MAX_FAILURES, LOCK_WINDOW_SECONDS)


def _used_challenge_key(jti: str) -> str:
    return f"staff:challenge-used:{jti}"


@dataclass(frozen=True)
class StaffTokens:
    access_token: str
    refresh_token: str
    expires_in: int
    session_expires_at: datetime
    staff: StaffUser
    recovery_codes: list[str] | None = None  # only right after 2FA was set up: shown once
    trust_token: str | None = None  # "Trust this browser": goes into its cookie


@dataclass(frozen=True)
class LoginStep:
    step: str  # TOTP_SETUP | TOTP | SIGNED_IN (a trusted browser)
    challenge_token: str
    otpauth_uri: str | None = None
    secret: str | None = None
    tokens: StaffTokens | None = None


# A real Argon2 hash, so a login for an unknown email takes as long as a wrong password.
_DUMMY_HASH: str | None = None


def _dummy_check() -> None:
    global _DUMMY_HASH
    if _DUMMY_HASH is None:
        _DUMMY_HASH = make_password(uuid.uuid4().hex)
    StaffUser(password_hash=_DUMMY_HASH).check_password("not-the-password")


def login(*, email: str, password: str, ip: str, trust_token: str | None = None) -> LoginStep:
    email = email.strip().lower()
    limit = _login_limit()
    if limit.exceeded(email):
        raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})

    staff = StaffUser.objects.select_related("role").filter(email=email).first()
    if staff is None:
        _dummy_check()
        limit.hit(email)
        raise InvalidCredentials()
    if not staff.check_password(password) or staff.status != StaffUser.Status.ACTIVE:
        limit.hit(email)
        record(staff, "staff.login_failed", staff, ip=ip)
        raise InvalidCredentials()
    # The password limit is only reset after the 2FA code is right (verify_totp).
    totp_limit = _totp_limit()
    if totp_limit.exceeded(str(staff.pk)):
        raise LoginLocked(details={"retryAfterSeconds": totp_limit.retry_after()})

    if staff.totp_confirmed_at is not None and trust_token:
        tokens = _trusted_sign_in(staff, trust_token, ip)
        if tokens is not None:
            return LoginStep("SIGNED_IN", "", tokens=tokens)

    if staff.totp_confirmed_at is None:
        if not staff.totp_secret_enc:
            staff.totp_secret_enc = crypto.encrypt(pyotp.random_base32())
            staff.save(update_fields=["totp_secret_enc", "updated_at"])
        secret = crypto.decrypt(staff.totp_secret_enc)
        uri = pyotp.TOTP(secret).provisioning_uri(name=staff.email, issuer_name=TOTP_ISSUER)
        challenge = issue_challenge(
            "staff_totp", {"staff": str(staff.pk), "setup": True}, CHALLENGE_TTL_SECONDS
        )
        return LoginStep("TOTP_SETUP", challenge, otpauth_uri=uri, secret=secret)
    challenge = issue_challenge("staff_totp", {"staff": str(staff.pk)}, CHALLENGE_TTL_SECONDS)
    return LoginStep("TOTP", challenge)


def _matching_step(secret: str, code: str) -> int | None:
    """The TOTP time step `code` belongs to (now ± 30 s), or None."""
    totp = pyotp.TOTP(secret, interval=TOTP_INTERVAL)
    now = time.time()
    for offset in (0, -1, 1):
        at = now + offset * TOTP_INTERVAL
        if hmac.compare_digest(totp.at(int(at)), code):
            return int(at // TOTP_INTERVAL)
    return None


def verify_totp(
    *, challenge_token: str, code: str, ip: str, trust_browser: bool = False, browser: str = ""
) -> StaffTokens:
    try:
        jti, data = read_challenge(challenge_token, "staff_totp")
    except InvalidToken:
        raise LoginExpired() from None
    if cache.get(_used_challenge_key(jti)):
        raise LoginExpired()  # a challenge works for one sign-in only
    staff_id = str(data.get("staff", ""))
    limit = _totp_limit()
    if limit.exceeded(staff_id):
        raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})

    # After a recovery code (§6.4) the new authenticator's secret travels in the setup challenge
    # only; the account itself has no usable secret until this code confirms it.
    pending = str(data.get("pending") or "") if data.get("setup") else ""
    tokens: StaffTokens | None = None
    failures = 0
    with transaction.atomic():
        staff = (
            StaffUser.objects.select_for_update()
            .select_related("role")
            .filter(pk=staff_id, status=StaffUser.Status.ACTIVE)
            .first()
        )
        if staff is None:
            raise LoginExpired()
        # Checked and counted under the staff row lock, so codes sent together are tried one at
        # a time and can't get past the limit.
        if limit.exceeded(staff_id):
            raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})
        # no secret: the old authenticator was cleared by a recovery code, so no code is right
        secret_enc = pending or staff.totp_secret_enc
        step = _matching_step(crypto.decrypt(secret_enc), code) if secret_enc else None
        already_used = step is not None and step <= (staff.totp_last_step or -1)
        # an emailed code (v2.18) works for the sign-in step it was sent with, once
        emailed = cache.get(_email_code_key(jti)) if data.get("email") else None
        by_email = (
            not (step is not None and not already_used)
            and emailed is not None
            and hmac.compare_digest(emailed, _email_code_digest(staff_id, code.strip()))
        )
        if (step is not None and not already_used) or by_email:
            if pending:
                staff.totp_secret_enc = pending
                staff.totp_confirmed_at = None  # _sign_in confirms it and makes 10 new codes
                staff.save(update_fields=["totp_secret_enc", "totp_confirmed_at", "updated_at"])
            tokens = _sign_in(
                staff,
                None if by_email else step,
                ip,
                trust_browser=trust_browser,
                browser=browser,
            )
            cache.delete(_email_code_key(jti))
            cache.set(_used_challenge_key(jti), 1, timeout=EMAIL_CODE_TTL_SECONDS + 5)
        else:
            failures = limit.hit(staff_id)

    if tokens is None:
        # Recorded outside the transaction, so the audit rows are kept.
        record(staff, "staff.totp_failed", staff, ip=ip)
        if failures >= settings.STAFF_TOTP_MAX_FAILURES:
            record(staff, "staff.locked", staff, reason="Too many wrong 2FA codes", ip=ip)
            raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})
        raise TotpInvalid()
    # Only a complete sign-in (password + code) clears the counters.
    _login_limit().reset(staff.email)
    limit.reset(staff_id)
    return tokens


def _sign_in(
    staff: StaffUser, step: int | None, ip: str, *, trust_browser: bool = False, browser: str = ""
) -> "StaffTokens":
    """The code was right: remember its time step (a code works once) and open a session.
    Right after 2FA was set up, 10 new recovery codes; on request, trust this browser.
    `step` None: an emailed code (v2.18), the authenticator's last step stays as it was."""
    now = timezone.now()
    staff.last_login_at = now
    fields = ["last_login_at", "updated_at"]
    if step is not None:
        staff.totp_last_step = step
        fields.append("totp_last_step")
    codes = None
    if staff.totp_confirmed_at is None:
        staff.totp_confirmed_at = now
        fields.append("totp_confirmed_at")
        record(staff, "staff.totp_setup", staff, ip=ip)
        codes = _new_recovery_codes(staff, ip)
    staff.save(update_fields=fields)
    trust = _trust_browser(staff, ip, browser) if trust_browser else None
    tokens = _issue(staff, uuid.uuid4(), started_at=now, ip=ip)
    how = {"two_factor": True} if step is not None else {"email_code": True}
    record(staff, "staff.login", staff, after=how, ip=ip)
    return replace(tokens, recovery_codes=codes, trust_token=trust)


# --- Sign-in recovery (§6.4, v2.16) ---


def _recovery_hash(staff_id: object, code: str) -> str:
    normal = code.replace("-", "").replace(" ", "").strip().lower()
    message = f"staff-recovery:{staff_id}:{normal}".encode()
    return hmac.new(settings.OTP_HMAC_KEY.encode(), message, hashlib.sha256).hexdigest()


def _new_recovery_codes(staff: StaffUser, ip: str | None) -> list[str]:
    """10 new one-time codes (the old ones stop working). Returned once, kept as hashes."""
    StaffRecoveryCode.objects.filter(staff=staff).delete()
    codes = []
    for _ in range(RECOVERY_CODE_COUNT):
        raw = "".join(secrets.choice(_RECOVERY_ALPHABET) for _ in range(8))
        codes.append(f"{raw[:4]}-{raw[4:]}")
    StaffRecoveryCode.objects.bulk_create(
        [StaffRecoveryCode(staff=staff, code_hash=_recovery_hash(staff.pk, c)) for c in codes]
    )
    # not saved until the admin says so: a page reloaded on the codes screen shows a warning
    staff.recovery_codes_saved_at = None
    staff.save(update_fields=["recovery_codes_saved_at", "updated_at"])
    record(staff, "staff.recovery_codes_created", staff, ip=ip)
    return codes


def confirm_recovery_codes_saved(*, staff_id: str, ip: str) -> StaffUser:
    """The admin said "I've saved them": the panel stops warning that the codes weren't saved."""
    with transaction.atomic():
        staff = StaffUser.objects.select_for_update().select_related("role").get(pk=staff_id)
        if staff.recovery_codes_saved_at is None:
            staff.recovery_codes_saved_at = timezone.now()
            staff.save(update_fields=["recovery_codes_saved_at", "updated_at"])
            record(staff, "staff.recovery_codes_saved", staff, ip=ip)
    return staff


def _trust_browser(staff: StaffUser, ip: str, browser: str) -> str:
    now = timezone.now()
    token = new_refresh_token()
    row = StaffTrustedBrowser.objects.create(
        staff=staff,
        token_hash=hash_token(token),
        expires_at=now + timedelta(days=settings.STAFF_TRUST_DAYS),
        ip=ip or None,
        label=browser[:120],
    )
    record(staff, "staff.browser_trusted", staff, after={"trusted_browser": str(row.pk)}, ip=ip)
    kept = StaffTrustedBrowser.objects.filter(staff=staff, expires_at__gt=now).order_by(
        "-created_at"
    )
    keep = list(kept.values_list("pk", flat=True)[:TRUSTED_BROWSERS_KEPT])
    StaffTrustedBrowser.objects.filter(staff=staff).exclude(pk__in=keep).delete()
    return token


def _trusted_sign_in(staff: StaffUser, trust_token: str, ip: str) -> StaffTokens | None:
    """The right password in a browser the admin trusted (30 days): no 2FA code needed."""
    now = timezone.now()
    with transaction.atomic():
        row = (
            StaffTrustedBrowser.objects.select_for_update()
            .filter(staff=staff, token_hash=hash_token(trust_token), expires_at__gt=now)
            .first()
        )
        if row is None:
            return None
        row.last_used_at = now
        row.save(update_fields=["last_used_at", "updated_at"])
        staff.last_login_at = now
        staff.save(update_fields=["last_login_at", "updated_at"])
        tokens = _issue(staff, uuid.uuid4(), started_at=now, ip=ip)
        # password only: which trusted browser let them skip the 2FA code
        record(staff, "staff.login", staff, after={"via_trusted_browser": str(row.pk)}, ip=ip)
    _login_limit().reset(staff.email)
    _totp_limit().reset(str(staff.pk))
    return tokens


def use_recovery_code(*, challenge_token: str, code: str, ip: str) -> LoginStep:
    """Lost phone: a recovery code instead of the 2FA code. The code is used up, the old
    authenticator stops working (sessions and trusted browsers too) and the admin scans a new
    QR code at once, which brings 10 new codes. The admin and the other Super Admins are told."""
    try:
        jti, data = read_challenge(challenge_token, "staff_totp")
    except InvalidToken:
        raise LoginExpired() from None
    if cache.get(_used_challenge_key(jti)) or data.get("setup"):
        raise LoginExpired()
    staff_id = str(data.get("staff", ""))
    limit = _totp_limit()
    if limit.exceeded(staff_id):
        raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})

    step: LoginStep | None = None
    failures = 0
    with transaction.atomic():
        staff = (
            StaffUser.objects.select_for_update()
            .select_related("role")
            .filter(pk=staff_id, status=StaffUser.Status.ACTIVE)
            .first()
        )
        if staff is None or staff.totp_confirmed_at is None:
            raise LoginExpired()
        if limit.exceeded(staff_id):  # under the lock, like verify_totp
            raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})
        row = (
            StaffRecoveryCode.objects.select_for_update()
            .filter(staff=staff, code_hash=_recovery_hash(staff.pk, code), used_at__isnull=True)
            .first()
        )
        if row is not None:
            row.used_at = timezone.now()
            row.save(update_fields=["used_at", "updated_at"])
            left = StaffRecoveryCode.objects.filter(staff=staff, used_at__isnull=True).count()
            # The old authenticator stops working at once, but the account stays behind the code
            # step: the new secret lives only in this setup challenge until a code from it is
            # confirmed (verify_totp). The password alone never signs in, even if the admin
            # leaves the setup half-done (then: another recovery code, or a Super Admin reset).
            secret = pyotp.random_base32()
            staff.totp_secret_enc = ""
            staff.totp_last_step = None
            staff.save(update_fields=["totp_secret_enc", "totp_last_step", "updated_at"])
            _sign_out_everywhere(staff, StaffSession.RevokeReason.FORCED)
            record(staff, "staff.recovery_code_used", staff, after={"codes_left": left}, ip=ip)
            cache.set(_used_challenge_key(jti), 1, timeout=CHALLENGE_TTL_SECONDS + 5)
            uri = pyotp.TOTP(secret).provisioning_uri(name=staff.email, issuer_name=TOTP_ISSUER)
            challenge = issue_challenge(
                "staff_totp",
                {"staff": staff_id, "setup": True, "pending": crypto.encrypt(secret)},
                CHALLENGE_TTL_SECONDS,
            )
            step = LoginStep("TOTP_SETUP", challenge, otpauth_uri=uri, secret=secret)
            _tell_recovery_used(staff, ip)
        else:
            failures = limit.hit(staff_id)

    if step is None:
        record(staff, "staff.recovery_code_failed", staff, ip=ip)
        if failures >= settings.STAFF_TOTP_MAX_FAILURES:
            record(staff, "staff.locked", staff, reason="Too many wrong codes", ip=ip)
            raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})
        raise RecoveryCodeInvalid()
    _login_limit().reset(staff.email)
    limit.reset(staff_id)
    return step


# --- An emailed code instead of the authenticator code (§6.4, v2.18) ---

EMAIL_CODE_TTL_SECONDS = 10 * 60
EMAIL_CODES_PER_HOUR = 5


class EmailCodeTooSoon(ApiError):
    status = 429
    code = "EMAIL_CODE_TOO_SOON"
    message = "Please wait before asking for another code."


@dataclass(frozen=True)
class EmailCodeSent:
    challenge_token: str  # the sign-in goes on with this one (10 minutes)
    email_masked: str
    resend_after_seconds: int


def _email_code_key(jti: str) -> str:
    return f"staff:email-code:{jti}"


def _email_code_sends_key(staff_id: str) -> str:
    return f"staff:email-code-sends:{staff_id}"


def _email_code_digest(staff_id: str, code: str) -> str:
    message = f"staff-email-code:{staff_id}:{code}".encode()
    return hmac.new(settings.OTP_HMAC_KEY.encode(), message, hashlib.sha256).hexdigest()


def mask_email(email: str) -> str:
    name, _, domain = email.partition("@")
    return f"{name[:1]}•••@{domain}"


def send_email_code(*, challenge_token: str, ip: str) -> EmailCodeSent:
    """Phone lost or not at hand: a 6-digit code to the admin's work email, typed in the same
    box as the authenticator code. Only at the code step of an account with 2FA set up (a first
    setup still scans the QR code). Only an HMAC is kept, with a new 10-minute sign-in step;
    resend after 30 / 60 / 120 s, at most 5 an hour; wrong codes count like wrong 2FA codes."""
    try:
        jti, data = read_challenge(challenge_token, "staff_totp")
    except InvalidToken:
        raise LoginExpired() from None
    if cache.get(_used_challenge_key(jti)) or data.get("setup"):
        raise LoginExpired()
    staff_id = str(data.get("staff", ""))
    staff = StaffUser.objects.filter(pk=staff_id, status=StaffUser.Status.ACTIVE).first()
    if staff is None or staff.totp_confirmed_at is None:
        raise LoginExpired()
    limit = _totp_limit()
    if limit.exceeded(staff_id):
        raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})

    waits: list[int] = settings.OTP_RESEND_WAITS_SECONDS
    now = time.time()
    sends = cache.get(_email_code_sends_key(staff_id)) or {"count": 0, "last": 0.0}
    if sends["count"] >= EMAIL_CODES_PER_HOUR:
        raise EmailCodeTooSoon(
            code="EMAIL_CODE_RATE_LIMITED",
            message="Too many emailed codes this hour. Use a recovery code, or try later.",
        )
    if sends["count"] > 0:
        remaining = int(sends["last"] + waits[min(sends["count"] - 1, len(waits) - 1)] - now)
        if remaining > 0:
            raise EmailCodeTooSoon(details={"retryAfterSeconds": remaining})
    count = sends["count"] + 1
    cache.set(_email_code_sends_key(staff_id), {"count": count, "last": now}, timeout=3600)

    code = f"{secrets.randbelow(10**6):06d}"
    cache.delete(_email_code_key(jti))
    cache.set(_used_challenge_key(jti), 1, timeout=CHALLENGE_TTL_SECONDS + 5)  # one live step
    challenge = issue_challenge(
        "staff_totp", {"staff": staff_id, "email": True}, EMAIL_CODE_TTL_SECONDS
    )
    new_jti, _ = read_challenge(challenge, "staff_totp")
    cache.set(
        _email_code_key(new_jti),
        _email_code_digest(staff_id, code),
        timeout=EMAIL_CODE_TTL_SECONDS,
    )
    send_mail(
        staff.email,
        "WellWish Admin sign-in code",
        f"Your WellWish Admin sign-in code is {code}. It works once, for 10 minutes.\n\n"
        "If you didn't try to sign in just now, someone knows your password: change it, or ask "
        "a Super Admin to disable your account (System → Admin users).",
    )
    record(staff, "staff.email_code_sent", staff, ip=ip)
    return EmailCodeSent(
        challenge_token=challenge,
        email_masked=mask_email(staff.email),
        resend_after_seconds=waits[min(count - 1, len(waits) - 1)],
    )


def _email_staff(emails: list[str], subject: str, text: str) -> None:
    def send() -> None:
        for email in emails:
            try:
                send_mail(email, subject, text)
            except Exception:
                logger.exception("Admin security email failed")

    transaction.on_commit(send, robust=True)


def _tell_recovery_used(staff: StaffUser, ip: str) -> None:
    when = timezone.now().astimezone(ZoneInfo(settings.DISPLAY_TIME_ZONE))
    others = (
        StaffUser.objects.filter(role__code=SUPER_ADMIN, status=StaffUser.Status.ACTIVE)
        .exclude(pk=staff.pk)
        .values_list("email", flat=True)
    )
    _email_staff(
        [staff.email, *others],
        "WellWish Admin: a recovery code was used",
        f"{staff.name} ({staff.email}) signed in to the WellWish admin panel with a recovery code "
        f"on {when:%d %b %Y, %I:%M %p} IST (IP {ip}). Their old authenticator app no longer "
        "works; they are setting up a new one.\n\nIf this wasn't them, a Super Admin should "
        "disable the account at once (System → Admin users).",
    )


def new_recovery_codes(*, staff_id: str, password: str, ip: str) -> list[str]:
    """From the panel: 10 new codes (the old ones stop working). Needs the password, so a
    session left open can't make codes for itself."""
    staff = StaffUser.objects.get(pk=staff_id)
    limit = _login_limit()
    if limit.exceeded(staff.email):
        raise LoginLocked(details={"retryAfterSeconds": limit.retry_after()})
    if not staff.check_password(password):
        limit.hit(staff.email)
        record(staff, "staff.password_check_failed", staff, ip=ip)
        raise WrongPassword()
    with transaction.atomic():
        # locked: two requests at once (a double click, two tabs) must not leave 20 codes
        staff = StaffUser.objects.select_for_update().get(pk=staff.pk)
        return _new_recovery_codes(staff, ip)


@transaction.atomic
def emergency_reset(*, email: str, new_password: str | None) -> StaffUser:
    """`ww.ps1 manage reset_staff_2fa` on the server: when even the last Super Admin can't sign
    in. Clears the authenticator, the recovery codes and trusted browsers, signs them out, and
    optionally sets a new password. Logged as done by the system; the admin gets an email."""
    staff = (
        StaffUser.objects.select_for_update()
        .select_related("role")
        .filter(email=email.strip().lower())
        .first()
    )
    if staff is None:
        raise NotFound()
    fields = ["totp_secret_enc", "totp_confirmed_at", "totp_last_step", "updated_at"]
    if new_password is not None:
        try:
            validate_password(new_password, user=staff)  # type: ignore[arg-type]
        except ValidationError as exc:
            raise InvalidStaffUser(code="WEAK_PASSWORD", message=" ".join(exc.messages)) from None
        staff.set_password(new_password)
        fields.append("password_hash")
    staff.totp_secret_enc = ""
    staff.totp_confirmed_at = None
    staff.totp_last_step = None
    staff.save(update_fields=fields)
    StaffRecoveryCode.objects.filter(staff=staff).delete()
    _sign_out_everywhere(staff, StaffSession.RevokeReason.FORCED)
    _login_limit().reset(staff.email)
    _totp_limit().reset(str(staff.pk))
    record(None, "staff.emergency_reset", staff, after={"new_password": new_password is not None})
    _email_staff(
        [staff.email],
        "WellWish Admin: your sign-in was reset on the server",
        "Your WellWish admin 2FA was reset on the server"
        + (" and a new password was set" if new_password is not None else "")
        + ". At your next sign-in, scan the new QR code with your authenticator app.\n\n"
        "If you didn't ask for this, tell the WellWish team at once.",
    )
    return staff


def _issue(staff: StaffUser, family_id: uuid.UUID, *, started_at: datetime, ip: str) -> StaffTokens:
    refresh = new_refresh_token()
    expires_at = started_at + timedelta(hours=settings.STAFF_SESSION_HOURS)
    StaffSession.objects.create(
        staff=staff,
        family_id=family_id,
        refresh_hash=hash_token(refresh),
        started_at=started_at,
        expires_at=expires_at,
        last_seen_at=timezone.now(),
        ip=ip,
    )
    claims = AccessClaims(
        sub=str(staff.pk), aud="staff", pid=str(staff.pk), role=staff.role.code, sid=str(family_id)
    )
    access, ttl = issue_access_token(claims)
    return StaffTokens(
        access_token=access,
        refresh_token=refresh,
        expires_in=ttl,
        session_expires_at=expires_at,
        staff=staff,
    )


def refresh(*, refresh_token: str, ip: str) -> StaffTokens:
    tokens, error = _rotate(refresh_token, ip)
    if error is not None:
        raise error  # raised after the revocation was committed
    if tokens is None:  # pragma: no cover (one of the two is always set)
        raise StaffSessionInvalid()
    return tokens


@transaction.atomic
def _rotate(refresh_token: str, ip: str) -> tuple[StaffTokens | None, ApiError | None]:
    row = (
        StaffSession.objects.select_for_update()
        .select_related("staff__role")
        .filter(refresh_hash=hash_token(refresh_token))
        .first()
    )
    if row is None or row.revoked_at is not None:
        raise StaffSessionInvalid()
    now = timezone.now()
    if row.rotated_at is not None:
        grace = timedelta(seconds=settings.REFRESH_REUSE_GRACE_SECONDS)
        if now - row.rotated_at > grace:
            _revoke_family(row.family_id, StaffSession.RevokeReason.REUSE_DETECTED)
            return None, StaffSessionInvalid()
        # Used again within seconds: two tabs refreshing together, or the first answer was
        # lost. Not theft: issue another token in the same session below.
    if row.expires_at <= now or row.staff.status != StaffUser.Status.ACTIVE:
        _revoke_family(row.family_id, StaffSession.RevokeReason.DISABLED)
        return None, StaffSessionInvalid()
    if row.last_seen_at < now - timedelta(minutes=settings.STAFF_IDLE_MINUTES):
        _revoke_family(row.family_id, StaffSession.RevokeReason.IDLE)
        return None, StaffSessionIdle()
    if row.rotated_at is None:
        row.rotated_at = now
        row.save(update_fields=["rotated_at", "updated_at"])
    return _issue(row.staff, row.family_id, started_at=row.started_at, ip=ip), None


def _to_sessions(family_ids: list[uuid.UUID], kind: str, reason: str) -> None:
    """Tell the admin's open live sockets (§10.4): `session.revoked` closes them for good,
    `socket.rejoin` makes the panel reconnect (new role, new groups)."""
    ids = [str(family_id) for family_id in family_ids]

    def send() -> None:
        for family_id in ids:
            send_to_group(session_group(family_id), kind, {"reason": reason})

    transaction.on_commit(send, robust=True)


def _revoke_family(family_id: uuid.UUID, reason: str) -> None:
    now = timezone.now()
    StaffSession.objects.filter(family_id=family_id, revoked_at__isnull=True).update(
        revoked_at=now, revoke_reason=reason, updated_at=now
    )
    _to_sessions([family_id], "session.revoked", reason)


def logout(*, refresh_token: str | None, session_id: str | None, ip: str) -> None:
    row = None
    if refresh_token:
        row = StaffSession.objects.filter(refresh_hash=hash_token(refresh_token)).first()
    elif session_id:
        row = StaffSession.objects.filter(family_id=session_id).first()
    if row is None:
        return
    _revoke_family(row.family_id, StaffSession.RevokeReason.LOGOUT)
    record(row.staff, "staff.logout", row.staff, ip=ip)


def touch_session(session_id: str, staff_id: str) -> bool:
    """Session validator for staff requests: active, not past 12 h, not idle for 30 minutes.
    Also records the activity (at most once a minute)."""
    now = timezone.now()
    row = (
        StaffSession.objects.filter(
            family_id=session_id,
            staff_id=uuid.UUID(staff_id),
            staff__status=StaffUser.Status.ACTIVE,
            revoked_at__isnull=True,
            rotated_at__isnull=True,
        )
        .only("id", "expires_at", "last_seen_at")
        .first()
    )
    if row is None or row.expires_at <= now:
        return False
    if row.last_seen_at < now - timedelta(minutes=settings.STAFF_IDLE_MINUTES):
        _revoke_family(uuid.UUID(session_id), StaffSession.RevokeReason.IDLE)
        return False
    if now - row.last_seen_at > TOUCH_EVERY:
        # The whole session (every token row), so any of its refresh tokens sees the activity.
        StaffSession.objects.filter(family_id=session_id, revoked_at__isnull=True).update(
            last_seen_at=now
        )
    return True


@transaction.atomic
def create_staff_user(
    *, name: str, email: str, password: str, role_code: str, actor: StaffUser | None, ip: str | None
) -> StaffUser:
    """Super Admins add staff (Phase 2 page). Also used by the create_staff_user command."""
    email = email.strip().lower()
    role = StaffRole.objects.filter(code=role_code).first()
    if role is None:
        raise InvalidStaffUser(code="UNKNOWN_ROLE", message="Unknown role.")
    if StaffUser.objects.filter(email=email).exists():
        raise InvalidStaffUser(code="EMAIL_TAKEN", message="A staff user with this email exists.")
    staff = StaffUser(name=name.strip(), email=email, role=role)
    try:
        validate_password(password, user=staff)  # type: ignore[arg-type]  # uses .email only
    except ValidationError as exc:
        raise InvalidStaffUser(code="WEAK_PASSWORD", message=" ".join(exc.messages)) from None
    staff.set_password(password)
    staff.save()
    record(actor, "staff.created", staff, after={"email": email, "role": role_code}, ip=ip)
    return staff


# --- Staff users page (§9.1 "Admin users and roles") ---
# Each admin has their own login; a Super Admin gives each one a role. Staff are never deleted
# (the audit log points to them): they are disabled. There must always be one active Super Admin.

SUPER_ADMIN = "SUPER_ADMIN"


def _locked_staff(staff_id: str) -> StaffUser:
    staff = StaffUser.objects.select_for_update().select_related("role").filter(pk=staff_id).first()
    if staff is None:
        raise NotFound()
    return staff


def _not_yourself(actor: StaffUser, staff: StaffUser, what: str) -> None:
    if actor.pk == staff.pk:
        raise InvalidStaffUser(
            code="NOT_YOURSELF", message=f"You can't {what} yourself. Ask another Super Admin."
        )


def _keep_one_super_admin(staff: StaffUser) -> None:
    """Refuse if `staff` is the last active Super Admin (rows locked, so two admins can't
    demote each other at the same moment)."""
    if staff.role.code != SUPER_ADMIN or staff.status != StaffUser.Status.ACTIVE:
        return
    others = (
        StaffUser.objects.select_for_update()
        .filter(role__code=SUPER_ADMIN, status=StaffUser.Status.ACTIVE)
        .exclude(pk=staff.pk)
    )
    if not list(others.values_list("pk", flat=True)):
        raise InvalidStaffUser(
            code="LAST_SUPER_ADMIN", message="There must always be one active Super Admin."
        )


def _sign_out_everywhere(staff: StaffUser, reason: str) -> int:
    """Ends every session and forgets every trusted browser (2FA reset, new password,
    disabled, signed out by an admin)."""
    now = timezone.now()
    StaffTrustedBrowser.objects.filter(staff=staff).delete()
    live = StaffSession.objects.filter(staff=staff, revoked_at__isnull=True)
    families = list(live.values_list("family_id", flat=True).distinct())
    ended = live.update(revoked_at=now, revoke_reason=reason, updated_at=now)
    _to_sessions(families, "session.revoked", reason)
    return ended


@transaction.atomic
def update_staff_user(
    *, actor: StaffUser, staff_id: str, name: str, role_code: str, ip: str
) -> StaffUser:
    """Change the name or role. A new role applies from the next request."""
    staff = _locked_staff(staff_id)
    role = StaffRole.objects.filter(code=role_code).first()
    if role is None:
        raise InvalidStaffUser(code="UNKNOWN_ROLE", message="Unknown role.")
    before = {"name": staff.name, "role": staff.role.code}
    if role.pk != staff.role_id:
        _not_yourself(actor, staff, "change the role of")
        _keep_one_super_admin(staff)
    staff.name = name.strip()
    staff.role = role
    after = {"name": staff.name, "role": role.code}
    changed = [k for k in after if before[k] != after[k]]
    if changed:
        staff.save(update_fields=["name", "role", "updated_at"])
        if "role" in changed:  # their live socket rejoins with the new role's groups
            families = StaffSession.objects.filter(staff=staff, revoked_at__isnull=True)
            _to_sessions(
                list(families.values_list("family_id", flat=True).distinct()),
                "socket.rejoin",
                "ROLE_CHANGED",
            )
        record(
            actor,
            "staff.role_changed" if "role" in changed else "staff.updated",
            staff,
            before={k: before[k] for k in changed},
            after={k: after[k] for k in changed},
            ip=ip,
        )
    return staff


@transaction.atomic
def set_staff_active(*, actor: StaffUser, staff_id: str, active: bool, ip: str) -> StaffUser:
    """Disable (signs them out at once) or enable again."""
    staff = _locked_staff(staff_id)
    status = StaffUser.Status.ACTIVE if active else StaffUser.Status.DISABLED
    if staff.status == status:
        return staff
    if not active:
        _not_yourself(actor, staff, "disable")
        _keep_one_super_admin(staff)
    staff.status = status
    staff.save(update_fields=["status", "updated_at"])
    if not active:
        _sign_out_everywhere(staff, StaffSession.RevokeReason.DISABLED)
    record(actor, "staff.enabled" if active else "staff.disabled", staff, ip=ip)
    return staff


@transaction.atomic
def reset_staff_2fa(*, actor: StaffUser, staff_id: str, ip: str) -> StaffUser:
    """Lost phone: clear the authenticator and the recovery codes. They scan a new QR code at the
    next sign-in (and get new codes)."""
    staff = _locked_staff(staff_id)
    StaffRecoveryCode.objects.filter(staff=staff).delete()
    staff.totp_secret_enc = ""
    staff.totp_confirmed_at = None
    staff.totp_last_step = None
    staff.save(
        update_fields=["totp_secret_enc", "totp_confirmed_at", "totp_last_step", "updated_at"]
    )
    _sign_out_everywhere(staff, StaffSession.RevokeReason.FORCED)
    record(actor, "staff.totp_reset", staff, ip=ip)
    return staff


@transaction.atomic
def set_staff_password(*, actor: StaffUser, staff_id: str, password: str, ip: str) -> StaffUser:
    """Forgotten password: a Super Admin sets a new one and tells them in person."""
    staff = _locked_staff(staff_id)
    try:
        validate_password(password, user=staff)  # type: ignore[arg-type]  # uses .email only
    except ValidationError as exc:
        raise InvalidStaffUser(code="WEAK_PASSWORD", message=" ".join(exc.messages)) from None
    staff.set_password(password)
    staff.save(update_fields=["password_hash", "updated_at"])
    _sign_out_everywhere(staff, StaffSession.RevokeReason.FORCED)
    _login_limit().reset(staff.email)
    record(actor, "staff.password_reset", staff, ip=ip)
    return staff


@transaction.atomic
def force_logout(*, actor: StaffUser, staff_id: str, ip: str) -> int:
    """Sign them out on every device. Returns how many sessions were ended."""
    staff = _locked_staff(staff_id)
    ended = _sign_out_everywhere(staff, StaffSession.RevokeReason.FORCED)
    record(actor, "staff.force_logout", staff, after={"sessions": ended}, ip=ip)
    return ended
