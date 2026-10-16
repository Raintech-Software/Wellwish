"""SOS and the trip share link (ARCHITECTURE §6.15)."""

from django.conf import settings
from django.db import models

from common.models import BaseModel


class SosStatus(models.TextChoices):
    OPEN = "OPEN", "Open"
    ACKNOWLEDGED = "ACKNOWLEDGED", "Acknowledged"
    RESOLVED = "RESOLVED", "Resolved"


class SosEvent(BaseModel):
    """Someone pressed SOS during a job: the admins' alarm until acknowledged, then resolved."""

    booking = models.ForeignKey("bookings.Booking", on_delete=models.CASCADE, related_name="sos")
    raised_by_type = models.CharField(max_length=8, help_text="PATIENT or PARTNER")
    raised_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name="+"
    )
    lat = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    lng = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    # Android said the position is fake (a mock location app): an SOS is never refused, but the
    # admins see it and the emergency SMS doesn't send people to that place (PHASES 9.3)
    mock_location = models.BooleanField(default=False)
    status = models.CharField(max_length=12, choices=SosStatus.choices, default=SosStatus.OPEN)
    ack_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.SET_NULL, null=True, blank=True, related_name="+"
    )
    ack_at = models.DateTimeField(null=True, blank=True)
    resolved_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.SET_NULL, null=True, blank=True, related_name="+"
    )
    resolved_at = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(blank=True, default="")
    escalated_at = models.DateTimeField(
        null=True, blank=True, help_text="Nobody acknowledged it in 2 minutes: Super Admins told"
    )

    class Meta:
        db_table = "sos_events"
        ordering = ("-created_at",)
        indexes = [models.Index(fields=["status", "created_at"], name="sos_status_idx")]

    def __str__(self) -> str:
        return f"SOS {self.booking_id} ({self.status})"


class ShareLink(BaseModel):
    """The family shares the trip with someone without the app (§6.15): a secret link that
    shows the partner's live position and step until the job ends."""

    booking = models.ForeignKey(
        "bookings.Booking", on_delete=models.CASCADE, related_name="share_links"
    )
    token_hash = models.CharField(max_length=64, unique=True)
    expires_at = models.DateTimeField()
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name="+"
    )

    class Meta:
        db_table = "share_links"

    def __str__(self) -> str:
        return f"Share link {self.booking_id}"
