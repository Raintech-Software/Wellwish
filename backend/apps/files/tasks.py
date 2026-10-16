"""Celery tasks for files."""

from celery import shared_task

from apps.files.services import cleanup_unattached


@shared_task(name="files.cleanup_unattached")
def cleanup_unattached_uploads() -> int:
    """Daily: delete uploads never attached to a form within 24 h."""
    return cleanup_unattached()
