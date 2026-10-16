"""Ratings and "Report a problem" (ARCHITECTURE §6.11, §9.1 Support)."""

from django.conf import settings
from django.db import models

from common.models import BaseModel


class ReviewStatus(models.TextChoices):
    VISIBLE = "VISIBLE", "Visible"
    HIDDEN = "HIDDEN", "Hidden by an admin"


class Review(BaseModel):
    """The family rates the partner after a completed visit (one per booking)."""

    booking = models.OneToOneField(
        "bookings.Booking", on_delete=models.CASCADE, related_name="review"
    )
    partner = models.ForeignKey(
        "partners.PartnerProfile", on_delete=models.CASCADE, related_name="reviews"
    )
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name="+"
    )
    stars = models.PositiveSmallIntegerField()
    tags = models.JSONField(default=list, blank=True)
    comment = models.CharField(max_length=500, blank=True, default="")
    status = models.CharField(
        max_length=8, choices=ReviewStatus.choices, default=ReviewStatus.VISIBLE
    )
    hidden_reason = models.CharField(max_length=300, blank=True, default="")

    class Meta:
        db_table = "reviews"
        indexes = [models.Index(fields=["partner", "status"], name="reviews_partner_idx")]
        constraints = [
            models.CheckConstraint(
                condition=models.Q(stars__gte=1, stars__lte=5), name="review_stars_1_to_5"
            )
        ]

    def __str__(self) -> str:
        return f"Review {self.booking_id}: {self.stars}"


class TicketStatus(models.TextChoices):
    OPEN = "OPEN", "Open"
    CLOSED = "CLOSED", "Closed"


class SupportTicket(BaseModel):
    """ "Report a problem" within 24 h of the visit: the admins reply and close it."""

    booking = models.ForeignKey(
        "bookings.Booking", on_delete=models.CASCADE, null=True, blank=True, related_name="tickets"
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="support_tickets"
    )
    text = models.CharField(max_length=1000)
    status = models.CharField(max_length=8, choices=TicketStatus.choices, default=TicketStatus.OPEN)
    replies = models.JSONField(
        default=list,
        blank=True,
        help_text='[{"by": "STAFF", "name": "Priya", "text": "...", "at": "..."}]',
    )
    closed_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "support_tickets"
        ordering = ("-created_at",)
        indexes = [models.Index(fields=["status", "created_at"], name="tickets_status_idx")]

    def __str__(self) -> str:
        return f"Ticket {self.pk} ({self.status})"
