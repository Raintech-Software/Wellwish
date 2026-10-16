"""Partner: points kept on the phone while offline (§6.11). Live points go over the socket."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.tracking import services
from apps.tracking.schemas import TrackBatchIn, TrackBatchOut
from common.auth import get_principal

router = Router(tags=["partner"])


@router.post(
    "/bookings/{uuid:booking_id}/track-batch",
    response=TrackBatchOut,
    by_alias=True,
    operation_id="partnerTrackBatch",
)
def track_batch(request: HttpRequest, booking_id: UUID, data: TrackBatchIn) -> TrackBatchOut:
    """Points from a network drop, oldest first or not: added to the route."""
    points = [
        services.Point(
            lat=float(p.lat), lng=float(p.lng), accuracy=p.accuracy, at=p.at, mock=p.mock
        )
        for p in data.points
    ]
    accepted = services.record_batch(
        booking_id=str(booking_id),
        partner_user_id=get_principal(request).subject_id,
        points=points,
    )
    return TrackBatchOut(accepted=accepted)
