"""A partner deletes their own account (ARCHITECTURE §6.20, PHASES 9B.3)."""

import datetime as dt
import re

import pytest
from django.utils import timezone

from apps.accounts.models import Consent, Session, User
from apps.assignments.models import StaffAlert
from apps.assignments.tests.test_assignments import accepted, assign
from apps.audit.models import AuditLog
from apps.bookings.models import Booking, BookingEvent
from apps.files.storage import LocalStorage
from apps.kyc.models import PartnerApplication, PartnerDocument
from apps.partners import services
from apps.partners.models import PartnerDeletion, PartnerPhone, PartnerProfile
from apps.partners.tests.support import PRIMARY, partner_login, register
from common.sms import read_dev_outbox as read_sms
from conftest import staff_token

pytestmark = pytest.mark.django_db


def error(resp) -> dict:
    return resp.json()["error"]


def patient_login(api, phone: str) -> str:
    body = {"phone": phone, "purpose": "login", "deviceId": "patient-device-1"}
    assert api.post("/auth/otp/send", body).status_code == 200
    code = re.findall(r"[0-9]{6}", read_sms(phone)[-1]["text"])[0]
    resp = api.post("/auth/otp/verify", {**body, "otp": code})
    assert resp.status_code == 200, resp.json()
    return str(resp.json()["accessToken"])


def test_deleting_logs_out_at_once_and_a_login_before_the_date_keeps_the_account(
    api, asha, staff_roles
):
    token, partner_id = asha
    resp = api.post("/partner/me/delete", token=token)
    assert resp.status_code == 200, resp.json()
    out = resp.json()
    assert not out["done"]
    due = dt.datetime.fromisoformat(out["dueAt"])
    assert dt.timedelta(days=6, hours=23) < due - timezone.now() <= dt.timedelta(days=7)
    partner = PartnerProfile.objects.get(pk=partner_id)
    # the status stays (sanctions keep working while it waits); not available any more
    assert partner.status == "APPROVED" and not partner.available_today
    assert AuditLog.objects.filter(action="partner.deletion_requested").exists()
    assert api.get("/partner/me", token).status_code == 401  # logged out everywhere
    # the admin sees it, with the date
    admin = staff_token(api, staff_roles)
    shown = api.get(f"/admin/partners/{partner_id}", admin).json()["partner"]
    assert shown["status"] == "APPROVED"
    assert dt.datetime.fromisoformat(shown["deletionDueAt"]) == due
    rows = api.get("/admin/partners", admin).json()["items"]
    assert next(r for r in rows if r["id"] == partner_id)["deleting"]  # the list's tag
    edit = {
        "role": "COMPANION",
        "fullName": "Someone Else",
        "dob": "1990-05-17",
        "gender": "FEMALE",
        "address": "Plot 12, Saheed Nagar, Bhubaneswar",
        "lat": "20.290000",
        "lng": "85.840000",
        "languages": ["Odia"],
        "emergencyName": "Ravi",
        "emergencyPhone": "9876500001",
    }
    refused = api.put(f"/admin/partners/{partner_id}", edit, admin)
    assert refused.status_code == 409 and error(refused)["code"] == "PARTNER_DELETED"
    deletion = PartnerDeletion.objects.get(user_id=partner_id)
    assert (deletion.source, deletion.phone_last4) == ("APP", "0001")

    # they log in again before the date: the account stays, approved as before
    token = partner_login(api, "+919811100001", device_id="device-0001")
    assert api.get("/partner/me", token).json()["partnerStatus"] == "APPROVED"
    deletion.refresh_from_db()
    assert deletion.status == "CANCELLED" and deletion.cancelled_at is not None
    assert services.process_due_deletions(now=due + dt.timedelta(minutes=1)) == 0


def test_refused_while_a_job_is_theirs_and_open_offers_go_back_to_the_queue(
    api, asha, booking, staff_roles, django_capture_on_commit_callbacks
):
    token, partner_id = asha
    ops = accepted(api, booking, asha, staff_roles)
    refused = api.post("/partner/me/delete", token=token)
    assert refused.status_code == 409 and error(refused)["code"] == "ACTIVE_JOBS"
    assert PartnerProfile.objects.get(pk=partner_id).status == "APPROVED"

    # the job moves to another partner; a new offer to Asha is open when she deletes
    Booking.objects.filter(pk=booking.pk).update(status="NEW", partner=None)
    assign(api, ops, booking.pk, partner_id)
    assert Booking.objects.get(pk=booking.pk).status == "OFFERED"
    with django_capture_on_commit_callbacks(execute=True):
        assert api.post("/partner/me/delete", token=token).status_code == 200
    booking.refresh_from_db()
    assert booking.status == "NEW" and booking.partner_id is None  # back in the queue


def test_after_the_waiting_time_the_personal_data_and_files_are_gone(
    api, django_capture_on_commit_callbacks
):
    token = partner_login(api)
    register(api, token)
    partner = PartnerProfile.objects.get(user__phone=PRIMARY)
    keys = [partner.photo_key, *PartnerDocument.objects.values_list("file_key", flat=True)]
    storage = LocalStorage()
    assert all(storage.size(key) for key in keys)
    api.post("/partner/me/consents", {"items": [{"type": "PRIVACY", "version": "2026-10"}]}, token)

    assert api.post("/partner/me/delete", token=token).status_code == 200
    deletion = PartnerDeletion.objects.get(user=partner.user)
    assert services.process_due_deletions(now=deletion.due_at - dt.timedelta(minutes=1)) == 0
    with django_capture_on_commit_callbacks(execute=True):
        assert services.process_due_deletions(now=deletion.due_at + dt.timedelta(minutes=1)) == 1

    partner.refresh_from_db()
    assert partner.status == "DELETED"
    assert (partner.full_name, partner.dob, partner.email, partner.address) == (
        "Former partner",
        None,
        "",
        "",
    )
    assert partner.photo_key == "" and partner.emergency_phone == "" and partner.lat is None
    assert not PartnerPhone.objects.filter(partner=partner).exists()
    assert not PartnerDocument.objects.filter(partner=partner).exists()
    assert not PartnerApplication.objects.filter(partner=partner).exists()
    assert all(storage.size(key) is None for key in keys)  # the files too
    # not a patient: the user row is anonymised, the number is free again
    user = User.objects.get(pk=partner.pk)
    assert user.phone.startswith("x") and user.status == "DELETED"
    assert not Session.objects.filter(user=user).exists()
    assert Consent.objects.filter(user=user).exists()  # proof of what was accepted stays
    deletion.refresh_from_db()
    assert deletion.status == "DONE" and not deletion.kept_patient


def test_someone_who_never_chose_a_role_is_deleted_at_once(api):
    token = partner_login(api)
    out = api.post("/partner/me/delete", token=token).json()
    assert out["done"]
    assert User.objects.filter(phone=PRIMARY).count() == 0  # anonymised at once


def test_a_patient_too_keeps_the_patient_account_and_can_register_again(
    api, asha, django_capture_on_commit_callbacks
):
    token, partner_id = asha
    patient = patient_login(api, "+919811100001")
    assert api.post("/partner/me/delete", token=token).status_code == 200
    deletion = PartnerDeletion.objects.get(user_id=partner_id)
    with django_capture_on_commit_callbacks(execute=True):
        services.process_due_deletions(now=deletion.due_at + dt.timedelta(minutes=1))
    deletion.refresh_from_db()
    assert deletion.kept_patient
    assert api.get("/patient/me", patient).status_code == 200  # still logged in as a patient
    assert not Session.objects.filter(user_id=partner_id, app="partner").exists()

    # the same number opens the Partner app again: it registers from the start
    token = partner_login(api, "+919811100001", device_id="device-0001")
    assert api.get("/partner/me", token).json()["partnerStatus"] == "DELETED"
    assert api.post("/partner/register/start", {"role": "NURSE"}, token).status_code == 200
    partner = PartnerProfile.objects.get(pk=partner_id)
    assert (partner.status, partner.role, partner.full_name) == ("REGISTERING", "NURSE", "")
    assert PartnerPhone.objects.filter(partner=partner, kind="PRIMARY").exists()


def test_a_patient_account_erased_after_the_partner_one_frees_the_number(
    api, asha, django_capture_on_commit_callbacks
):
    """Both accounts deleted: whichever goes last anonymises the user (a DELETED partner
    account is no reason to keep it)."""
    from apps.patients.models import AccountDeletion
    from apps.patients.services import process_due_deletions as erase_patients

    token, partner_id = asha
    patient = patient_login(api, "+919811100001")
    assert api.post("/partner/me/delete", token=token).status_code == 200
    with django_capture_on_commit_callbacks(execute=True):
        later = timezone.now() + dt.timedelta(days=8)
        assert services.process_due_deletions(now=later) == 1
    assert User.objects.get(pk=partner_id).phone == "+919811100001"  # still a patient
    assert api.post("/patient/me/delete-request", token=patient).status_code == 200
    with django_capture_on_commit_callbacks(execute=True):
        assert erase_patients(now=timezone.now() + dt.timedelta(days=8)) == 1
    assert not AccountDeletion.objects.get(user_id=partner_id).kept_partner
    assert User.objects.get(pk=partner_id).phone.startswith("x")


def test_sanctions_keep_working_while_a_deletion_waits(api, asha, staff_roles):
    """Deleting and logging in again is no way out of a suspension (deep check)."""
    token, partner_id = asha
    assert api.post("/partner/me/delete", token=token).status_code == 200
    admin = staff_token(api, staff_roles)
    suspended = api.post(f"/admin/partners/{partner_id}/suspend", {"reason": "Complaint"}, admin)
    assert suspended.status_code == 200, suspended.json()
    token = partner_login(api, "+919811100001", device_id="device-0001")
    assert api.get("/partner/me", token).json()["partnerStatus"] == "SUSPENDED"  # not undone
    assert PartnerDeletion.objects.get(user_id=partner_id).status == "CANCELLED"


def test_a_deleting_partner_gets_no_offers_and_is_not_reviewed(
    api, asha, booking, staff_roles, django_capture_on_commit_callbacks
):
    token, partner_id = asha
    assert api.post("/partner/me/delete", token=token).status_code == 200
    ops = staff_token(api, staff_roles, "OPERATIONS")
    listed = api.get(f"/admin/bookings/{booking.pk}/candidates", ops).json()
    assert partner_id not in [c["partnerId"] for c in listed]
    offer = assign(api, ops, booking.pk, partner_id)
    assert offer.status_code == 409 and error(offer)["code"] == "PARTNER_NOT_ELIGIBLE"

    # an applicant who asks to delete leaves the review queue and can't be opened
    applicant = partner_login(api)
    register(api, applicant)
    with django_capture_on_commit_callbacks(execute=True):
        assert api.post("/partner/kyc/submit", token=applicant).status_code == 200
    reviewer = staff_token(api, staff_roles, "VERIFICATION")
    assert len(api.get("/admin/applications", reviewer).json()) == 1
    assert api.post("/partner/me/delete", token=applicant).status_code == 200
    assert api.get("/admin/applications", reviewer).json() == []
    application = PartnerApplication.objects.get(partner__user__phone=PRIMARY)
    opened = api.post(f"/admin/applications/{application.pk}/claim", token=reviewer)
    assert opened.status_code == 409 and error(opened)["code"] == "PARTNER_DELETING"


def test_the_erase_takes_the_name_out_of_timelines_and_alerts(
    api, asha, booking, staff_roles, django_capture_on_commit_callbacks
):
    token, partner_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, partner_id)  # the offer event notes "Asha Behera"
    assert BookingEvent.objects.filter(booking=booking, note="Asha Behera").exists()
    StaffAlert.objects.create(
        kind="DECLINED",
        booking=booking,
        pickup_at=booking.pickup_at,
        details={"partner": "Asha Behera"},
    )
    with django_capture_on_commit_callbacks(execute=True):
        assert api.post("/partner/me/delete", token=token).status_code == 200
        services.process_due_deletions(now=timezone.now() + dt.timedelta(days=8))
    assert not BookingEvent.objects.filter(note="Asha Behera").exists()
    assert BookingEvent.objects.filter(booking=booking, note="Former partner").exists()
    assert StaffAlert.objects.get(kind="DECLINED").details["partner"] == "Former partner"


def test_registering_needs_the_partner_terms_first(api):
    token = partner_login(api, accept_terms=False)
    refused = api.post("/partner/register/start", {"role": "COMPANION"}, token)
    assert refused.status_code == 409 and error(refused)["code"] == "CONSENT_NEEDED"
