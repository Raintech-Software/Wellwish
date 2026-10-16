"""Read queries for the inbox, always filtered by the caller."""

from datetime import timedelta

from django.db.models import QuerySet
from django.utils import timezone

from apps.notifications.models import Notification

# The family's inbox (P25) keeps what matters for a booking and nothing older (developer,
# 16 Oct 2026, v2.33): the last 30 days and at most the newest 50 messages. The partner inbox
# keeps everything (approval, changes needed and rejection reasons are read much later).
FAMILY_INBOX_DAYS = 30
FAMILY_INBOX_MAX = 50


def inbox(user_id: str, app: str) -> QuerySet[Notification]:
    rows = Notification.objects.filter(user_id=user_id, app=app).order_by("-created_at")
    if app != "patient":
        return rows
    since = timezone.now() - timedelta(days=FAMILY_INBOX_DAYS)
    recent = rows.filter(created_at__gte=since).values_list("pk", flat=True)
    newest = list(recent[:FAMILY_INBOX_MAX])
    return Notification.objects.filter(pk__in=newest).order_by("-created_at")


def unread_count(user_id: str, app: str) -> int:
    """The bell: unread among what the inbox shows."""
    return inbox(user_id, app).filter(read_at__isnull=True).count()
