"""Admin: the live map of jobs in progress (§9.1 Live) and a finished job's route."""

from decimal import Decimal
from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.bookings import selectors as booking_selectors
from apps.tracking import selectors, services
from apps.tracking.api.out import live_job_out
from apps.tracking.models import BookingTrack
from apps.tracking.schemas import LiveJobOut, TrackOut
from common.auth import staff_permission
from common.errors import NotFound

router = Router(tags=["admin"])


@router.get("/live", response=list[LiveJobOut], by_alias=True, operation_id="adminLiveJobs")
@staff_permission("live.view")
def live(request: HttpRequest) -> list[LiveJobOut]:
    """Every job in progress with the partner's latest point (`stale`: none for 2 minutes)."""
    rows = selectors.live_jobs().prefetch_related("partner__phones").select_related("partner__user")
    return [live_job_out(b) for b in rows]


@router.get(
    "/bookings/{uuid:booking_id}/track",
    response=TrackOut,
    by_alias=True,
    operation_id="adminBookingTrack",
)
@staff_permission("bookings.view")
def track(request: HttpRequest, booking_id: UUID) -> TrackOut:
    """The route saved when the job ended (404 before that)."""
    booking = booking_selectors.admin_booking(str(booking_id))
    saved = BookingTrack.objects.filter(booking=booking).first()
    if saved is None:
        raise NotFound()
    return TrackOut(
        points=[[lat, lng] for lat, lng in services.decode(saved.polyline)],
        km=str(saved.km.quantize(Decimal("0.01"))),
        started_at=saved.started_at,
        ended_at=saved.ended_at,
    )
