"""Public: what a trip share link shows (§6.15). No login; the secret token is the key."""

from django.http import HttpRequest
from ninja import Header, Router

from apps.safety import services
from apps.safety.schemas import PublicTrackOut
from apps.tracking.api.out import live_out

router = Router(tags=["public"])


@router.get("/track", response=PublicTrackOut, by_alias=True, operation_id="publicSharedTrip")
def shared_trip(
    request: HttpRequest,
    token: str = Header(..., alias="X-Share-Token", max_length=64),
) -> PublicTrackOut:
    """The secret comes in a header, never in the URL (so it isn't logged). 404 once the link
    expired or the visit ended."""
    booking = services.shared_booking(token)
    live = live_out(booking)
    return PublicTrackOut(
        partner_first_name=(booking.partner.full_name.split(" ")[0] if booking.partner else ""),
        service_name=str(booking.price_snapshot.get("name", "")),
        service_name_hi=str(booking.price_snapshot.get("name_hi", "")),
        service_name_or=str(booking.price_snapshot.get("name_or", "")),
        status=booking.status,
        step=booking.current_step,
        lat=live.lat,
        lng=live.lng,
        at=live.at,
        eta_min=live.eta_min,
    )
