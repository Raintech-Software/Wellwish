"""Celery tasks for bookings."""

from celery import shared_task

from apps.bookings.services import expire_unpaid, reminder_sweep


@shared_task(name="bookings.expire_unpaid")
def expire_unpaid_bookings() -> int:
    """Every 5 minutes: unpaid bookings past their payment time become EXPIRED (§10.5)."""
    return expire_unpaid()


@shared_task(name="bookings.reminder_sweep")
def send_reminders() -> int:
    """Every minute: T-24 h and T-2 h reminders (§10.5)."""
    return reminder_sweep()


@shared_task(name="bookings.not_completed_sweep")
def not_completed_sweep() -> int:
    """Every 10 min: last step done an hour ago, not completed → admin alert (§10.5)."""
    from apps.bookings import visit

    return visit.not_completed_sweep()


@shared_task(name="bookings.not_started_sweep")
def not_started_sweep() -> int:
    """Every 10 min: accepted, but not on the way 30 minutes after pickup → admin alert."""
    from apps.bookings import visit

    return visit.not_started_sweep()
