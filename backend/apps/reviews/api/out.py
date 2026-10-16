"""Building review and ticket answers (shared by the patient, partner and admin endpoints)."""

import datetime as dt

from apps.reviews.models import Review, SupportTicket
from apps.reviews.schemas import (
    AdminReviewOut,
    AdminTicketOut,
    PartnerReviewOut,
    ReviewOut,
    TicketOut,
    TicketReplyOut,
)


def review_out(review: Review) -> ReviewOut:
    return ReviewOut(
        stars=review.stars, tags=review.tags, comment=review.comment, created_at=review.created_at
    )


def partner_review_out(review: Review) -> PartnerReviewOut:
    return PartnerReviewOut(
        **review_out(review).model_dump(),
        service_name=str(review.booking.price_snapshot.get("name", "")),
        service_name_hi=str(review.booking.price_snapshot.get("name_hi", "")),
        service_name_or=str(review.booking.price_snapshot.get("name_or", "")),
    )


def admin_review_out(review: Review) -> AdminReviewOut:
    return AdminReviewOut(
        **review_out(review).model_dump(),
        id=str(review.pk),
        booking_id=str(review.booking_id),
        code=review.booking.code,
        partner_id=str(review.partner_id),
        partner_name=review.partner.full_name,
        status=review.status,
        hidden_reason=review.hidden_reason,
    )


def ticket_out(ticket: SupportTicket) -> TicketOut:
    return TicketOut(
        id=str(ticket.pk),
        text=ticket.text,
        status=ticket.status,
        replies=[
            TicketReplyOut(
                by=r.get("by", "STAFF"),
                name=r.get("name", ""),
                text=r.get("text", ""),
                at=dt.datetime.fromisoformat(r["at"]),
            )
            for r in ticket.replies
        ],
        created_at=ticket.created_at,
    )


def admin_ticket_out(ticket: SupportTicket) -> AdminTicketOut:
    booking = ticket.booking
    profile = getattr(ticket.user, "patient_profile", None)
    return AdminTicketOut(
        **ticket_out(ticket).model_dump(),
        booking_id=str(booking.pk) if booking else None,
        code=booking.code if booking else "",
        patient_name=profile.full_name if profile else "",
        patient_phone=str(ticket.user.phone) if ticket.user.phone else "",
        partner_name=booking.partner.full_name if booking and booking.partner else "",
        closed_at=ticket.closed_at,
    )
