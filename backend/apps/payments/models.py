"""Booking-fee payments and refunds through Razorpay (ARCHITECTURE §6.12, §11).

The webhook is the truth: a booking becomes NEW only when Razorpay says the money was captured
(webhook, or our own check with Razorpay's API), never because the app says so. Amounts always
come from the booking's price snapshot. Money is integer paise.

The Razorpay keys are entered by a Super Admin in the panel (§9.1 Settings → Payments) and kept
encrypted (`common.crypto`); the secrets are never shown again.
"""

from django.db import models
from django.db.models import Q

from common.models import BaseModel


class GatewayKeys(BaseModel):
    """One row: the Razorpay keys entered in the admin panel."""

    key_id = models.CharField(
        max_length=64, blank=True, default="", help_text="rzp_test_… / rzp_live_…"
    )
    key_secret_enc = models.TextField(blank=True, default="")
    webhook_secret_enc = models.TextField(blank=True, default="")
    updated_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )

    class Meta:
        db_table = "payment_gateway_keys"
        verbose_name_plural = "payment gateway keys"

    def __str__(self) -> str:
        return "Razorpay keys"


class PaymentStatus(models.TextChoices):
    CREATED = "CREATED", "Order created"
    AUTHORIZED = "AUTHORIZED", "Paid, being confirmed"
    CAPTURED = "CAPTURED", "Captured"
    FAILED = "FAILED", "Failed"


class Payment(BaseModel):
    """One Razorpay order for a booking's fee (and the payment made for it)."""

    booking = models.ForeignKey(
        "bookings.Booking", on_delete=models.PROTECT, related_name="payments"
    )
    amount_paise = models.BigIntegerField()
    currency = models.CharField(max_length=3, default="INR")
    razorpay_order_id = models.CharField(max_length=64, unique=True)
    razorpay_payment_id = models.CharField(max_length=64, blank=True, default="")
    status = models.CharField(
        max_length=12, choices=PaymentStatus.choices, default=PaymentStatus.CREATED
    )
    method = models.CharField(
        max_length=24, blank=True, default="", help_text="upi, card, netbanking…"
    )
    mode = models.CharField(max_length=4, blank=True, default="", help_text="TEST or LIVE keys")
    captured_at = models.DateTimeField(null=True, blank=True)
    failure_reason = models.CharField(max_length=200, blank=True, default="")

    class Meta:
        db_table = "payments"
        ordering = ("-created_at",)
        constraints = [
            models.UniqueConstraint(
                fields=["razorpay_payment_id"],
                condition=~Q(razorpay_payment_id=""),
                name="payments_razorpay_payment_uniq",
            ),
            models.CheckConstraint(
                condition=Q(amount_paise__gt=0), name="payments_amount_positive"
            ),
        ]
        indexes = [
            models.Index(fields=["status", "created_at"], name="payments_status_created_idx")
        ]

    def __str__(self) -> str:
        return self.razorpay_order_id


class RefundStatus(models.TextChoices):
    AWAITING_APPROVAL = "AWAITING_APPROVAL", "Waiting for Finance approval"
    PENDING = "PENDING", "Sent to Razorpay"
    PROCESSED = "PROCESSED", "Refunded"
    FAILED = "FAILED", "Failed"
    REJECTED = "REJECTED", "Not approved"


class RequestedBy(models.TextChoices):
    PATIENT = "PATIENT", "Patient"
    STAFF = "STAFF", "Admin"
    SYSTEM = "SYSTEM", "System"


class Refund(BaseModel):
    payment = models.ForeignKey(Payment, on_delete=models.PROTECT, related_name="refunds")
    percent = models.PositiveSmallIntegerField()
    amount_paise = models.BigIntegerField()
    reason = models.CharField(max_length=300)
    status = models.CharField(max_length=20, choices=RefundStatus.choices)
    razorpay_refund_id = models.CharField(max_length=64, blank=True, default="")
    requested_by_type = models.CharField(max_length=8, choices=RequestedBy.choices)
    requested_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )
    approved_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )
    decided_at = models.DateTimeField(null=True, blank=True)
    processed_at = models.DateTimeField(null=True, blank=True)
    failure_reason = models.CharField(max_length=200, blank=True, default="")

    class Meta:
        db_table = "refunds"
        ordering = ("-created_at",)
        constraints = [
            models.CheckConstraint(condition=Q(amount_paise__gt=0), name="refunds_amount_positive"),
            models.CheckConstraint(
                condition=Q(percent__gte=1) & Q(percent__lte=100), name="refunds_percent_range"
            ),
        ]
        indexes = [models.Index(fields=["status", "created_at"], name="refunds_status_created_idx")]

    def __str__(self) -> str:
        return f"Refund {self.amount_paise} of {self.payment_id}"


class WebhookEvent(BaseModel):
    """Every webhook received once (Razorpay retries: a repeat is ignored). Only ids, amounts
    and statuses are kept, never the payer's contact details."""

    provider = models.CharField(max_length=16, default="razorpay")
    event_id = models.CharField(max_length=64, unique=True)
    type = models.CharField(max_length=48)
    payload = models.JSONField(default=dict)
    processed_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "webhook_events"
        ordering = ("-created_at",)

    def __str__(self) -> str:
        return f"{self.type} {self.event_id}"
