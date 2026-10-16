"""Celery tasks for partners."""

from celery import shared_task

from apps.partners.services import end_temporary_sweep


@shared_task(name="partners.process_account_deletions")
def process_account_deletions() -> int:
    """Daily: erase the partners whose "delete my account" waiting time is over (§6.20)."""
    from apps.partners.services import process_due_deletions

    return process_due_deletions()


@shared_task(name="partners.end_temporary_sweep")
def end_temporary_partners() -> int:
    """Every 5 minutes: temporary partners whose one job is over lose access (§6.19)."""
    return end_temporary_sweep()
