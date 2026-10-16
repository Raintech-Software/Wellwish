"""Celery tasks for notifications."""

from celery import shared_task

from apps.notifications.services import delete_old_family_messages


@shared_task(name="notifications.delete_old_family_messages")
def delete_old_family_inbox() -> int:
    """Daily: the family's inbox keeps 30 days (v2.33)."""
    return delete_old_family_messages()
