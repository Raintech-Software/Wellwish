from celery import shared_task

from apps.safety import services


@shared_task(name="safety.escalate_unacknowledged_sos")
def escalate_unacknowledged_sos() -> int:
    """§13: an SOS not acknowledged within 2 minutes → the Super Admins and the support phone."""
    return services.escalate_unacknowledged()
