"""Celery tasks for partner verification."""

from celery import shared_task

from apps.kyc.services import check_expiry


@shared_task(name="kyc.check_document_expiry")
def check_document_expiry() -> dict[str, int]:
    """Daily: 30-day reminders, then expire documents and suspend partners who need them."""
    return check_expiry()
