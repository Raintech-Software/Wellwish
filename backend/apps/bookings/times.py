"""Which dates and times a patient can book (ARCHITECTURE §6.17).

Times are offered in India time (IST) on the admin's time step (9:00, 9:30…), inside the
service hours, at least the minimum notice from now, within the booking window, not inside a
blocked time and, when "max bookings per time" is on, not full. The app gets the list from
`GET /v1/patient/booking-times`; the server checks the chosen time again when booking
(`check_time`), so a stale screen can never book a time that is no longer allowed.

The service hours limit the start time. A long visit (a 12-hour nurse shift) may end after them.
"""

import datetime as dt
from collections import Counter
from dataclasses import dataclass
from typing import Any
from zoneinfo import ZoneInfo

from django.conf import settings
from django.db import connection
from django.utils import timezone

from apps.app_config.models import BlockedTime
from apps.app_config.selectors import all_settings
from apps.bookings.models import Booking, BookingStatus
from apps.services.models import Service
from common.errors import Conflict

IST = ZoneInfo(settings.DISPLAY_TIME_ZONE)

# Bookings that hold a place in a time (for "max bookings per time"). Unpaid ones count
# until they expire, so two people can't both pay for the last place.
HOLDING = (
    BookingStatus.PENDING_PAYMENT,
    BookingStatus.NEW,
    BookingStatus.OFFERED,
    BookingStatus.ACCEPTED,
    BookingStatus.IN_PROGRESS,
)


class TimeNotAvailable(Conflict):
    code = "TIME_NOT_AVAILABLE"
    message = "This time is no longer available. Please pick another time."


@dataclass(frozen=True)
class Rules:
    window_days: int
    notice: dt.timedelta
    start: dt.time
    end: dt.time
    step_min: int
    max_per_slot: int
    payment_expiry: dt.timedelta

    def inside_hours(self, t: dt.time) -> bool:
        if self.start < self.end:
            return self.start <= t < self.end
        if self.start == self.end:  # open all day
            return True
        return t >= self.start or t < self.end  # hours that run past midnight


def _hhmm(text: str) -> dt.time:
    hours, minutes = text.split(":")
    return dt.time(int(hours), int(minutes))


def rules() -> Rules:
    values = all_settings()
    return Rules(
        window_days=int(values["booking_window_days"]),
        notice=dt.timedelta(hours=int(values["min_notice_hours"])),
        start=_hhmm(values["service_hours_start"]),
        end=_hhmm(values["service_hours_end"]),
        step_min=int(values["time_step_min"]),
        max_per_slot=int(values["max_per_slot"]),
        payment_expiry=dt.timedelta(minutes=int(values["payment_expiry_min"])),
    )


def _day_start(day: dt.date) -> dt.datetime:
    return dt.datetime.combine(day, dt.time(0, 0), tzinfo=IST)


def _candidates(day: dt.date, r: Rules) -> list[dt.datetime]:
    """Every time on the step for that IST date, inside the service hours."""
    start = _day_start(day)
    times = []
    for minute in range(0, 24 * 60, r.step_min):
        at = start + dt.timedelta(minutes=minute)
        if r.inside_hours(at.time()):
            times.append(at)
    return times


class _Calendar:
    """Blocked times and bookings per time for a date range, loaded once."""

    def __init__(
        self,
        partner_type: str,
        start: dt.datetime,
        end: dt.datetime,
        r: Rules,
        now: dt.datetime,
        *,
        leave_out: Any = None,
        notice: bool = True,
    ) -> None:
        self.rules = r
        self.now = now
        self.notice = notice
        self.blocks = list(
            BlockedTime.objects.filter(
                service_type__in=("", partner_type), from_ts__lt=end, to_ts__gt=start
            ).values_list("from_ts", "to_ts")
        )
        self.taken: Counter[dt.datetime] = Counter()
        if r.max_per_slot > 0:
            holding = Booking.objects.filter(
                price_snapshot__partner_type=partner_type,
                pickup_at__gte=start,
                pickup_at__lt=end,
                status__in=HOLDING,
            )
            if leave_out is not None:
                holding = holding.exclude(pk=leave_out)
            rows = holding.values_list("pickup_at", "status", "created_at")
            for pickup_at, status, created_at in rows:
                if status == BookingStatus.PENDING_PAYMENT and created_at <= now - r.payment_expiry:
                    continue  # unpaid and past its payment time: no longer holds a place
                self.taken[pickup_at] += 1

    def problem(self, at: dt.datetime) -> str | None:
        """Why `at` can't be booked, or None. `at` is assumed to be on a step."""
        r = self.rules
        today = self.now.astimezone(IST).date()
        local = at.astimezone(IST)
        if not today <= local.date() <= today + dt.timedelta(days=r.window_days):
            return "OUTSIDE_WINDOW"
        if at < self.now + (r.notice if self.notice else dt.timedelta(0)):
            return "TOO_SOON"
        if not r.inside_hours(local.time()):
            return "OUTSIDE_HOURS"
        if any(start <= at < end for start, end in self.blocks):
            return "BLOCKED"
        if r.max_per_slot > 0 and self.taken[at] >= r.max_per_slot:
            return "FULL"
        return None


def booking_window(now: dt.datetime | None = None) -> tuple[dt.date, dt.date]:
    """(first, last) date that can be picked: today to today + the booking window."""
    now = now or timezone.now()
    today = now.astimezone(IST).date()
    return today, today + dt.timedelta(days=rules().window_days)


def _type(service: Service | str) -> str:
    return service if isinstance(service, str) else service.partner_type


def available_times(
    service: Service | str, day: dt.date, now: dt.datetime | None = None, *, leave_out: Any = None
) -> list[dt.datetime]:
    """The times a patient can pick for this service (or partner type) on this IST date (the
    time grid). `leave_out`: a booking being moved (its own place doesn't count)."""
    now = now or timezone.now()
    r = rules()
    start = _day_start(day)
    calendar = _Calendar(
        _type(service), start, start + dt.timedelta(days=1), r, now, leave_out=leave_out
    )
    return [at for at in _candidates(day, r) if calendar.problem(at) is None]


def available_days(
    service: Service | str, now: dt.datetime | None = None, *, leave_out: Any = None
) -> list[tuple[dt.date, bool]]:
    """Every date in the booking window and whether it has at least one free time (blocked
    and full dates are greyed out in the app's date strip)."""
    now = now or timezone.now()
    r = rules()
    first, last = booking_window(now)
    calendar = _Calendar(
        _type(service),
        _day_start(first),
        _day_start(last + dt.timedelta(days=1)),
        r,
        now,
        leave_out=leave_out,
    )
    days = []
    day = first
    while day <= last:
        free = any(calendar.problem(at) is None for at in _candidates(day, r))
        days.append((day, free))
        day += dt.timedelta(days=1)
    return days


def _on_step(at: dt.datetime, r: Rules) -> bool:
    local = at.astimezone(IST)
    minutes = local.hour * 60 + local.minute
    return local.second == 0 and local.microsecond == 0 and minutes % r.step_min == 0


def lock_time(partner_type: str, at: dt.datetime) -> None:
    """With "max bookings per time" on, two bookings for the same time wait for each other
    (until the end of the transaction), so the last place can't be taken twice."""
    key = f"booking-time:{partner_type}:{at.astimezone(dt.UTC).isoformat()}"
    with connection.cursor() as cursor:
        cursor.execute("SELECT pg_advisory_xact_lock(hashtextextended(%s, 0))", [key])


def check_time(
    service: Service | str,
    at: dt.datetime,
    now: dt.datetime | None = None,
    *,
    leave_out: Any = None,
    notice: bool = True,
) -> None:
    """The server's own check when booking or changing the time (§6.17). Raises 409
    TIME_NOT_AVAILABLE. `service`: a Service or its partner type. `leave_out`: the booking being
    moved (its own place doesn't count). `notice=False`: the admin may move a booking inside the
    minimum notice."""
    now = now or timezone.now()
    partner_type = service if isinstance(service, str) else service.partner_type
    r = rules()
    if at.tzinfo is None or not _on_step(at, r):
        raise TimeNotAvailable(details={"reason": "NOT_ON_STEP"})
    if r.max_per_slot > 0:
        lock_time(partner_type, at)
    day = _day_start(at.astimezone(IST).date())
    calendar = _Calendar(
        partner_type, day, day + dt.timedelta(days=1), r, now, leave_out=leave_out, notice=notice
    )
    problem = calendar.problem(at)
    if problem:
        raise TimeNotAvailable(details={"reason": problem})


def place_still_free(booking: Booking, now: dt.datetime | None = None) -> bool:
    """When a payment arrives: does the booking still have its place? Only "max bookings per
    time" can take it (an unpaid booking stops holding its place once its payment time is up)."""
    r = rules()
    if r.max_per_slot <= 0:
        return True
    now = now or timezone.now()
    lock_time(booking.partner_type, booking.pickup_at)
    calendar = _Calendar(
        booking.partner_type,
        booking.pickup_at,
        booking.pickup_at + dt.timedelta(seconds=1),
        r,
        now,
        leave_out=booking.pk,
    )
    return calendar.taken[booking.pickup_at] < r.max_per_slot
