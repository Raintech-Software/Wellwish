"""Partners: companions and nurses (ARCHITECTURE §6.3, §8, §11).

The profile uses the user id as its key. The status follows the §6.3 diagram and only changes
through `apps.partners.services` → `transition()` (the kyc app drives most of the moves).
"""

from typing import ClassVar

from django.conf import settings
from django.db import models

from common.models import BaseModel


class PartnerRole(models.TextChoices):
    COMPANION = "COMPANION", "Companion"
    NURSE = "NURSE", "Nurse"


class PartnerStatus(models.TextChoices):
    REGISTERING = "REGISTERING", "Registering"  # role chosen; phones, email or profile missing
    REGISTERED = "REGISTERED", "Registered"  # phones + email verified, profile done
    SUBMITTED = "SUBMITTED", "Submitted"
    UNDER_REVIEW = "UNDER_REVIEW", "Under review"
    CHANGES_REQUESTED = "CHANGES_REQUESTED", "Changes requested"
    APPROVED = "APPROVED", "Approved"
    REJECTED = "REJECTED", "Rejected"
    SUSPENDED = "SUSPENDED", "Suspended"
    DEACTIVATED = "DEACTIVATED", "Deactivated"
    # §6.19 (v2.17): a person the admin phoned and ID-checked, for one booking only
    TEMPORARY = "TEMPORARY", "Temporary"
    TEMP_ENDED = "TEMP_ENDED", "Temporary (ended)"
    # §6.20 (v2.31): erased after "delete my account" (while it waits, the status stays)
    DELETED = "DELETED", "Deleted"


class Gender(models.TextChoices):
    FEMALE = "FEMALE", "Female"
    MALE = "MALE", "Male"
    OTHER = "OTHER", "Other"


class PartnerProfile(models.Model):
    user = models.OneToOneField(
        "accounts.User", on_delete=models.PROTECT, primary_key=True, related_name="partner"
    )
    role = models.CharField(max_length=16, choices=PartnerRole.choices)
    status = models.CharField(
        max_length=24, choices=PartnerStatus.choices, default=PartnerStatus.REGISTERING
    )
    version = models.PositiveIntegerField(default=0)
    suspended_reason = models.CharField(
        max_length=32, blank=True, default="", help_text="ADMIN or DOCUMENT_EXPIRED"
    )
    full_name = models.CharField(max_length=80, blank=True, default="")
    dob = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=8, choices=Gender.choices, blank=True, default="")
    photo_key = models.CharField(max_length=255, blank=True, default="")
    email = models.EmailField(blank=True, default="")
    email_verified_at = models.DateTimeField(null=True, blank=True)
    address = models.CharField(max_length=300, blank=True, default="")
    lat = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    lng = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    languages = models.JSONField(default=list, blank=True)
    skills = models.JSONField(default=list, blank=True)
    emergency_name = models.CharField(max_length=80, blank=True, default="")
    emergency_phone = models.CharField(max_length=16, blank=True, default="")
    available_today = models.BooleanField(default=False)
    available_on = models.DateField(
        null=True, blank=True, help_text="The India date the switch was turned on (resets daily)"
    )
    rating_avg = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    rating_count = models.PositiveIntegerField(default=0)
    added_by_admin = models.BooleanField(default=False)
    approved_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "partner_profiles"
        indexes = [
            models.Index(fields=["status", "role"], name="partner_status_role_idx"),
            models.Index(fields=["lat", "lng"], name="partner_base_location_idx"),
        ]

    def __str__(self) -> str:
        return f"Partner {self.pk}"

    @property
    def profile_complete(self) -> bool:
        return bool(
            self.full_name
            and self.dob
            and self.gender
            and self.photo_key
            and self.address
            and self.lat is not None
            and self.lng is not None
            and self.languages
            and self.emergency_name
            and self.emergency_phone
        )


class PartnerPhone(BaseModel):
    class Kind(models.TextChoices):
        PRIMARY = "PRIMARY", "Primary (login)"
        ALTERNATE = "ALTERNATE", "Alternate"

    partner = models.ForeignKey(PartnerProfile, on_delete=models.CASCADE, related_name="phones")
    kind = models.CharField(max_length=16, choices=Kind.choices)
    phone = models.CharField(max_length=16)
    verified_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "partner_phones"
        constraints = [
            models.UniqueConstraint(fields=["partner", "kind"], name="partner_phone_kind_uniq")
        ]

    def __str__(self) -> str:
        return f"PartnerPhone {self.kind}"


class TemporaryIdCheck(BaseModel):
    """A temporary partner for one booking (§6.19): the ID the admin checked on the phone before
    the temporary assign. Kept on record like partner documents (the photo is private, every
    view logged); `ended_at` is set when their access ends. One open check per partner."""

    class IdType(models.TextChoices):
        AADHAAR = "AADHAAR", "Aadhaar"
        DRIVING_LICENCE = "DRIVING_LICENCE", "Driving licence"
        VOTER_ID = "VOTER_ID", "Voter ID"
        PAN = "PAN", "PAN card"

    class EndReason(models.TextChoices):
        COMPLETED = "COMPLETED", "The job was completed"
        CANCELLED = "CANCELLED", "The booking was cancelled"
        UNASSIGNED = "UNASSIGNED", "Unassigned or reassigned"
        RESCHEDULED = "RESCHEDULED", "The time changed"
        BY_ADMIN = "BY_ADMIN", "Ended by an admin"

    partner = models.ForeignKey(
        PartnerProfile, on_delete=models.PROTECT, related_name="temporary_checks"
    )
    booking = models.ForeignKey(
        "bookings.Booking", on_delete=models.PROTECT, related_name="temporary_checks"
    )
    id_type = models.CharField(max_length=16, choices=IdType.choices)
    id_last4 = models.CharField(max_length=4, help_text="Last 4 characters only (§12)")
    id_photo_key = models.CharField(max_length=255)
    nursing_reg_no = models.CharField(
        max_length=40, blank=True, default="", help_text="As printed; nurse bookings only"
    )
    reason = models.CharField(max_length=300, help_text="Why no regular partner could take it")
    checked_by = models.ForeignKey("staff.StaffUser", on_delete=models.PROTECT, related_name="+")
    checked_at = models.DateTimeField()
    ended_at = models.DateTimeField(null=True, blank=True)
    end_reason = models.CharField(max_length=12, choices=EndReason.choices, blank=True, default="")

    class Meta:
        db_table = "temporary_id_checks"
        constraints = [
            models.UniqueConstraint(
                fields=["partner"],
                condition=models.Q(ended_at__isnull=True),
                name="temp_check_one_open_per_partner",
            )
        ]

    def __str__(self) -> str:
        return f"TemporaryIdCheck {self.pk}"


class SelfieCheck(BaseModel):
    """The once-a-day selfie before going available (§8.3, §6.15). Admins spot-check them
    against the approved photo."""

    partner = models.ForeignKey(PartnerProfile, on_delete=models.CASCADE, related_name="selfies")
    file_key = models.CharField(max_length=255)
    at = models.DateTimeField()

    class Meta:
        db_table = "selfie_checks"
        indexes = [models.Index(fields=["partner", "-at"], name="selfie_partner_at_idx")]

    def __str__(self) -> str:
        return f"SelfieCheck {self.at:%Y-%m-%d}"


class DeletionSource(models.TextChoices):
    """Where a "delete my account" came from (§6.20)."""

    APP = "APP", "The app"
    WEB = "WEB", "The website"
    ADMIN = "ADMIN", "An admin (the person phoned)"


class PartnerDeletion(BaseModel):
    """A partner's "delete my account" (§6.20). They are logged out at once; while it waits
    (`account_deletion_days`) their status stays as it is, so sanctions keep working, but they
    get no offers and aren't reviewed. Then a daily task erases their personal data (status
    DELETED). A Partner app login before then cancels it. Someone who never chose a role has
    nothing to wait for: done at once."""

    class Status(models.TextChoices):
        PENDING = "PENDING", "Waiting"
        CANCELLED = "CANCELLED", "Cancelled (logged in again)"
        DONE = "DONE", "Deleted"

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="partner_deletions"
    )
    status = models.CharField(max_length=12, choices=Status.choices, default=Status.PENDING)
    due_at = models.DateTimeField()
    cancelled_at = models.DateTimeField(null=True, blank=True)
    done_at = models.DateTimeField(null=True, blank=True)
    phone_last4 = models.CharField(max_length=4, blank=True, default="")
    kept_patient = models.BooleanField(
        default=False, help_text="Also a patient: only the partner data was removed"
    )
    source = models.CharField(
        max_length=8, choices=DeletionSource.choices, default=DeletionSource.APP
    )

    class Meta:
        db_table = "partner_deletions"
        indexes = [models.Index(fields=["status", "due_at"], name="partner_del_status_due_idx")]
        constraints: ClassVar[list[models.BaseConstraint]] = [
            models.UniqueConstraint(
                fields=["user"],
                condition=models.Q(status="PENDING"),
                name="partner_del_one_pending",
            )
        ]

    def __str__(self) -> str:
        return f"PartnerDeletion {self.status}"
