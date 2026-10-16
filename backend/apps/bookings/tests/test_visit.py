"""The visit: job steps with GPS, the job OTP, care notes, patient not available, the balance
(PHASES 8.1, 8.2, 8.5-8.7; ARCHITECTURE §6.11)."""

import datetime as dt

import pytest
from django.utils import timezone

from apps.assignments.models import AlertKind, StaffAlert
from apps.assignments.tests.fixtures import approved_partner
from apps.assignments.tests.test_assignments import accepted
from apps.audit.models import AuditLog
from apps.bookings.models import Booking, BookingEvent, BookingStatus
from apps.documents.models import PatientDocument
from apps.payments.tests.test_cancel_reschedule import paid_booking
from common import realtime
from common.sms import read_dev_outbox as read_sms
from conftest import staff_token

pytestmark = pytest.mark.django_db

S = BookingStatus
HOME = {"lat": "20.296100", "lng": "85.824500"}  # Mother's address in the test world
FAR = {"lat": "20.350000", "lng": "85.900000"}  # about 10 km away


def step(api, token, booking_id, name, **extra):
    return api.post(
        f"/partner/bookings/{booking_id}/steps", {"step": name, "accuracy": 12.0, **extra}, token
    )


def otp_of(api, world, booking_id):
    return api.get(f"/patient/bookings/{booking_id}", world.token).json()["jobOtp"]


def test_a_hospital_visit_step_by_step(
    api, world, booking, asha, staff_roles, sent, django_capture_on_commit_callbacks
):
    token, _ = asha
    with django_capture_on_commit_callbacks(execute=True):
        accepted(api, booking, asha, staff_roles)
    # §6.11: the OTP is shown to the owner and sent by SMS to Mother's own phone
    otp = otp_of(api, world, booking.pk)
    assert otp and len(otp) == 4 and otp.isdigit()
    assert read_sms("+919876543210")[-1]["template"] == "JOB_OTP"
    booking.refresh_from_db()
    assert otp not in booking.otp_hash and otp not in booking.otp_enc  # never stored plain

    job = api.get(f"/partner/jobs/{booking.pk}", token).json()
    assert job["visit"]["steps"][:3] == ["ON_THE_WAY", "REACHED_PATIENT", "PICKED_UP"]
    assert job["visit"]["nextStep"] == "ON_THE_WAY" and job["visit"]["otpStep"] == "PICKED_UP"
    assert step(api, token, booking.pk, "PICKED_UP").json()["error"]["code"] == "STEP_OUT_OF_ORDER"

    with django_capture_on_commit_callbacks(execute=True):
        resp = step(api, token, booking.pk, "ON_THE_WAY", lat="20.290000", lng="85.840000")
    assert resp.status_code == 200, resp.json()
    assert resp.json()["status"] == "IN_PROGRESS"
    assert (realtime.user_group("patient", str(booking.booked_by_id)), "booking.updated") in [
        (g, k) for g, k, _ in sent
    ]
    # an offline retry of the same step does nothing
    assert step(api, token, booking.pk, "ON_THE_WAY").status_code == 200
    assert BookingEvent.objects.filter(booking=booking, step="ON_THE_WAY").count() == 1

    assert step(api, token, booking.pk, "REACHED_PATIENT", **HOME).status_code == 200
    wrong = step(api, token, booking.pk, "PICKED_UP", otp="0000" if otp != "0000" else "1111")
    assert wrong.status_code == 422
    assert wrong.json()["error"]["details"]["triesLeft"] == 3
    assert step(api, token, booking.pk, "PICKED_UP", otp=otp).status_code == 200
    assert otp_of(api, world, booking.pk) is None  # done: no longer shown

    # "Reached hospital" 10 km away: saved, flagged for the admin
    far = step(api, token, booking.pk, "REACHED_HOSPITAL", **FAR)
    assert far.status_code == 200
    assert far.json()["visit"]["done"][-1]["far"] is True
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.FAR_STEP).exists()

    for name in ("VISIT_DONE", "DROPPED_HOME"):
        assert step(api, token, booking.pk, name, **HOME).status_code == 200
    done = step(api, token, booking.pk, "COMPLETED", **HOME)
    assert done.json()["status"] == "COMPLETED" and done.json()["visit"]["nextStep"] is None

    patient = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert [d["step"] for d in patient["visit"]["done"]] == [
        "ON_THE_WAY",
        "REACHED_PATIENT",
        "PICKED_UP",
        "REACHED_HOSPITAL",
        "VISIT_DONE",
        "DROPPED_HOME",
        "COMPLETED",
    ]


def test_wrong_codes_bring_a_growing_wait_and_the_admin_can_mark_the_step(
    api, world, booking, asha, staff_roles, sent, django_capture_on_commit_callbacks
):
    """§6.11 (developer, 12 Oct 2026): 4 tries, then 5, 10, 20 min… before the next one; never
    a hard lock."""
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    otp = otp_of(api, world, booking.pk)
    step(api, token, booking.pk, "ON_THE_WAY")
    step(api, token, booking.pk, "REACHED_PATIENT", **HOME)
    bad = "1234" if otp != "1234" else "4321"
    with django_capture_on_commit_callbacks(execute=True):
        codes = [
            step(api, token, booking.pk, "PICKED_UP", otp=bad).json()["error"] for _ in range(4)
        ]
    assert [c["details"]["triesLeft"] for c in codes] == [3, 2, 1, 0]
    first_wait = dt.datetime.fromisoformat(codes[-1]["details"]["retryAt"]) - timezone.now()
    assert dt.timedelta(minutes=4) < first_wait <= dt.timedelta(minutes=5)
    # waiting: even the right code waits; the admin is alerted (once)
    waiting = step(api, token, booking.pk, "PICKED_UP", otp=otp).json()["error"]
    assert waiting["code"] == "OTP_WAIT" and "retryAt" in waiting["details"]
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.OTP_LOCKED).count() == 1
    assert ("staff.ops", "alert") in [(g, k) for g, k, _ in sent]
    job = api.get(f"/partner/jobs/{booking.pk}", token).json()
    assert job["visit"]["otpRetryAt"] is not None
    # after the wait one more wrong code: 10 minutes this time
    Booking.objects.filter(pk=booking.pk).update(otp_retry_at=timezone.now())
    again = step(api, token, booking.pk, "PICKED_UP", otp=bad).json()["error"]
    second_wait = dt.datetime.fromisoformat(again["details"]["retryAt"]) - timezone.now()
    assert dt.timedelta(minutes=9) < second_wait <= dt.timedelta(minutes=10)
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.OTP_LOCKED).count() == 1
    # the admin confirms with the family by phone and marks the step (logged)
    resp = api.post(
        f"/admin/bookings/{booking.pk}/steps",
        {"step": "PICKED_UP", "reason": "Daughter confirmed on the phone"},
        ops,
    )
    assert resp.status_code == 200, resp.json()
    assert resp.json()["visit"]["done"][-1] == {
        **resp.json()["visit"]["done"][-1],
        "step": "PICKED_UP",
        "by": "STAFF",
    }
    assert AuditLog.objects.filter(action="booking.step_marked").exists()
    support = staff_token(api, staff_roles, "SUPPORT")
    no = api.post(
        f"/admin/bookings/{booking.pk}/steps",
        {"step": "REACHED_HOSPITAL", "reason": "x" * 5},
        support,
    )
    assert no.status_code == 403


def test_a_nurse_writes_a_care_note_saved_to_the_documents(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    nurse = approved_partner(api, "+919811100003", role="NURSE", name="Mina Sahu")
    home = paid_booking(
        api, world, fake, django_capture_on_commit_callbacks, service="Wound dressing"
    )
    token, _ = nurse
    accepted(api, home, nurse, staff_roles)
    otp = otp_of(api, world, home.pk)
    step(api, token, home.pk, "ON_THE_WAY")
    step(api, token, home.pk, "REACHED_HOME", **HOME)
    assert step(api, token, home.pk, "STARTED", otp=otp).status_code == 200
    missing = step(api, token, home.pk, "CARE_DONE", note=" ")
    assert missing.json()["error"]["code"] == "CARE_NOTE_REQUIRED"
    vitals = {"bp": "130/85", "pulse": 78, "spo2": 97}
    resp = step(
        api, token, home.pk, "CARE_DONE", note="Dressing changed, wound clean.", vitals=vitals
    )
    assert resp.status_code == 200, resp.json()
    note = PatientDocument.objects.get(type=PatientDocument.Type.CARE_NOTE)
    assert note.text == "Dressing changed, wound clean." and note.vitals == vitals
    assert note.file_key is None and note.size_bytes == 0
    docs = api.get("/patient/documents", world.token).json()["items"]
    care = next(d for d in docs if d["type"] == "CARE_NOTE")
    assert care["text"].startswith("Dressing") and care["vitals"]["pulse"] == 78
    assert api.get(f"/patient/documents/{note.pk}/view-url", world.token).status_code == 422


def test_patient_not_available_needs_15_minutes_and_a_call(api, world, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    assert (
        api.post(f"/partner/bookings/{booking.pk}/patient-not-available", {}, token).status_code
        == 409
    )
    step(api, token, booking.pk, "REACHED_PATIENT", **HOME)
    early = api.post(f"/partner/bookings/{booking.pk}/patient-not-available", {}, token)
    assert early.json()["error"]["code"] == "TOO_EARLY"
    # 15 minutes later but no call yet
    BookingEvent.objects.filter(booking=booking, step="REACHED_PATIENT").update(
        server_ts=timezone.now() - dt.timedelta(minutes=16)
    )
    no_call = api.post(f"/partner/bookings/{booking.pk}/patient-not-available", {}, token)
    assert no_call.json()["error"]["details"]["called"] is False
    assert (
        api.post(f"/partner/bookings/{booking.pk}/calls", {"to": "MEMBER"}, token).status_code
        == 204
    )
    resp = api.post(f"/partner/bookings/{booking.pk}/patient-not-available", HOME, token)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["status"] == "PATIENT_NO_SHOW"
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.NO_SHOW).exists()
    # the call attempt isn't on the family's timeline
    timeline = api.get(f"/patient/bookings/{booking.pk}", world.token).json()["timeline"]
    assert "CALL" not in [t["event"] for t in timeline]


def test_the_balance_is_recorded_after_completed(api, world, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    balance = {"amountPaise": 40000, "mode": "CASH", "note": ""}
    assert (
        api.post(f"/partner/bookings/{booking.pk}/balance", balance, token).json()["error"]["code"]
        == "BALANCE_NOT_NOW"
    )
    ops = staff_token(api, staff_roles, "SUPER_ADMIN")
    for name in ("ON_THE_WAY", "REACHED_PATIENT", "PICKED_UP", "REACHED_HOSPITAL"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    for name in ("VISIT_DONE", "DROPPED_HOME", "COMPLETED"):
        step(api, token, booking.pk, name, **HOME)
    resp = api.post(f"/partner/bookings/{booking.pk}/balance", balance | {"mode": "UPI"}, token)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["visit"]["balanceCollectedPaise"] == 40000
    assert resp.json()["visit"]["balanceMode"] == "UPI"
    Booking.objects.filter(pk=booking.pk).update()  # no-op
    BookingEvent.objects.filter(booking=booking, to_status=S.COMPLETED).update(
        server_ts=timezone.now() - dt.timedelta(hours=25)
    )
    late = api.post(f"/partner/bookings/{booking.pk}/balance", balance, token)
    assert late.json()["error"]["code"] == "BALANCE_NOT_NOW"


def test_another_partner_cant_touch_the_job(api, booking, asha, ravi, staff_roles):
    accepted(api, booking, asha, staff_roles)
    ravi_token, _ = ravi
    assert step(api, ravi_token, booking.pk, "ON_THE_WAY").status_code == 404
    assert (
        api.post(f"/partner/bookings/{booking.pk}/calls", {"to": "MEMBER"}, ravi_token).status_code
        == 404
    )


def test_a_fake_location_on_a_step_is_not_kept_and_the_admin_is_told(
    api, booking, asha, staff_roles
):
    """§12: mock locations are refused. The step still saves (the visit goes on), without the
    fake position: an arrival is flagged as "no position", and the admin gets MOCK_GPS."""
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    assert step(api, token, booking.pk, "ON_THE_WAY", **HOME).status_code == 200
    resp = step(api, token, booking.pk, "REACHED_PATIENT", **HOME, mock=True)
    assert resp.status_code == 200 and resp.json()["visit"]["done"][-1]["far"] is True
    row = BookingEvent.objects.get(booking=booking, step="REACHED_PATIENT")
    assert row.lat is None and row.lng is None and row.accuracy is None
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.MOCK_GPS).count() == 1
