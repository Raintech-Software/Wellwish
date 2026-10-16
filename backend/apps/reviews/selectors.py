"""Reads for reviews and support tickets (§6.13, §9.1)."""

from django.db.models import QuerySet

from apps.bookings.models import Booking
from apps.reviews.models import Review, ReviewStatus, SupportTicket, TicketStatus
from common.ids import uid


def booking_review(booking: Booking) -> Review | None:
    return Review.objects.filter(booking=booking).first()


def booking_tickets(booking: Booking, user_id: str) -> list[SupportTicket]:
    return list(
        SupportTicket.objects.filter(booking=booking, user_id=user_id).order_by("created_at")
    )


def partner_reviews(partner_id: str, limit: int = 20) -> QuerySet[Review]:
    """R15: the partner's visible reviews, newest first."""
    return (
        Review.objects.select_related("booking")
        .filter(partner_id=uid(partner_id), status=ReviewStatus.VISIBLE)
        .order_by("-created_at")[:limit]
    )


def admin_reviews(status: str = "all") -> QuerySet[Review]:
    rows = Review.objects.select_related("booking", "partner").order_by("-created_at")
    if status in (ReviewStatus.VISIBLE, ReviewStatus.HIDDEN):
        rows = rows.filter(status=status)
    return rows


def admin_tickets(status: str = "open") -> QuerySet[SupportTicket]:
    rows = SupportTicket.objects.select_related(
        "booking", "booking__partner", "user", "user__patient_profile"
    ).order_by("-created_at")
    if status == "open":
        rows = rows.filter(status=TicketStatus.OPEN)
    return rows
