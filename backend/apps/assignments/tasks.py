"""Celery tasks for assignments (ARCHITECTURE §10.5)."""

from celery import shared_task

from apps.assignments import services


@shared_task(name="assignments.offer_timeout")
def offer_timeout(assignment_id: str) -> bool:
    """`accept_timeout_seconds` after an offer (countdown): still open → admin alert + reminder."""
    return services.offer_timeout(assignment_id)


@shared_task(name="assignments.escalation_sweep")
def escalation_sweep() -> int:
    """Every 5 min: unassigned bookings past the assign deadline → red alert, Super Admins told."""
    return services.escalation_sweep()
