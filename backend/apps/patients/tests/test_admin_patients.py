"""Admin: patients list and profile (§9.1). No health notes for the admin; opening a document
needs a reason and is audit-logged."""

import pytest

from apps.audit.models import AuditLog
from apps.patients.tests.support import OWNER, add_document, add_member, address_body, patient
from conftest import staff_token

pytestmark = pytest.mark.django_db

PROFILE = {"fullName": "Priyansu Gouda", "dob": "1990-05-17", "gender": "MALE", "language": "or"}


def _patient_with_family(api):
    token = patient(api)
    api.put("/patient/me", PROFILE, token)
    mother = add_member(api, token)
    api.post("/patient/addresses", address_body(mother["id"]), token)
    doc = add_document(api, token, mother["id"]).json()
    return token, mother, doc


def test_list_and_search_patients(api, staff_roles):
    _patient_with_family(api)
    admin = staff_token(api, staff_roles, "SUPPORT")
    rows = api.get("/admin/patients", admin).json()
    assert rows["count"] == 1
    row = rows["items"][0]
    assert row["fullName"] == "Priyansu Gouda" and row["phone"] == OWNER
    assert row["memberCount"] == 1 and row["deletionDueAt"] is None
    assert api.get("/admin/patients?q=gouda", admin).json()["count"] == 1
    assert api.get(f"/admin/patients?q={OWNER[-6:]}", admin).json()["count"] == 1
    assert api.get("/admin/patients?q=nobody", admin).json()["count"] == 0


def test_patient_profile_without_health_notes(api, staff_roles):
    _, mother, doc = _patient_with_family(api)
    admin = staff_token(api, staff_roles, "OPERATIONS")
    user_id = api.get("/admin/patients", admin).json()["items"][0]["id"]
    detail = api.get(f"/admin/patients/{user_id}", admin).json()
    members = {m["relation"]: m for m in detail["members"]}
    for health_note in ("conditions", "allergies", "mobility", "sensoryNotes"):
        assert health_note not in members["MOTHER"]
    assert detail["dob"] == "1990-05-17"
    assert [a["memberId"] for a in detail["addresses"]] == [mother["id"]]
    assert detail["documentsVisible"] is True
    assert [d["id"] for d in detail["documents"]] == [doc["id"]]
    assert api.get("/admin/patients/00000000-0000-0000-0000-000000000000", admin).status_code == 404


def test_opening_a_document_needs_a_reason_and_is_logged(api, staff_roles):
    _, _, doc = _patient_with_family(api)
    ops = staff_token(api, staff_roles, "OPERATIONS")
    user_id = api.get("/admin/patients", ops).json()["items"][0]["id"]
    path = f"/admin/patients/{user_id}/documents/{doc['id']}/view-url"
    assert api.post(path, {"reason": ""}, ops).status_code == 422
    assert api.post(path, {"reason": "       "}, ops).status_code == 422  # spaces aren't a reason
    resp = api.post(path, {"reason": "Checking the prescription before assigning"}, ops)
    assert resp.status_code == 200 and resp.json()["url"]
    log = AuditLog.objects.get(action="patient_document.viewed")
    assert log.reason == "Checking the prescription before assigning"
    # Support may see patients but not open their documents
    support = staff_token(api, staff_roles, "SUPPORT")
    assert api.post(path, {"reason": "Just looking around"}, support).status_code == 403
    # a document of another account is not found through this patient
    other = f"/admin/patients/00000000-0000-0000-0000-000000000000/documents/{doc['id']}/view-url"
    assert api.post(other, {"reason": "Checking the prescription"}, ops).status_code == 404


def test_patients_need_permission(api, staff_roles):
    verification = staff_token(api, staff_roles, "VERIFICATION")
    assert api.get("/admin/patients", verification).status_code == 403


def test_document_titles_only_for_roles_that_may_open_them(api, staff_roles):
    """§9.2: Support and Finance see patients, but not their medical documents."""
    _patient_with_family(api)
    support = staff_token(api, staff_roles, "SUPPORT")
    user_id = api.get("/admin/patients", support).json()["items"][0]["id"]
    detail = api.get(f"/admin/patients/{user_id}", support).json()
    assert detail["documentsVisible"] is False and detail["documents"] == []
    assert detail["addresses"]  # the rest of the profile is still there


def test_deletion_list_status_filter(api, staff_roles):
    token, _, _ = _patient_with_family(api)
    api.post("/patient/me/delete-request", token=token)
    admin = staff_token(api, staff_roles)
    assert api.get("/admin/account-deletions?status=PENDING", admin).json()["count"] == 1
    assert api.get("/admin/account-deletions?status=DONE", admin).json()["count"] == 0
    assert api.get("/admin/account-deletions?status=WHATEVER", admin).status_code == 422


# --- PHASES 9.10: the admin's actions on a patient account (patients.manage) ---


def _refresh(api, refresh_token: str):
    return api.post("/auth/refresh", {"refreshToken": refresh_token})


def test_block_logs_out_the_patient_app_only_and_unblock_lets_them_back(api, staff_roles):
    from django.core.cache import cache

    from apps.partners.tests.support import partner_login
    from conftest import otp_login

    login = otp_login(api, phone=OWNER)
    api.put("/patient/me", PROFILE, login["accessToken"])
    partner_token = partner_login(api, OWNER)  # the same person in the partner app
    boss = staff_token(api, staff_roles, "SUPER_ADMIN")
    support = staff_token(api, staff_roles, "SUPPORT")
    user_id = api.get("/admin/patients", boss).json()["items"][0]["id"]

    reason = {"reason": "Abusive calls to partners"}
    assert api.post(f"/admin/patients/{user_id}/block", reason, support).status_code == 403
    detail = api.post(f"/admin/patients/{user_id}/block", reason, boss).json()
    assert detail["patient"]["blockedAt"] and detail["blockedReason"] == reason["reason"]
    # out of the patient app at once, and kept out
    assert api.get("/patient/me", login["accessToken"]).status_code == 401
    assert _refresh(api, login["refreshToken"]).json()["error"]["code"] in (
        "SESSION_REVOKED",
        "ACCOUNT_BLOCKED",
    )
    cache.clear()
    device = "patient-device-2"
    sent = api.post("/auth/otp/send", {"phone": OWNER, "purpose": "login", "deviceId": device})
    assert sent.status_code == 200
    again = api.post(
        "/auth/otp/verify",
        {"phone": OWNER, "otp": "123456", "purpose": "login", "deviceId": device},
    )
    assert again.json()["error"]["code"] == "ACCOUNT_BLOCKED"
    # the partner app is not touched
    assert api.get("/partner/me", partner_token).status_code == 200

    api.post(f"/admin/patients/{user_id}/unblock", {"reason": "Spoke to them, sorted"}, boss)
    cache.clear()
    assert otp_login(api, phone=OWNER, device_id="patient-device-3")["accessToken"]
    actions = list(AuditLog.objects.values_list("action", "reason").order_by("at"))
    assert ("patient.blocked", "Abusive calls to partners") in actions
    assert ("patient.unblocked", "Spoke to them, sorted") in actions


def test_details_change_only_with_a_reason_and_the_change_is_logged(api, staff_roles):
    token, _, _ = _patient_with_family(api)
    boss = staff_token(api, staff_roles, "SUPER_ADMIN")
    user_id = api.get("/admin/patients", boss).json()["items"][0]["id"]
    change = PROFILE | {"fullName": "Priyanshu Gouda", "language": "hi"}
    assert api.put(f"/admin/patients/{user_id}", change, boss).status_code == 422  # no reason
    ops = staff_token(api, staff_roles, "OPERATIONS")
    with_reason = change | {"reason": "Asked by phone: name spelt wrong"}
    assert api.put(f"/admin/patients/{user_id}", with_reason, ops).status_code == 403
    detail = api.put(f"/admin/patients/{user_id}", with_reason, boss).json()
    assert detail["patient"]["fullName"] == "Priyanshu Gouda" and detail["language"] == "hi"
    me = api.get("/patient/me", token).json()
    assert me["fullName"] == "Priyanshu Gouda" and me["language"] == "hi"
    row = AuditLog.objects.get(action="patient.updated")
    assert row.reason == "Asked by phone: name spelt wrong"
    # which details changed, not their values (audit rows outlive an account erasure)
    assert row.before is None and row.after == {"changed": ["full_name", "language"]}


def test_deletion_started_for_a_patient_who_asks_by_phone(api, staff_roles):
    token, _, _ = _patient_with_family(api)
    boss = staff_token(api, staff_roles, "SUPER_ADMIN")
    user_id = api.get("/admin/patients", boss).json()["items"][0]["id"]
    detail = api.post(
        f"/admin/patients/{user_id}/deletion", {"reason": "Asked by phone on 13 Oct"}, boss
    ).json()
    assert detail["patient"]["deletionDueAt"]
    assert api.get("/patient/me", token).status_code == 401  # logged out at once
    pending = api.get("/admin/account-deletions?status=PENDING", boss).json()
    assert pending["count"] == 1
    assert AuditLog.objects.filter(
        action="patient.deletion_requested", reason="Asked by phone on 13 Oct"
    ).exists()
