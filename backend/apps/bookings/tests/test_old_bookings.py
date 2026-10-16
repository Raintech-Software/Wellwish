"""PHASES 9.11 (carried over from Phase 8): old bookings that never happened, and a night job
past midnight."""

import datetime as dt

import pytest
from django.utils import timezone

from apps.assignments.models import AlertKind, StaffAlert
from apps.assignments.tests.test_assignments import accepted
from apps.bookings import visit
from apps.bookings.models import Booking
from apps.bookings.tests.test_visit import step

pytestmark = pytest.mark.django_db


def test_a_visit_long_gone_leaves_upcoming_and_the_admin_hears_it_never_started(
    api, world, booking, asha, staff_roles
):
    accepted(api, booking, asha, staff_roles)
    upcoming = api.get("/patient/bookings?bucket=upcoming", world.token).json()
    assert [b["id"] for b in upcoming["items"]] == [str(booking.pk)]

    # pickup was yesterday morning, and the partner never tapped "On the way"
    Booking.objects.filter(pk=booking.pk).update(pickup_at=timezone.now() - dt.timedelta(hours=20))
    assert api.get("/patient/bookings?bucket=upcoming", world.token).json()["count"] == 0
    past = api.get("/patient/bookings?bucket=past", world.token).json()["items"]
    assert [(b["id"], b["status"]) for b in past] == [(str(booking.pk), "ACCEPTED")]
    # nothing closes by itself (money is the admin's call): an alert, once
    assert visit.not_started_sweep() == 1
    assert visit.not_started_sweep() == 0
    alert = StaffAlert.objects.get(kind=AlertKind.NOT_STARTED)
    assert alert.booking_id == booking.pk and alert.details["partner"] == "Asha Behera"
    booking.refresh_from_db()
    assert booking.status == "ACCEPTED"


def test_a_booking_stuck_for_days_is_still_flagged_up_to_a_month_back(
    api, booking, asha, staff_roles
):
    # the live check found one accepted for a pickup days ago, never started, with no alert
    accepted(api, booking, asha, staff_roles)
    Booking.objects.filter(pk=booking.pk).update(pickup_at=timezone.now() - dt.timedelta(days=6))
    assert visit.not_started_sweep() == 1
    StaffAlert.objects.all().delete()
    Booking.objects.filter(pk=booking.pk).update(pickup_at=timezone.now() - dt.timedelta(days=31))
    assert visit.not_started_sweep() == 0  # older than a month: left to the bookings list


def test_on_time_or_already_on_the_way_is_not_flagged(api, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    Booking.objects.filter(pk=booking.pk).update(
        pickup_at=timezone.now() - dt.timedelta(minutes=10)
    )
    assert visit.not_started_sweep() == 0  # 10 minutes late: not yet
    assert step(api, token, booking.pk, "ON_THE_WAY").status_code == 200
    Booking.objects.filter(pk=booking.pk).update(pickup_at=timezone.now() - dt.timedelta(hours=1))
    assert visit.not_started_sweep() == 0  # on the way: fine


def test_a_night_job_past_midnight_stays_on_the_partners_home(api, booking, asha, staff_roles):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    assert step(api, token, booking.pk, "ON_THE_WAY").status_code == 200
    # it started at 23:30 yesterday (India time) and is still going
    Booking.objects.filter(pk=booking.pk).update(pickup_at=timezone.now() - dt.timedelta(days=1))
    today = api.get("/partner/home", token).json()["today"]
    assert [j["id"] for j in today] == [str(booking.pk)]
