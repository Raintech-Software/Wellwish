"""Patient: where the partner is now (P19, §6.11). Updates come over the socket."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.bookings import selectors as booking_selectors
from apps.tracking.api.out import live_out
from apps.tracking.schemas import LiveLocationOut
from common.auth import get_principal

router = Router(tags=["patient"])


@router.get(
    "/bookings/{uuid:booking_id}/live",
    response=LiveLocationOut,
    by_alias=True,
    operation_id="patientBookingLive",
)
def live(request: HttpRequest, booking_id: UUID) -> LiveLocationOut:
    """The partner's latest point and ETA (empty before "On the way" and after the job)."""
    booking = booking_selectors.own_booking(get_principal(request).subject_id, str(booking_id))
    return live_out(booking)
