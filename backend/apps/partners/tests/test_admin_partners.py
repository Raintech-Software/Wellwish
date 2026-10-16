"""Admin partner pages: list, profile with history, edit, deactivate, force logout (3.9, 3.17)."""

import pytest

from apps.audit.models import AuditLog
from apps.partners.models import PartnerProfile
from apps.partners.tests.support import PROFILE, partner_login, register
from conftest import make_staff, staff_login

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def _media(settings, tmp_path):
    settings.FILE_STORAGE = "local"
    settings.MEDIA_ROOT = tmp_path


@pytest.fixture
def admin(api, staff_roles):
    return staff_login(api, make_staff(staff_roles)).access_token


@pytest.fixture
def partner(api):
    token = partner_login(api)
    register(api, token)
    return token


def pid():
    return str(PartnerProfile.objects.get().pk)


def test_list_filters_and_search(api, admin, partner):
    rows = api.get("/admin/partners", admin).json()
    assert rows["count"] == 1
    row = rows["items"][0]
    assert row["fullName"] == "Asha Behera"
    assert row["phone"] == "+919000000001"
    assert row["alternatePhone"] == "+919000000002"
    assert row["status"] == "REGISTERED"
    assert api.get("/admin/partners?role=NURSE", admin).json()["count"] == 0
    assert api.get("/admin/partners?q=asha", admin).json()["count"] == 1
    assert api.get("/admin/partners?q=90000", admin).json()["count"] == 1
    assert api.get("/admin/partners?status=APPROVED", admin).json()["count"] == 0


def test_profile_shows_phones_documents_and_history(api, admin, partner):
    detail = api.get(f"/admin/partners/{pid()}", admin).json()
    phones = {p["kind"]: p for p in detail["partner"]["phones"]}
    assert phones["PRIMARY"]["verified"] and phones["ALTERNATE"]["verified"]
    assert detail["partner"]["emailVerified"] is True
    assert {d["required"]["docType"] for d in detail["documents"]} >= {"AADHAAR", "PAN"}
    assert any(h["action"] == "partner.status_changed" for h in detail["history"])


def test_edit_and_change_role_are_audited(api, admin, partner):
    body = {k: PROFILE[k] for k in PROFILE} | {"role": "NURSE", "fullName": "Asha B."}
    resp = api.put(f"/admin/partners/{pid()}", body, admin)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["partner"]["role"] == "NURSE"
    row = AuditLog.objects.get(action="partner.role_changed")
    assert row.before == {"role": "COMPANION", "full_name": "Asha Behera"}
    assert row.after == {"role": "NURSE", "full_name": "Asha B."}


def test_deactivate_and_force_logout(api, admin, partner, django_capture_on_commit_callbacks):
    PartnerProfile.objects.update(status="APPROVED")
    logout = api.post(f"/admin/partners/{pid()}/logout", token=admin)
    assert logout.status_code == 200
    assert api.get("/partner/me", partner).status_code == 401
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(f"/admin/partners/{pid()}/deactivate", {"reason": "Left the job"}, admin)
    assert resp.json()["partner"]["status"] == "DEACTIVATED"
    again = api.post(f"/admin/partners/{pid()}/reinstate", token=admin)
    assert again.json()["error"]["code"] == "INVALID_TRANSITION"


def test_suspend_only_from_approved(api, admin, partner):
    resp = api.post(f"/admin/partners/{pid()}/suspend", {"reason": "Testing"}, admin)
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "INVALID_TRANSITION"


def test_partner_admin_permissions(api, staff_roles, partner):
    finance = staff_login(api, make_staff(staff_roles, "FINANCE")).access_token
    assert api.get("/admin/partners", finance).status_code == 403
    verification = staff_login(api, make_staff(staff_roles, "VERIFICATION")).access_token
    assert api.get("/admin/partners", verification).status_code == 200
    assert (
        api.post(f"/admin/partners/{pid()}/suspend", {"reason": "x y z"}, verification).status_code
        == 409
    )
