"""Family inbox (/v1/patient/notifications, screen P25): booking confirmed, partner assigned,
reminders, on the way, completed, cancelled / refunded, WellWish's replies. The same messages go
out as push once Firebase is set up; the inbox keeps them either way (v2.32)."""

from django.db.models import QuerySet
from django.http import HttpRequest
from ninja import Router
from ninja.pagination import paginate

from apps.notifications import selectors, services
from apps.notifications.models import Notification
from apps.notifications.schemas import MarkReadIn, NotificationOut, UnreadCountOut
from common.auth import get_principal
from common.pagination import WWPagination

router = Router(tags=["patient"])


@router.get(
    "/notifications",
    response=list[NotificationOut],
    by_alias=True,
    operation_id="patientNotificationsList",
)
@paginate(WWPagination)
def list_notifications(request: HttpRequest) -> QuerySet[Notification]:
    """Newest first. `data.bookingId` opens that booking."""
    return selectors.inbox(get_principal(request).subject_id, "patient")


@router.get(
    "/notifications/unread-count",
    response=UnreadCountOut,
    by_alias=True,
    operation_id="patientNotificationsUnread",
)
def unread_count(request: HttpRequest) -> UnreadCountOut:
    """The number on the bell."""
    return UnreadCountOut(
        unread=selectors.unread_count(get_principal(request).subject_id, "patient")
    )


@router.post(
    "/notifications/read",
    response=UnreadCountOut,
    by_alias=True,
    operation_id="patientNotificationsRead",
)
def mark_read(request: HttpRequest, data: MarkReadIn) -> UnreadCountOut:
    user_id = get_principal(request).subject_id
    services.mark_read(
        user_id=user_id,
        app="patient",
        # [] marks nothing; leaving ids out marks all (review, 16 Oct 2026)
        ids=None if data.ids is None else [str(i) for i in data.ids],
    )
    return UnreadCountOut(unread=selectors.unread_count(user_id, "patient"))
