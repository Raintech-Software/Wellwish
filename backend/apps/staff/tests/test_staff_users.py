"""Admin users page: each admin has their own login and a role (§9.1, §9.2, PHASES 2.7)."""

import pytest

from apps.audit.models import AuditLog
from apps.staff.models import StaffSession, StaffUser
from conftest import STAFF_PASSWORD, make_staff, staff_login

pytestmark = pytest.mark.django_db

NEW = {
    "name": "Ravi Operations",
    "email": "Ravi@WellWish.test",
    "role": "OPERATIONS",
    "password": "a-long-first-password-42",
}


@pytest.fixture
def boss(api, staff_roles):
    """A signed-in Super Admin."""
    return staff_login(api, make_staff(staff_roles, email="boss@wellwish.test"))


def error_code(resp) -> str:
    return resp.json()["error"]["code"]


def test_add_staff_user_who_then_signs_in_with_their_role(api, boss):
    resp = api.post("/admin/staff-users", NEW, boss.access_token)
    assert resp.status_code == 200, resp.json()
    body = resp.json()
    assert body["email"] == "ravi@wellwish.test"
    assert body["role"] == {"code": "OPERATIONS", "name": "Operations"}
    assert body["twoFactorSet"] is False
    assert body["isYou"] is False
    assert "password" not in str(AuditLog.objects.get(action="staff.created").after)

    ravi = StaffUser.objects.get(email="ravi@wellwish.test")
    step = api.post("/admin/auth/login", {"email": ravi.email, "password": NEW["password"]})
    assert step.json()["step"] == "TOTP_SETUP"  # their own authenticator


def test_list_marks_you_and_counts_sessions(api, boss):
    listed = api.get("/admin/staff-users", boss.access_token).json()
    me = next(s for s in listed if s["id"] == str(boss.staff.pk))
    assert me["isYou"] is True
    assert me["activeSessions"] == 1
    assert me["twoFactorSet"] is True


@pytest.mark.parametrize(
    ("change", "code"),
    [
        ({"password": "short"}, None),  # 422 from the schema (min 12)
        ({"password": "123456789012"}, "WEAK_PASSWORD"),
        ({"role": "KING"}, None),
        ({"email": "boss@wellwish.test"}, "EMAIL_TAKEN"),
    ],
)
def test_add_is_validated(api, boss, change, code):
    resp = api.post("/admin/staff-users", {**NEW, **change}, boss.access_token)
    assert resp.status_code == 422
    if code:
        assert error_code(resp) == code


def test_change_role_applies_on_the_next_request(api, boss, staff_roles):
    ravi = make_staff(staff_roles, "OPERATIONS")
    ravi_token = staff_login(api, ravi).access_token
    assert api.get("/admin/services", ravi_token).status_code == 200
    resp = api.put(
        f"/admin/staff-users/{ravi.pk}",
        {"name": "Ravi", "role": "VERIFICATION"},
        boss.access_token,
    )
    assert resp.json()["role"]["code"] == "VERIFICATION"
    assert api.get("/admin/services", ravi_token).status_code == 403  # no services.view
    row = AuditLog.objects.get(action="staff.role_changed")
    assert row.before == {"name": "Test Admin", "role": "OPERATIONS"}
    assert row.after == {"name": "Ravi", "role": "VERIFICATION"}


def test_disable_signs_them_out_and_blocks_login(api, boss, staff_roles):
    ravi = make_staff(staff_roles, "OPERATIONS")
    ravi_token = staff_login(api, ravi).access_token
    resp = api.post(f"/admin/staff-users/{ravi.pk}/disable", token=boss.access_token)
    assert resp.json()["status"] == "DISABLED"
    assert api.get("/admin/me", ravi_token).status_code == 401
    assert StaffSession.objects.filter(staff=ravi, revoke_reason="DISABLED").exists()
    login = api.post("/admin/auth/login", {"email": ravi.email, "password": STAFF_PASSWORD})
    assert login.status_code == 401

    resp = api.post(f"/admin/staff-users/{ravi.pk}/enable", token=boss.access_token)
    assert resp.json()["status"] == "ACTIVE"
    actions = set(AuditLog.objects.values_list("action", flat=True))
    assert {"staff.disabled", "staff.enabled"} <= actions


def test_you_cannot_disable_or_demote_yourself(api, boss):
    me = boss.staff.pk
    resp = api.post(f"/admin/staff-users/{me}/disable", token=boss.access_token)
    assert error_code(resp) == "NOT_YOURSELF"
    resp = api.put(
        f"/admin/staff-users/{me}", {"name": "Boss", "role": "SUPPORT"}, boss.access_token
    )
    assert error_code(resp) == "NOT_YOURSELF"
    # renaming yourself is fine
    resp = api.put(
        f"/admin/staff-users/{me}", {"name": "Boss", "role": "SUPER_ADMIN"}, boss.access_token
    )
    assert resp.json()["name"] == "Boss"


def test_another_super_admin_can_be_disabled(api, boss, staff_roles):
    other = make_staff(staff_roles, "SUPER_ADMIN", email="other@wellwish.test")
    resp = api.post(f"/admin/staff-users/{other.pk}/disable", token=boss.access_token)
    assert resp.status_code == 200


def test_the_last_active_super_admin_stays(staff_roles):
    from apps.staff import services

    boss = make_staff(staff_roles, email="boss@wellwish.test")
    helper = make_staff(staff_roles, "SUPER_ADMIN", email="helper@wellwish.test")
    services.set_staff_active(actor=boss, staff_id=str(helper.pk), active=False, ip="127.0.0.1")
    with pytest.raises(services.InvalidStaffUser) as exc:
        services.update_staff_user(
            actor=helper, staff_id=str(boss.pk), name="Boss", role_code="SUPPORT", ip="127.0.0.1"
        )
    assert exc.value.code == "LAST_SUPER_ADMIN"


def test_reset_2fa_shows_a_new_qr_at_the_next_sign_in(api, boss, staff_roles):
    ravi = make_staff(staff_roles, "OPERATIONS")
    ravi_token = staff_login(api, ravi).access_token
    resp = api.post(f"/admin/staff-users/{ravi.pk}/reset-2fa", token=boss.access_token)
    assert resp.json()["twoFactorSet"] is False
    assert api.get("/admin/me", ravi_token).status_code == 401
    step = api.post("/admin/auth/login", {"email": ravi.email, "password": STAFF_PASSWORD})
    assert step.json()["step"] == "TOTP_SETUP"
    assert AuditLog.objects.filter(action="staff.totp_reset", entity_id=str(ravi.pk)).exists()


def test_set_password_and_force_logout(api, boss, staff_roles):
    ravi = make_staff(staff_roles, "OPERATIONS")
    ravi_token = staff_login(api, ravi).access_token
    resp = api.post(
        f"/admin/staff-users/{ravi.pk}/password",
        {"password": "another-long-password-77"},
        boss.access_token,
    )
    assert resp.status_code == 200
    assert api.get("/admin/me", ravi_token).status_code == 401
    old = api.post("/admin/auth/login", {"email": ravi.email, "password": STAFF_PASSWORD})
    assert old.status_code == 401
    ravi.refresh_from_db()
    assert ravi.check_password("another-long-password-77")

    assert AuditLog.objects.filter(action="staff.password_reset").exists()


def test_force_logout(api, boss, staff_roles):
    sita = make_staff(staff_roles, "SUPPORT")
    sita_token = staff_login(api, sita).access_token
    ended = api.post(f"/admin/staff-users/{sita.pk}/logout", token=boss.access_token)
    assert ended.json() == {"sessionsEnded": 1}
    assert api.get("/admin/me", sita_token).status_code == 401
    assert AuditLog.objects.filter(action="staff.force_logout").exists()


def test_only_staff_manage(api, staff_roles):
    finance = staff_login(api, make_staff(staff_roles, "FINANCE")).access_token
    assert api.get("/admin/staff-users", finance).status_code == 403
    assert api.post("/admin/staff-users", NEW, finance).status_code == 403
