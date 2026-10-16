"""Bookings (ARCHITECTURE §6.9, §6.17, §11).

A booking is made by the account owner (`booked_by`) for one of their family members. It keeps
snapshots of the price, the member and the address used, so later edits (a new price, a moved
address, a removed member, an erased account) never change what was booked. Every status change
goes through `services.transition()` and writes a `BookingEvent`.

Money is integer paise. The partner columns (`partner`, `busy_window`, OTP, steps, balance) are
used from Phase 7 on; the database already refuses a partner with two overlapping accepted jobs.
"""

from django.conf import settings
from django.contrib.postgres.constraints import ExclusionConstraint
from django.contrib.postgres.fields import DateTimeRangeField, RangeOperators
from django.db import models
from django.db.models import Q

from common.models import BaseModel


class BookingStatus(models.TextChoices):
    PENDING_PAYMENT = "PENDING_PAYMENT", "Pending payment"
    NEW = "NEW", "New (to assign)"
    OFFERED = "OFFERED", "Offered to a partner"
    ACCEPTED = "ACCEPTED", "Accepted"
    IN_PROGRESS = "IN_PROGRESS", "In progress"
    COMPLETED = "COMPLETED", "Completed"
    PATIENT_NO_SHOW = "PATIENT_NO_SHOW", "Patient not available"
    CANCELLED = "CANCELLED", "Cancelled"
    EXPIRED = "EXPIRED", "Expired (not paid)"


class Booking(BaseModel):
    code = models.CharField(max_length=16, unique=True, help_text="WW-10001, for phone support")
    booked_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.PROTECT, related_name="bookings"
    )
    # SET_NULL: an erased account's members go; the booking keeps its (scrubbed) snapshot.
    member = models.ForeignKey(
        "patients.Member",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="bookings",
    )
    service = models.ForeignKey(
        "services.Service", on_delete=models.PROTECT, related_name="bookings"
    )
    price_snapshot = models.JSONField(
        help_text="Service name, partner and visit type, duration, total, fee, balance (paise)"
    )
    hospital = models.ForeignKey(
        "hospitals.Hospital",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="bookings",
    )
    hospital_text = models.CharField(
        max_length=200, blank=True, default="", help_text="Typed in: not in the directory"
    )
    doctor = models.ForeignKey(
        "hospitals.Doctor",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="bookings",
    )
    appointment_at = models.DateTimeField(
        null=True, blank=True, help_text="The doctor appointment (hospital visits)"
    )
    pickup_at = models.DateTimeField(help_text="When the partner's job starts")
    address = models.ForeignKey(
        "addresses.Address",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="bookings",
    )
    address_snapshot = models.JSONField()
    member_snapshot = models.JSONField()
    notes = models.CharField(max_length=500, blank=True, default="")
    reschedule_count = models.PositiveSmallIntegerField(default=0)
    reconfirm_needed = models.BooleanField(
        default=False, help_text="The time changed after a partner was offered or accepted it"
    )
    status = models.CharField(
        max_length=16, choices=BookingStatus.choices, default=BookingStatus.PENDING_PAYMENT
    )
    partner = models.ForeignKey(
        "partners.PartnerProfile",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="bookings",
    )
    busy_window = DateTimeRangeField(
        help_text="Pickup - 1 h → pickup + duration + 30 min (the partner's blocked time)"
    )
    current_step = models.CharField(max_length=24, blank=True, default="")
    otp_hash = models.CharField(max_length=128, blank=True, default="")
    otp_enc = models.CharField(
        max_length=200,
        blank=True,
        default="",
        help_text="The job OTP, encrypted (shown to the owner)",
    )
    otp_attempts = models.PositiveSmallIntegerField(default=0)
    otp_retry_at = models.DateTimeField(
        null=True,
        blank=True,
        help_text="After 4 wrong codes: the next try from then (5, 10, 20 min…, §6.11)",
    )
    balance_collected_paise = models.BigIntegerField(null=True, blank=True)
    balance_mode = models.CharField(max_length=8, blank=True, default="")
    cancelled_by = models.CharField(max_length=16, blank=True, default="")
    cancel_reason = models.CharField(max_length=300, blank=True, default="")
    refund_percent = models.PositiveSmallIntegerField(null=True, blank=True)
    version = models.PositiveIntegerField(default=0)
    idempotency_key = models.CharField(
        max_length=64, blank=True, default="", help_text="A retried 'Book' returns this booking"
    )
    idempotency_hash = models.CharField(
        max_length=64, blank=True, default="", help_text="What was sent with the key (SHA-256)"
    )

    class Meta:
        db_table = "bookings"
        ordering = ("-pickup_at",)
        indexes = [
            models.Index(fields=["status", "pickup_at"], name="bookings_status_pickup_idx"),
            models.Index(fields=["booked_by", "pickup_at"], name="bookings_owner_pickup_idx"),
        ]
        constraints = [
            ExclusionConstraint(
                name="no_partner_overlap",
                expressions=[
                    ("partner", RangeOperators.EQUAL),
                    ("busy_window", RangeOperators.OVERLAPS),
                ],
                condition=Q(status__in=["ACCEPTED", "IN_PROGRESS"]),
            ),
            models.UniqueConstraint(
                fields=["booked_by", "idempotency_key"],
                condition=~Q(idempotency_key=""),
                name="bookings_idempotency_uniq",
            ),
            models.CheckConstraint(
                condition=Q(appointment_at__isnull=True)
                | Q(appointment_at__gte=models.F("pickup_at")),
                name="bookings_appointment_after_pickup",
            ),
        ]

    def __str__(self) -> str:
        return self.code

    @property
    def partner_type(self) -> str:
        return str(self.price_snapshot.get("partner_type", ""))

    @property
    def visit_type(self) -> str:
        return str(self.price_snapshot.get("visit_type", ""))


class BookingDocument(BaseModel):
    """A medical document attached to a booking. If the patient deletes the document later,
    the row stays with `document` empty, so the booking can say "document removed"."""

    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name="documents")
    document = models.ForeignKey(
        "documents.PatientDocument",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="booking_links",
    )
    doc_type = models.CharField(max_length=16, help_text="Copied: PRESCRIPTION, LAB_REPORT…")

    class Meta:
        db_table = "booking_documents"
        constraints = [
            models.UniqueConstraint(
                fields=["booking", "document"],
                condition=Q(document__isnull=False),
                name="booking_document_uniq",
            )
        ]

    def __str__(self) -> str:
        return f"BookingDocument {self.id}"


class ActorType(models.TextChoices):
    PATIENT = "PATIENT", "Patient"
    PARTNER = "PARTNER", "Partner"
    STAFF = "STAFF", "Admin"
    SYSTEM = "SYSTEM", "System"


class BookingEvent(BaseModel):
    """The booking's timeline: every status change and (from Phase 8) every job step."""

    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name="events")
    from_status = models.CharField(max_length=16, blank=True, default="")
    to_status = models.CharField(max_length=16)
    event = models.CharField(max_length=24, help_text="CREATE, PAY, OFFER, CANCEL…")
    step = models.CharField(max_length=24, blank=True, default="")
    actor_type = models.CharField(max_length=8, choices=ActorType.choices)
    actor_id = models.UUIDField(null=True, blank=True)
    lat = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    lng = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    accuracy = models.FloatField(null=True, blank=True, help_text="Metres")
    client_ts = models.DateTimeField(null=True, blank=True)
    server_ts = models.DateTimeField()
    far_from_target = models.BooleanField(default=False)
    note = models.CharField(max_length=300, blank=True, default="")
    vitals = models.JSONField(null=True, blank=True)

    class Meta:
        db_table = "booking_events"
        ordering = ("server_ts", "created_at")
        indexes = [models.Index(fields=["booking", "server_ts"], name="booking_events_time_idx")]

    def __str__(self) -> str:
        return f"{self.booking_id}: {self.from_status or '-'} → {self.to_status}"


class BookingReminder(BaseModel):
    """A T-24 h or T-2 h reminder already sent (§6.17), so each goes out once per booking time
    (a new time gets its own reminders)."""

    class Kind(models.TextChoices):
        DAY_BEFORE = "24H", "24 hours before"
        TWO_HOURS = "2H", "2 hours before"

    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name="reminders")
    kind = models.CharField(max_length=4, choices=Kind.choices)
    pickup_at = models.DateTimeField()

    class Meta:
        db_table = "booking_reminders"
        constraints = [
            models.UniqueConstraint(
                fields=["booking", "kind", "pickup_at"], name="one_reminder_per_time"
            )
        ]

    def __str__(self) -> str:
        return f"Reminder {self.kind}"
