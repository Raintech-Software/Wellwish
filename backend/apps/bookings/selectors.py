"""Booking reads. Patients see only the bookings they made (others' are "not found")."""

import datetime as dt
import re
from typing import Any, Literal

from django.db.models import Prefetch, Q, QuerySet
from django.utils import timezone

from apps.bookings.models import Booking, BookingDocument, BookingEvent, BookingStatus
from apps.bookings.times import IST
from apps.partners import selectors as partners
from common.dates import today_ist
from common.errors import NotFound
from common.ids import uid

S = BookingStatus

Bucket = Literal["upcoming", "ongoing", "past"]
BUCKETS: dict[str, tuple[str, ...]] = {
    "upcoming": (S.PENDING_PAYMENT, S.NEW, S.OFFERED, S.ACCEPTED),
    "ongoing": (S.IN_PROGRESS,),
    "past": (S.COMPLETED, S.PATIENT_NO_SHOW, S.CANCELLED, S.EXPIRED),
}


# A booking still waiting (unpaid, unassigned, accepted but never started) whose pickup was
# this long ago is shown with the past ones, not as "next" (PHASES 9.11; the admin is alerted
# when a partner hasn't started, NOT_STARTED).
STALE_AFTER = dt.timedelta(hours=12)

# §6.14, §6.15: after the job, phone numbers stay visible 1 hour, documents 24 hours.
PHONES_AFTER_JOB = dt.timedelta(hours=1)
DOCUMENTS_AFTER_JOB = dt.timedelta(hours=24)


def in_job_window(booking: Booking, after: dt.timedelta, now: dt.datetime | None = None) -> bool:
    """From the partner's acceptance until `after` past completion."""
    if booking.status in (S.ACCEPTED, S.IN_PROGRESS):
        return True
    if booking.status != S.COMPLETED:
        return False
    done = (
        BookingEvent.objects.filter(booking=booking, to_status=S.COMPLETED)
        .order_by("-server_ts")
        .values_list("server_ts", flat=True)
        .first()
    )
    return done is not None and (now or timezone.now()) - done <= after


def _with_details(qs: QuerySet[Booking]) -> QuerySet[Booking]:
    return qs.select_related("hospital", "doctor", "partner__user").prefetch_related(
        Prefetch(
            "documents",
            queryset=BookingDocument.objects.select_related("document").order_by("created_at"),
        ),
        Prefetch("events", queryset=BookingEvent.objects.order_by("server_ts", "created_at")),
    )


def patient_bookings(user_id: str, bucket: Bucket) -> QuerySet[Booking]:
    """P17: Upcoming (soonest first) · Ongoing · Past (latest first). A waiting booking whose
    pickup was more than 12 hours ago counts as past (it never happened; the admin sorts it out)."""
    stale = Q(status__in=BUCKETS["upcoming"], pickup_at__lt=timezone.now() - STALE_AFTER)
    rows = Booking.objects.filter(booked_by_id=uid(user_id))
    if bucket == "upcoming":
        rows = rows.filter(status__in=BUCKETS[bucket]).exclude(stale)
    elif bucket == "past":
        rows = rows.filter(Q(status__in=BUCKETS[bucket]) | stale)
    else:
        rows = rows.filter(status__in=BUCKETS[bucket])
    rows = rows.select_related("hospital")
    return rows.order_by("-pickup_at" if bucket == "past" else "pickup_at")


def member_bookings(user_id: str, member_id: str, limit: int = 5) -> list[Booking]:
    """P29: a family member's bookings: the unfinished ones (soonest first), then the latest
    finished ones, at most `limit`."""
    rows = Booking.objects.filter(
        booked_by_id=uid(user_id), member_id=uid(member_id)
    ).select_related("hospital")
    unfinished = BUCKETS["upcoming"] + BUCKETS["ongoing"]
    open_ = list(rows.filter(status__in=unfinished).order_by("pickup_at")[:limit])
    past = rows.filter(status__in=BUCKETS["past"]).order_by("-pickup_at")
    done = list(past[: limit - len(open_)])
    return open_ + done


def own_booking(user_id: str, booking_id: str) -> Booking:
    booking = _with_details(Booking.objects.filter(pk=uid(booking_id), booked_by_id=uid(user_id)))
    found = booking.first()
    if found is None:
        raise NotFound()
    return found


# --- Admin (§9.1 Bookings) ---

When = Literal["upcoming", "today", "tomorrow", "later", "past"]
HIDDEN_BY_DEFAULT = (S.PENDING_PAYMENT, S.EXPIRED)  # not paid: nothing for the admin to do
UNFINISHED = (S.NEW, S.OFFERED, S.ACCEPTED, S.IN_PROGRESS)
CODE = re.compile(r"^(WW-?)?(\d{5,})$", re.IGNORECASE)


def _ist_day(day: dt.date) -> tuple[dt.datetime, dt.datetime]:
    start = dt.datetime.combine(day, dt.time(0, 0), tzinfo=IST)
    return start, start + dt.timedelta(days=1)


def admin_bookings(
    *,
    status: str = "",
    day: dt.date | None = None,
    partner_type: str = "",
    when: str = "",
    q: str = "",
    today: dt.date | None = None,
    temporary: bool | None = None,
) -> QuerySet[Booking]:
    """`when` (India dates, by pickup): `upcoming` (default: from today on, plus unfinished
    ones whose time has passed, soonest first), `today`, `tomorrow`, `later`, `past` (before today,
    latest first). Unpaid and expired bookings only when asked for by status, or found by their
    code. `q`: a booking code (WW-10001 or 10001), a phone (the patient's or the member's, at
    least 4 digits) or the member's name."""
    rows = Booking.objects.select_related("booked_by", "hospital").annotate(
        temporary_partner=partners.had_temporary_partner()
    )
    if temporary is not None:  # §6.19: the "Temporary partner" filter
        rows = rows.filter(temporary_partner=temporary)
    q = q.strip()
    found = CODE.match(q)
    code = f"WW-{found.group(2)}" if found else None
    only_code = bool(found and found.group(1))  # "WW-…": not a phone
    if status:
        rows = rows.filter(status=status)
    else:
        shown = ~Q(status__in=HIDDEN_BY_DEFAULT)
        if code:  # phone support: a code finds the booking whatever its state
            shown |= Q(code=code)
        rows = rows.filter(shown)
    if partner_type:
        rows = rows.filter(price_snapshot__partner_type=partner_type)
    if day:
        start, end = _ist_day(day)
        rows = rows.filter(pickup_at__gte=start, pickup_at__lt=end)
    start, end = _ist_day(today or today_ist())
    when = when or ("" if day or q else "upcoming")  # a search looks at every date
    if when == "upcoming":
        rows = rows.filter(Q(pickup_at__gte=start) | Q(status__in=UNFINISHED))
    elif when == "today":
        rows = rows.filter(pickup_at__gte=start, pickup_at__lt=end)
    elif when == "tomorrow":
        rows = rows.filter(pickup_at__gte=end, pickup_at__lt=end + dt.timedelta(days=1))
    elif when == "later":
        rows = rows.filter(pickup_at__gte=end + dt.timedelta(days=1))
    elif when == "past":
        rows = rows.filter(pickup_at__lt=start)
    if q:
        match = Q(code=code) if code else Q(pk__in=[])
        if not only_code:
            match |= Q(member_snapshot__full_name__icontains=q)
            digits = "".join(ch for ch in q if ch.isdigit())
            if len(digits) >= 4:
                tail = digits[-10:]  # "09876543210" and "+91 98765 43210" alike
                match |= Q(booked_by__phone__startswith="+", booked_by__phone__contains=tail)
                match |= Q(member_snapshot__phone__icontains=tail)  # text, not JSON containment
        rows = rows.filter(match)
    return rows.order_by("-pickup_at" if when == "past" else "pickup_at")


def admin_booking(booking_id: str) -> Booking:
    found = _with_details(
        Booking.objects.select_related("booked_by")
        .filter(pk=uid(booking_id))
        .annotate(temporary_partner=partners.had_temporary_partner())
    ).first()
    if found is None:
        raise NotFound()
    return found


def patient_bookings_for_admin(user_id: str) -> QuerySet[Booking]:
    """Admin patient page (§9.1 Patients): every booking of the account, latest first."""
    return (
        Booking.objects.filter(booked_by_id=uid(user_id))
        .select_related("hospital", "booked_by")
        .annotate(temporary_partner=partners.had_temporary_partner())
        .order_by("-pickup_at")
    )


# --- Dashboard and reports (Phase 9.2, §9.1) ---

# Paid bookings: every status after the fee (the unpaid and expired ones never happened).
BOOKED = (S.NEW, S.OFFERED, S.ACCEPTED, S.IN_PROGRESS, S.COMPLETED, S.PATIENT_NO_SHOW, S.CANCELLED)
OPEN = (S.NEW, S.OFFERED, S.ACCEPTED, S.IN_PROGRESS)


def _ist_range(start: dt.date, end: dt.date) -> tuple[dt.datetime, dt.datetime]:
    since = dt.datetime.combine(start, dt.time(0, 0), tzinfo=IST)
    return since, dt.datetime.combine(end + dt.timedelta(days=1), dt.time(0, 0), tzinfo=IST)


def day_counts(day: dt.date) -> dict[str, int]:
    """The dashboard's "today": bookings whose visit is on this India date, by status."""
    since, until = _ist_range(day, day)
    counts = {str(status): 0 for status in BOOKED}
    for status in Booking.objects.filter(
        pickup_at__gte=since, pickup_at__lt=until, status__in=BOOKED
    ).values_list("status", flat=True):
        counts[str(status)] += 1
    return counts


def bookings_report(start: dt.date, end: dt.date) -> dict[str, list[dict[str, Any]]]:
    """Bookings report: paid bookings by visit date (India) and by service, with how they
    ended. `end` included."""
    since, until = _ist_range(start, end)
    days: dict[dt.date, dict[str, int]] = {}
    services: dict[str, dict[str, int]] = {}
    blank = {"booked": 0, "completed": 0, "cancelled": 0, "no_show": 0, "open": 0}
    for pickup_at, status, snapshot in Booking.objects.filter(
        pickup_at__gte=since, pickup_at__lt=until, status__in=BOOKED
    ).values_list("pickup_at", "status", "price_snapshot"):
        name = str((snapshot or {}).get("name", ""))
        for row in (
            days.setdefault(pickup_at.astimezone(IST).date(), dict(blank)),
            services.setdefault(name, dict(blank)),
        ):
            row["booked"] += 1
            if status == S.COMPLETED:
                row["completed"] += 1
            elif status == S.CANCELLED:
                row["cancelled"] += 1
            elif status == S.PATIENT_NO_SHOW:
                row["no_show"] += 1
            else:
                row["open"] += 1
    return {
        "days": [{"date": day, **row} for day, row in sorted(days.items())],
        "services": [
            {"service": name, **row}
            for name, row in sorted(services.items(), key=lambda item: -item[1]["booked"])
        ],
    }


def cancelled_between(start: dt.date, end: dt.date) -> list[tuple[Booking, dt.datetime]]:
    """Bookings cancelled on these India dates (`end` included), with when: the cancellations
    report (9.2)."""
    since, until = _ist_range(start, end)
    rows: dict[object, tuple[Booking, dt.datetime]] = {}
    for event in (
        BookingEvent.objects.filter(
            to_status=S.CANCELLED, server_ts__gte=since, server_ts__lt=until
        )
        .select_related("booking")
        .order_by("server_ts")
    ):
        rows.setdefault(event.booking_id, (event.booking, event.server_ts))
    return list(rows.values())
