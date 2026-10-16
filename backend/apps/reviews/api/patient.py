"""Patient: rate the partner, report a problem (P20, §6.11)."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.reviews import services
from apps.reviews.api.out import review_out, ticket_out
from apps.reviews.schemas import ReportIn, ReviewIn, ReviewOut, TicketOut
from common.auth import get_principal

router = Router(tags=["patient"])


@router.post(
    "/bookings/{uuid:booking_id}/review",
    response=ReviewOut,
    by_alias=True,
    operation_id="patientReview",
)
def review(request: HttpRequest, booking_id: UUID, data: ReviewIn) -> ReviewOut:
    """Once, after Completed. 409 NOT_REVIEWABLE / ALREADY_REVIEWED."""
    saved = services.add_review(
        user_id=get_principal(request).subject_id,
        booking_id=str(booking_id),
        stars=data.stars,
        tags=list(data.tags),
        comment=data.comment,
    )
    return review_out(saved)


@router.post(
    "/bookings/{uuid:booking_id}/report-problem",
    response=TicketOut,
    by_alias=True,
    operation_id="patientReportProblem",
)
def report_problem(request: HttpRequest, booking_id: UUID, data: ReportIn) -> TicketOut:
    """Within 24 h after the visit (409 REPORT_TOO_LATE): a ticket for the admins."""
    ticket = services.report_problem(
        user_id=get_principal(request).subject_id, booking_id=str(booking_id), text=data.text
    )
    return ticket_out(ticket)
