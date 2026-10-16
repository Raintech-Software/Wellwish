"""Building the live-location answers (shared by the patient and admin endpoints)."""

import datetime as dt

from django.utils import timezone

from apps.assignments.api.out import phones
from apps.bookings.models import Booking, BookingStatus
from apps.tracking import selectors
from apps.tracking.schemas import LiveJobOut, LiveLocationOut
from apps.tracking.services import NO_LOCATION_AFTER


def live_out(booking: Booking) -> LiveLocationOut:
    latest = (
        selectors.latest_point(booking) if booking.status == BookingStatus.IN_PROGRESS else None
    )
    if latest is None:
        return LiveLocationOut(
            booking_id=str(booking.pk),
            lat=None,
            lng=None,
            at=None,
            eta_min=None,
            step=booking.current_step,
        )
    return LiveLocationOut(
        booking_id=str(booking.pk),
        lat=f"{latest['lat']:.6f}",
        lng=f"{latest['lng']:.6f}",
        at=dt.datetime.fromisoformat(latest["at"]),
        eta_min=selectors.eta_minutes(booking, latest["lat"], latest["lng"]),
        step=booking.current_step,
    )


def live_job_out(booking: Booking) -> LiveJobOut:
    base = live_out(booking)
    primary, alternate = phones(booking.partner)
    stale = base.at is None or timezone.now() - base.at > NO_LOCATION_AFTER
    return LiveJobOut(
        **base.model_dump(),
        code=booking.code,
        partner_name=booking.partner.full_name if booking.partner else "",
        partner_phone=primary,
        partner_alternate_phone=alternate,
        service_name=str(booking.price_snapshot.get("name", "")),
        member_name=str(booking.member_snapshot.get("full_name", "")),
        pickup_at=booking.pickup_at,
        stale=stale,
    )
