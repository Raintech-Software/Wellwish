"""Partner: SOS during a job (§6.15)."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.assignments import selectors as assignment_selectors
from apps.safety import services
from apps.safety.schemas import SosIn, SosOut
from common.auth import get_principal

router = Router(tags=["partner"])


@router.post(
    "/bookings/{uuid:booking_id}/sos", response=SosOut, by_alias=True, operation_id="partnerSos"
)
def sos(request: HttpRequest, booking_id: UUID, data: SosIn) -> SosOut:
    """The admins' alarm + SMS to the partner's emergency contact. 409 NOT_IN_PROGRESS."""
    user_id = get_principal(request).subject_id
    booking = assignment_selectors.own_job(user_id, str(booking_id))
    event = services.raise_sos(
        booking=booking,
        user_id=user_id,
        side="PARTNER",
        lat=float(data.lat) if data.lat else None,
        lng=float(data.lng) if data.lng else None,
        mock=data.mock,
    )
    return SosOut(id=str(event.pk), status=event.status, created_at=event.created_at)
