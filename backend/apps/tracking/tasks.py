"""Celery tasks for live location (ARCHITECTURE §10.5)."""

from celery import shared_task

from apps.tracking import services


@shared_task(name="tracking.finish")
def finish(booking_id: str) -> None:
    """Save a finished job's route (safe to run twice)."""
    services.finish(booking_id)


@shared_task(name="tracking.no_location_watch")
def no_location_watch() -> int:
    """Every minute: a job in progress with no location for 2 minutes → admin alert."""
    return services.no_location_watch()
