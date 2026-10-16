"""Assignment with the 2-minute rule (PHASES 7.1-7.9, 7.17; ARCHITECTURE §6.10, §6.17)."""

import datetime as dt

import pytest
from django.utils import timezone

from apps.assignments import services
from apps.assignments.models import AlertKind, BookingAssignment, OfferResponse, StaffAlert
from apps.assignments.tests.fixtures import approved_partner
from apps.audit.models import AuditLog
from apps.bookings.models import ActorType, Booking, BookingEvent, BookingStatus
from apps.bookings.services import reminder_sweep
from apps.bookings.tests.support import tomorrow_at
from apps.notifications.models import Notification
from apps.partners.models import PartnerProfile
from apps.partners.tests.support import partner_login
from apps.payments.tests.test_cancel_reschedule import paid_booking
from common import realtime
from common.mail import read_dev_outbox as read_mail
from common.sms import read_dev_outbox as read_sms
from conftest import make_staff, staff_login, staff_token

pytestmark = pytest.mark.django_db

S = BookingStatus


def current(api, token, booking_id):
    """What the admin's page shows as the offer / job (sent back as `expectedAssignmentId`)."""
    resp = api.get(f"/admin/bookings/{booking_id}/assignment", token)
    return resp.json()["currentAssignmentId"] if resp.status_code == 200 else None


def assign(api, token, booking_id, partner_id):
    body = {"partnerId": partner_id, "expectedAssignmentId": current(api, token, booking_id)}
    return api.post(f"/admin/bookings/{booking_id}/assign", body, token)


def note(api, token, booking_id, reason):
    return {"reason": reason, "expectedAssignmentId": current(api, token, booking_id)}


def settled_early(booking):
    """Booked and paid days ahead (reminders skip bookings settled inside their window)."""
    early = booking.pickup_at - dt.timedelta(days=3)
    Booking.objects.filter(pk=booking.pk).update(created_at=early)
    BookingEvent.objects.filter(booking=booking, event="PAY").update(server_ts=early)


def offer_of(partner_token, api):
    offers = api.get("/partner/offers", partner_token).json()
    assert len(offers) == 1, offers
    return offers[0]


# --- 7.1-7.4: queue, candidates, assign, accept ---


def test_assign_accept_and_the_patient_sees_the_partner(
    api, world, booking, asha, ravi, staff_roles, sent, django_capture_on_commit_callbacks
):
    asha_token, asha_id = asha
    _, ravi_id = ravi
    _, nurse_id = approved_partner(api, "+919811100003", role="NURSE", name="Mina")
    ops = staff_token(api, staff_roles, "OPERATIONS")

    queue = api.get("/admin/assignments/queue", ops).json()
    assert [row["code"] for row in queue["items"]] == [booking.code]
    assert queue["items"][0]["offer"] is None
    assert api.get("/admin/assignments/queue/counts", ops).json()["tomorrow"] == 1

    candidates = api.get(f"/admin/bookings/{booking.pk}/candidates", ops).json()
    ids = [c["partnerId"] for c in candidates]
    assert nurse_id not in ids  # a nurse can't take a companion booking
    assert set(ids) == {asha_id, ravi_id}
    assert candidates[0]["partnerId"] == asha_id  # nearest first
    assert candidates[0]["phone"] == "+919811100001"
    assert candidates[0]["distanceKm"] is not None

    with django_capture_on_commit_callbacks(execute=True):
        resp = assign(api, ops, booking.pk, asha_id)
    assert resp.status_code == 200, resp.json()
    state = resp.json()
    assert state["status"] == "OFFERED"
    assert state["openOffer"]["partnerName"] == "Asha Behera"
    timeout = dt.datetime.fromisoformat(state["openOffer"]["timeoutAt"])
    sent_at = dt.datetime.fromisoformat(state["openOffer"]["sentAt"])
    assert timeout - sent_at == dt.timedelta(seconds=120)
    assert (realtime.user_group("partner", asha_id), "offer.new") in [(g, k) for g, k, _ in sent]
    assert any(g == "staff.ops" and k == "queue.changed" for g, k, _ in sent)
    assert Notification.objects.filter(user_id=asha_id, type="OFFER_NEW").exists()
    assert read_sms("+919811100001")[-1]["template"] == "OFFER_NEW"
    assert AuditLog.objects.filter(action="booking.assigned").exists()

    # R08/R09: the summary only, no address or phones before accepting
    home = api.get("/partner/home", asha_token).json()
    offer = home["offers"][0]
    assert offer["area"] == "Saheed Nagar, Bhubaneswar 751007"
    assert "Plot" not in str(offer)
    assert offer["balancePaise"] == 40000
    assert offer["hasPrescription"] is True
    assert api.get(f"/partner/jobs/{booking.pk}", asha_token).status_code == 404

    with django_capture_on_commit_callbacks(execute=True):
        accepted = api.post(f"/partner/offers/{offer['assignmentId']}/accept", token=asha_token)
    assert accepted.status_code == 200, accepted.json()
    job = accepted.json()
    assert job["status"] == "ACCEPTED"
    assert job["address"]["line1"].startswith("Plot")  # the full address opens now
    assert job["member"]["conditions"] == "BP, diabetes"
    assert job["bookerPhone"] == "+919000000001"
    assert len(job["documents"]) == 1

    detail = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert detail["status"] == "ACCEPTED"
    assert detail["partner"]["fullName"] == "Asha Behera"
    assert detail["partner"]["phone"] == "+919811100001"
    assert Notification.objects.filter(type="BOOKING_ASSIGNED").exists()
    # Mother's phone: "partner assigned", then the job OTP (Phase 8)
    assert [m["template"] for m in read_sms("+919876543210")[-2:]] == [
        "BOOKING_ASSIGNED",
        "JOB_OTP",
    ]
    assert (realtime.user_group("patient", str(booking.booked_by_id)), "booking.updated") in [
        (g, k) for g, k, _ in sent
    ]
    # out of the queue; Ravi can't see the job or its documents
    assert api.get("/admin/assignments/queue", ops).json()["items"] == []
    ravi_token = partner_login(api, "+919811100002", device_id="device-0002")
    assert api.get(f"/partner/jobs/{booking.pk}", ravi_token).status_code == 404
    link = job["documents"][0]["id"]
    url = api.get(f"/partner/jobs/{booking.pk}/documents/{link}/view-url", asha_token)
    assert url.status_code == 200 and url.json()["mime"]
    assert (
        api.get(f"/partner/jobs/{booking.pk}/documents/{link}/view-url", ravi_token).status_code
        == 404
    )


def test_two_minutes_without_an_answer_alerts_the_admin(
    api, booking, asha, staff_roles, sent, django_capture_on_commit_callbacks
):
    _, asha_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, asha_id)
    offer = BookingAssignment.objects.get()
    assert services.offer_timeout(str(offer.pk), now=offer.sent_at) is False  # too early
    with django_capture_on_commit_callbacks(execute=True):
        assert services.offer_timeout(str(offer.pk), now=offer.timeout_at) is True
    assert services.offer_timeout(str(offer.pk), now=offer.timeout_at) is False  # once
    alert = StaffAlert.objects.get()
    assert alert.kind == AlertKind.OFFER_TIMEOUT
    assert ("staff.ops", "alert") in [(g, k) for g, k, _ in sent]
    alerts = api.get("/admin/alerts", ops).json()["items"]
    assert alerts[0]["phone"] == "+919811100001"  # call buttons
    # the offer stays open: the admin records "accepted by phone"
    offer.refresh_from_db()
    assert offer.response == OfferResponse.OPEN
    resp = api.post(
        f"/admin/bookings/{booking.pk}/accept-by-phone", note(api, ops, booking.pk, "Said yes"), ops
    )
    assert resp.status_code == 200, resp.json()
    assert resp.json()["status"] == "ACCEPTED"
    assert resp.json()["offers"][0]["response"] == "ACCEPTED_BY_PHONE"
    assert AuditLog.objects.filter(action="booking.accepted_by_phone").exists()
    assert api.get("/admin/alerts", ops).json()["items"] == []  # answered: alert done


def test_a_late_accept_still_wins(api, booking, asha, staff_roles):
    asha_token, asha_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, asha_id)
    offer = BookingAssignment.objects.get()
    services.offer_timeout(str(offer.pk), now=offer.timeout_at)
    late = api.post(f"/partner/offers/{offer.pk}/accept", token=asha_token)
    assert late.status_code == 200, late.json()  # at 3 minutes the job is still theirs


def test_decline_returns_the_booking_to_the_queue_with_the_reason(
    api, booking, asha, staff_roles, sent
):
    asha_token, asha_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, asha_id)
    offer = offer_of(asha_token, api)
    bad = api.post(
        f"/partner/offers/{offer['assignmentId']}/decline", {"reason": "BUSY"}, asha_token
    )
    assert bad.status_code == 422
    resp = api.post(
        f"/partner/offers/{offer['assignmentId']}/decline",
        {"reason": "TOO_FAR", "note": "No bus that early"},
        asha_token,
    )
    assert resp.status_code == 200, resp.json()
    assert resp.json() == []
    booking.refresh_from_db()
    assert (booking.status, booking.partner_id) == (S.NEW, None)
    alert = StaffAlert.objects.get(kind=AlertKind.DECLINED)
    assert alert.details["reason"] == "TOO_FAR" and alert.details["note"] == "No bus that early"
    queue = api.get("/admin/assignments/queue", ops).json()["items"]
    assert queue[0]["openAlerts"] == 1
    again = api.post(f"/partner/offers/{offer['assignmentId']}/accept", token=asha_token)
    assert again.json()["error"]["code"] == "OFFER_NOT_OPEN"


def test_reassigning_withdraws_the_first_offer(
    api, booking, asha, ravi, staff_roles, django_capture_on_commit_callbacks
):
    asha_token, asha_id = asha
    _, ravi_id = ravi
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, asha_id)
    first = offer_of(asha_token, api)
    with django_capture_on_commit_callbacks(execute=True):
        resp = assign(api, ops, booking.pk, ravi_id)
    assert resp.json()["openOffer"]["partnerName"] == "Ravi Das"
    assert BookingAssignment.objects.filter(response=OfferResponse.OPEN).count() == 1
    late = api.post(f"/partner/offers/{first['assignmentId']}/accept", token=asha_token)
    assert late.json()["error"]["code"] == "OFFER_NOT_OPEN"  # "no longer yours"
    assert Notification.objects.filter(user_id=asha_id, type="OFFER_WITHDRAWN").exists()
    assert AuditLog.objects.filter(action="booking.reassigned").exists()


def test_a_busy_partner_is_refused(
    api, world, fake, asha, staff_roles, django_capture_on_commit_callbacks
):
    asha_token, asha_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    first = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    second = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(10).isoformat(),
        appointmentAt=tomorrow_at(11).isoformat(),
    )
    # both offered while she is free, she accepts the first
    assign(api, ops, first.pk, asha_id)
    assign(api, ops, second.pk, asha_id)
    offers = api.get("/partner/offers", asha_token).json()
    assert len(offers) == 2
    by_booking = {o["bookingId"]: o["assignmentId"] for o in offers}
    ok = api.post(f"/partner/offers/{by_booking[str(first.pk)]}/accept", token=asha_token)
    assert ok.status_code == 200
    # the second overlaps: the database refuses it
    clash = api.post(f"/partner/offers/{by_booking[str(second.pk)]}/accept", token=asha_token)
    assert clash.json()["error"]["code"] == "PARTNER_BUSY"
    # and she isn't suggested or assignable for it any more
    candidates = api.get(f"/admin/bookings/{second.pk}/candidates", ops).json()
    assert asha_id not in [c["partnerId"] for c in candidates]
    third = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(11).isoformat(),
        appointmentAt=tomorrow_at(12).isoformat(),
    )
    refused = assign(api, ops, third.pk, asha_id)
    assert refused.json()["error"]["code"] == "PARTNER_BUSY"


def test_only_approved_partners_of_the_right_type(api, booking, staff_roles):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    _, nurse_id = approved_partner(api, "+919811100003", role="NURSE")
    assert assign(api, ops, booking.pk, nurse_id).json()["error"]["code"] == "PARTNER_NOT_ELIGIBLE"
    _, pending_id = approved_partner(api, "+919811100004")
    PartnerProfile.objects.filter(user__phone="+919811100004").update(status="SUSPENDED")
    assert (
        assign(api, ops, booking.pk, pending_id).json()["error"]["code"] == "PARTNER_NOT_ELIGIBLE"
    )


# --- 7.6, 7.7: escalation and reminders ---


def test_unassigned_tomorrow_morning_turns_red_at_6pm_today(
    api, booking, staff_roles, django_capture_on_commit_callbacks
):
    staff = make_staff(staff_roles, "SUPER_ADMIN", email="boss@wellwish.test")
    # paid well before (so the 30-minute grace for late bookings plays no part)
    booking.events.filter(event="PAY").update(server_ts=timezone.now() - dt.timedelta(days=1))
    deadline = services.booking_deadline(booking)
    ist = booking.pickup_at.astimezone(dt.timezone(dt.timedelta(hours=5, minutes=30)))
    assert deadline.astimezone(ist.tzinfo).hour == 18
    assert deadline.astimezone(ist.tzinfo).date() == ist.date() - dt.timedelta(days=1)
    assert services.escalation_sweep(now=deadline - dt.timedelta(minutes=1)) == 0
    with django_capture_on_commit_callbacks(execute=True):
        assert services.escalation_sweep(now=deadline + dt.timedelta(minutes=1)) == 1
    assert services.escalation_sweep(now=deadline + dt.timedelta(minutes=6)) == 0  # once
    assert StaffAlert.objects.get().kind == AlertKind.ESCALATION
    assert "still has no partner" in read_mail(staff.email)[-1]["subject"]


def test_a_late_booking_gets_30_minutes_before_it_counts_as_late():
    """Developer, 12 Oct 2026: a same-day booking was red the moment it was paid."""
    now = timezone.now().replace(microsecond=0)
    pickup = now + dt.timedelta(hours=2)  # the evening before and 3 h before are both past
    assert services.assign_deadline(pickup, now) == now + dt.timedelta(minutes=30)
    soon = now + dt.timedelta(minutes=10)  # paid 10 minutes before the pickup
    assert services.assign_deadline(soon, now) == soon
    early = tomorrow_at(19)  # paid long before: the usual rule
    assert services.assign_deadline(early, now - dt.timedelta(days=3)) == services.assign_deadline(
        early
    )


def test_three_hours_before_comes_first_for_a_late_evening_booking():
    pickup = tomorrow_at(19)
    # 6 PM the day before is earlier than 3 h before (4 PM on the day)
    assert services.assign_deadline(pickup).astimezone(pickup.tzinfo).hour == 18
    soon = timezone.now().replace(microsecond=0) + dt.timedelta(hours=5)
    assert services.assign_deadline(soon) <= soon - dt.timedelta(hours=3)


def test_reminders_24h_and_2h_before(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    asha_token, asha_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, asha_id)
    api.post(
        f"/partner/offers/{offer_of(asha_token, api)['assignmentId']}/accept", token=asha_token
    )
    settled_early(booking)
    pickup = Booking.objects.get(pk=booking.pk).pickup_at
    with django_capture_on_commit_callbacks(execute=True):
        assert reminder_sweep(now=pickup - dt.timedelta(hours=23)) == 1
    assert reminder_sweep(now=pickup - dt.timedelta(hours=23)) == 0  # once
    assert reminder_sweep(now=pickup - dt.timedelta(hours=3)) == 0  # between the two
    with django_capture_on_commit_callbacks(execute=True):
        assert reminder_sweep(now=pickup - dt.timedelta(minutes=90)) == 1
    assert Notification.objects.filter(type="BOOKING_REMINDER").count() == 2
    assert Notification.objects.filter(user_id=asha_id, type="JOB_REMINDER").count() == 2
    assert read_sms("+919876543210")[-1]["template"] == "BOOKING_REMINDER"


def test_after_the_job_phones_last_1_hour_and_documents_24_hours(
    api, world, booking, asha, staff_roles
):
    """§6.14, §6.15, §12: the job window closes after completion (Phase 8 completes jobs)."""
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    link = api.get(f"/partner/jobs/{booking.pk}", token).json()["documents"][0]["id"]
    url = f"/partner/jobs/{booking.pk}/documents/{link}/view-url"
    assert api.get(url, token).status_code == 200
    log = AuditLog.objects.get(action="partner.document_viewed")
    assert log.staff is None
    assert log.after == {"partnerUserId": asha[1], "bookingId": str(booking.pk)}

    Booking.objects.filter(pk=booking.pk).update(status=S.COMPLETED)
    done = BookingEvent.objects.create(
        booking=booking,
        from_status=S.IN_PROGRESS,
        to_status=S.COMPLETED,
        event="COMPLETE",
        actor_type=ActorType.PARTNER,
        server_ts=timezone.now() - dt.timedelta(minutes=30),
    )
    job = api.get(f"/partner/jobs/{booking.pk}", token).json()
    assert job["bookerPhone"] and job["member"]["conditions"] == "BP, diabetes"
    assert api.get(f"/patient/bookings/{booking.pk}", world.token).json()["partner"]["phone"]

    two_hours_ago = timezone.now() - dt.timedelta(hours=2)
    BookingEvent.objects.filter(pk=done.pk).update(server_ts=two_hours_ago)
    job = api.get(f"/partner/jobs/{booking.pk}", token).json()
    assert job["bookerPhone"] == "" and job["member"]["phone"] == ""
    assert job["member"]["conditions"] == "BP, diabetes" and len(job["documents"]) == 1
    assert api.get(url, token).status_code == 200
    patient = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert patient["partner"]["phone"] == ""

    a_day_ago = timezone.now() - dt.timedelta(hours=25)
    BookingEvent.objects.filter(pk=done.pk).update(server_ts=a_day_ago)
    job = api.get(f"/partner/jobs/{booking.pk}", token).json()
    assert job["member"]["conditions"] == "" and job["documents"] == [] and job["notes"] == ""
    assert api.get(url, token).status_code == 404


# --- 7.8: a new time re-confirms with the partner ---


def accepted(api, booking, partner, staff_roles, ops=None):
    token, partner_id = partner
    ops = ops or staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, partner_id)
    resp = api.post(f"/partner/offers/{offer_of(token, api)['assignmentId']}/accept", token=token)
    assert resp.status_code == 200, resp.json()
    return ops


def test_a_new_time_asks_the_partner_to_confirm(
    api, world, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    asha_token, asha_id = asha
    accepted(api, booking, asha, staff_roles)
    with django_capture_on_commit_callbacks(execute=True):
        moved = api.post(
            f"/patient/bookings/{booking.pk}/reschedule",
            {"pickupAt": tomorrow_at(12).isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
            world.token,
        )
    assert moved.json()["reconfirmNeeded"] is True
    offer = offer_of(asha_token, api)
    assert offer["kind"] == "RECONFIRM"
    assert Notification.objects.filter(user_id=asha_id, type="OFFER_TIME_CHANGED").exists()
    ok = api.post(f"/partner/offers/{offer['assignmentId']}/accept", token=asha_token)
    assert ok.status_code == 200, ok.json()
    booking.refresh_from_db()
    assert (booking.status, booking.reconfirm_needed) == (S.ACCEPTED, False)
    assert booking.events.filter(event="RECONFIRM").exists()


def test_a_new_time_for_a_waiting_booking_reorders_the_queue(
    api, world, booking, sent, django_capture_on_commit_callbacks
):
    with django_capture_on_commit_callbacks(execute=True):
        moved = api.post(
            f"/patient/bookings/{booking.pk}/reschedule",
            {"pickupAt": tomorrow_at(12).isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
            world.token,
        )
    assert moved.status_code == 200, moved.json()
    changes = [d for g, k, d in sent if g == "staff.ops" and k == "queue.changed"]
    assert changes[-1]["reason"] == "RESCHEDULED"


def test_declining_the_new_time_puts_it_back_in_the_queue(api, world, booking, asha, staff_roles):
    asha_token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": tomorrow_at(12).isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
        world.token,
    )
    offer = offer_of(asha_token, api)
    api.post(
        f"/partner/offers/{offer['assignmentId']}/decline", {"reason": "NOT_AVAILABLE"}, asha_token
    )
    booking.refresh_from_db()
    assert (booking.status, booking.partner_id) == (S.NEW, None)
    assert api.get("/admin/assignments/queue", ops).json()["items"][0]["code"] == booking.code
    assert StaffAlert.objects.get().details["reconfirm"] is True


def test_a_new_time_that_clashes_releases_the_partner(
    api, world, fake, asha, staff_roles, django_capture_on_commit_callbacks
):
    _, asha_id = asha
    morning = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    afternoon = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(15).isoformat(),
        appointmentAt=tomorrow_at(16).isoformat(),
    )
    ops = accepted(api, morning, asha, staff_roles)
    accepted(api, afternoon, asha, staff_roles, ops)
    with django_capture_on_commit_callbacks(execute=True):
        moved = api.post(
            f"/admin/bookings/{afternoon.pk}/reschedule",
            {"pickupAt": tomorrow_at(10).isoformat(), "appointmentAt": tomorrow_at(11).isoformat()},
            ops,
        )
    assert moved.status_code == 200, moved.json()  # not a 500 from the overlap rule
    afternoon.refresh_from_db()
    assert (afternoon.status, afternoon.partner_id) == (S.NEW, None)
    assert Notification.objects.filter(user_id=asha_id, type="OFFER_WITHDRAWN").exists()


# --- Cancel and unassign ---


def test_cancelling_withdraws_the_offer_and_tells_an_accepted_partner(
    api, world, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    _, asha_id = asha
    accepted(api, booking, asha, staff_roles)
    with django_capture_on_commit_callbacks(execute=True):
        api.post(f"/patient/bookings/{booking.pk}/cancel", {"reason": "PLANS_CHANGED"}, world.token)
    assert Notification.objects.filter(user_id=asha_id, type="JOB_CANCELLED").exists()
    assert read_sms("+919811100001")[-1]["template"] == "JOB_CANCELLED"


def test_admin_unassigns_an_accepted_partner(api, booking, asha, staff_roles):
    asha_token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    resp = api.post(
        f"/admin/bookings/{booking.pk}/unassign", note(api, ops, booking.pk, "Partner is ill"), ops
    )
    assert resp.status_code == 200, resp.json()
    assert resp.json()["status"] == "NEW" and resp.json()["partner"] is None
    assert api.get(f"/partner/jobs/{booking.pk}", asha_token).status_code == 404
    assert AuditLog.objects.filter(action="booking.unassigned").exists()


# --- Permissions ---


def test_who_may_do_what(api, booking, asha, staff_roles):
    asha_token, asha_id = asha
    support = staff_token(api, staff_roles, "SUPPORT")
    assert api.get("/admin/assignments/queue", support).status_code == 200  # may look
    assert assign(api, support, booking.pk, asha_id).status_code == 403  # may not assign
    verification = staff_token(api, staff_roles, "VERIFICATION")
    assert api.get("/admin/assignments/queue", verification).status_code == 403
    # an unapproved partner can't see offers
    PartnerProfile.objects.filter(pk=asha_id).update(status="SUSPENDED")
    assert api.get("/partner/home", asha_token).status_code in (401, 403)


def test_staff_login_helper_works(api, staff_roles):
    staff = make_staff(staff_roles, "OPERATIONS", email="ops2@wellwish.test")
    assert staff_login(api, staff).access_token


# --- Deep check (10 Oct 2026) ---


def test_two_admins_at_once_the_second_is_refused(api, booking, asha, ravi, staff_roles):
    """§6.16: the second admin acted on an old page: 409 OFFER_CHANGED, nothing changes."""
    _, asha_id = asha
    _, ravi_id = ravi
    ops = staff_token(api, staff_roles, "OPERATIONS")
    seen = current(api, ops, booking.pk)  # both pages show "not assigned yet"
    assert seen is None
    assert assign(api, ops, booking.pk, asha_id).status_code == 200
    stale = api.post(
        f"/admin/bookings/{booking.pk}/assign",
        {"partnerId": ravi_id, "expectedAssignmentId": seen},
        ops,
    )
    assert stale.status_code == 409 and stale.json()["error"]["code"] == "OFFER_CHANGED"
    assert "Asha Behera" in stale.json()["error"]["message"]
    phone = api.post(
        f"/admin/bookings/{booking.pk}/accept-by-phone",
        {"reason": "Said yes", "expectedAssignmentId": None},
        ops,
    )
    assert phone.status_code == 409
    assert BookingAssignment.objects.get().partner.full_name == "Asha Behera"


def test_cancelling_after_a_declined_new_time_tells_only_the_new_partner(
    api, world, booking, asha, ravi, staff_roles, django_capture_on_commit_callbacks
):
    asha_token, asha_id = asha
    _, ravi_id = ravi
    ops = accepted(api, booking, asha, staff_roles)
    with django_capture_on_commit_callbacks(execute=True):
        api.post(
            f"/patient/bookings/{booking.pk}/reschedule",
            {"pickupAt": tomorrow_at(12).isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
            world.token,
        )
    offer = offer_of(asha_token, api)
    declined = api.post(
        f"/partner/offers/{offer['assignmentId']}/decline", {"reason": "NOT_AVAILABLE"}, asha_token
    )
    assert declined.status_code == 200, declined.json()
    assert not BookingAssignment.objects.filter(
        partner_id=asha_id, response__in=("OPEN", "ACCEPTED", "ACCEPTED_BY_PHONE")
    ).exists()
    accepted(api, booking, ravi, staff_roles, ops)
    with django_capture_on_commit_callbacks(execute=True):
        cancel = api.post(
            f"/patient/bookings/{booking.pk}/cancel", {"reason": "PLANS_CHANGED"}, world.token
        )
    assert cancel.status_code == 200, cancel.json()
    assert Notification.objects.filter(user_id=ravi_id, type="JOB_CANCELLED").count() == 1
    assert not Notification.objects.filter(user_id=asha_id, type="JOB_CANCELLED").exists()


def test_a_suspended_partner_loses_offers_and_jobs_are_flagged(
    api, booking, asha, ravi, staff_roles, django_capture_on_commit_callbacks
):
    _, asha_id = asha
    _, ravi_id = ravi
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, asha_id)
    PartnerProfile.objects.filter(pk=asha_id).update(status="SUSPENDED")
    # no "accepted by phone" for a suspended partner
    resp = api.post(
        f"/admin/bookings/{booking.pk}/accept-by-phone", note(api, ops, booking.pk, "Yes"), ops
    )
    assert resp.json()["error"]["code"] == "PARTNER_NOT_ELIGIBLE"
    assert services.on_partner_unavailable(asha_id, "SUSPENDED") == 1
    booking.refresh_from_db()
    assert (booking.status, booking.partner_id) == (S.NEW, None)
    # an accepted job of a partner suspended later: flagged and back in the queue
    accepted(api, booking, ravi, staff_roles, ops)
    PartnerProfile.objects.filter(pk=ravi_id).update(status="SUSPENDED")
    assert services.on_partner_unavailable(ravi_id, "SUSPENDED") == 1
    assert StaffAlert.objects.filter(kind=AlertKind.PARTNER_UNAVAILABLE).count() == 1
    row = api.get("/admin/assignments/queue", ops).json()["items"][0]
    assert (row["code"], row["problem"]) == (booking.code, "PARTNER_UNAVAILABLE")


def test_an_unconfirmed_new_time_escalates_at_the_deadline(
    api, world, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    ops = accepted(api, booking, asha, staff_roles)
    with django_capture_on_commit_callbacks(execute=True):
        api.post(
            f"/patient/bookings/{booking.pk}/reschedule",
            {"pickupAt": tomorrow_at(12).isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
            world.token,
        )
    booking.refresh_from_db()
    # the sweep's own deadline: a time change also gets its 30 minutes (run near 6 PM IST, the
    # plain "6 PM the evening before" is earlier than that, so this test failed at that hour)
    deadline = services.booking_deadline(booking)
    assert services.escalation_sweep(now=deadline + dt.timedelta(minutes=1)) == 1
    row = api.get("/admin/assignments/queue", ops).json()["items"][0]
    assert row["problem"] == "RECONFIRM"


def test_a_booking_made_inside_the_reminder_window_gets_no_reminder(booking):
    """Paid now for 23 hours from now: the confirmation went out just now, no 24 h reminder on
    top. (The pickup is set here: the fixture's "tomorrow at 10" is inside 24 h only after 10.)"""
    pickup = timezone.now() + dt.timedelta(hours=23)
    Booking.objects.filter(pk=booking.pk).update(pickup_at=pickup, appointment_at=None)
    assert reminder_sweep(now=timezone.now()) == 0


def test_only_managers_silence_alerts(api, booking, asha, staff_roles):
    _, asha_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assign(api, ops, booking.pk, asha_id)
    offer = BookingAssignment.objects.get()
    services.offer_timeout(str(offer.pk), now=offer.timeout_at)
    alert = StaffAlert.objects.get()
    support = staff_token(api, staff_roles, "SUPPORT")
    assert api.post(f"/admin/alerts/{alert.pk}/ack", token=support).status_code == 403
    assert api.post(f"/admin/alerts/{alert.pk}/ack", token=ops).status_code == 200
    # live.manage ("Acknowledge alerts and SOS") is enough too
    from apps.staff.models import StaffRolePermission

    StaffRolePermission.objects.create(role=staff_roles["SUPPORT"], permission="live.manage")
    assert api.post(f"/admin/alerts/{alert.pk}/ack", token=support).status_code == 200


def test_a_new_time_for_an_offered_booking_sends_a_fresh_offer(
    api, world, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    asha_token, asha_id = asha
    ops = staff_token(api, staff_roles, "OPERATIONS")
    with django_capture_on_commit_callbacks(execute=True):
        assign(api, ops, booking.pk, asha_id)
    first = offer_of(asha_token, api)["assignmentId"]
    with django_capture_on_commit_callbacks(execute=True):
        moved = api.post(
            f"/patient/bookings/{booking.pk}/reschedule",
            {"pickupAt": tomorrow_at(12).isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
            world.token,
        )
    assert moved.status_code == 200, moved.json()
    fresh = offer_of(asha_token, api)
    assert fresh["assignmentId"] != first
    booking.refresh_from_db()
    assert (booking.status, booking.reconfirm_needed) == (S.OFFERED, False)
    assert Notification.objects.filter(user_id=asha_id, type="OFFER_NEW").count() == 2
