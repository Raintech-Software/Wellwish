"""Phase 8 deep check: the visit's edge cases (wrong codes, arrivals without a position, admin
steps reaching the partner, other families, erasure, SOS and alerts on the admin side)."""

import datetime as dt

import pytest
from django.core.cache import cache
from django.utils import timezone

from apps.assignments.models import AlertKind, StaffAlert
from apps.assignments.tests.test_assignments import accepted
from apps.bookings import services as bookings
from apps.bookings.models import Booking, BookingEvent
from apps.bookings.tests.test_visit import FAR, HOME, otp_of, step
from apps.patients.tests.support import patient
from apps.reviews import services as reviews
from apps.safety import services as safety
from apps.safety.models import ShareLink, SosEvent
from apps.tracking import services as tracking
from apps.tracking.models import BookingTrack
from common import realtime

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def fresh_cache():
    cache.clear()
    yield
    cache.clear()


def test_each_wrong_code_is_saved_at_once(api, world, booking, asha, staff_roles):
    """A wrong try is saved with its own request (not after it): the count is right even when
    tries arrive together."""
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    otp = otp_of(api, world, booking.pk)
    step(api, token, booking.pk, "ON_THE_WAY")
    step(api, token, booking.pk, "REACHED_PATIENT", **HOME)
    bad = "1234" if otp != "1234" else "4321"
    for left in (3, 2):
        resp = step(api, token, booking.pk, "PICKED_UP", otp=bad)
        assert resp.json()["error"]["details"]["triesLeft"] == left
    assert Booking.objects.get(pk=booking.pk).otp_attempts == 2
    assert step(api, token, booking.pk, "PICKED_UP", otp=otp).status_code == 200


def test_an_arrival_without_a_position_is_flagged(api, world, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    resp = step(api, token, booking.pk, "REACHED_PATIENT")  # no lat / lng
    assert resp.status_code == 200
    assert resp.json()["visit"]["done"][-1]["far"] is True
    alert = StaffAlert.objects.get(booking=booking, kind=AlertKind.FAR_STEP)
    assert alert.details == {"step": "REACHED_PATIENT", "metres": None}


def test_a_step_marked_by_the_admin_reaches_the_partner_app(
    api, booking, asha, staff_roles, sent, django_capture_on_commit_callbacks
):
    token, user_id = asha
    ops = accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    with django_capture_on_commit_callbacks(execute=True):
        api.post(
            f"/admin/bookings/{booking.pk}/steps",
            {"step": "REACHED_PATIENT", "reason": "Called the partner"},
            ops,
        )
    partner_group = realtime.user_group("partner", user_id)
    assert (partner_group, "booking.updated") in [(g, k) for g, k, _ in sent]


def test_another_family_cant_see_or_touch_this_visit(api, world, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    other = patient(api, phone="+919000000002", device_id="patient-device-2")
    calls = [
        ("get", f"/patient/bookings/{booking.pk}/live", None),
        ("post", f"/patient/bookings/{booking.pk}/sos", {}),
        ("post", f"/patient/bookings/{booking.pk}/share-link", {}),
        ("post", f"/patient/bookings/{booking.pk}/review", {"stars": 5}),
        ("post", f"/patient/bookings/{booking.pk}/report-problem", {"text": "Not my booking"}),
    ]
    for method, path, body in calls:
        resp = api.get(path, other) if method == "get" else api.post(path, body, other)
        assert resp.status_code == 404, path


def test_vitals_stay_off_the_timeline(api, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY", vitals={"pulse": 80})
    assert BookingEvent.objects.get(booking=booking, step="ON_THE_WAY").vitals is None


def test_account_erasure_removes_the_visit_positions(api, world, booking, asha, staff_roles):
    token, user_id = asha
    ops = accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY", **FAR)
    api.post(f"/patient/bookings/{booking.pk}/share-link", token=world.token)
    api.post(f"/partner/bookings/{booking.pk}/sos", {"lat": "20.290000", "lng": "85.840000"}, token)
    tracking.record_point(
        booking_id=str(booking.pk),
        partner_user_id=user_id,
        point=tracking.Point(lat=20.28, lng=85.83, accuracy=9, at=timezone.now()),
    )
    for name in ("REACHED_PATIENT", "PICKED_UP", "REACHED_HOSPITAL", "VISIT_DONE", "DROPPED_HOME"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    step(api, token, booking.pk, "COMPLETED", **HOME)
    tracking.finish(str(booking.pk))
    api.post(
        f"/patient/bookings/{booking.pk}/review",
        {"stars": 4, "comment": "Mother's name is Sabitri"},
        world.token,
    )
    assert BookingTrack.objects.filter(booking=booking).exists()

    owner = str(Booking.objects.get(pk=booking.pk).booked_by_id)
    bookings.erase_for_owner(user_id=owner)
    tracking.erase_for_owner(user_id=owner)
    safety.erase_for_owner(user_id=owner)
    reviews.erase_for_owner(user_id=owner)

    events = BookingEvent.objects.filter(booking=booking)
    assert not events.filter(lat__isnull=False).exists()
    assert not BookingTrack.objects.filter(booking=booking).exists()
    assert SosEvent.objects.get(booking=booking).lat is None
    assert not ShareLink.objects.filter(booking=booking).exists()
    review = booking.review
    review.refresh_from_db()
    assert review.stars == 4 and review.comment == ""


def test_an_sos_is_resolved_once(api, booking, asha, staff_roles):
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    api.post(f"/partner/bookings/{booking.pk}/sos", {}, token)
    sos_id = str(SosEvent.objects.get().pk)
    first = api.post(f"/admin/sos/{sos_id}/resolve", {"notes": "Called her, all fine"}, ops)
    assert first.status_code == 200
    second = api.post(f"/admin/sos/{sos_id}/resolve", {"notes": "Second admin's note"}, ops)
    assert second.json()["error"]["code"] == "SOS_ALREADY_RESOLVED"
    assert SosEvent.objects.get().notes == "Called her, all fine"


def test_visit_alerts_show_the_partner_to_call_and_close_everywhere_when_seen(
    api, booking, asha, staff_roles, sent, django_capture_on_commit_callbacks
):
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    step(api, token, booking.pk, "REACHED_PATIENT", **FAR)
    rows = api.get("/admin/alerts?kind=FAR_STEP&kind=NO_LOCATION", ops).json()["items"]
    assert [r["kind"] for r in rows] == ["FAR_STEP"]
    assert rows[0]["partnerName"] == "Asha Behera" and rows[0]["phone"].startswith("+91")
    with django_capture_on_commit_callbacks(execute=True):
        api.post(f"/admin/alerts/{rows[0]['id']}/ack", token=ops)
    acked = [d for g, k, d in sent if g == "staff.ops" and k == "alert.acked"]
    assert acked == [{"id": rows[0]["id"], "bookingId": str(booking.pk)}]
    live = api.get("/admin/live", ops).json()
    assert "partnerAlternatePhone" in live[0]


def test_a_share_link_ends_after_12_hours(api, world, booking, asha, staff_roles):
    accepted(api, booking, asha, staff_roles)
    link = api.post(f"/patient/bookings/{booking.pk}/share-link", token=world.token).json()
    secret = link["url"].split("#", 1)[1]
    assert api.get("/public/track", HTTP_X_SHARE_TOKEN=secret).status_code == 200
    ShareLink.objects.update(expires_at=timezone.now() - dt.timedelta(seconds=1))
    assert api.get("/public/track", HTTP_X_SHARE_TOKEN=secret).status_code == 404


def test_on_the_way_only_from_2_hours_before_pickup(api, booking, asha, staff_roles, settings):
    """§6.11 (developer, 10 Oct 2026): a tap days early would stop the family cancelling."""
    settings.JOB_START_BEFORE_HOURS = 2
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)  # the visit is tomorrow
    early = step(api, token, booking.pk, "ON_THE_WAY")
    assert early.json()["error"]["code"] == "TOO_EARLY_TO_START"
    start = dt.datetime.fromisoformat(early.json()["error"]["details"]["from"])
    assert start == Booking.objects.get(pk=booking.pk).pickup_at - dt.timedelta(hours=2)
    Booking.objects.filter(pk=booking.pk).update(pickup_at=timezone.now() + dt.timedelta(hours=1))
    assert step(api, token, booking.pk, "ON_THE_WAY").status_code == 200
    assert ops  # the admin can still mark it any time (after a call)
