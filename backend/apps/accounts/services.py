"""All writes for accounts: OTP login, Google link, sessions, devices, consents (§6.2, §6.4)."""

import logging
import uuid
from dataclasses import dataclass
from datetime import datetime, timedelta

from django.conf import settings
from django.db import IntegrityError, transaction
from django.db.models import Q
from django.utils import timezone

from apps.accounts import otp
from apps.accounts.google import verify_id_token
from apps.accounts.models import App, Consent, Device, Session, User
from common.auth import partner_role
from common.errors import ApiError, Conflict
from common.phone import InvalidPhone, normalize_indian_mobile
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

# OTP purpose → the app the login is for
PURPOSE_APP = {"login": App.PATIENT, "partner_primary": App.PARTNER}
GOOGLE_LINK_TTL_SECONDS = 10 * 60


class InvalidPhoneNumber(ApiError):
    status = 422
    code = "INVALID_PHONE"
    message = "Enter a valid 10-digit Indian mobile number."


class AccountBlocked(ApiError):
    status = 403
    code = "ACCOUNT_BLOCKED"
    message = "This account is blocked. Please contact WellWish support."


class SessionInvalid(ApiError):
    status = 401
    code = "SESSION_INVALID"
    message = "Please log in again."


class SessionRevoked(ApiError):
    status = 401
    code = "SESSION_REVOKED"
    message = "You were logged out. Please log in again."


class ConsentVersionChanged(Conflict):
    code = "CONSENT_VERSION_CHANGED"
    message = "The terms were updated. Please read them again."


@dataclass(frozen=True)
class TokenPair:
    access_token: str
    refresh_token: str
    expires_in: int


@dataclass(frozen=True)
class LoginResult:
    tokens: TokenPair
    user: User
    is_new_user: bool


@dataclass(frozen=True)
class GoogleLoginResult:
    tokens: TokenPair | None
    google_link_token: str | None


def _phone(raw: str) -> str:
    try:
        return normalize_indian_mobile(raw)
    except InvalidPhone:
        raise InvalidPhoneNumber() from None


# --- The account deletion page (§6.20): an SMS code proves the number; nobody is logged in ---

DELETION_PAGE_PURPOSE = "account_deletion"


def send_deletion_code(*, phone: str, ip: str) -> str:
    """Same code rules and limits as a login. Sent whether or not an account uses the number
    (the page doesn't tell strangers). Returns the number in E.164."""
    e164 = _phone(phone)
    # per IP: every visitor of the page would otherwise share one "device"
    otp.send_code(phone=e164, purpose=DELETION_PAGE_PURPOSE, device_id=f"web-{ip}", ip=ip)
    return e164


def verify_deletion_code(*, phone: str, code: str) -> str | None:
    """The user id behind the number once the code is right; None if no account uses it."""
    otp.verify_code(phone=phone, purpose=DELETION_PAGE_PURPOSE, code=code)
    user = User.objects.filter(phone=phone, status=User.Status.ACTIVE).first()
    return str(user.pk) if user else None


# --- OTP login ---


def send_login_otp(
    *, phone: str, purpose: str, device_id: str, ip: str, app_hash: str = ""
) -> otp.OtpSent:
    return otp.send_code(
        phone=_phone(phone), purpose=purpose, device_id=device_id, ip=ip, app_hash=app_hash
    )


def verify_login_otp(
    *,
    phone: str,
    code: str,
    purpose: str,
    device_id: str,
    google_link_token: str | None = None,
    language: str | None = None,
) -> LoginResult:
    """Check the code, then log in to the app the purpose belongs to (patient or partner). A new
    account starts in the app's language (`language`, the phone's; §5)."""
    e164 = _phone(phone)
    # Outside the transaction: a wrong code raises, and the lock alert it publishes
    # (on commit) must not be rolled back with it.
    otp.verify_code(phone=e164, purpose=purpose, code=code)
    return _log_in(e164, purpose, device_id, google_link_token, language)


@transaction.atomic
def _log_in(
    e164: str,
    purpose: str,
    device_id: str,
    google_link_token: str | None,
    language: str | None = None,
) -> LoginResult:
    user, is_new = User.objects.get_or_create(phone=e164)
    # Lock the row: a nightly account erase (which also locks it) finishes first. If it just
    # anonymised this user, the number is free again and this login gets a new, empty account.
    user = User.objects.select_for_update().get(pk=user.pk)
    if user.phone != e164:
        user, is_new = User.objects.get_or_create(phone=e164)
    if user.status != User.Status.ACTIVE:
        raise AccountBlocked()
    if user.phone_verified_at is None:
        user.phone_verified_at = timezone.now()
        user.save(update_fields=["phone_verified_at", "updated_at"])
    if is_new and language:
        set_language(user=user, language=language)

    app = PURPOSE_APP[purpose]
    if google_link_token:
        if app != App.PATIENT:
            raise ApiError(code="GOOGLE_NOT_ALLOWED", message="Google sign-in is for patients.")
        _link_google(user, google_link_token)

    if app == App.PATIENT:
        from apps.patients.selectors import is_blocked
        from apps.patients.services import ensure_profile

        if is_blocked(str(user.pk)):
            raise AccountBlocked()  # blocked from the patient app by an admin (§9.1)
        ensure_profile(user)
    if app == App.PARTNER:
        from apps.partners.services import cancel_deletion_on_login

        cancel_deletion_on_login(str(user.pk))  # logging in again keeps the account (§6.20)
    tokens = create_session(user, app, device_id)
    return LoginResult(tokens=tokens, user=user, is_new_user=is_new)


# --- Google sign-in (patients only) ---


@transaction.atomic
def google_login(*, id_token: str, device_id: str) -> GoogleLoginResult:
    """A known Google account with a verified phone is logged in. Otherwise the app verifies a
    phone by OTP and sends `google_link_token` back with the code (§6.2)."""
    identity = verify_id_token(id_token)
    user = User.objects.filter(google_sub=identity.sub).first()
    if user is not None and user.phone_verified_at is not None:
        from apps.patients.selectors import is_blocked
        from apps.patients.services import ensure_profile

        if user.status != User.Status.ACTIVE or is_blocked(str(user.pk)):
            raise AccountBlocked()
        ensure_profile(user)
        tokens = create_session(user, App.PATIENT, device_id)
        return GoogleLoginResult(tokens=tokens, google_link_token=None)
    link = issue_challenge(
        "google_link", {"sub": identity.sub, "email": identity.email}, GOOGLE_LINK_TTL_SECONDS
    )
    return GoogleLoginResult(tokens=None, google_link_token=link)


def _link_google(user: User, link_token: str) -> None:
    try:
        _, data = read_challenge(link_token, "google_link")
    except InvalidToken:
        raise ApiError(
            code="GOOGLE_LINK_EXPIRED", message="Google sign-in expired. Please start again."
        ) from None
    sub = str(data["sub"])
    if user.google_sub == sub:
        return
    if user.google_sub or User.objects.filter(google_sub=sub).exclude(pk=user.pk).exists():
        raise Conflict(
            code="GOOGLE_ALREADY_LINKED",
            message="This phone or Google account is already linked to another login.",
        )
    user.google_sub = sub
    fields = ["google_sub", "updated_at"]
    if not user.email and data.get("email"):
        user.email = str(data["email"])
        fields.append("email")
    user.save(update_fields=fields)


# --- Sessions ---


def _claims(user: User, app: str, family_id: uuid.UUID) -> AccessClaims:
    # patient_profiles and partner_profiles use the user id as their key, so pid = user id
    role = "PATIENT" if app == App.PATIENT else partner_role(str(user.pk))
    return AccessClaims(sub=str(user.pk), aud=app, pid=str(user.pk), role=role, sid=str(family_id))


def _issue(user: User, app: str, device_id: str, family_id: uuid.UUID) -> TokenPair:
    refresh = new_refresh_token()
    Session.objects.create(
        user=user,
        app=app,
        device_id=device_id,
        family_id=family_id,
        refresh_hash=hash_token(refresh),
        expires_at=timezone.now() + timedelta(days=settings.REFRESH_TOKEN_TTL_DAYS),
    )
    access, ttl = issue_access_token(_claims(user, app, family_id))
    return TokenPair(access_token=access, refresh_token=refresh, expires_in=ttl)


def create_session(user: User, app: str, device_id: str) -> TokenPair:
    """A new login. Partners keep one active device: their older sessions are logged out (§6.4)."""
    if app == App.PARTNER:
        families = list(
            Session.objects.filter(user=user, app=App.PARTNER, revoked_at__isnull=True)
            .values_list("family_id", flat=True)
            .distinct()
        )
        if families:
            _revoke_families(families, Session.RevokeReason.LOGGED_IN_ELSEWHERE)
    return _issue(user, app, device_id, uuid.uuid4())


def refresh_session(refresh_token: str) -> TokenPair:
    """Rotate: the used token is spent and a new one is issued in the same family. A spent token
    used again revokes the whole family, because someone may have copied it."""
    tokens = _rotate(refresh_token)
    if tokens is None:
        # The revocation is committed by now; only then answer with the error.
        raise SessionRevoked(details={"reason": Session.RevokeReason.REUSE_DETECTED})
    return tokens


@transaction.atomic
def _rotate(refresh_token: str) -> TokenPair | None:
    """None = reuse detected (the family was revoked)."""
    row = (
        Session.objects.select_for_update()
        .select_related("user")
        .filter(refresh_hash=hash_token(refresh_token))
        .first()
    )
    if row is None:
        raise SessionInvalid()
    if row.revoked_at is not None:
        raise SessionRevoked(details={"reason": row.revoke_reason})
    now = timezone.now()
    grace = timedelta(seconds=settings.REFRESH_REUSE_GRACE_SECONDS)
    if row.rotated_at is not None and now - row.rotated_at > grace:
        _revoke_families([row.family_id], Session.RevokeReason.REUSE_DETECTED)
        logger.warning("Refresh token reused: session family %s revoked", row.family_id)
        return None
    # A spent token used again within the grace period: the app's first answer was lost on a
    # weak network. Not theft: another token in the same session is issued below.
    if row.expires_at <= now:
        raise SessionInvalid()
    if row.user.status != User.Status.ACTIVE:
        raise AccountBlocked()
    if row.app == App.PATIENT:
        from apps.patients.selectors import is_blocked

        if is_blocked(str(row.user_id)):
            raise AccountBlocked()
    if row.rotated_at is None:
        row.rotated_at = now
        row.save(update_fields=["rotated_at", "updated_at"])
    return _issue(row.user, row.app, row.device_id, row.family_id)


def _revoke_families(family_ids: list[uuid.UUID], reason: str) -> None:
    now = timezone.now()
    ended = set(
        Session.objects.filter(family_id__in=family_ids).values_list("user_id", "app", "device_id")
    )
    Session.objects.filter(family_id__in=family_ids, revoked_at__isnull=True).update(
        revoked_at=now, revoke_reason=reason, updated_at=now
    )
    _forget_logged_out_devices(ended)

    def notify() -> None:
        for family_id in family_ids:
            send_to_group(session_group(str(family_id)), "session.revoked", {"reason": reason})

    transaction.on_commit(notify)


def logout(*, session_id: str) -> None:
    _revoke_families([uuid.UUID(session_id)], Session.RevokeReason.LOGOUT)


def logout_all(*, user_id: str, app: str) -> None:
    families = list(
        Session.objects.filter(user_id=user_id, app=app, revoked_at__isnull=True)
        .values_list("family_id", flat=True)
        .distinct()
    )
    _revoke_families(families, Session.RevokeReason.LOGOUT_ALL)


def revoke_user_sessions(*, user_id: str, reason: str, app: str | None = None) -> None:
    """For other apps (a suspended partner, a blocked patient, a deleted patient account): log
    out everywhere at once, in one app or in both."""
    sessions = Session.objects.filter(user_id=user_id, revoked_at__isnull=True)
    if app:
        sessions = sessions.filter(app=app)
    families = list(sessions.values_list("family_id", flat=True).distinct())
    _revoke_families(families, reason)


def lock_user(user_id: str) -> None:
    """Lock the user row, as a login does first (inside the caller's transaction). Other apps'
    jobs that end in erasing a login (§6.20) take it first too, so the two never deadlock."""
    User.objects.select_for_update().filter(pk=user_id).values_list("pk").first()


@transaction.atomic
def erase_patient_account(*, user_id: str, keep_user: bool) -> None:
    """Account deletion (§12): forget the patient app's phones and sessions. Unless the person
    is also a partner, the user row is anonymised: the phone number is freed (a new login makes
    a new, empty account), the email and Google link are removed. Consent records stay (proof
    of what was accepted)."""
    erase_app_account(user_id=user_id, app=App.PATIENT, keep_user=keep_user)


@transaction.atomic
def erase_app_account(*, user_id: str, app: str, keep_user: bool) -> None:
    """One app's account is erased (a patient's §12, a partner's §6.20). `keep_user`: the
    person still uses the other app, so only this app's sessions and phones go; otherwise the
    user row is anonymised too."""
    if keep_user:
        revoke_user_sessions(user_id=user_id, reason=Session.RevokeReason.ACCOUNT_DELETED, app=app)
        Session.objects.filter(user_id=user_id, app=app).delete()
        Device.objects.filter(user_id=user_id, app=app).delete()
        return
    revoke_user_sessions(user_id=user_id, reason=Session.RevokeReason.ACCOUNT_DELETED)
    Session.objects.filter(user_id=user_id).delete()
    Device.objects.filter(user_id=user_id).delete()
    user = User.objects.select_for_update().get(pk=user_id)
    user.phone = f"x{uuid.uuid4().hex[:15]}"  # not a phone number: can never log in
    user.phone_verified_at = None
    user.email = ""
    user.google_sub = None
    user.status = User.Status.DELETED
    user.is_active = False
    user.save(
        update_fields=[
            "phone",
            "phone_verified_at",
            "email",
            "google_sub",
            "status",
            "is_active",
            "updated_at",
        ]
    )


# --- Devices, consents, language ---


SESSIONS_KEPT = timedelta(days=30)


def delete_old_sessions(*, now: datetime | None = None) -> int:
    """Every night (PHASES 9.11): session rows revoked or expired more than 30 days ago (each
    refresh adds a row). Reuse detection only needs a family while its tokens could still be
    used, and that ends when they expire."""
    cutoff = (now or timezone.now()) - SESSIONS_KEPT
    deleted, _ = Session.objects.filter(
        Q(revoked_at__lt=cutoff) | Q(expires_at__lt=cutoff)
    ).delete()
    return deleted


def _forget_logged_out_devices(devices: set[tuple[uuid.UUID, str, str]]) -> None:
    """A phone with no active session for that user and app gets no more push messages."""
    now = timezone.now()
    for user_id, app, device_id in devices:
        still_logged_in = Session.objects.filter(
            user_id=user_id,
            app=app,
            device_id=device_id,
            revoked_at__isnull=True,
            rotated_at__isnull=True,
            expires_at__gt=now,
        ).exists()
        if not still_logged_in:
            Device.objects.filter(user_id=user_id, app=app, device_id=device_id).delete()


@transaction.atomic
def register_device(
    *, user_id: str, app: str, device_id: str, platform: str, app_version: str, fcm_token: str
) -> Device:
    if fcm_token:
        # One push token = one phone and one person: if the phone changed hands, the
        # previous account must not keep sending to it.
        Device.objects.filter(fcm_token=fcm_token).exclude(
            user_id=user_id, app=app, device_id=device_id
        ).delete()
    device, _ = Device.objects.update_or_create(
        user_id=user_id,
        app=app,
        device_id=device_id,
        defaults={"platform": platform, "app_version": app_version, "fcm_token": fcm_token},
    )
    return device


def accept_consents(
    *, user_id: str, items: list[tuple[str, str]], ip: str, app: str = App.PATIENT
) -> None:
    """Store each (type, version) the user accepted. Only this app's consents, and only their
    current version, can be accepted."""
    from apps.accounts.selectors import current_consent_versions

    current = current_consent_versions(app)
    now = timezone.now()
    rows = []
    for consent_type, version in items:
        if current.get(consent_type) != version:
            raise ConsentVersionChanged(details={"type": consent_type})
        rows.append(
            Consent(user_id=user_id, type=consent_type, version=version, accepted_at=now, ip=ip)
        )
    Consent.objects.bulk_create(rows)


def set_language(*, user: User, language: str) -> None:
    if user.language != language:
        user.language = language
        user.save(update_fields=["language", "updated_at"])


def forget_push_tokens(tokens: list[str]) -> None:
    """FCM said these tokens are dead (app uninstalled): stop sending to them."""
    if tokens:
        Device.objects.filter(fcm_token__in=tokens).update(fcm_token="")


def get_or_create_user(phone: str) -> tuple[User, bool]:
    """For a partner added by an admin (§6.3): the user exists before their first login.
    The phone is verified at that first OTP login."""
    user = User.objects.filter(phone=phone).first()
    if user is not None:
        return user, False
    return User.objects.create_user(phone), True


def lock_or_create_user(phone: str) -> User:
    """`get_or_create_user`, then the user row locked until the caller's transaction ends (a
    temporary assign, §6.19): two admins typing the same new number at once are served one
    after the other instead of the second failing on the duplicate."""
    try:
        with transaction.atomic():
            user, _ = get_or_create_user(phone)
    except IntegrityError:  # the other admin created it just now
        user = User.objects.get(phone=phone)
    return User.objects.select_for_update().get(pk=user.pk)
