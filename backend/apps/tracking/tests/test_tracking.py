"""Live location during a job (PHASES 8.3, 8.4; ARCHITECTURE §6.11, §10.4, §10.5)."""

import datetime as dt
import uuid

import pytest
from asgiref.sync import async_to_sync
from channels.testing import WebsocketCommunicator
from django.core.cache import cache
from django.utils import timezone

from apps.assignments.models import AlertKind, StaffAlert
from apps.assignments.tests.test_assignments import accepted
from apps.bookings import visit
from apps.bookings.models import BookingEvent
from apps.bookings.tests.test_visit import HOME, step
from apps.tracking import services
from apps.tracking.models import BookingTrack
from common import realtime
from config.asgi import application
from conftest import Api, staff_token

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def fresh_cache():
    cache.clear()
    yield
    cache.clear()


def point(lat: float, lng: float, *, seconds_ago: float = 0, accuracy: float = 10, mock=False):
    at = timezone.now() - dt.timedelta(seconds=seconds_ago)
    return services.Point(lat=lat, lng=lng, accuracy=accuracy, at=at, mock=mock)


@pytest.fixture
def on_the_way(api, booking, asha, staff_roles):
    token, user_id = asha
    accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    return booking, token, user_id


def test_points_are_checked_and_passed_on(api, world, on_the_way, sent):
    booking, _, user_id = on_the_way

    def send(p):
        return services.record_point(booking_id=str(booking.pk), partner_user_id=user_id, point=p)

    assert send(point(20.2800, 85.8300, seconds_ago=30)) is None
    assert send(point(20.2810, 85.8310, accuracy=80)) == "INACCURATE"
    assert send(point(20.5000, 85.9000, seconds_ago=20)) == "TOO_FAST"  # 25 km in 10 s
    assert send(point(20.2820, 85.8320, mock=True)) == "MOCK"
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.MOCK_GPS).count() == 1
    assert send(point(20.2830, 85.8330, seconds_ago=10)) is None

    owner = realtime.user_group("patient", str(booking.booked_by_id))
    to_family = [d for g, k, d in sent if g == owner and k == "booking.location"]
    assert len(to_family) == 2 and to_family[-1]["lat"] == "20.283000"
    # the socket message has the same shape as GET …/live (the app reads both the same way)
    assert set(to_family[-1]) == {"bookingId", "lat", "lng", "at", "etaMin", "step"}
    assert isinstance(to_family[-1]["lng"], str) and isinstance(to_family[-1]["etaMin"], int)
    assert to_family[-1]["etaMin"] >= 1  # heading to Mother's home
    to_staff = [d for g, k, d in sent if g == "staff.ops" and k == "job.location"]
    assert len(to_staff) == 1  # at most every 15 s

    live = api.get(f"/patient/bookings/{booking.pk}/live", world.token).json()
    assert live["lat"] == "20.283000" and live["step"] == "ON_THE_WAY"


def test_the_admin_live_map(api, on_the_way, staff_roles):
    booking, _, user_id = on_the_way
    services.record_point(
        booking_id=str(booking.pk), partner_user_id=user_id, point=point(20.28, 85.83)
    )
    ops = staff_token(api, staff_roles, "SUPER_ADMIN")  # Operations exists already (accepted())
    jobs = api.get("/admin/live", ops).json()
    assert [j["code"] for j in jobs] == [booking.code]
    assert jobs[0]["lat"] == "20.280000" and jobs[0]["stale"] is False
    assert jobs[0]["partnerName"] == "Asha Behera"
    verification = staff_token(api, staff_roles, "VERIFICATION")
    assert api.get("/admin/live", verification).status_code == 403


def test_offline_points_in_a_batch_and_the_route_saved_at_the_end(
    api, on_the_way, staff_roles, django_capture_on_commit_callbacks
):
    booking, token, _ = on_the_way
    base = timezone.now() - dt.timedelta(seconds=50)  # kept offline since "On the way"
    batch = [
        {
            "lat": "20.290000",
            "lng": "85.840000",
            "accuracy": 8,
            "at": (base + dt.timedelta(seconds=s)).isoformat(),
        }
        for s in (20, 0, 40)  # out of order
    ] + [
        {"lat": "20.291000", "lng": "85.841000", "accuracy": 200, "at": base.isoformat()},
        {
            "lat": "20.292000",
            "lng": "85.842000",
            "accuracy": 5,
            "mock": True,
            "at": base.isoformat(),
        },
        # before "On the way": never part of this job
        {
            "lat": "20.293000",
            "lng": "85.843000",
            "accuracy": 5,
            "at": (base - dt.timedelta(hours=2)).isoformat(),
        },
    ]
    resp = api.post(f"/partner/bookings/{booking.pk}/track-batch", {"points": batch}, token)
    assert resp.json() == {"accepted": 3}
    for name in ("REACHED_PATIENT",):
        step(api, token, booking.pk, name, **HOME)
    ops = staff_token(api, staff_roles, "SUPER_ADMIN")
    for name in ("PICKED_UP", "REACHED_HOSPITAL", "VISIT_DONE", "DROPPED_HOME"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    with django_capture_on_commit_callbacks(execute=True):
        step(api, token, booking.pk, "COMPLETED", **HOME)
    track = BookingTrack.objects.get(booking=booking)
    assert track.points_count == 3
    assert services.decode(track.polyline)[0] == (20.29, 85.84)
    assert cache.get(f"track:{booking.pk}") is None  # Redis cleared
    route = api.get(f"/admin/bookings/{booking.pk}/track", ops).json()
    assert len(route["points"]) == 3 and route["km"] == "0.00"


def test_no_location_for_2_minutes_alerts_the_admin(on_the_way, sent):
    booking, _, user_id = on_the_way
    services.record_point(
        booking_id=str(booking.pk),
        partner_user_id=user_id,
        point=point(20.28, 85.83, seconds_ago=30),
    )
    assert services.no_location_watch() == 0
    later = timezone.now() + dt.timedelta(minutes=3)
    assert services.no_location_watch(now=later) == 1
    assert services.no_location_watch(now=later) == 0  # once while open
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.NO_LOCATION).exists()


def test_rough_points_indoors_mean_the_phone_is_alive(on_the_way):
    """Indoors the phone may only know its position to ~300 m: those points aren't shown, but
    the phone isn't silent, so no "no location" alert (Phase 8 phone test)."""
    booking, _, user_id = on_the_way
    now = timezone.now()
    BookingEvent.objects.filter(booking=booking, event="START").update(
        server_ts=now - dt.timedelta(minutes=5)
    )
    rough = services.Point(lat=20.28, lng=85.83, accuracy=320, at=now)
    assert (
        services.record_point(booking_id=str(booking.pk), partner_user_id=user_id, point=rough)
        == "INACCURATE"
    )
    assert services.no_location_watch(now=now + dt.timedelta(seconds=60)) == 0
    assert services.no_location_watch(now=now + dt.timedelta(minutes=3)) == 1  # silent since


def test_last_step_done_an_hour_ago_but_not_completed_alerts(api, on_the_way, staff_roles):
    booking, _, _ = on_the_way
    ops = staff_token(api, staff_roles, "SUPER_ADMIN")
    for name in ("REACHED_PATIENT", "PICKED_UP", "REACHED_HOSPITAL", "VISIT_DONE", "DROPPED_HOME"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    assert visit.not_completed_sweep() == 0
    BookingEvent.objects.filter(booking=booking, step="DROPPED_HOME").update(
        server_ts=timezone.now() - dt.timedelta(minutes=61)
    )
    assert visit.not_completed_sweep() == 1
    assert visit.not_completed_sweep() == 0
    assert StaffAlert.objects.filter(booking=booking, kind=AlertKind.NOT_COMPLETED).exists()


@pytest.mark.django_db(transaction=True)
def test_the_partner_socket_answers_a_refused_point():
    from apps.partners.tests.support import partner_login

    token = partner_login(Api(), "+919811100008", device_id="device-8", accept_terms=False)
    booking_id = str(uuid.uuid4())

    async def run() -> dict:
        socket = WebsocketCommunicator(application, "/ws/partner/")
        connected, _ = await socket.connect()
        assert connected
        await socket.send_json_to({"type": "auth", "token": token})
        assert (await socket.receive_json_from(timeout=5))["type"] == "auth.ok"
        await socket.send_json_to(
            {
                "type": "location.update",
                "data": {"bookingId": booking_id, "lat": 20.28, "lng": 85.83, "accuracy": 9},
            }
        )
        answer = await socket.receive_json_from(timeout=5)
        await socket.disconnect()
        return answer

    answer = async_to_sync(run)()
    assert answer == {
        "type": "location.rejected",
        "data": {"bookingId": booking_id, "reason": "NOT_IN_PROGRESS"},
    }


def batch_of(*points: tuple[float, float, dt.datetime]) -> dict:
    return {
        "points": [
            {"lat": f"{lat:.6f}", "lng": f"{lng:.6f}", "accuracy": 8, "at": at.isoformat()}
            for lat, lng, at in points
        ]
    }


def test_a_phone_clock_ahead_cannot_freeze_the_live_position(api, on_the_way):
    """A batch point from the future is taken as "now"; the next live point (server time)
    still replaces it, and the point times on the map are the server's."""
    booking, token, user_id = on_the_way
    future = timezone.now() + dt.timedelta(hours=3)
    resp = api.post(
        f"/partner/bookings/{booking.pk}/track-batch", batch_of((20.28, 85.83, future)), token
    )
    assert resp.json() == {"accepted": 1}
    booking.refresh_from_db()
    latest = cache.get(f"loc:{booking.partner_id}")
    assert dt.datetime.fromisoformat(latest["at"]) <= timezone.now()
    services.record_point(
        booking_id=str(booking.pk),
        partner_user_id=user_id,
        point=point(20.281, 85.831, seconds_ago=-30),  # the next live point, 30 s later
    )
    assert cache.get(f"loc:{booking.partner_id}")["lat"] == 20.281


def test_points_that_are_not_real_positions_are_refused(on_the_way):
    booking, _, user_id = on_the_way

    def send(p):
        return services.record_point(booking_id=str(booking.pk), partner_user_id=user_id, point=p)

    now = timezone.now()
    assert send(services.Point(lat=float("nan"), lng=85.8, accuracy=5, at=now)) == "INVALID"
    assert send(services.Point(lat=20.2, lng=float("inf"), accuracy=5, at=now)) == "INVALID"
    assert send(services.Point(lat=95.0, lng=85.8, accuracy=5, at=now)) == "INVALID"
    assert send(services.Point(lat=20.2, lng=85.8, accuracy=None, at=now)) == "INACCURATE"
    assert send(point(20.28, 85.83)) is None  # a real one still works afterwards


def test_points_sent_just_after_the_end_join_the_route_then_no_more(
    api, on_the_way, staff_roles, django_capture_on_commit_callbacks
):
    """The phone sends what it kept offline after "Completed": still part of this job's route
    until the route is saved; after that a batch changes nothing (no stray live position)."""
    booking, token, user_id = on_the_way
    services.record_point(
        booking_id=str(booking.pk), partner_user_id=user_id, point=point(20.28, 85.83)
    )
    ops = staff_token(api, staff_roles, "SUPER_ADMIN")
    for name in ("REACHED_PATIENT", "PICKED_UP", "REACHED_HOSPITAL", "VISIT_DONE", "DROPPED_HOME"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    step(api, token, booking.pk, "COMPLETED", **HOME)  # the route isn't saved yet
    booking.refresh_from_db()
    earlier = timezone.now() - dt.timedelta(seconds=20)
    resp = api.post(
        f"/partner/bookings/{booking.pk}/track-batch", batch_of((20.2805, 85.8305, earlier)), token
    )
    assert resp.json() == {"accepted": 1}
    assert cache.get(f"loc:{booking.partner_id}")["lat"] == 20.28  # not shown live any more
    services.finish(str(booking.pk))
    assert BookingTrack.objects.get(booking=booking).points_count == 2
    again = api.post(
        f"/partner/bookings/{booking.pk}/track-batch", batch_of((20.2806, 85.8306, earlier)), token
    )
    assert again.json() == {"accepted": 0}
    assert cache.get(f"track:{booking.pk}") is None


def test_no_points_before_on_the_way(api, world, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    resp = api.post(
        f"/partner/bookings/{booking.pk}/track-batch",
        batch_of((20.28, 85.83, timezone.now())),
        token,
    )
    assert resp.json() == {"accepted": 0}
    assert cache.get(f"track:{booking.pk}") is None


@pytest.mark.django_db(transaction=True)
def test_a_broken_point_on_the_socket_does_not_close_it():
    from apps.partners.tests.support import partner_login

    token = partner_login(Api(), "+919811100009", device_id="device-9", accept_terms=False)

    async def run() -> list[dict]:
        socket = WebsocketCommunicator(application, "/ws/partner/")
        connected, _ = await socket.connect()
        assert connected
        await socket.send_json_to({"type": "auth", "token": token})
        assert (await socket.receive_json_from(timeout=5))["type"] == "auth.ok"
        answers = []
        for booking_id in ("not-a-booking-id", str(uuid.uuid4())):
            await socket.send_json_to(
                {
                    "type": "location.update",
                    "data": {"bookingId": booking_id, "lat": 20.28, "lng": 85.83, "accuracy": 9},
                }
            )
            answers.append(await socket.receive_json_from(timeout=5))
        await socket.disconnect()
        return answers

    answers = async_to_sync(run)()
    assert [a["data"]["reason"] for a in answers] == ["NOT_IN_PROGRESS", "NOT_IN_PROGRESS"]


def test_fake_gps_on_three_jobs_suspends_the_partner_once_the_visit_is_over(
    api, world, fake, on_the_way, django_capture_on_commit_callbacks
):
    """§6.16: mock points are refused and flagged once per job; fake GPS on 3 different jobs
    since the last approval suspends the partner for review, but never in the middle of a
    visit (it waits until that job ends). A reinstatement starts the count again."""
    from apps.bookings.models import Booking
    from apps.partners import services as partners
    from apps.partners.models import PartnerProfile
    from apps.tracking.events import suspend_after_the_job

    booking, _, user_id = on_the_way

    def fake_point_sent() -> str | None:
        fake_point = point(20.28, 85.83, mock=True)
        return services.record_point(
            booking_id=str(booking.pk), partner_user_id=user_id, point=fake_point
        )

    def status() -> str:
        return PartnerProfile.objects.get(pk=user_id).status

    def flag_another_job(hour: int) -> None:
        """An earlier job of hers (finished) where fake GPS was flagged."""
        other = Booking.objects.get(pk=booking.pk)
        other.pk, other.code, other.status = uuid.uuid4(), f"WW-9{hour}", "COMPLETED"
        other.idempotency_key = uuid.uuid4().hex
        other._state.adding = True
        other.save()
        StaffAlert.objects.create(
            kind=AlertKind.MOCK_GPS,
            booking=other,
            pickup_at=other.pickup_at,
            details={"partner": "Asha Behera", "partnerId": user_id},
        )

    flags = StaffAlert.objects.filter(kind=AlertKind.MOCK_GPS)
    assert fake_point_sent() == "MOCK" and fake_point_sent() == "MOCK"
    assert flags.count() == 1  # one open flag per job, however many fake points
    flags.update(acknowledged_at=timezone.now())
    assert fake_point_sent() == "MOCK" and flags.count() == 2  # flagged again, still one job
    flag_another_job(12)
    flag_another_job(15)  # now 3 different jobs…
    assert partners.suspend_for_fake_gps(user_id) is False  # …but a visit is in progress
    assert status() == "APPROVED"
    # the visit ends: the suspension that waited happens
    Booking.objects.filter(pk=booking.pk).update(status="COMPLETED")
    with django_capture_on_commit_callbacks(execute=True):
        suspend_after_the_job("booking.completed", {"booking_id": str(booking.pk)})
    profile = PartnerProfile.objects.get(pk=user_id)
    assert profile.status == "SUSPENDED" and profile.suspended_reason == "MOCK_GPS"
    assert partners.suspend_for_fake_gps(user_id) is False  # twice: nothing more

    # reinstated after the review: the old flags don't count any more
    partners.reinstate(actor=None, partner_id=user_id, ip=None, reason="Spoke to her")
    flag_another_job(18)
    assert partners.suspend_for_fake_gps(user_id) is False
    assert status() == "APPROVED"
