"""Phase 8 second deep check (12 Oct 2026): the changes made after the phone test (growing
wait, full price in the app, alerts) reviewed again. One test per problem found."""

import datetime as dt

import pytest
from django.core.cache import cache
from django.utils import timezone

from apps.assignments import services as assignments
from apps.assignments.models import AlertKind, StaffAlert
from apps.assignments.tests.test_assignments import accepted
from apps.bookings import visit
from apps.bookings.models import Booking
from apps.bookings.tests.test_visit import HOME, otp_of, step
from apps.notifications.models import Notification
from apps.tracking import services as tracking
from apps.tracking.tests.test_tracking import batch_of, on_the_way, point  # noqa: F401 (fixture)
from conftest import staff_token

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def fresh_cache():
    cache.clear()
    yield
    cache.clear()


def at_the_door(api, world, booking, asha, staff_roles):
    """Accepted, On the way, Reached: the next step needs the visit code."""
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    otp = otp_of(api, world, booking.pk)
    step(api, token, booking.pk, "ON_THE_WAY")
    step(api, token, booking.pk, "REACHED_PATIENT", **HOME)
    return token, ops, otp


def completed(api, booking, asha, staff_roles, capture):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    ops = staff_token(api, staff_roles, "SUPER_ADMIN")
    for name in ("ON_THE_WAY", "REACHED_PATIENT", "PICKED_UP", "REACHED_HOSPITAL"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    with capture(execute=True):
        for name in ("VISIT_DONE", "DROPPED_HOME", "COMPLETED"):
            assert step(api, token, booking.pk, name, **HOME).status_code == 200
    return token


def paid_in_full(booking):
    snapshot = {**booking.price_snapshot, "balance_paise": 0}
    Booking.objects.filter(pk=booking.pk).update(price_snapshot=snapshot)


# --- The visit code ---


def test_the_wait_stays_at_60_minutes_however_many_wrong_codes():
    """The 43rd wrong code overflowed timedelta: a 500 that rolled the count back, so the wait
    stopped working and every code could be tried."""
    waits = {n: visit._otp_wait(n) for n in (4, 5, 6, 7, 8, 43, 1000)}
    minutes = {n: w.total_seconds() / 60 for n, w in waits.items() if w is not None}
    assert minutes == {4: 5, 5: 10, 6: 20, 7: 40, 8: 60, 43: 60, 1000: 60}
    assert visit._otp_wait(3) is None


def test_a_missing_code_is_not_a_wrong_try(api, world, booking, asha, staff_roles):
    token, _, otp = at_the_door(api, world, booking, asha, staff_roles)
    for sent in ("", "12"):
        resp = step(api, token, booking.pk, "PICKED_UP", otp=sent)
        assert resp.status_code == 422
        assert resp.json()["error"]["code"] == "OTP_REQUIRED"
    assert Booking.objects.get(pk=booking.pk).otp_attempts == 0
    assert step(api, token, booking.pk, "PICKED_UP", otp=otp).status_code == 200


def test_the_wrong_code_alert_closes_when_the_step_is_done(
    api, world, booking, asha, staff_roles, sent, django_capture_on_commit_callbacks
):
    token, ops, otp = at_the_door(api, world, booking, asha, staff_roles)
    bad = "1234" if otp != "1234" else "4321"
    for _ in range(4):
        step(api, token, booking.pk, "PICKED_UP", otp=bad)
    alert = StaffAlert.objects.get(booking=booking, kind=AlertKind.OTP_LOCKED)
    assert alert.acknowledged_at is None
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/admin/bookings/{booking.pk}/steps",
            {"step": "PICKED_UP", "reason": "Confirmed with the family by phone"},
            ops,
        )
    assert resp.status_code == 200, resp.json()
    alert.refresh_from_db()
    assert alert.acknowledged_at is not None
    assert ("staff.ops", "alert.acked") in [(g, k) for g, k, _ in sent]  # banners close


# --- Balance and the "visit completed" message (full price in the app, v2.15) ---


def test_no_balance_when_nothing_is_due_and_never_more_than_due(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    token = completed(api, booking, asha, staff_roles, django_capture_on_commit_callbacks)
    url = f"/partner/bookings/{booking.pk}/balance"
    too_much = api.post(url, {"amountPaise": 50000, "mode": "CASH", "note": ""}, token)
    assert too_much.status_code == 422
    assert too_much.json()["error"]["code"] == "BALANCE_TOO_HIGH"
    assert too_much.json()["error"]["details"]["duePaise"] == 40000
    paid_in_full(booking)
    nothing = api.post(url, {"amountPaise": 40000, "mode": "CASH", "note": ""}, token)
    assert nothing.status_code == 409
    assert nothing.json()["error"]["code"] == "BALANCE_NOT_DUE"
    assert Booking.objects.get(pk=booking.pk).balance_collected_paise in (None, 0)


def test_the_completed_message_asks_to_pay_only_when_something_is_due(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    completed(api, booking, asha, staff_roles, django_capture_on_commit_callbacks)
    due = Notification.objects.get(type="JOB_COMPLETED")
    assert "₹400" in due.body


def test_paid_in_full_the_completed_message_has_no_pay_line(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    paid_in_full(booking)
    completed(api, booking, asha, staff_roles, django_capture_on_commit_callbacks)
    assert not Notification.objects.filter(type="JOB_COMPLETED").exists()
    message = Notification.objects.get(type="JOB_COMPLETED_PAID")
    assert "Pay" not in message.body and "₹" not in message.body


# --- Alerts ---


def test_no_location_isnt_raised_again_after_an_admin_saw_it(on_the_way):  # noqa: F811
    booking, _, user_id = on_the_way
    tracking.record_point(
        booking_id=str(booking.pk), partner_user_id=user_id, point=point(20.28, 85.83)
    )
    later = timezone.now() + dt.timedelta(minutes=3)
    assert tracking.no_location_watch(now=later) == 1
    StaffAlert.objects.filter(booking=booking).update(acknowledged_at=timezone.now())
    # the same silence: acknowledged, so no new banner every minute
    assert tracking.no_location_watch(now=later + dt.timedelta(minutes=1)) == 0
    assert tracking.no_location_watch(now=later + dt.timedelta(minutes=5)) == 0
    # the phone comes back, then goes silent again: a new alert
    StaffAlert.objects.filter(booking=booking).update(
        created_at=timezone.now() - dt.timedelta(minutes=10)
    )
    tracking.record_point(
        booking_id=str(booking.pk), partner_user_id=user_id, point=point(20.281, 85.831)
    )
    assert tracking.no_location_watch(now=timezone.now() + dt.timedelta(minutes=3)) == 1


def test_an_escalation_closes_when_the_booking_is_accepted(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    alert = StaffAlert.objects.create(
        kind=AlertKind.ESCALATION, booking=booking, pickup_at=booking.pickup_at, details={}
    )
    with django_capture_on_commit_callbacks(execute=True):
        accepted(api, booking, asha, staff_roles)
    alert.refresh_from_db()
    assert alert.acknowledged_at is not None


def test_an_escalation_closes_when_the_time_changes(api, booking, staff_roles):
    alert = StaffAlert.objects.create(
        kind=AlertKind.ESCALATION, booking=booking, pickup_at=booking.pickup_at, details={}
    )
    assignments.on_reschedule(booking=booking, released_partner_id=None)
    alert.refresh_from_db()
    assert alert.acknowledged_at is not None


# --- Ownership ---


def test_points_for_someone_elses_booking_answer_404(api, booking, asha, ravi, staff_roles):
    accepted(api, booking, asha, staff_roles)
    ravi_token, _ = ravi
    resp = api.post(
        f"/partner/bookings/{booking.pk}/track-batch",
        batch_of((20.28, 85.83, timezone.now())),
        ravi_token,
    )
    assert resp.status_code == 404
