"""Sessions and access checks (ARCHITECTURE §6.4, §6.5, PHASES 1.3 to 1.6, 1.20)."""

from datetime import timedelta

import pytest
from django.utils import timezone

from apps.accounts.models import Session, User
from apps.patients.models import Member, PatientProfile
from common.tokens import AccessClaims, issue_access_token
from conftest import TEST_NUMBER, make_staff, otp_login, staff_login

pytestmark = pytest.mark.django_db


def error(resp) -> dict:
    return resp.json()["error"]


def test_first_patient_login_creates_profile_and_self_member(api):
    tokens = otp_login(api)
    assert tokens["isNewUser"] is True
    user = User.objects.get(phone=TEST_NUMBER)
    assert user.phone_verified_at is not None
    assert PatientProfile.objects.filter(user=user).exists()
    assert Member.objects.filter(owner=user, relation="SELF").count() == 1

    again = otp_login(api)
    assert again["isNewUser"] is False
    assert Member.objects.filter(owner=user, relation="SELF").count() == 1


def test_access_token_works_until_logout(api):
    tokens = otp_login(api)
    assert api.get("/patient/me", token=tokens["accessToken"]).status_code == 200
    assert api.post("/auth/logout", token=tokens["accessToken"]).status_code == 200
    assert api.get("/patient/me", token=tokens["accessToken"]).status_code == 401
    resp = api.post("/auth/refresh", {"refreshToken": tokens["refreshToken"]})
    assert resp.status_code == 401
    assert error(resp)["code"] == "SESSION_REVOKED"


def test_refresh_rotates_the_token(api):
    first = otp_login(api)
    resp = api.post("/auth/refresh", {"refreshToken": first["refreshToken"]})
    assert resp.status_code == 200
    second = resp.json()
    assert second["refreshToken"] != first["refreshToken"]
    assert second["accessToken"] != first["accessToken"]
    assert api.get("/patient/me", token=second["accessToken"]).status_code == 200
    # still the same session family (sid)
    assert Session.objects.values("family_id").distinct().count() == 1
    assert Session.objects.count() == 2


def _age_rotation(seconds: int) -> None:
    Session.objects.filter(rotated_at__isnull=False).update(
        rotated_at=timezone.now() - timedelta(seconds=seconds)
    )


def test_reusing_a_refresh_token_revokes_the_whole_family(api):
    first = otp_login(api)
    second = api.post("/auth/refresh", {"refreshToken": first["refreshToken"]}).json()
    _age_rotation(31)  # past the 30 s retry grace

    reuse = api.post("/auth/refresh", {"refreshToken": first["refreshToken"]})
    assert reuse.status_code == 401
    assert error(reuse) == {
        "code": "SESSION_REVOKED",
        "message": "You were logged out. Please log in again.",
        "details": {"reason": "REUSE_DETECTED"},
    }
    # the thief's and the owner's newer tokens are dead too
    assert api.post("/auth/refresh", {"refreshToken": second["refreshToken"]}).status_code == 401
    assert api.get("/patient/me", token=second["accessToken"]).status_code == 401
    assert set(Session.objects.values_list("revoke_reason", flat=True)) == {"REUSE_DETECTED"}


def test_a_quick_retry_with_the_same_refresh_token_is_not_theft(api):
    """The first answer was lost on a weak network: the app retries with the token it has."""
    first = otp_login(api)
    lost = api.post("/auth/refresh", {"refreshToken": first["refreshToken"]})
    assert lost.status_code == 200
    retry = api.post("/auth/refresh", {"refreshToken": first["refreshToken"]})
    assert retry.status_code == 200
    assert api.get("/patient/me", token=retry.json()["accessToken"]).status_code == 200
    assert not Session.objects.filter(revoked_at__isnull=False).exists()
    # …and the retried token keeps working afterwards
    again = api.post("/auth/refresh", {"refreshToken": retry.json()["refreshToken"]})
    assert again.status_code == 200


def test_unknown_or_expired_refresh_token(api):
    tokens = otp_login(api)
    assert error(api.post("/auth/refresh", {"refreshToken": "nope"}))["code"] == "SESSION_INVALID"
    Session.objects.update(expires_at=timezone.now() - timedelta(seconds=1))
    resp = api.post("/auth/refresh", {"refreshToken": tokens["refreshToken"]})
    assert error(resp)["code"] == "SESSION_INVALID"
    assert api.get("/patient/me", token=tokens["accessToken"]).status_code == 401


def test_partner_token_is_rejected_on_patient_routes_and_back(api):
    patient = otp_login(api, purpose="login")
    partner = otp_login(api, purpose="partner_primary", device_id="partner-dev-1")

    assert api.get("/patient/me", token=partner["accessToken"]).status_code == 401
    assert api.get("/partner/me", token=patient["accessToken"]).status_code == 401
    assert api.get("/patient/me", token=patient["accessToken"]).status_code == 200
    assert api.get("/partner/me", token=partner["accessToken"]).status_code == 200
    # neither works on the admin routes
    assert api.get("/admin/me", token=patient["accessToken"]).status_code == 401
    assert api.get("/admin/me", token=partner["accessToken"]).status_code == 401


def test_patient_and_partner_sessions_are_separate(api):
    """One person can use both apps (§6.1). Logging in to one doesn't log out the other."""
    patient = otp_login(api, purpose="login")
    otp_login(api, purpose="partner_primary", device_id="partner-dev-1")
    assert api.get("/patient/me", token=patient["accessToken"]).status_code == 200


def test_staff_token_is_rejected_on_app_routes(api, staff_roles):
    staff = staff_login(api, make_staff(staff_roles))
    assert api.get("/patient/me", token=staff.access_token).status_code == 401
    assert api.get("/partner/me", token=staff.access_token).status_code == 401


def test_missing_tampered_and_expired_access_tokens(api, settings):
    tokens = otp_login(api)
    assert api.get("/patient/me").status_code == 401
    assert api.get("/patient/me", token=tokens["accessToken"] + "x").status_code == 401

    original_key = settings.JWT_SIGNING_KEY
    settings.JWT_SIGNING_KEY = "another-signing-key-at-least-32-bytes-long"
    assert api.get("/patient/me", token=tokens["accessToken"]).status_code == 401
    settings.JWT_SIGNING_KEY = original_key

    user = User.objects.get(phone=TEST_NUMBER)
    sid = str(Session.objects.get(user=user).family_id)
    settings.ACCESS_TOKEN_TTL_SECONDS = -5
    expired, _ = issue_access_token(
        AccessClaims(sub=str(user.pk), aud="patient", pid=str(user.pk), role="PATIENT", sid=sid)
    )
    resp = api.get("/patient/me", token=expired)
    assert resp.status_code == 401
    assert error(resp)["code"] == "UNAUTHORIZED"


def test_partner_has_one_active_device(api):
    first = otp_login(api, purpose="partner_primary", device_id="partner-phone-a")
    second = otp_login(api, purpose="partner_primary", device_id="partner-phone-b")

    assert api.get("/partner/me", token=first["accessToken"]).status_code == 401
    resp = api.post("/auth/refresh", {"refreshToken": first["refreshToken"]})
    assert error(resp)["code"] == "SESSION_REVOKED"
    assert error(resp)["details"] == {"reason": "LOGGED_IN_ELSEWHERE"}
    assert api.get("/partner/me", token=second["accessToken"]).status_code == 200


def test_patients_can_use_many_devices(api):
    first = otp_login(api, device_id="patient-phone-a")
    otp_login(api, device_id="patient-tablet-b")
    assert api.get("/patient/me", token=first["accessToken"]).status_code == 200


def test_logout_all_ends_every_session_of_that_app(api):
    a = otp_login(api, device_id="patient-phone-a")
    b = otp_login(api, device_id="patient-tablet-b")
    partner = otp_login(api, purpose="partner_primary", device_id="partner-phone-a")
    assert api.post("/auth/logout-all", token=a["accessToken"]).status_code == 200
    assert api.get("/patient/me", token=a["accessToken"]).status_code == 401
    assert api.get("/patient/me", token=b["accessToken"]).status_code == 401
    assert api.get("/partner/me", token=partner["accessToken"]).status_code == 200


def test_blocked_user_is_logged_out_and_cannot_log_in(api):
    tokens = otp_login(api)
    User.objects.filter(phone=TEST_NUMBER).update(status=User.Status.BLOCKED)
    assert api.get("/patient/me", token=tokens["accessToken"]).status_code == 401
    assert (
        error(api.post("/auth/refresh", {"refreshToken": tokens["refreshToken"]}))["code"]
        == "ACCOUNT_BLOCKED"
    )
    api.post("/auth/otp/send", {"phone": TEST_NUMBER, "purpose": "login", "deviceId": "dev-00001"})
    resp = api.post(
        "/auth/otp/verify",
        {"phone": TEST_NUMBER, "otp": "123456", "purpose": "login", "deviceId": "dev-00001"},
    )
    assert resp.status_code == 403
    assert error(resp)["code"] == "ACCOUNT_BLOCKED"


def test_access_token_claims(api):
    import jwt

    tokens = otp_login(api)
    claims = jwt.decode(tokens["accessToken"], options={"verify_signature": False})
    user = User.objects.get(phone=TEST_NUMBER)
    assert claims["aud"] == "patient"
    assert claims["sub"] == str(user.pk)
    assert claims["pid"] == str(user.pk)
    assert claims["role"] == "PATIENT"
    assert claims["sid"] == str(Session.objects.get(user=user).family_id)
    assert claims["exp"] - claims["iat"] == 15 * 60
    assert tokens["expiresIn"] == 900

    partner = otp_login(api, purpose="partner_primary", device_id="partner-phone-a")
    partner_claims = jwt.decode(partner["accessToken"], options={"verify_signature": False})
    assert partner_claims["aud"] == "partner"
    assert partner_claims["role"] is None  # not registered as a partner yet (Phase 3)


def test_refresh_tokens_are_stored_only_as_hashes(api):
    tokens = otp_login(api)
    row = Session.objects.get()
    assert row.refresh_hash != tokens["refreshToken"]
    assert len(row.refresh_hash) == 64


def test_old_session_rows_are_deleted_every_night(api):
    """PHASES 9.11: revoked or expired a month ago → gone; a live login is kept."""
    import uuid

    from apps.accounts.services import delete_old_sessions

    otp_login(api)
    live = Session.objects.get()
    old = timezone.now() - timedelta(days=31)
    Session.objects.create(
        user=live.user,
        app=live.app,
        device_id="old-phone",
        family_id=uuid.uuid4(),
        refresh_hash="a" * 64,
        expires_at=old,
    )
    Session.objects.create(
        user=live.user,
        app=live.app,
        device_id="old-phone-2",
        family_id=uuid.uuid4(),
        refresh_hash="b" * 64,
        expires_at=timezone.now() + timedelta(days=10),
        revoked_at=old,
    )
    assert delete_old_sessions() == 2
    assert list(Session.objects.values_list("pk", flat=True)) == [live.pk]
