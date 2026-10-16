"""Offers to partners and the admin's alerts (ARCHITECTURE §6.10, §9.3, §11).

A booking has at most one OPEN offer. The partner accepts (or the admin records "accepted by
phone") or declines with a reason; assigning someone else withdraws the open offer. A booking
whose time changed after a partner accepted gets a RECONFIRM offer to the same partner.

`StaffAlert` keeps the admin's alerts (2 minutes without an answer, declined, past the assign
deadline) so the banner is there even if the admin wasn't connected when it fired.
"""

from django.db import models
from django.db.models import Q

from common.models import BaseModel


class OfferKind(models.TextChoices):
    NEW = "NEW", "Offer"
    RECONFIRM = "RECONFIRM", "Confirm the new time"
    TEMPORARY = "TEMPORARY", "Temporary partner (accepted at once, §6.19)"


class OfferResponse(models.TextChoices):
    OPEN = "OPEN", "Waiting for the partner"
    ACCEPTED = "ACCEPTED", "Accepted"
    ACCEPTED_BY_PHONE = "ACCEPTED_BY_PHONE", "Accepted by phone"
    DECLINED = "DECLINED", "Declined"
    WITHDRAWN = "WITHDRAWN", "Withdrawn"


class DeclineReason(models.TextChoices):
    NOT_AVAILABLE = "NOT_AVAILABLE", "Not available"
    TOO_FAR = "TOO_FAR", "Too far"
    OTHER = "OTHER", "Other"


class BookingAssignment(BaseModel):
    booking = models.ForeignKey(
        "bookings.Booking", on_delete=models.CASCADE, related_name="assignments"
    )
    partner = models.ForeignKey(
        "partners.PartnerProfile", on_delete=models.PROTECT, related_name="assignments"
    )
    kind = models.CharField(max_length=12, choices=OfferKind.choices, default=OfferKind.NEW)
    assigned_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )
    sent_at = models.DateTimeField()
    timeout_at = models.DateTimeField(help_text="The 2-minute rule: the admin is alerted then")
    response = models.CharField(
        max_length=20, choices=OfferResponse.choices, default=OfferResponse.OPEN
    )
    responded_at = models.DateTimeField(null=True, blank=True)
    decline_reason = models.CharField(
        max_length=16, choices=DeclineReason.choices, blank=True, default=""
    )
    decline_note = models.CharField(max_length=200, blank=True, default="")
    reminded_at = models.DateTimeField(
        null=True, blank=True, help_text="The 2-minute alert and reminder went out"
    )

    class Meta:
        db_table = "booking_assignments"
        ordering = ("-sent_at",)
        constraints = [
            models.UniqueConstraint(
                fields=["booking"],
                condition=Q(response="OPEN"),
                name="one_open_offer_per_booking",
            )
        ]
        indexes = [
            models.Index(fields=["partner", "response"], name="assign_partner_response_idx"),
        ]

    def __str__(self) -> str:
        return f"Offer {self.kind} {self.response}"


class AlertKind(models.TextChoices):
    OFFER_TIMEOUT = "OFFER_TIMEOUT", "Not accepted in 2 minutes"
    DECLINED = "DECLINED", "Declined"
    ESCALATION = "ESCALATION", "Unassigned past the deadline"
    PARTNER_UNAVAILABLE = "PARTNER_UNAVAILABLE", "Partner suspended: reassign"
    # The visit (Phase 8, §6.11, §9.1 Live)
    NO_LOCATION = "NO_LOCATION", "No location for 2 minutes"
    FAR_STEP = "FAR_STEP", "Step marked far from the place"
    MOCK_GPS = "MOCK_GPS", "Fake GPS location"
    OTP_LOCKED = "OTP_LOCKED", "Visit code wrong 4 times (partner waiting)"
    NO_SHOW = "NO_SHOW", "Patient not available: review"
    NOT_COMPLETED = "NOT_COMPLETED", "Not marked completed"
    NOT_STARTED = "NOT_STARTED", "Not on the way 30 minutes after pickup"


class StaffAlert(BaseModel):
    kind = models.CharField(max_length=20, choices=AlertKind.choices)
    booking = models.ForeignKey(
        "bookings.Booking", on_delete=models.CASCADE, related_name="staff_alerts"
    )
    assignment = models.ForeignKey(
        BookingAssignment, on_delete=models.CASCADE, null=True, blank=True, related_name="alerts"
    )
    pickup_at = models.DateTimeField(help_text="The booking's time when it fired")
    details = models.JSONField(default=dict, blank=True)
    acknowledged_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )
    acknowledged_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "staff_alerts"
        ordering = ("-created_at",)
        constraints = [
            # One timeout alert per offer, one escalation per booking time (a new time can
            # escalate again).
            models.UniqueConstraint(
                fields=["assignment"],
                condition=Q(kind="OFFER_TIMEOUT"),
                name="one_timeout_alert_per_offer",
            ),
            models.UniqueConstraint(
                fields=["booking", "pickup_at"],
                condition=Q(kind="ESCALATION"),
                name="one_escalation_per_booking_time",
            ),
        ]
        indexes = [
            models.Index(fields=["acknowledged_at", "-created_at"], name="alert_open_idx"),
        ]

    def __str__(self) -> str:
        return f"Alert {self.kind}"
