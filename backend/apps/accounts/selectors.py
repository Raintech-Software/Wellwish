"""Read queries for accounts, always filtered by the caller."""

from django.conf import settings
from django.utils import timezone

from apps.accounts.models import App, Consent, Device, Session, User
from apps.legal.selectors import consent_versions as legal_consent_versions


def session_is_active(session_id: str, user_id: str, app: str) -> bool:
    """The access token's session (family) still has a live refresh token, and the user is active.
    Called on every patient/partner request (registered in AccountsConfig.ready)."""
    return Session.objects.filter(
        family_id=session_id,
        user_id=user_id,
        app=app,
        user__status=User.Status.ACTIVE,
        revoked_at__isnull=True,
        rotated_at__isnull=True,
        expires_at__gt=timezone.now(),
    ).exists()


def get_user(user_id: str) -> User:
    return User.objects.get(pk=user_id)


# What each app's people accept (§6.20): the legal pages' consent versions, health data's setting.
PATIENT_CONSENTS = ("TERMS", "PRIVACY", "HEALTH_DATA")
PARTNER_CONSENTS = ("PARTNER_TERMS", "PRIVACY")


def current_consent_versions(app: str) -> dict[str, str]:
    versions = {**legal_consent_versions(), "HEALTH_DATA": settings.CONSENT_VERSION_HEALTH_DATA}
    types = PATIENT_CONSENTS if app == App.PATIENT else PARTNER_CONSENTS
    return {t: versions[t] for t in types}


def consents_needed(user_id: str, app: str = App.PATIENT) -> list[tuple[str, str]]:
    """(type, current version) for every consent of this app the user hasn't accepted in its
    current version."""
    current = current_consent_versions(app)
    accepted = set(
        Consent.objects.filter(user_id=user_id, type__in=list(current))
        .values_list("type", "version")
        .distinct()
    )
    return [(t, v) for t, v in current.items() if (t, v) not in accepted]


def push_tokens(user_id: str, app: str) -> list[str]:
    """FCM tokens of the user's phones for one app (for notifications)."""
    return [
        t
        for t in Device.objects.filter(user_id=user_id, app=app).values_list("fcm_token", flat=True)
        if t
    ]


def session_device_id(session_id: str) -> str:
    """The device a session (family) logged in from, for per-device rate limits."""
    row = Session.objects.filter(family_id=session_id).values_list("device_id", flat=True).first()
    return row or session_id


def find_user_by_phone(phone: str) -> User | None:
    return User.objects.filter(phone=phone).first()
