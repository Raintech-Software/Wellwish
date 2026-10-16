"""Admin: support tickets (reply, close) and reviews moderation (hide / show) (§9.1 Support).
Every action is logged."""

from typing import Literal
from uuid import UUID

from django.http import HttpRequest
from ninja import Router
from ninja.pagination import paginate

from apps.reviews import selectors, services
from apps.reviews.api.out import admin_review_out, admin_ticket_out
from apps.reviews.schemas import AdminReviewOut, AdminTicketOut, ReviewModerateIn, TicketReplyIn
from apps.staff.selectors import acting_staff
from common.auth import staff_permission
from common.pagination import Mapped, WWPagination
from common.request import client_ip

router = Router(tags=["admin"])


def _ticket(ticket_id: str) -> AdminTicketOut:
    return admin_ticket_out(selectors.admin_tickets("all").get(pk=ticket_id))


@router.get("/tickets", response=list[AdminTicketOut], by_alias=True, operation_id="adminTickets")
@staff_permission("support.manage")
@paginate(WWPagination)
def tickets(
    request: HttpRequest, status: Literal["open", "all"] = "open"
) -> Mapped[AdminTicketOut]:
    return Mapped(selectors.admin_tickets(status), admin_ticket_out)


@router.post(
    "/tickets/{uuid:ticket_id}/reply",
    response=AdminTicketOut,
    by_alias=True,
    operation_id="adminTicketReply",
)
@staff_permission("support.manage")
def reply(request: HttpRequest, ticket_id: UUID, data: TicketReplyIn) -> AdminTicketOut:
    """The family gets a message with the reply."""
    services.reply(
        ticket_id=str(ticket_id), staff=acting_staff(request), text=data.text, ip=client_ip(request)
    )
    return _ticket(str(ticket_id))


@router.post(
    "/tickets/{uuid:ticket_id}/close",
    response=AdminTicketOut,
    by_alias=True,
    operation_id="adminTicketClose",
)
@staff_permission("support.manage")
def close(request: HttpRequest, ticket_id: UUID) -> AdminTicketOut:
    services.close(ticket_id=str(ticket_id), staff=acting_staff(request), ip=client_ip(request))
    return _ticket(str(ticket_id))


@router.get("/reviews", response=list[AdminReviewOut], by_alias=True, operation_id="adminReviews")
@staff_permission("support.manage")
@paginate(WWPagination)
def reviews(
    request: HttpRequest, status: Literal["all", "VISIBLE", "HIDDEN"] = "all"
) -> Mapped[AdminReviewOut]:
    return Mapped(selectors.admin_reviews(status), admin_review_out)


def _moderate(request: HttpRequest, review_id: UUID, reason: str, visible: bool) -> AdminReviewOut:
    review = services.set_review_visible(
        review_id=str(review_id),
        staff=acting_staff(request),
        visible=visible,
        reason=reason,
        ip=client_ip(request),
    )
    return admin_review_out(selectors.admin_reviews().get(pk=review.pk))


@router.post(
    "/reviews/{uuid:review_id}/hide",
    response=AdminReviewOut,
    by_alias=True,
    operation_id="adminReviewHide",
)
@staff_permission("support.manage")
def hide(request: HttpRequest, review_id: UUID, data: ReviewModerateIn) -> AdminReviewOut:
    """Hidden, never deleted; the partner's average leaves it out."""
    return _moderate(request, review_id, data.reason, visible=False)


@router.post(
    "/reviews/{uuid:review_id}/show",
    response=AdminReviewOut,
    by_alias=True,
    operation_id="adminReviewShow",
)
@staff_permission("support.manage")
def show(request: HttpRequest, review_id: UUID, data: ReviewModerateIn) -> AdminReviewOut:
    return _moderate(request, review_id, data.reason, visible=True)
