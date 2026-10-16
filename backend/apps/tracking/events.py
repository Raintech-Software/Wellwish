"""Event handlers of the tracking app (ARCHITECTURE §10.2)."""

from typing import Any

from apps.tracking import services
from common import events


@events.subscribe("booking.completed")
def on_completed(name: str, payload: dict[str, Any]) -> None:
    """The job ended: save the route (2 minutes later: the phone may still send the points it
    kept offline), then forget the live data."""
    from apps.tracking.tasks import finish

    finish.apply_async(args=[payload["booking_id"]], countdown=services.FINISH_AFTER_S)


@events.subscribe("booking.no_show")
def on_no_show(name: str, payload: dict[str, Any]) -> None:
    from apps.tracking.tasks import finish

    finish.apply_async(args=[payload["booking_id"]], countdown=services.FINISH_AFTER_S)


@events.subscribe("booking.completed")
@events.subscribe("booking.no_show")
def suspend_after_the_job(name: str, payload: dict[str, Any]) -> None:
    """§6.16: a fake-GPS suspension waits until the partner's visit is over."""
    from apps.bookings.models import Booking
    from apps.partners import services as partners

    partner_id = (
        Booking.objects.filter(pk=payload["booking_id"])
        .values_list("partner_id", flat=True)
        .first()
    )
    if partner_id is not None:
        partners.suspend_for_fake_gps(str(partner_id))
