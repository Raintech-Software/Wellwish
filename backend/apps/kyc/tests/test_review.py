"""Documents, submit and the admin review (§6.3, §9.4, PHASES 3.5 to 3.10, 3.19)."""

from datetime import timedelta

import pytest
from django.utils import timezone

from apps.audit.models import AuditLog
from apps.kyc.models import PartnerApplication, PartnerDocument, RequiredDocument
from apps.kyc.services import InvalidDocument, check_expiry, mask_number
from apps.notifications.models import Notification
from apps.partners.models import PartnerProfile
from apps.partners.tests.support import (
    PDF,
    PROFILE,
    add_document,
    partner_login,
    register,
    save_profile,
    upload,
    verify_alternate,
    verify_email,
)
from common.sms import read_dev_outbox as read_sms
from conftest import make_staff, staff_login

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def _media(settings, tmp_path):
    settings.FILE_STORAGE = "local"
    settings.MEDIA_ROOT = tmp_path


@pytest.fixture
def partner(api):
    return partner_login(api)


@pytest.fixture
def admin(api, staff_roles):
    return staff_login(api, make_staff(staff_roles, email="reviewer@wellwish.test"))


def submit(api, token, capture):
    with capture(execute=True):
        return api.post("/partner/kyc/submit", token=token)


def app_id():
    return str(PartnerApplication.objects.get().pk)


def docs(status_json):
    return {d["required"]["docType"]: d for d in status_json["documents"]}


# --- Documents ---


def test_required_documents_depend_on_the_role(api, partner):
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    companion = {d["docType"] for d in api.get("/partner/kyc/required", partner).json()}
    assert "NURSING_REGISTRATION" not in companion
    assert {"AADHAAR", "PAN", "SELFIE", "POLICE_VERIFICATION", "ADDRESS_PROOF"} <= companion
    api.post("/partner/register/start", {"role": "NURSE"}, partner)
    nurse = {d["docType"] for d in api.get("/partner/kyc/required", partner).json()}
    assert {"NURSING_QUALIFICATION", "NURSING_REGISTRATION"} <= nurse
    assert "FIRST_AID" not in nurse
    # hints and conditions in Hindi and Odia too, like the labels (Phase 9.1)
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    rows = {d["docType"]: d for d in api.get("/partner/kyc/required", partner).json()}
    assert rows["AADHAAR"]["helpHi"] and rows["AADHAAR"]["helpOr"]
    assert rows["DRIVING_LICENCE"]["conditionHi"] == "अगर आप मरीज़ को गाड़ी से ले जाएँगे"
    assert rows["FIRST_AID"]["conditionOr"] == "ଯଦି ଆପଣଙ୍କ ପାଖରେ ଅଛି"


def test_aadhaar_is_stored_masked(api, partner):
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    resp = add_document(api, partner, "AADHAAR", number="2345 6789 1234")
    assert resp.status_code == 200, resp.json()
    assert docs(resp.json())["AADHAAR"]["document"]["numberMasked"] == "XXXX XXXX 1234"
    stored = PartnerDocument.objects.get(doc_type="AADHAAR")
    assert stored.number_masked == "XXXX XXXX 1234"
    assert "23456789" not in str(PartnerDocument.objects.values().get(doc_type="AADHAAR"))


@pytest.mark.parametrize(
    ("doc_type", "changes", "code"),
    [
        ("AADHAAR", {"number": "1234"}, "INVALID_AADHAAR"),
        ("PAN", {"number": "12345"}, "INVALID_PAN"),
        ("POLICE_VERIFICATION", {"expiresOn": None}, "EXPIRY_REQUIRED"),
        ("POLICE_VERIFICATION", {"expiresOn": "2020-01-01"}, "ALREADY_EXPIRED"),
        ("NURSING_REGISTRATION", {}, "UNKNOWN_DOCUMENT"),  # not for companions
    ],
)
def test_document_checks(api, partner, doc_type, changes, code):
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    resp = add_document(api, partner, doc_type, **changes)
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == code


def test_a_fake_document_file_is_refused(api, partner):
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    key = upload(api, partner, "kyc_document", b"MZ\x90\x00" + b"\x00" * 60, "application/pdf")
    resp = api.post("/partner/kyc/documents", {"docType": "ADDRESS_PROOF", "fileKey": key}, partner)
    assert resp.json()["error"]["code"] == "INVALID_FILE"


def test_reupload_replaces_the_current_document(api, partner):
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    add_document(api, partner, "ADDRESS_PROOF")
    add_document(api, partner, "ADDRESS_PROOF")
    assert PartnerDocument.objects.filter(doc_type="ADDRESS_PROOF").count() == 2
    assert PartnerDocument.objects.filter(doc_type="ADDRESS_PROOF", is_current=True).count() == 1


# --- Submit ---


def test_submit_needs_details_and_every_mandatory_document(
    api, partner, django_capture_on_commit_callbacks
):
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    early = submit(api, partner, django_capture_on_commit_callbacks)
    assert early.json()["error"]["code"] == "DETAILS_MISSING"
    verify_alternate(api, partner)
    verify_email(api, partner)
    save_profile(api, partner)
    add_document(api, partner, "AADHAAR")
    missing = submit(api, partner, django_capture_on_commit_callbacks)
    assert missing.status_code == 409
    assert missing.json()["error"]["code"] == "DOCUMENTS_MISSING"
    assert "PAN" in missing.json()["error"]["details"]["missing"]


def test_submit_creates_the_application(api, partner, django_capture_on_commit_callbacks):
    status = register(api, partner)
    assert status["canSubmit"] is True
    resp = submit(api, partner, django_capture_on_commit_callbacks)
    assert resp.status_code == 200, resp.json()
    body = resp.json()
    assert body["profile"]["status"] == "SUBMITTED"
    assert body["application"]["status"] == "SUBMITTED"
    assert body["canEdit"] is False
    # an inbox message for the partner
    assert Notification.objects.filter(type="PARTNER_SUBMITTED").count() == 1
    # details are locked while in review
    locked = save_profile(api, partner)
    assert locked.json()["error"]["code"] == "NOT_EDITABLE"
    assert add_document(api, partner, "PAN").json()["error"]["code"] == "NOT_EDITABLE"


# --- Review ---


def submitted(api, partner, capture):
    register(api, partner)
    assert submit(api, partner, capture).status_code == 200


def test_claim_locks_the_application_for_30_minutes(
    api, partner, admin, staff_roles, django_capture_on_commit_callbacks
):
    submitted(api, partner, django_capture_on_commit_callbacks)
    queue = api.get("/admin/applications", admin.access_token).json()
    assert [r["fullName"] for r in queue] == ["Asha Behera"]
    resp = api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["claimedByMe"] is True
    assert PartnerProfile.objects.get().status == "UNDER_REVIEW"
    other = staff_login(api, make_staff(staff_roles, "VERIFICATION"))
    taken = api.post(f"/admin/applications/{app_id()}/claim", token=other.access_token)
    assert taken.status_code == 409
    assert taken.json()["error"]["code"] == "CLAIMED_BY_OTHER"
    # the lock ends after 30 minutes
    PartnerApplication.objects.update(claimed_until=timezone.now() - timedelta(seconds=1))
    assert (
        api.post(f"/admin/applications/{app_id()}/claim", token=other.access_token).status_code
        == 200
    )
    # now the first admin can't review any more
    doc = PartnerDocument.objects.earliest("created_at")
    late = api.post(f"/admin/partner-documents/{doc.pk}/approve", token=admin.access_token)
    assert late.json()["error"]["code"] == "NOT_CLAIMED"


def test_document_view_is_audit_logged(api, partner, admin, django_capture_on_commit_callbacks):
    submitted(api, partner, django_capture_on_commit_callbacks)
    doc = PartnerDocument.objects.get(doc_type="AADHAAR")
    resp = api.get(f"/admin/partner-documents/{doc.pk}/view-url", admin.access_token)
    assert resp.status_code == 200
    assert resp.json()["mime"] == "application/pdf"
    assert resp.json()["url"].startswith("/v1/files/view/")
    entry = AuditLog.objects.get(action="partner_document.viewed")
    assert entry.staff_id == admin.staff.pk
    assert entry.entity_id == str(doc.pk)


def review_all(api, admin, reject=None):
    for doc in PartnerDocument.objects.filter(is_current=True):
        if reject and doc.doc_type == reject:
            api.post(
                f"/admin/partner-documents/{doc.pk}/reject",
                {"reason": "Photo is blurred, upload a clear one"},
                admin.access_token,
            )
        else:
            api.post(f"/admin/partner-documents/{doc.pk}/approve", token=admin.access_token)


def test_rejected_document_reason_reupload_and_approval(
    api, partner, admin, django_capture_on_commit_callbacks
):
    """Exit criterion 2: the reason shows in the app, re-upload, approve."""
    submitted(api, partner, django_capture_on_commit_callbacks)
    api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    review_all(api, admin, reject="PAN")
    early = api.post(f"/admin/applications/{app_id()}/approve", token=admin.access_token)
    assert early.json()["error"]["code"] == "DOCUMENTS_NOT_APPROVED"
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/admin/applications/{app_id()}/request-changes",
            {"note": "Please upload a clear PAN card."},
            admin.access_token,
        )
    assert resp.status_code == 200, resp.json()

    status = api.get("/partner/kyc/status", partner).json()
    assert status["profile"]["status"] == "CHANGES_REQUESTED"
    assert status["application"]["notes"] == "Please upload a clear PAN card."
    pan = docs(status)["PAN"]
    assert pan["status"] == "REJECTED"
    assert pan["document"]["rejectReason"] == "Photo is blurred, upload a clear one"
    assert status["canSubmit"] is False
    assert Notification.objects.filter(type="PARTNER_CHANGES_REQUESTED").exists()
    assert any("need a change" in m["text"] for m in read_sms("+919000000001"))

    resp = add_document(api, partner, "PAN")
    assert docs(resp.json())["PAN"]["status"] == "PENDING"
    assert submit(api, partner, django_capture_on_commit_callbacks).status_code == 200
    api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    detail = api.get(f"/admin/applications/{app_id()}", admin.access_token).json()
    assert detail["canApprove"] is False  # the new PAN waits
    review_all(api, admin)
    with django_capture_on_commit_callbacks(execute=True):
        done = api.post(f"/admin/applications/{app_id()}/approve", token=admin.access_token)
    assert done.status_code == 200, done.json()
    assert PartnerProfile.objects.get().status == "APPROVED"
    assert api.get("/partner/me", partner).json()["partnerStatus"] == "APPROVED"
    assert Notification.objects.filter(type="PARTNER_APPROVED").exists()
    assert any("approved" in m["text"] for m in read_sms("+919000000001"))
    actions = set(AuditLog.objects.values_list("action", flat=True))
    assert {
        "partner_document.approved",
        "partner_document.rejected",
        "partner.status_changed",
    } <= actions


def test_request_changes_needs_a_reason(api, partner, admin, django_capture_on_commit_callbacks):
    submitted(api, partner, django_capture_on_commit_callbacks)
    api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    resp = api.post(
        f"/admin/applications/{app_id()}/request-changes", {"note": ""}, admin.access_token
    )
    assert resp.json()["error"]["code"] == "NOTHING_TO_CHANGE"


def test_reject_document_needs_a_reason(api, partner, admin, django_capture_on_commit_callbacks):
    submitted(api, partner, django_capture_on_commit_callbacks)
    api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    doc = PartnerDocument.objects.earliest("created_at")
    resp = api.post(f"/admin/partner-documents/{doc.pk}/reject", {"reason": ""}, admin.access_token)
    assert resp.status_code == 422


def test_reject_application_is_final(api, partner, admin, django_capture_on_commit_callbacks):
    submitted(api, partner, django_capture_on_commit_callbacks)
    api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/admin/applications/{app_id()}/reject", {"reason": "Not eligible"}, admin.access_token
        )
    assert resp.status_code == 200
    assert PartnerProfile.objects.get().status == "REJECTED"
    assert add_document(api, partner, "PAN").json()["error"]["code"] == "NOT_EDITABLE"
    again = api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    assert again.json()["error"]["code"] == "ALREADY_DECIDED"


def test_review_permissions(api, partner, staff_roles, django_capture_on_commit_callbacks):
    submitted(api, partner, django_capture_on_commit_callbacks)
    support = staff_login(api, make_staff(staff_roles, "SUPPORT")).access_token
    assert api.get("/admin/applications", support).status_code == 403
    doc = PartnerDocument.objects.earliest("created_at")
    assert api.get(f"/admin/partner-documents/{doc.pk}/view-url", support).status_code == 403


# --- Approved partners: suspend, renewals, expiry ---


def approve(api, partner, admin, capture):
    submitted(api, partner, capture)
    api.post(f"/admin/applications/{app_id()}/claim", token=admin.access_token)
    review_all(api, admin)
    with capture(execute=True):
        assert (
            api.post(
                f"/admin/applications/{app_id()}/approve", token=admin.access_token
            ).status_code
            == 200
        )


def test_suspend_logs_the_partner_out_at_once(
    api, partner, admin, django_capture_on_commit_callbacks, monkeypatch
):
    """Exit criterion 4."""
    approve(api, partner, admin, django_capture_on_commit_callbacks)
    pushed = []
    monkeypatch.setattr(
        "apps.accounts.services.send_to_group",
        lambda group, kind, data: pushed.append((group, kind)),
    )
    pid = PartnerProfile.objects.get().pk
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/admin/partners/{pid}/suspend", {"reason": "No-show twice"}, admin.access_token
        )
    assert resp.status_code == 200, resp.json()
    assert resp.json()["partner"]["status"] == "SUSPENDED"
    assert api.get("/partner/me", partner).status_code == 401
    assert pushed and pushed[0][1] == "session.revoked"
    assert Notification.objects.filter(type="PARTNER_SUSPENDED").exists()
    # they can log in again, but only see their status
    again = partner_login(api, device_id="partner-device-9")
    assert api.get("/partner/me", again).json()["partnerStatus"] == "SUSPENDED"
    assert api.patch("/partner/me/availability", {"availableToday": True}, again).status_code == 403
    reinstated = api.post(f"/admin/partners/{pid}/reinstate", token=admin.access_token)
    assert reinstated.json()["partner"]["status"] == "APPROVED"


def test_renewal_keeps_the_approved_document_until_reviewed(
    api, partner, admin, django_capture_on_commit_callbacks
):
    approve(api, partner, admin, django_capture_on_commit_callbacks)
    resp = add_document(api, partner, "POLICE_VERIFICATION", expiresOn="2100-01-31")
    police = docs(resp.json())["POLICE_VERIFICATION"]
    assert police["status"] == "APPROVED"  # the old one stays current
    assert police["replacement"]["status"] == "PENDING"
    new = PartnerDocument.objects.get(doc_type="POLICE_VERIFICATION", is_current=False)
    pid = PartnerProfile.objects.get().pk
    listed = api.get("/admin/partners?toReview=true", admin.access_token).json()
    assert [p["id"] for p in listed["items"]] == [str(pid)]
    assert (
        api.post(f"/admin/partner-documents/{new.pk}/approve", token=admin.access_token).status_code
        == 200
    )
    current = PartnerDocument.objects.get(doc_type="POLICE_VERIFICATION", is_current=True)
    assert current.pk == new.pk
    assert str(current.expires_on) == "2100-01-31"


def test_expiry_reminds_then_suspends_until_a_new_document_is_approved(
    api, partner, admin, django_capture_on_commit_callbacks
):
    approve(api, partner, admin, django_capture_on_commit_callbacks)
    today = timezone.localdate()
    police = PartnerDocument.objects.get(doc_type="POLICE_VERIFICATION", is_current=True)
    police.expires_on = today + timedelta(days=20)
    police.save()
    with django_capture_on_commit_callbacks(execute=True):
        assert check_expiry(today=today) == {"reminded": 1, "expired": 0, "suspended": 0}
    assert Notification.objects.filter(type="DOCUMENT_EXPIRING").count() == 1
    with django_capture_on_commit_callbacks(execute=True):
        assert check_expiry(today=today)["reminded"] == 0  # once only

    with django_capture_on_commit_callbacks(execute=True):
        result = check_expiry(today=today + timedelta(days=21))
    assert result == {"reminded": 0, "expired": 1, "suspended": 1}
    partner_row = PartnerProfile.objects.get()
    assert partner_row.status == "SUSPENDED"
    assert partner_row.suspended_reason == "DOCUMENT_EXPIRED"
    assert api.get("/partner/me", partner).status_code == 401
    assert Notification.objects.filter(type="DOCUMENT_EXPIRED").exists()

    token = partner_login(api, device_id="partner-device-3")
    resp = add_document(api, token, "POLICE_VERIFICATION", expiresOn="2100-01-31")
    assert docs(resp.json())["POLICE_VERIFICATION"]["status"] == "PENDING"
    new = PartnerDocument.objects.get(doc_type="POLICE_VERIFICATION", is_current=True)
    with django_capture_on_commit_callbacks(execute=True):
        api.post(f"/admin/partner-documents/{new.pk}/approve", token=admin.access_token)
    assert PartnerProfile.objects.get().status == "APPROVED"  # reinstated automatically


# --- Manual add ---


def admin_upload(api, admin, purpose, content=PDF, mime="application/pdf"):
    return upload(api, admin.access_token, purpose, content, mime, admin=True)


def test_admin_adds_a_partner_who_logs_in_approved(api, admin, django_capture_on_commit_callbacks):
    """Exit criterion 3."""
    from apps.partners.tests.support import PNG

    documents = []
    for rule in RequiredDocument.objects.filter(role="NURSE", mandatory=True):
        body = {"docType": rule.doc_type, "fileKey": admin_upload(api, admin, "kyc_document")}
        if rule.number_rule == "AADHAAR":
            body["number"] = "234567891234"
        elif rule.number_rule == "PAN":
            body["number"] = "ABCDE1234F"
        elif rule.number_rule == "TEXT":
            body["number"] = "OD-NC-777"
        if rule.has_expiry:
            body["expiresOn"] = "2099-01-01"
        documents.append(body)
    payload = {
        **PROFILE,
        "role": "NURSE",
        "phone": "9876543299",
        "alternatePhone": "9876543298",
        "email": "nurse@example.com",
        "photoKey": admin_upload(api, admin, "partner_photo", PNG, "image/png"),
        "documents": documents,
        "checked": True,
    }
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post("/admin/partners", payload, admin.access_token)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["status"] == "APPROVED"
    assert resp.json()["addedByAdmin"] is True
    assert PartnerDocument.objects.filter(status="APPROVED").count() == len(documents)
    sms = read_sms("+919876543299")
    assert any("partner app" in m["text"] for m in sms)

    token = partner_login(api, "+919876543299", device_id="nurse-phone")
    assert api.get("/partner/me", token).json()["partnerStatus"] == "APPROVED"
    status = api.get("/partner/kyc/status", token).json()
    assert status["steps"]["alternatePhone"] is False and status["steps"]["email"] is False
    # they verify the email once (allowed while approved, only until verified)
    assert verify_email(api, token, "nurse@example.com").status_code == 200
    again = api.post("/partner/register/email", {"email": "other@example.com"}, token)
    assert again.json()["error"]["code"] == "NOT_EDITABLE"


def test_manual_add_needs_every_mandatory_document(api, admin):
    payload = {
        **PROFILE,
        "role": "COMPANION",
        "phone": "9876543297",
        "alternatePhone": "9876543296",
        "email": "c@example.com",
        "photoKey": "x",
        "documents": [{"docType": "PAN", "fileKey": "kyc/x/y.pdf", "number": "ABCDE1234F"}],
        "checked": True,
    }
    resp = api.post("/admin/partners", payload, admin.access_token)
    assert resp.json()["error"]["code"] == "DOCUMENTS_MISSING"


def test_required_documents_admin(api, admin, partner):
    rows = api.get("/admin/required-documents", admin.access_token).json()
    aadhaar = next(r for r in rows if r["role"] == "COMPANION" and r["docType"] == "AADHAAR")
    body = {k: aadhaar[k] for k in aadhaar if k not in ("id",)}
    resp = api.put(
        f"/admin/required-documents/{aadhaar['id']}",
        {**body, "help": "Both sides", "helpHi": "दोनों तरफ़", "conditionOr": "ଯଦି ଦରକାର"},
        admin.access_token,
    )
    assert resp.json()["help"] == "Both sides"
    assert (resp.json()["helpHi"], resp.json()["conditionOr"]) == ("दोनों तरफ़", "ଯଦି ଦରକାର")
    new = api.post(
        "/admin/required-documents",
        {
            **body,
            "docType": "VACCINATION",
            "label": "Vaccination card",
            "mandatory": False,
            "numberRule": "NONE",
        },
        admin.access_token,
    )
    assert new.status_code == 200, new.json()
    assert (
        api.delete(f"/admin/required-documents/{new.json()['id']}", admin.access_token).status_code
        == 200
    )
    api.post("/partner/register/start", {"role": "COMPANION"}, partner)
    add_document(api, partner, "AADHAAR")
    used = api.delete(f"/admin/required-documents/{aadhaar['id']}", admin.access_token)
    assert used.json()["error"]["code"] == "IN_USE"


@pytest.mark.parametrize(
    ("rule", "raw", "stored"),
    [
        ("AADHAAR", "2345 6789 1234", "XXXX XXXX 1234"),
        ("PAN", "abcde1234f", "XXXXXX234F"),
        ("TEXT", "  od-02-2019   0012345 ", "OD-02-2019 0012345"),  # as printed, spaces tidied
        ("NONE", "anything", ""),
    ],
)
def test_document_numbers_are_masked_or_kept_as_printed(rule: str, raw: str, stored: str) -> None:
    assert mask_number(rule, raw) == stored


@pytest.mark.parametrize(("rule", "raw"), [("AADHAAR", "1234"), ("PAN", "ABC"), ("TEXT", "ab")])
def test_bad_document_numbers_are_refused(rule: str, raw: str) -> None:
    with pytest.raises(InvalidDocument):
        mask_number(rule, raw)
