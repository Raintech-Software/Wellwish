"""Celery tasks for accounts. OTP SMS is sent inside the request on purpose (see otp.py), so
the plain code never sits in the task queue."""

from celery import shared_task


@shared_task(name="accounts.delete_old_sessions")
def delete_old_sessions() -> int:
    """Every night: session rows revoked or expired more than 30 days ago (PHASES 9.11)."""
    from apps.accounts.services import delete_old_sessions as delete

    return delete()
