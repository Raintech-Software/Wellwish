"""Reads for live location (ARCHITECTURE §6.11): the latest point (Redis), the ETA, the
jobs in progress for the admins' live map, a finished job's route."""

import datetime as dt
from typing import Any

from django.core.cache import cache
from django.db.models import QuerySet

from apps.bookings import visit
from apps.bookings.models import Booking, BookingStatus
from common.geo import haversine_km

CITY_SPEED_KMH = 20  # the ETA is a simple guess until a maps key is added (§3.2)


def loc_key(partner_id: Any) -> str:
    return f"loc:{partner_id}"


def track_key(booking_id: Any) -> str:
    return f"track:{booking_id}"


def alive_key(booking_id: Any) -> str:
    """When the partner's phone last sent a point for this job, even one too rough to use."""
    return f"alive:{booking_id}"


def latest_point(booking: Booking) -> dict[str, Any] | None:
    """The partner's latest point for this job (None before the first one)."""
    if booking.partner_id is None:
        return None
    latest = cache.get(loc_key(booking.partner_id))
    if not latest or latest.get("bookingId") != str(booking.pk):
        return None
    return latest


def eta_minutes(booking: Booking, lat: float, lng: float) -> int | None:
    """Straight-line distance to where the partner is heading next, at city speed."""
    step = visit.next_step(booking)
    heading = {
        visit.Step.REACHED_PATIENT: "home",
        visit.Step.REACHED_HOME: "home",
        visit.Step.REACHED_HOSPITAL: "hospital",
        visit.Step.AT_PLACE: "hospital",
        visit.Step.DROPPED_HOME: "home",
        visit.Step.DELIVERED: "home",
    }.get(step or "")
    if heading is None:
        return None
    target = visit._target(booking, heading)
    if target is None:
        return None
    km = haversine_km(lat, lng, target[0], target[1])
    return max(1, round(km / CITY_SPEED_KMH * 60))


def live_jobs() -> QuerySet[Booking]:
    """The admins' live map (§9.1 Live): every job in progress."""
    return (
        Booking.objects.select_related("partner", "hospital")
        .filter(status=BookingStatus.IN_PROGRESS)
        .order_by("pickup_at")
    )


def last_seen(booking: Booking) -> dt.datetime | None:
    latest = latest_point(booking)
    return dt.datetime.fromisoformat(latest["at"]) if latest else None
