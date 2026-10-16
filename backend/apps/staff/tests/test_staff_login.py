"""Admin login with password + TOTP 2FA, sessions and permissions (§6.4, §9.2, PHASES 1.9)."""

from datetime import timedelta

import pyotp
import pytest
from django.conf import settings as django_settings
from django.utils import timezone

from apps.audit.models import AuditLog
from apps.staff.models import StaffSession, StaffUser
from apps.staff.permissions import PERMISSIONS, ROLE_PERMISSIONS
from conftest import STAFF_PASSWORD, make_staff, staff_login

pytestmark = pytest.mark.django_db
CLIENT = {"HTTP_X_WW_CLIENT": "admin"}


def error(resp) -> dict:
    return resp.json()["error"]


def test_first_login_sets_up_totp_then_signs_in(api, staff_roles):
    staff = make_staff(staff_roles)
    step = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    assert step.status_code == 200
    body = step.json()
    assert body["step"] == "TOTP_SETUP"
    assert body["secret"]
    assert body["otpauthUri"].startswith("otpauth://totp/WellWish%20Admin:")
    staff.refresh_from_db()
    assert body["secret"] not in staff.totp_secret_enc  # stored encrypted

    resp = api.post(
        "/admin/auth/totp",
        {"challengeToken": body["challengeToken"], "code": pyotp.TOTP(body["secret"]).now()},
    )
    assert resp.status_code == 200
    out = resp.json()
    assert out["accessToken"]
    assert out["expiresIn"] == 900
    assert out["staff"]["email"] == staff.email
    assert out["staff"]["role"] == {"code": "SUPER_ADMIN", "name": "Super Admin"}
    assert set(out["staff"]["permissions"]) == set(PERMISSIONS)

    cookie = resp.cookies[django_settings.STAFF_REFRESH_COOKIE]
    assert cookie["httponly"]
    assert cookie["path"] == "/v1/admin/auth"
    assert cookie["samesite"] == "Strict"
    assert "refreshToken" not in out  # never readable by page scripts

    staff.refresh_from_db()
    assert staff.totp_confirmed_at is not None
    actions = list(AuditLog.objects.filter(staff=staff).values_list("action", flat=True))
    assert set(actions) == {"staff.totp_setup", "staff.login", "staff.recovery_codes_created"}


def test_second_login_asks_only_for_the_code(api, staff_roles):
    staff = make_staff(staff_roles)
    staff_login(api, staff)
    step = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    assert step.json()["step"] == "TOTP"
    assert step.json()["secret"] is None
    assert step.json()["otpauthUri"] is None


def test_email_is_case_insensitive(api, staff_roles):
    staff = make_staff(staff_roles)
    step = api.post("/admin/auth/login", {"email": staff.email.upper(), "password": STAFF_PASSWORD})
    assert step.status_code == 200


def test_wrong_password_and_unknown_email_look_the_same(api, staff_roles):
    staff = make_staff(staff_roles)
    wrong = api.post("/admin/auth/login", {"email": staff.email, "password": "nope-nope-nope"})
    unknown = api.post("/admin/auth/login", {"email": "x@wellwish.test", "password": "nope"})
    assert wrong.status_code == unknown.status_code == 401
    assert error(wrong) == error(unknown)
    assert AuditLog.objects.filter(action="staff.login_failed", staff=staff).count() == 1


def test_five_wrong_passwords_lock_the_login(api, staff_roles):
    staff = make_staff(staff_roles)
    for _ in range(5):
        api.post("/admin/auth/login", {"email": staff.email, "password": "wrong-password!"})
    resp = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    assert resp.status_code == 429
    assert error(resp)["code"] == "LOGIN_LOCKED"


def test_wrong_and_reused_totp_codes(api, staff_roles):
    staff = make_staff(staff_roles)
    login = staff_login(api, staff)
    used_code = pyotp.TOTP(login.secret).at((login.staff.totp_last_step or 0) * 30)

    step = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    challenge = step.json()["challengeToken"]
    wrong = "000000" if used_code != "000000" else "111111"
    resp = api.post("/admin/auth/totp", {"challengeToken": challenge, "code": wrong})
    assert error(resp)["code"] == "TOTP_INVALID"
    # the code already used to sign in can't be used again
    resp = api.post("/admin/auth/totp", {"challengeToken": challenge, "code": used_code})
    assert error(resp)["code"] == "TOTP_INVALID"


def _wrong_code(secret: str) -> str:
    """A 6-digit code that is not valid now (nor 30 s either side)."""
    totp = pyotp.TOTP(secret)
    valid = {totp.at(timezone.now() + timedelta(seconds=s)) for s in (-30, 0, 30)}
    return next(c for c in ("000000", "111111", "222222", "333333") if c not in valid)


def test_wrong_codes_lock_the_staff_member_across_new_sign_ins(api, staff_roles):
    """Starting a new sign-in must not give 5 fresh guesses: the count is per person."""
    staff = make_staff(staff_roles)
    login = staff_login(api, staff)
    wrong = _wrong_code(login.secret)
    for attempt in range(5):
        step = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
        assert step.status_code == 200
        resp = api.post(
            "/admin/auth/totp", {"challengeToken": step.json()["challengeToken"], "code": wrong}
        )
        assert error(resp)["code"] == ("LOGIN_LOCKED" if attempt == 4 else "TOTP_INVALID")

    # now even the right password and the right code are refused for 15 minutes
    step = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    assert step.status_code == 429
    assert error(step)["code"] == "LOGIN_LOCKED"
    actions = list(AuditLog.objects.filter(staff=staff).values_list("action", flat=True))
    assert actions.count("staff.totp_failed") == 5
    assert "staff.locked" in actions


def test_a_right_password_alone_does_not_clear_the_password_limit(api, staff_roles):
    """Otherwise an attacker with the password could keep resetting the counter."""
    staff = make_staff(staff_roles)
    for _ in range(4):
        api.post("/admin/auth/login", {"email": staff.email, "password": "wrong-password!"})
    api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    api.post("/admin/auth/login", {"email": staff.email, "password": "wrong-password!"})
    resp = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    assert error(resp)["code"] == "LOGIN_LOCKED"


def test_a_challenge_works_for_one_sign_in_only(api, staff_roles):
    staff = make_staff(staff_roles)
    login = staff_login(api, staff)
    step = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    challenge = step.json()["challengeToken"]
    now_code = pyotp.TOTP(login.secret).at(timezone.now() + timedelta(seconds=30))
    first = api.post("/admin/auth/totp", {"challengeToken": challenge, "code": now_code})
    assert first.status_code == 200
    later_code = pyotp.TOTP(login.secret).at(timezone.now() + timedelta(seconds=60))
    again = api.post("/admin/auth/totp", {"challengeToken": challenge, "code": later_code})
    assert error(again)["code"] == "LOGIN_EXPIRED"


def test_forged_challenge_is_rejected(api, staff_roles):
    resp = api.post("/admin/auth/totp", {"challengeToken": "forged", "code": "123456"})
    assert error(resp)["code"] == "LOGIN_EXPIRED"


def test_disabled_staff_cannot_sign_in_and_is_signed_out(api, staff_roles):
    staff = make_staff(staff_roles)
    login = staff_login(api, staff)
    StaffUser.objects.filter(pk=staff.pk).update(status=StaffUser.Status.DISABLED)
    assert api.get("/admin/me", token=login.access_token).status_code == 401
    resp = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    assert error(resp)["code"] == "INVALID_CREDENTIALS"


def test_refresh_uses_the_cookie_and_rotates_it(api, staff_roles):
    login = staff_login(api, make_staff(staff_roles))
    old_cookie = api.client.cookies[django_settings.STAFF_REFRESH_COOKIE].value

    resp = api.post("/admin/auth/refresh", **CLIENT)
    assert resp.status_code == 200
    assert resp.json()["accessToken"] != login.access_token
    new_cookie = resp.cookies[django_settings.STAFF_REFRESH_COOKIE].value
    assert new_cookie and new_cookie != old_cookie

    # Two tabs refreshing together send the same cookie: within 30 s that's not theft.
    api.client.cookies[django_settings.STAFF_REFRESH_COOKIE] = old_cookie
    assert api.post("/admin/auth/refresh", **CLIENT).status_code == 200

    # Later, the old cookie is a stolen copy: the whole session is signed out.
    StaffSession.objects.filter(rotated_at__isnull=False).update(
        rotated_at=timezone.now() - timedelta(seconds=31)
    )
    api.client.cookies[django_settings.STAFF_REFRESH_COOKIE] = old_cookie
    assert api.post("/admin/auth/refresh", **CLIENT).status_code == 401
    api.client.cookies[django_settings.STAFF_REFRESH_COOKIE] = new_cookie
    assert api.post("/admin/auth/refresh", **CLIENT).status_code == 401


def test_refresh_needs_the_client_header(api, staff_roles):
    staff_login(api, make_staff(staff_roles))
    resp = api.post("/admin/auth/refresh")
    assert resp.status_code == 403
    assert error(resp)["code"] == "CLIENT_HEADER_MISSING"


def test_30_minutes_idle_signs_out(api, staff_roles):
    login = staff_login(api, make_staff(staff_roles))
    assert api.get("/admin/me", token=login.access_token).status_code == 200
    StaffSession.objects.update(last_seen_at=timezone.now() - timedelta(minutes=31))
    assert api.get("/admin/me", token=login.access_token).status_code == 401
    resp = api.post("/admin/auth/refresh", **CLIENT)
    assert resp.status_code == 401
    assert StaffSession.objects.filter(revoke_reason="IDLE").exists()


def test_idle_refresh_is_refused(api, staff_roles):
    staff_login(api, make_staff(staff_roles))
    StaffSession.objects.update(last_seen_at=timezone.now() - timedelta(minutes=31))
    resp = api.post("/admin/auth/refresh", **CLIENT)
    assert error(resp)["code"] == "SESSION_IDLE"


def test_activity_keeps_the_session_alive(api, staff_roles):
    login = staff_login(api, make_staff(staff_roles))
    StaffSession.objects.update(last_seen_at=timezone.now() - timedelta(minutes=20))
    assert api.get("/admin/me", token=login.access_token).status_code == 200
    seen = StaffSession.objects.get(rotated_at__isnull=True).last_seen_at
    assert seen > timezone.now() - timedelta(minutes=1)


def test_session_ends_12_hours_after_sign_in(api, staff_roles):
    login = staff_login(api, make_staff(staff_roles))
    StaffSession.objects.update(expires_at=timezone.now() - timedelta(seconds=1))
    assert api.get("/admin/me", token=login.access_token).status_code == 401
    assert api.post("/admin/auth/refresh", **CLIENT).status_code == 401
    session = StaffSession.objects.get()
    assert session.expires_at - session.started_at <= timedelta(hours=12)


def test_logout_clears_the_cookie_and_session(api, staff_roles):
    login = staff_login(api, make_staff(staff_roles))
    resp = api.post("/admin/auth/logout", **CLIENT)
    assert resp.status_code == 200
    assert resp.cookies[django_settings.STAFF_REFRESH_COOKIE].value == ""
    assert api.get("/admin/me", token=login.access_token).status_code == 401
    assert AuditLog.objects.filter(action="staff.logout").count() == 1


@pytest.mark.parametrize("role", ["OPERATIONS", "VERIFICATION", "FINANCE", "SUPPORT"])
def test_staff_permission_is_denied_without_the_permission(api, staff_roles, role):
    login = staff_login(api, make_staff(staff_roles, role=role))
    resp = api.get("/admin/roles", token=login.access_token)
    assert resp.status_code == 403
    assert error(resp) == {
        "code": "FORBIDDEN",
        "message": "You don't have permission to do this.",
        "details": {"permission": "staff.manage"},
    }
    me = api.get("/admin/me", token=login.access_token).json()
    assert set(me["permissions"]) == set(ROLE_PERMISSIONS[role])


def test_super_admin_sees_the_roles(api, staff_roles):
    login = staff_login(api, make_staff(staff_roles))
    disabled = make_staff(staff_roles, role="SUPPORT")
    StaffUser.objects.filter(pk=disabled.pk).update(status=StaffUser.Status.DISABLED)
    resp = api.get("/admin/roles", token=login.access_token)
    assert resp.status_code == 200
    roles = {r["code"]: r for r in resp.json()["roles"]}
    assert set(roles) == {"SUPER_ADMIN", "OPERATIONS", "VERIFICATION", "FINANCE", "SUPPORT"}
    assert roles["SUPER_ADMIN"]["userCount"] == 1
    assert roles["SUPPORT"]["userCount"] == 0  # disabled staff aren't counted
    assert "refunds.approve" in roles["FINANCE"]["permissions"]
    assert "refunds.approve" not in roles["OPERATIONS"]["permissions"]


def test_roles_match_the_architecture_table(staff_roles):
    """§9.2 spot checks: who can assign bookings, approve refunds, manage staff."""
    assert "bookings.manage" in ROLE_PERMISSIONS["OPERATIONS"]
    assert "bookings.manage" not in ROLE_PERMISSIONS["SUPPORT"]
    assert "bookings.view" in ROLE_PERMISSIONS["SUPPORT"]
    assert "partners.review" in ROLE_PERMISSIONS["VERIFICATION"]
    assert "partners.review" not in ROLE_PERMISSIONS["OPERATIONS"]
    assert "partners.add" in ROLE_PERMISSIONS["OPERATIONS"]
    assert "services.manage" in ROLE_PERMISSIONS["FINANCE"]
    assert "refunds.approve" in ROLE_PERMISSIONS["FINANCE"]
    assert "refunds.request" in ROLE_PERMISSIONS["SUPPORT"]
    for role in ("OPERATIONS", "VERIFICATION", "FINANCE", "SUPPORT"):
        for only_super in ("settings.manage", "staff.manage", "audit.view"):
            assert only_super not in ROLE_PERMISSIONS[role]


def test_create_staff_user_needs_a_strong_password(staff_roles):
    from apps.staff.services import InvalidStaffUser, create_staff_user

    with pytest.raises(InvalidStaffUser) as exc:
        create_staff_user(
            name="A",
            email="a@wellwish.test",
            password="short",
            role_code="SUPPORT",
            actor=None,
            ip=None,
        )
    assert exc.value.code == "WEAK_PASSWORD"
    staff = create_staff_user(
        name="Asha",
        email="Asha@WellWish.test",
        password="a-very-long-password-2026",
        role_code="SUPPORT",
        actor=None,
        ip=None,
    )
    assert staff.email == "asha@wellwish.test"
    assert staff.password_hash != "a-very-long-password-2026"
    assert AuditLog.objects.filter(action="staff.created", entity_id=str(staff.pk)).exists()


def test_dev_seed_creates_the_admin_once(staff_roles, monkeypatch):
    from django.core.management import call_command

    monkeypatch.setenv("DEV_ADMIN_EMAIL", "dev-admin@wellwish.test")
    monkeypatch.setenv("DEV_ADMIN_PASSWORD", "dev-only-password-2026")
    call_command("seed")
    call_command("seed")
    staff = StaffUser.objects.get(email="dev-admin@wellwish.test")
    assert staff.role.code == "SUPER_ADMIN"
