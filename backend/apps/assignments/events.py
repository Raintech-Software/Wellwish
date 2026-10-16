"""Event handlers of the assignments app (ARCHITECTURE §10.2)."""

from typing import Any

from apps.bookings.models import Booking
from common import events, realtime


@events.subscribe("booking.paid")
def on_booking_paid(name: str, payload: dict[str, Any]) -> None:
    """A newly paid booking enters the Unassigned queue: the admins hear the sound."""
    booking = Booking.objects.filter(pk=payload["booking_id"]).first()
    if booking is None:
        return
    realtime.send_to_group(
        "staff.ops",
        "queue.changed",
        {"bookingId": str(booking.pk), "code": booking.code, "reason": "NEW"},
    )


@events.subscribe("partner.submitted")
def on_partner_submitted(name: str, payload: dict[str, Any]) -> None:
    """A new partner application: a live alert for the reviewers (§6.14, moved from Phase 3)."""
    realtime.send_to_group(
        "staff.partners",
        "alert",
        {"kind": "NEW_APPLICATION", "partnerId": payload.get("partner_id", "")},
    )


@events.subscribe("partner.suspended")
def on_partner_suspended(name: str, payload: dict[str, Any]) -> None:
    """§6.16: open offers go back to the queue; upcoming jobs are flagged for reassignment."""
    from apps.assignments import services

    services.on_partner_unavailable(payload["partner_id"], "SUSPENDED")


@events.subscribe("partner.deactivated")
def on_partner_deactivated(name: str, payload: dict[str, Any]) -> None:
    from apps.assignments import services

    services.on_partner_unavailable(payload["partner_id"], "DEACTIVATED")


@events.subscribe("partner.deletion_requested")
def on_partner_deletion_requested(name: str, payload: dict[str, Any]) -> None:
    """§6.20: open offers go back to the queue (accepted jobs refuse the deletion)."""
    from apps.assignments import services

    services.on_partner_unavailable(payload["partner_id"], "DELETION_REQUESTED")


@events.subscribe("partner.temp_ended")
def on_temp_ended(name: str, payload: dict[str, Any]) -> None:
    """§6.19: a temporary partner's access ended (often by the sweep, an hour after Completed,
    with no booking change): open booking pages refresh their ID card."""
    booking_id = payload.get("booking_id")
    booking = Booking.objects.filter(pk=str(booking_id)).first() if booking_id else None
    if booking is None:
        return
    realtime.send_to_group(
        "staff.ops",
        "queue.changed",
        {"bookingId": str(booking.pk), "code": booking.code, "reason": "TEMP_ENDED"},
    )
