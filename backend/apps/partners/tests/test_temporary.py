"""Temporary partners (ARCHITECTURE §6.19, PHASES 8B): a person the admin phoned and ID-checked,
for one booking only."""

import pytest
from django.db import IntegrityError, transaction
from django.utils import timezone

from apps.accounts.models import User
from apps.assignments.models import BookingAssignment
from apps.audit.models import AuditLog
from apps.bookings.models import Booking
from apps.bookings.tests.support import tomorrow_at
from apps.notifications.models import Notification
from apps.partners.models import PartnerPhone, PartnerProfile, PartnerStatus, TemporaryIdCheck
from apps.partners.services import change_status
from apps.partners.tests.support import PNG, upload
from apps.payments.tests.test_cancel_reschedule import paid_booking
from common.sms import read_dev_outbox as read_sms
from common.state_machine import InvalidTransition
from conftest import make_staff, staff_token

pytestmark = pytest.mark.django_db

S = PartnerStatus
NEW_PERSON = "+919811100066"


@pytest.fixture(autouse=True)
def _media(settings, tmp_path):
    settings.FILE_STORAGE = "local"
    settings.MEDIA_ROOT = tmp_path


def temporary_profile(phone: str = "+919811100055") -> PartnerProfile:
    user = User.objects.create_user(phone)
    return PartnerProfile.objects.create(user=user, role="COMPANION", status=S.TEMPORARY)


# --- 8B.1: statuses and the ID check ---


def test_a_temporary_partner_ends_is_reused_or_registers_for_real():
    partner = temporary_profile()
    assert change_status(partner, "temp_end") == S.TEMP_ENDED
    assert change_status(partner, "temp_assign") == S.TEMPORARY  # needed again later
    change_status(partner, "temp_end")
    assert change_status(partner, "register") == S.REGISTERING  # signs up properly
    # never straight to approved, and no way into the temporary states from the normal flow
    with pytest.raises(InvalidTransition):
        change_status(partner, "temp_assign")
    with pytest.raises(InvalidTransition):
        change_status(temporary_profile("+919811100056"), "approve")


def test_one_open_id_check_per_partner(booking, staff_roles):
    staff = make_staff(staff_roles, "OPERATIONS")
    partner = temporary_profile()
    fields = {
        "partner": partner,
        "booking": booking,
        "id_type": TemporaryIdCheck.IdType.AADHAAR,
        "id_last4": "1234",
        "id_photo_key": "partners/temporary-ids/staff-x/a.jpg",
        "reason": "Every companion busy this evening",
        "checked_by": staff,
        "checked_at": timezone.now(),
    }
    TemporaryIdCheck.objects.create(**fields)
    with pytest.raises(IntegrityError), transaction.atomic():
        TemporaryIdCheck.objects.create(**fields)
    # ended: a new one may open (the same person needed again)
    TemporaryIdCheck.objects.filter(partner=partner).update(ended_at=timezone.now())
    TemporaryIdCheck.objects.create(**fields)
    assert TemporaryIdCheck.objects.filter(partner=partner).count() == 2


# --- 8B.2: the temporary assign ---


def current(api, ops, booking_id):
    return api.get(f"/admin/bookings/{booking_id}/assignment", ops).json()["currentAssignmentId"]


def temp_assign(api, ops, booking_id, *, phone=NEW_PERSON, **change):
    body = {
        "phone": phone,
        "fullName": "Mamata Sahoo",
        "gender": "FEMALE",
        "idType": "AADHAAR",
        "idLast4": "4321",
        "idPhotoKey": upload(api, ops, "temp_partner_id", PNG, "image/png", admin=True),
        "nursingRegNo": "",
        "reason": "Every companion is busy this evening",
        "idChecked": True,
        "expectedAssignmentId": current(api, ops, booking_id),
        **change,
    }
    return api.post(f"/admin/bookings/{booking_id}/temporary-assign", body, ops)


def test_a_new_number_gets_the_booking_accepted_at_once(
    api, world, booking, staff_roles, django_capture_on_commit_callbacks
):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    with django_capture_on_commit_callbacks(execute=True):
        resp = temp_assign(api, ops, booking.pk, idLast4="ab12")
    assert resp.status_code == 200, resp.json()
    assert resp.json()["status"] == "ACCEPTED"

    partner = PartnerProfile.objects.get(user__phone=NEW_PERSON)
    assert (partner.status, partner.role, partner.full_name) == (
        S.TEMPORARY,
        "COMPANION",
        "Mamata Sahoo",
    )
    assert Booking.objects.get(pk=booking.pk).partner_id == partner.pk
    offer = BookingAssignment.objects.get(booking=booking)
    assert (offer.kind, offer.response) == ("TEMPORARY", "ACCEPTED_BY_PHONE")
    check = TemporaryIdCheck.objects.get(partner=partner)
    assert (check.id_type, check.id_last4, check.ended_at) == ("AADHAAR", "AB12", None)
    assert Booking.objects.get(pk=booking.pk).otp_hash  # the visit code, as on accept
    # the person: the app link with their job; the family: the usual "partner assigned"
    sms = read_sms(NEW_PERSON)[-1]
    assert sms["template"] == "TEMP_PARTNER_JOB" and booking.code in sms["text"]
    assert Notification.objects.filter(type="BOOKING_ASSIGNED").exists()
    entry = AuditLog.objects.get(action="booking.temp_assigned")
    assert entry.after is not None and entry.after["id_last4"] == "AB12" and entry.reason
    # the family's app shows a partner like any other (8B.5: never "temporary")
    detail = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert detail["partner"]["fullName"] == "Mamata Sahoo"
    assert "temporary" not in str(detail).lower() and "TEMP" not in str(detail)


def test_numbers_that_are_refused(api, world, booking, asha, staff_roles):
    ops = staff_token(api, staff_roles, "OPERATIONS")

    def error_for(phone, **change):
        resp = temp_assign(api, ops, booking.pk, phone=phone, **change)
        assert resp.status_code in (409, 422), resp.json()
        return resp.json()["error"]

    approved = error_for("+919811100001")  # Asha, an approved partner
    assert approved["code"] == "PHONE_IS_PARTNER" and approved["details"]["status"] == "APPROVED"
    PartnerPhone.objects.create(
        partner=PartnerProfile.objects.get(user__phone="+919811100001"),
        kind=PartnerPhone.Kind.ALTERNATE,
        phone="+919811100002",
    )
    assert error_for("+919811100002")["code"] == "PHONE_IS_PARTNER"  # her alternate phone
    rejected = temporary_profile("+919811100003")
    PartnerProfile.objects.filter(pk=rejected.pk).update(status=S.REJECTED)
    assert error_for("+919811100003")["details"]["status"] == "REJECTED"
    assert error_for("+919000000001")["code"] == "TEMP_PARTNER_IS_FAMILY"  # who booked
    assert error_for("98765 43210")["code"] == "TEMP_PARTNER_IS_FAMILY"  # Mother's phone
    assert error_for("12345")["code"] == "INVALID_PHONE"
    assert error_for(NEW_PERSON, idChecked=False)["code"] == "ID_NOT_CHECKED"
    assert not TemporaryIdCheck.objects.exists()


def test_a_patients_number_works_and_is_still_one_person(api, world, booking, staff_roles):
    patient = User.objects.create_user("+919811100088")
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert temp_assign(api, ops, booking.pk, phone="+919811100088").status_code == 200
    assert PartnerProfile.objects.get(pk=patient.pk).status == S.TEMPORARY
    assert User.objects.filter(phone="+919811100088").count() == 1  # one number, one person


def test_busy_elsewhere_refused_ended_reused(
    api, world, booking, fake, staff_roles, django_capture_on_commit_callbacks
):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert temp_assign(api, ops, booking.pk).status_code == 200
    other = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(15).isoformat(),
        appointmentAt=tomorrow_at(16).isoformat(),
    )
    busy = temp_assign(api, ops, other.pk)
    assert busy.json()["error"]["code"] == "TEMP_PARTNER_BUSY"
    # their first job ended: the same profile is used again, with a new ID check
    partner = PartnerProfile.objects.get(user__phone=NEW_PERSON)
    change_status(partner, "temp_end")
    TemporaryIdCheck.objects.filter(partner=partner).update(ended_at=timezone.now())
    again = temp_assign(api, ops, other.pk)
    assert again.status_code == 200, again.json()
    assert PartnerProfile.objects.filter(user__phone=NEW_PERSON).count() == 1
    assert TemporaryIdCheck.objects.filter(partner=partner).count() == 2


def test_an_open_offer_is_withdrawn_and_another_admin_is_noticed(
    api, world, booking, asha, staff_roles
):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    _, asha_id = asha
    api.post(
        f"/admin/bookings/{booking.pk}/assign",
        {"partnerId": asha_id, "expectedAssignmentId": None},
        ops,
    )
    stale = temp_assign(api, ops, booking.pk, expectedAssignmentId=None)
    assert stale.json()["error"]["code"] == "OFFER_CHANGED"  # offered meanwhile
    assert temp_assign(api, ops, booking.pk).status_code == 200
    rows = dict(BookingAssignment.objects.filter(booking=booking).values_list("kind", "response"))
    assert rows == {"NEW": "WITHDRAWN", "TEMPORARY": "ACCEPTED_BY_PHONE"}


def test_a_nurse_booking_needs_the_registration_number(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    nurse_job = paid_booking(
        api, world, fake, django_capture_on_commit_callbacks, service="Wound dressing"
    )
    ops = staff_token(api, staff_roles, "OPERATIONS")
    missing = temp_assign(api, ops, nurse_job.pk)
    assert missing.json()["error"]["code"] == "NURSING_REG_REQUIRED"
    ok = temp_assign(api, ops, nurse_job.pk, nursingRegNo="OD-NC-778")
    assert ok.status_code == 200, ok.json()
    assert PartnerProfile.objects.get(user__phone=NEW_PERSON).role == "NURSE"


def test_the_id_card_and_photo_for_admins_only(api, world, booking, staff_roles):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert api.get(f"/admin/bookings/{booking.pk}/temporary-partner", ops).status_code == 404
    temp_assign(api, ops, booking.pk)
    card = api.get(f"/admin/bookings/{booking.pk}/temporary-partner", ops).json()
    assert card["fullName"] == "Mamata Sahoo" and card["phone"] == NEW_PERSON
    assert (card["idType"], card["idLast4"], card["status"]) == ("AADHAAR", "4321", "TEMPORARY")
    assert card["checkedBy"] and card["selfieUrl"] is None
    # the photo of an ID card: like partner documents, not for view-only roles
    support = staff_token(api, staff_roles, "SUPPORT")  # bookings.view
    assert api.get(f"/admin/bookings/{booking.pk}/temporary-partner", support).status_code == 200
    hidden = api.get(f"/admin/bookings/{booking.pk}/temporary-partner/id-photo", support)
    assert hidden.status_code == 403
    photo = api.get(f"/admin/bookings/{booking.pk}/temporary-partner/id-photo", ops).json()
    assert photo["url"].startswith("/v1/files/view/") and photo["mime"] == "image/png"
    assert AuditLog.objects.filter(action="temporary.id_viewed").count() == 1
    finance = staff_token(api, staff_roles, "FINANCE")
    assert api.get(f"/admin/bookings/{booking.pk}/temporary-partner", finance).status_code == 403
    refused = api.post(f"/admin/bookings/{booking.pk}/temporary-assign", {}, support)
    assert refused.status_code in (403, 422)


# --- 8B.3: what a temporary partner can open ---


@pytest.fixture
def temporary(api, world, booking, staff_roles, settings, django_capture_on_commit_callbacks):
    """A temporary partner logged in to the partner app with the SMS code; the booking is
    tomorrow, so "On the way" is opened early for these tests."""
    from apps.partners.tests.support import partner_login

    settings.JOB_START_BEFORE_HOURS = 48
    ops = staff_token(api, staff_roles, "OPERATIONS")
    with django_capture_on_commit_callbacks(execute=True):
        assert temp_assign(api, ops, booking.pk).status_code == 200
    token = partner_login(api, NEW_PERSON, device_id="temp-phone")
    return token, ops


def step(api, token, booking_id, name, **extra):
    body = {"step": name, "lat": "20.296100", "lng": "85.824500", "accuracy": 12.0, **extra}
    return api.post(f"/partner/bookings/{booking_id}/steps", body, token)


def test_a_temporary_partner_opens_only_their_job(
    api, world, booking, fake, temporary, django_capture_on_commit_callbacks
):
    token, _ = temporary
    me = api.get("/partner/me", token).json()
    assert me["partnerStatus"] == "TEMPORARY" and me["temporaryBookingId"] == str(booking.pk)
    job = api.get(f"/partner/jobs/{booking.pk}", token)
    assert job.status_code == 200, job.json()
    assert job.json()["address"]["line1"].startswith("Plot")  # the full job, as accepted
    # another booking: not found, whatever its state
    other = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(15).isoformat(),
        appointmentAt=tomorrow_at(16).isoformat(),
    )
    assert api.get(f"/partner/jobs/{other.pk}", token).status_code == 404
    assert step(api, token, other.pk, "ON_THE_WAY").status_code == 404
    # offers, availability, totals, the job lists and registration stay closed
    for path in ("/partner/offers", "/partner/home", "/partner/totals", "/partner/jobs"):
        assert api.get(path, token).json()["error"]["code"] == "PARTNER_NOT_APPROVED", path
    assert api.get("/partner/me/availability", token).status_code == 403
    start = api.post("/partner/register/start", {"role": "COMPANION"}, token)
    assert start.json()["error"]["code"] == "ROLE_LOCKED"
    # their language, like any partner (Phase 9.1)
    assert api.put("/partner/me/language", {"language": "or"}, token=token).status_code == 200


def test_on_the_way_needs_todays_selfie_which_becomes_their_photo(api, world, booking, temporary):
    token, _ = temporary
    refused = step(api, token, booking.pk, "ON_THE_WAY")
    assert refused.status_code == 409 and refused.json()["error"]["code"] == "SELFIE_REQUIRED"
    assert api.get("/partner/me", token).json()["selfieToday"] is False  # the app asks first
    selfie = upload(api, token, "partner_selfie")
    assert api.post("/partner/me/selfie", {"fileKey": selfie}, token).status_code == 200
    assert api.get("/partner/me", token).json()["selfieToday"] is True  # also after a restart
    assert PartnerProfile.objects.get(user__phone=NEW_PERSON).photo_key == selfie
    started = step(api, token, booking.pk, "ON_THE_WAY")
    assert started.status_code == 200, started.json()
    assert started.json()["status"] == "IN_PROGRESS"
    # the family sees the photo like for any partner
    family = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert family["partner"]["photoUrl"]


# --- 8B.5: who sees "temporary" ---


def test_only_the_admin_side_says_temporary(
    api, world, booking, fake, asha, temporary, django_capture_on_commit_callbacks
):
    _, ops = temporary
    detail = api.get(f"/admin/bookings/{booking.pk}", ops).json()
    assert detail["temporaryPartner"] is True
    other = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(15).isoformat(),
        appointmentAt=tomorrow_at(16).isoformat(),
    )
    rows = api.get("/admin/bookings?temporary=true", ops).json()["items"]
    assert [r["code"] for r in rows] == [booking.code] and rows[0]["temporaryPartner"]
    others = api.get("/admin/bookings?temporary=false", ops).json()["items"]
    assert [r["code"] for r in others] == [other.code]
    # never in the suggestions for another booking: only approved partners are
    candidates = api.get(f"/admin/bookings/{other.pk}/candidates", ops).json()
    assert NEW_PERSON not in [c["phone"] for c in candidates] and candidates  # Asha is
    # the family: the normal cancel rules (no special refund), and no word "temporary"
    preview = api.get(f"/patient/bookings/{booking.pk}/cancel-preview", world.token).json()
    assert preview["refundPercent"] == 50
    assert "temporary" not in str(preview).lower()


# --- 8B.4: when access ends ---


def ended(reason):
    partner = PartnerProfile.objects.get(user__phone=NEW_PERSON)
    check = TemporaryIdCheck.objects.get(partner=partner)
    return partner.status == S.TEMP_ENDED and check.end_reason == reason and check.ended_at


def logged_out(api, token):
    return api.get("/partner/me", token).status_code == 401


def test_unassign_ends_access_at_once(api, booking, temporary):
    token, ops = temporary
    body = {"reason": "She can't make it", "expectedAssignmentId": current(api, ops, booking.pk)}
    resp = api.post(f"/admin/bookings/{booking.pk}/unassign", body, ops)
    assert resp.status_code == 200, resp.json()
    assert Booking.objects.get(pk=booking.pk).status == "NEW"  # back in the queue
    assert ended("UNASSIGNED") and logged_out(api, token)


def test_a_cancel_ends_access_at_once(api, booking, temporary, django_capture_on_commit_callbacks):
    token, ops = temporary
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/admin/bookings/{booking.pk}/cancel",
            {"reason": "The family called to cancel", "refundPercent": 100},
            ops,
        )
    assert resp.status_code == 200, resp.json()
    assert ended("CANCELLED") and logged_out(api, token)


def test_a_new_time_releases_a_temporary_partner(api, world, booking, temporary):
    token, _ = temporary
    resp = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": tomorrow_at(15).isoformat(), "appointmentAt": tomorrow_at(16).isoformat()},
        world.token,
    )
    assert resp.status_code == 200, resp.json()
    after = Booking.objects.get(pk=booking.pk)
    assert (after.status, after.partner_id) == ("NEW", None)  # no "confirm the new time"
    assert not BookingAssignment.objects.filter(booking=booking, kind="RECONFIRM").exists()
    assert ended("RESCHEDULED") and logged_out(api, token)


def test_an_hour_after_completed_access_ends(api, booking, temporary):
    from datetime import timedelta

    from apps.partners.services import end_temporary_sweep

    token, ops = temporary
    for name in (
        "ON_THE_WAY",
        "REACHED_PATIENT",
        "PICKED_UP",
        "REACHED_HOSPITAL",
        "VISIT_DONE",
        "DROPPED_HOME",
        "COMPLETED",
    ):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    assert Booking.objects.get(pk=booking.pk).status == "COMPLETED"
    # still there for the hour after the job (record the balance, send kept points)
    assert end_temporary_sweep() == 0
    assert api.get(f"/partner/jobs/{booking.pk}", token).status_code == 200
    assert end_temporary_sweep(now=timezone.now() + timedelta(minutes=61)) == 1
    assert ended("COMPLETED") and logged_out(api, token)
    assert end_temporary_sweep(now=timezone.now() + timedelta(minutes=61)) == 0  # once


def test_after_the_end_the_app_is_as_for_someone_not_registered(api, booking, temporary):
    from apps.partners.tests.support import partner_login

    _, ops = temporary
    body = {"reason": "Not needed", "expectedAssignmentId": current(api, ops, booking.pk)}
    api.post(f"/admin/bookings/{booking.pk}/unassign", body, ops)
    again = partner_login(api, NEW_PERSON, device_id="temp-phone-2")
    me = api.get("/partner/me", again).json()
    assert me["partnerStatus"] == "TEMP_ENDED" and me["temporaryBookingId"] is None
    assert api.get(f"/partner/jobs/{booking.pk}", again).status_code == 403
    # registering for real: the full registration and verification follow
    start = api.post("/partner/register/start", {"role": "COMPANION"}, again)
    assert start.status_code == 200, start.json()
    assert start.json()["profile"]["status"] == "REGISTERING"
    # their temporary job stays on record
    assert TemporaryIdCheck.objects.filter(partner__user__phone=NEW_PERSON).count() == 1


def test_a_patient_on_the_same_number_stays_logged_in(api, world, booking, staff_roles):
    import re

    from apps.partners.services import end_temporary

    phone = "+919811100099"
    sent = api.post(
        "/auth/otp/send", {"phone": phone, "purpose": "login", "deviceId": "patient-phone"}
    )
    assert sent.status_code == 200
    code = re.findall(r"\b(\d{6})\b", read_sms(phone)[-1]["text"])[0]
    patient = api.post(
        "/auth/otp/verify",
        {"phone": phone, "otp": code, "purpose": "login", "deviceId": "patient-phone"},
    ).json()["accessToken"]
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert temp_assign(api, ops, booking.pk, phone=phone).status_code == 200
    partner = PartnerProfile.objects.get(user__phone=phone)
    assert end_temporary(
        partner_id=str(partner.pk), booking_id=str(booking.pk), reason="UNASSIGNED"
    )
    assert api.get("/patient/me", patient).status_code == 200  # the patient app keeps working


# --- deep check (12 Oct 2026) ---


def complete(api, ops, booking_id):
    for name in (
        "ON_THE_WAY",
        "REACHED_PATIENT",
        "PICKED_UP",
        "REACHED_HOSPITAL",
        "VISIT_DONE",
        "DROPPED_HOME",
        "COMPLETED",
    ):
        api.post(f"/admin/bookings/{booking_id}/steps", {"step": name, "reason": "Test run"}, ops)
    assert Booking.objects.get(pk=booking_id).status == "COMPLETED"


def test_a_temporary_booking_has_its_partner_for_the_queue_and_escalation(api, booking, temporary):
    from datetime import timedelta

    from apps.assignments import services as assignments
    from apps.assignments.models import StaffAlert

    _, ops = temporary
    rows = api.get("/admin/assignments/queue?when=all", ops).json()["items"]
    assert booking.code not in [r["code"] for r in rows]  # not "still unassigned"
    deadline = assignments.booking_deadline(Booking.objects.get(pk=booking.pk))
    assert assignments.escalation_sweep(now=deadline + timedelta(minutes=1)) == 0
    assert not StaffAlert.objects.filter(booking=booking).exists()  # no "still no partner" mail
    # once their access has ended, the booking needs a partner again
    api.post(f"/admin/bookings/{booking.pk}/temporary-partner/end", {"reason": "Not coming"}, ops)
    rows = api.get("/admin/assignments/queue?when=all", ops).json()["items"]
    assert [r["problem"] for r in rows if r["code"] == booking.code] == ["PARTNER_UNAVAILABLE"]


def test_an_admin_can_end_access_during_the_visit(api, booking, staff_roles, temporary):
    from apps.assignments.models import StaffAlert

    token, ops = temporary
    selfie = upload(api, token, "partner_selfie")
    api.post("/partner/me/selfie", {"fileKey": selfie}, token)
    assert step(api, token, booking.pk, "ON_THE_WAY").json()["status"] == "IN_PROGRESS"
    # unassign and cancel can't once the visit has started; this can
    support = staff_token(api, staff_roles, "SUPPORT")
    path = f"/admin/bookings/{booking.pk}/temporary-partner/end"
    assert api.post(path, {"reason": "Rude to the patient"}, support).status_code == 403
    resp = api.post(path, {"reason": "Rude to the patient"}, ops)
    assert resp.status_code == 200, resp.json()
    assert ended("BY_ADMIN") and logged_out(api, token)
    alert = StaffAlert.objects.get(booking=booking, kind="PARTNER_UNAVAILABLE")
    assert alert.details["why"] == "TEMP_ENDED"
    entry = AuditLog.objects.get(action="temporary.access_ended")
    assert entry.reason == "Rude to the patient"
    again = api.post(path, {"reason": "Twice"}, ops)
    assert again.status_code == 409 and again.json()["error"]["code"] == "NOT_TEMPORARY"


def test_reused_right_after_completed_and_a_late_end_never_ends_the_new_job(
    api, world, booking, fake, temporary, django_capture_on_commit_callbacks
):
    from datetime import timedelta

    from apps.partners.services import end_temporary, end_temporary_sweep
    from apps.partners.tests.support import partner_login

    token, ops = temporary
    selfie = upload(api, token, "partner_selfie")
    api.post("/partner/me/selfie", {"fileKey": selfie}, token)
    complete(api, ops, booking.pk)
    other = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(15).isoformat(),
        appointmentAt=tomorrow_at(16).isoformat(),
    )
    # within the hour after Completed: not "busy", their finished job ends now
    again = temp_assign(api, ops, other.pk)
    assert again.status_code == 200, again.json()
    partner = PartnerProfile.objects.get(user__phone=NEW_PERSON)
    assert partner.status == S.TEMPORARY
    assert partner.photo_key == selfie  # taken today: it still counts, so it stays the photo
    first = TemporaryIdCheck.objects.get(partner=partner, booking=booking)
    assert first.end_reason == "COMPLETED" and first.ended_at
    assert logged_out(api, token)  # the finished job's session; they log in for the new one
    # a late call for the old booking (a slow sweep, a hook) never ends the new job
    assert not end_temporary(
        partner_id=str(partner.pk), booking_id=str(booking.pk), reason="COMPLETED"
    )
    assert end_temporary_sweep(now=timezone.now() + timedelta(minutes=61)) == 0
    token2 = partner_login(api, NEW_PERSON, device_id="temp-phone-3")
    assert api.get("/partner/me", token2).json()["temporaryBookingId"] == str(other.pk)


def test_the_id_card_keeps_this_jobs_selfie(api, booking, temporary):
    from datetime import timedelta

    from django.db.models import F

    from apps.partners.models import SelfieCheck

    token, ops = temporary
    selfie = upload(api, token, "partner_selfie")
    api.post("/partner/me/selfie", {"fileKey": selfie}, token)
    card = f"/admin/bookings/{booking.pk}/temporary-partner"
    assert api.get(card, ops).json()["selfieUrl"]
    # the next day it is still this job's selfie (not "today's")
    day = timedelta(days=1)
    TemporaryIdCheck.objects.update(checked_at=F("checked_at") - day)
    SelfieCheck.objects.update(at=F("at") - day)
    assert api.get(card, ops).json()["selfieUrl"]
    # a selfie from before this job (an earlier one) is not shown as this job's
    SelfieCheck.objects.update(at=F("at") - 3 * day)
    assert api.get(card, ops).json()["selfieUrl"] is None


def test_one_failing_check_does_not_stop_the_sweep(api, booking, temporary, monkeypatch):
    from datetime import timedelta

    from apps.partners import services as partners

    _, ops = temporary
    complete(api, ops, booking.pk)
    real = partners.end_temporary
    calls = []

    def flaky(**kwargs):
        calls.append(kwargs)
        if len(calls) == 1:
            raise RuntimeError("database hiccup")
        return real(**kwargs)

    monkeypatch.setattr(partners, "end_temporary", flaky)
    later = timezone.now() + timedelta(minutes=61)
    assert partners.end_temporary_sweep(now=later) == 0  # logged, not raised
    assert partners.end_temporary_sweep(now=later) == 1  # the next run ends it
    assert ended("COMPLETED")


def test_the_same_new_number_from_two_admins_is_one_person(monkeypatch):
    from apps.accounts import services as accounts

    User.objects.create_user("+919811100077")  # the other admin created it just now

    def racing(phone):
        raise IntegrityError("duplicate key value violates unique constraint")

    monkeypatch.setattr(accounts, "get_or_create_user", racing)
    user = accounts.lock_or_create_user("+919811100077")
    assert user.phone == "+919811100077" and User.objects.count() == 1


def test_a_reused_person_never_shows_an_old_selfie(
    api, world, booking, fake, temporary, django_capture_on_commit_callbacks
):
    from datetime import timedelta

    from django.db.models import F

    from apps.partners.models import SelfieCheck

    token, ops = temporary
    selfie = upload(api, token, "partner_selfie")
    api.post("/partner/me/selfie", {"fileKey": selfie}, token)
    SelfieCheck.objects.update(at=F("at") - timedelta(days=2))  # an earlier job's selfie
    body = {"reason": "Not needed", "expectedAssignmentId": current(api, ops, booking.pk)}
    api.post(f"/admin/bookings/{booking.pk}/unassign", body, ops)
    other = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(15).isoformat(),
        appointmentAt=tomorrow_at(16).isoformat(),
    )
    assert temp_assign(api, ops, other.pk).status_code == 200
    assert PartnerProfile.objects.get(user__phone=NEW_PERSON).photo_key == ""
    family = api.get(f"/patient/bookings/{other.pk}", world.token).json()
    assert family["partner"]["photoUrl"] is None  # until this visit's selfie
