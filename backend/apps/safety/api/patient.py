"""Patient: SOS and the trip share link during a job (P19, §6.15)."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.bookings import selectors as booking_selectors
from apps.safety import services
from apps.safety.schemas import ShareLinkOut, SosIn, SosOut
from common.auth import get_principal

router = Router(tags=["patient"])


@router.post(
    "/bookings/{uuid:booking_id}/sos", response=SosOut, by_alias=True, operation_id="patientSos"
)
def sos(request: HttpRequest, booking_id: UUID, data: SosIn) -> SosOut:
    """The admins' alarm + SMS to your and the member's emergency contacts.
    409 NOT_IN_PROGRESS."""
    user_id = get_principal(request).subject_id
    booking = booking_selectors.own_booking(user_id, str(booking_id))
    event = services.raise_sos(
        booking=booking,
        user_id=user_id,
        side="PATIENT",
        lat=float(data.lat) if data.lat else None,
        lng=float(data.lng) if data.lng else None,
        mock=data.mock,
    )
    return SosOut(id=str(event.pk), status=event.status, created_at=event.created_at)


@router.post(
    "/bookings/{uuid:booking_id}/share-link",
    response=ShareLinkOut,
    by_alias=True,
    operation_id="patientShareLink",
)
def share_link(request: HttpRequest, booking_id: UUID) -> ShareLinkOut:
    """A secret link to the live trip for someone without the app (ends with the visit)."""
    url, expires = services.create_share_link(
        user_id=get_principal(request).subject_id, booking_id=str(booking_id)
    )
    return ShareLinkOut(url=url, expires_at=expires)
