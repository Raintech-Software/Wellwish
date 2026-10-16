"""Ratings and "Report a problem" (ARCHITECTURE §6.11, §9.1).

- After a completed visit the family rates the partner once (1-5 stars, tags, a comment). The
  partner's average counts visible reviews only; an admin can hide one (not delete), logged.
- Within 24 hours after the visit ends (completed, or patient not available) the family can
  report a problem: a support ticket for the admins, who reply (the family gets a message) and
  close it.
"""

import datetime as dt
from decimal import ROUND_HALF_UP, Decimal
from typing import Any

from django.db import IntegrityError, transaction
from django.db.models import Avg, Count
from django.utils import timezone

from apps.audit.services import record
from apps.bookings import selectors as booking_selectors
from apps.bookings.models import Booking, BookingEvent, BookingStatus
from apps.partners import services as partners
from apps.reviews.models import Review, ReviewStatus, SupportTicket, TicketStatus
from apps.staff.models import StaffUser
from common import events, realtime
from common.errors import Conflict, NotFound
from common.ids import uid

S = BookingStatus
REPORT_WINDOW = dt.timedelta(hours=24)
ENDED = (S.COMPLETED, S.PATIENT_NO_SHOW)


class AlreadyReviewed(Conflict):
    code = "ALREADY_REVIEWED"
    message = "You've already rated this visit. Thank you!"


class NotReviewable(Conflict):
    code = "NOT_REVIEWABLE"
    message = "You can rate the visit once it's completed."


class ReportTooLate(Conflict):
    code = "REPORT_TOO_LATE"
    message = "Problems can be reported for 24 hours after the visit. Please call WellWish support."


def ended_at(booking: Booking) -> dt.datetime | None:
    return (
        BookingEvent.objects.filter(
            booking=booking, to_status__in=ENDED, event__in=("COMPLETE", "NO_SHOW")
        )
        .order_by("-server_ts")
        .values_list("server_ts", flat=True)
        .first()
    )


def can_report(booking: Booking, now: dt.datetime | None = None) -> bool:
    if booking.status not in ENDED:
        return False
    end = ended_at(booking)
    return end is not None and (now or timezone.now()) - end <= REPORT_WINDOW


def refresh_rating(partner_id: Any) -> None:
    """The partner's average from visible reviews (2 decimals). Call inside a transaction."""
    partners.lock_for_rating(str(partner_id))
    stats = Review.objects.filter(partner_id=partner_id, status=ReviewStatus.VISIBLE).aggregate(
        avg=Avg("stars"), count=Count("id")
    )
    avg = (
        Decimal(str(stats["avg"])).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
        if stats["avg"] is not None
        else None
    )
    partners.set_rating(str(partner_id), avg, int(stats["count"]))


def add_review(
    *, user_id: str, booking_id: str, stars: int, tags: list[str], comment: str
) -> Review:
    """P20: rate the partner (once, after Completed)."""
    booking = booking_selectors.own_booking(user_id, booking_id)
    if booking.status != S.COMPLETED or booking.partner_id is None:
        raise NotReviewable()
    try:
        with transaction.atomic():
            review = Review.objects.create(
                booking=booking,
                partner_id=booking.partner_id,
                author_id=uid(user_id),
                stars=stars,
                tags=sorted(set(tags)),
                comment=comment.strip(),
            )
            refresh_rating(booking.partner_id)
    except IntegrityError:
        raise AlreadyReviewed() from None
    return review


def set_review_visible(
    *, review_id: str, staff: StaffUser, visible: bool, reason: str, ip: str | None
) -> Review:
    """Moderation (§9.1): hide (never delete) or show again. Logged."""
    with transaction.atomic():
        review = Review.objects.select_for_update().filter(pk=uid(review_id)).first()
        if review is None:
            raise NotFound()
        review.status = ReviewStatus.VISIBLE if visible else ReviewStatus.HIDDEN
        review.hidden_reason = "" if visible else reason
        review.save(update_fields=["status", "hidden_reason", "updated_at"])
        refresh_rating(review.partner_id)
        record(
            staff,
            "review.shown" if visible else "review.hidden",
            review,
            after={"stars": review.stars},
            reason=reason,
            ip=ip,
        )
        return review


# --- Support tickets ---


def report_problem(*, user_id: str, booking_id: str, text: str) -> SupportTicket:
    """P20 "Report a problem": within 24 h after the visit ends."""
    booking = booking_selectors.own_booking(user_id, booking_id)
    if not can_report(booking):
        raise ReportTooLate()
    with transaction.atomic():
        ticket = SupportTicket.objects.create(
            booking=booking, user_id=uid(user_id), text=text.strip()
        )
        data = {"id": str(ticket.pk), "bookingId": str(booking.pk), "code": booking.code}
        transaction.on_commit(
            lambda: realtime.send_to_group("staff.ops", "ticket.new", data), robust=True
        )
    return ticket


def _ticket(ticket_id: str) -> SupportTicket:
    ticket = SupportTicket.objects.select_for_update().filter(pk=uid(ticket_id)).first()
    if ticket is None:
        raise NotFound()
    return ticket


def reply(*, ticket_id: str, staff: StaffUser, text: str, ip: str | None) -> SupportTicket:
    """The admin answers; the family gets a message. Logged."""
    with transaction.atomic():
        ticket = _ticket(ticket_id)
        ticket.replies = [
            *ticket.replies,
            {
                "by": "STAFF",
                "name": staff.name,
                "text": text.strip(),
                "at": timezone.now().isoformat(),
            },
        ]
        ticket.save(update_fields=["replies", "updated_at"])
        record(staff, "ticket.replied", ticket, ip=ip)
        events.publish("ticket.replied", {"ticket_id": str(ticket.pk)})
        return ticket


def close(*, ticket_id: str, staff: StaffUser, ip: str | None) -> SupportTicket:
    with transaction.atomic():
        ticket = _ticket(ticket_id)
        if ticket.status != TicketStatus.CLOSED:
            ticket.status, ticket.closed_at = TicketStatus.CLOSED, timezone.now()
            ticket.save(update_fields=["status", "closed_at", "updated_at"])
            record(staff, "ticket.closed", ticket, ip=ip)
        return ticket


def erase_for_owner(*, user_id: str) -> None:
    """Account deletion (§12): ratings stay (the partner's average) without the comment; the
    reported problems keep WellWish's replies but lose the family's text."""
    Review.objects.filter(booking__booked_by_id=uid(user_id)).update(comment="")
    SupportTicket.objects.filter(user_id=uid(user_id)).update(text="")
