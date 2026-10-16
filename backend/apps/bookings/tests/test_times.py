"""Booking dates and times (§6.17, PHASES 5.2): the time grid follows the settings, blocked
dates are greyed out, and the server refuses a time inside the minimum notice."""

import datetime as dt

import pytest
from django.core.cache import cache

from apps.app_config.models import AppSetting, BlockedTime
from apps.app_config.selectors import CACHE_KEY
from apps.bookings import times
from apps.bookings.models import Booking
from apps.bookings.tests.support import at_ist, body, book, make_world
from apps.services.models import Service
from apps.services.seed import seed_services

pytestmark = pytest.mark.django_db

DAY = dt.date(2026, 10, 9)  # a Friday
NOW = at_ist(DAY, 8, 10)  # 8:10 AM IST


def setting(key, value):
    AppSetting.objects.update_or_create(key=key, defaults={"value": value})
    cache.delete(CACHE_KEY)  # settings are cached for a minute


@pytest.fixture
def companion(db):
    seed_services()
    return Service.objects.get(name="Doctor visit companion")


def hhmm(values):
    return [v.astimezone(times.IST).strftime("%H:%M") for v in values]


def test_default_grid(companion):
    """Service hours 7:00 to 21:00, a 30-minute step, 3 hours' notice."""
    today = hhmm(times.available_times(companion, DAY, NOW))
    assert today[0] == "11:30"  # 8:10 + 3 h = 11:10 → the next step
    assert today[-1] == "20:30"  # the last start before 21:00
    assert len(today) == 19
    tomorrow = hhmm(times.available_times(companion, DAY + dt.timedelta(days=1), NOW))
    assert tomorrow[:3] == ["07:00", "07:30", "08:00"]
    assert len(tomorrow) == 28


def test_settings_change_the_grid(companion):
    setting("time_step_min", "60")
    setting("service_hours_start", "09:00")
    setting("service_hours_end", "13:00")
    setting("min_notice_hours", 0)
    assert hhmm(times.available_times(companion, DAY, NOW)) == ["09:00", "10:00", "11:00", "12:00"]


def test_hours_that_run_past_midnight(companion):
    setting("service_hours_start", "20:00")
    setting("service_hours_end", "02:00")
    grid = hhmm(times.available_times(companion, DAY + dt.timedelta(days=1), NOW))
    assert grid == ["00:00", "00:30", "01:00", "01:30", "20:00", "20:30", "21:00", "21:30",
                    "22:00", "22:30", "23:00", "23:30"]  # fmt: skip


def test_window_and_days(companion):
    days = times.available_days(companion, NOW)
    assert days[0] == (DAY, True)
    assert days[-1][0] == DAY + dt.timedelta(days=30)
    assert len(days) == 31
    setting("booking_window_days", 7)
    assert len(times.available_days(companion, NOW)) == 8
    assert times.available_times(companion, DAY + dt.timedelta(days=8), NOW) == []


def test_late_evening_starts_tomorrow(companion):
    late = at_ist(DAY, 20, 0)  # 8 PM: 3 hours' notice is past the service hours
    assert times.available_times(companion, DAY, late) == []
    days = dict(times.available_days(companion, late))
    assert days[DAY] is False
    assert hhmm(times.available_times(companion, DAY + dt.timedelta(days=1), late))[0] == "07:00"


def test_blocked_dates_and_times(companion):
    nurse = Service.objects.get(name="Injection visit")
    holiday = DAY + dt.timedelta(days=3)
    BlockedTime.objects.create(
        from_ts=at_ist(holiday, 0), to_ts=at_ist(holiday + dt.timedelta(days=1), 0), reason="Diwali"
    )
    sunday = DAY + dt.timedelta(days=2)
    BlockedTime.objects.create(
        from_ts=at_ist(sunday, 13), to_ts=at_ist(sunday, 21), reason="Sunday afternoon",
        service_type="NURSE",
    )  # fmt: skip
    days = dict(times.available_days(companion, NOW))
    assert days[holiday] is False  # greyed out
    assert days[sunday] is True
    assert times.available_times(companion, holiday, NOW) == []
    assert hhmm(times.available_times(companion, sunday, NOW))[-1] == "20:30"  # companions: open
    assert hhmm(times.available_times(nurse, sunday, NOW))[-1] == "12:30"  # nurses: closed at 1
    with pytest.raises(times.TimeNotAvailable) as error:
        times.check_time(nurse, at_ist(sunday, 13), NOW)
    assert error.value.details == {"reason": "BLOCKED"}


@pytest.mark.parametrize(
    ("at", "reason"),
    [
        (at_ist(DAY, 11, 0), "TOO_SOON"),  # inside the 3 hours' notice
        (at_ist(DAY, 7, 0), "TOO_SOON"),  # already past
        (at_ist(DAY + dt.timedelta(days=1), 6, 30), "OUTSIDE_HOURS"),
        (at_ist(DAY + dt.timedelta(days=1), 21, 0), "OUTSIDE_HOURS"),
        (at_ist(DAY + dt.timedelta(days=1), 9, 15), "NOT_ON_STEP"),
        (at_ist(DAY + dt.timedelta(days=31), 9, 0), "OUTSIDE_WINDOW"),
    ],
)
def test_the_server_check(companion, at, reason):
    with pytest.raises(times.TimeNotAvailable) as error:
        times.check_time(companion, at, NOW)
    assert error.value.code == "TIME_NOT_AVAILABLE"
    assert error.value.details == {"reason": reason}


def test_max_bookings_per_time(api):
    world = make_world(api)
    setting("max_per_slot", 1)
    first = book(api, world.token, body(world))
    assert first.status_code == 200, first.json()
    pickup = Booking.objects.get().pickup_at
    service = world.service("Doctor visit companion")
    day = pickup.astimezone(times.IST).date()
    assert pickup not in times.available_times(service, day)
    # nurse services have their own places
    assert pickup in times.available_times(world.service("Wound dressing"), day)
    second = book(api, world.token, body(world))
    assert second.status_code == 409
    assert second.json()["error"]["details"] == {"reason": "FULL"}
    # an unpaid booking past its payment time no longer holds the place
    Booking.objects.update(created_at=pickup - dt.timedelta(days=2))
    assert pickup in times.available_times(service, day)


def test_booking_times_endpoint(api):
    world = make_world(api)
    service = world.service("Doctor visit companion")
    resp = api.get(f"/patient/booking-times?serviceId={service.pk}", world.token)
    assert resp.status_code == 200, resp.json()
    data = resp.json()
    assert len(data["days"]) == 31
    first_free = next(d["date"] for d in data["days"] if d["available"])
    assert data["date"] == first_free
    assert data["times"]
    assert data["timeStepMin"] == 30
    assert data["travelBufferMin"] == 60
    tomorrow = data["days"][1]["date"]
    picked = api.get(f"/patient/booking-times?serviceId={service.pk}&date={tomorrow}", world.token)
    assert len(picked.json()["times"]) == 28
    outside = api.get(f"/patient/booking-times?serviceId={service.pk}&date=2030-01-01", world.token)
    assert outside.json()["times"] == []
    service.is_active = False
    service.save()
    gone = api.get(f"/patient/booking-times?serviceId={service.pk}", world.token)
    assert gone.status_code == 404
