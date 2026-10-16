"""Partner inbox (/v1/partner/notifications). Works at any partner status, so a partner who
isn't approved yet can read why (changes needed, rejected, suspended)."""

from django.db.models import QuerySet
from django.http import HttpRequest
from ninja import Router
from ninja.pagination import paginate

from apps.notifications import selectors, services
from apps.notifications.models import Notification
from apps.notifications.schemas import MarkReadIn, NotificationOut, UnreadCountOut
from common.auth import get_principal
from common.pagination import WWPagination

router = Router(tags=["partner"])


@router.get(
    "/notifications",
    response=list[NotificationOut],
    by_alias=True,
    operation_id="partnerNotificationsList",
)
@paginate(WWPagination)
def list_notifications(request: HttpRequest) -> QuerySet[Notification]:
    """Newest first."""
    return selectors.inbox(get_principal(request).subject_id, "partner")


@router.get(
    "/notifications/unread-count",
    response=UnreadCountOut,
    by_alias=True,
    operation_id="partnerNotificationsUnread",
)
def unread_count(request: HttpRequest) -> UnreadCountOut:
    return UnreadCountOut(
        unread=selectors.unread_count(get_principal(request).subject_id, "partner")
    )


@router.post(
    "/notifications/read",
    response=UnreadCountOut,
    by_alias=True,
    operation_id="partnerNotificationsRead",
)
def mark_read(request: HttpRequest, data: MarkReadIn) -> UnreadCountOut:
    user_id = get_principal(request).subject_id
    services.mark_read(
        user_id=user_id,
        app="partner",
        # [] marks nothing; leaving ids out marks all (review, 16 Oct 2026)
        ids=None if data.ids is None else [str(i) for i in data.ids],
    )
    return UnreadCountOut(unread=selectors.unread_count(user_id, "partner"))
