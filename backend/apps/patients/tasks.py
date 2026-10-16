"""Celery tasks for patients."""

from celery import shared_task

from apps.patients.services import process_due_deletions


@shared_task(name="patients.process_account_deletions")
def process_account_deletions() -> int:
    """Daily: erase the accounts whose "delete my account" grace period is over (§12)."""
    return process_due_deletions()
