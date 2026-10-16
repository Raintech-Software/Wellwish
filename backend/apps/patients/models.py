"""Patient profile and family members (ARCHITECTURE §6.1, §6.18, §11).

Every booking points to a member, never directly to a user. The account owner is the `SELF`
member. Phase 1 creates the profile and the SELF member; Phase 4 adds family members (up to
`max_members`, removed = hidden, never deleted) and account deletion.
Health fields (conditions, allergies…) are medical text: never log them.
"""

from typing import ClassVar

from django.conf import settings
from django.db import models

from common.models import BaseModel


class Gender(models.TextChoices):
    FEMALE = "FEMALE", "Female"
    MALE = "MALE", "Male"
    OTHER = "OTHER", "Other"


class PatientProfile(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        primary_key=True,
        related_name="patient_profile",
    )
    full_name = models.CharField(max_length=80, blank=True, default="")
    dob = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=8, choices=Gender.choices, blank=True, default="")
    emergency_name = models.CharField(max_length=80, blank=True, default="")
    emergency_phone = models.CharField(max_length=16, blank=True, default="")
    # Blocked by an admin for abuse (§9.1): the patient app only (not the partner app)
    blocked_at = models.DateTimeField(null=True, blank=True)
    blocked_reason = models.CharField(max_length=300, blank=True, default="")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "patient_profiles"

    def __str__(self) -> str:
        return f"PatientProfile {self.user_id}"

    @property
    def is_complete(self) -> bool:
        return bool(self.full_name and self.dob and self.gender)


class Member(BaseModel):
    class Relation(models.TextChoices):
        SELF = "SELF", "Self"
        MOTHER = "MOTHER", "Mother"
        FATHER = "FATHER", "Father"
        GRANDMOTHER = "GRANDMOTHER", "Grandmother"
        GRANDFATHER = "GRANDFATHER", "Grandfather"
        SPOUSE = "SPOUSE", "Spouse"
        CHILD = "CHILD", "Child"
        SIBLING = "SIBLING", "Sibling"
        OTHER = "OTHER", "Other"

    class Mobility(models.TextChoices):
        WALKS_ALONE = "WALKS_ALONE", "Walks alone"
        NEEDS_SUPPORT = "NEEDS_SUPPORT", "Needs support"
        WHEELCHAIR = "WHEELCHAIR", "Wheelchair"

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="members"
    )
    relation = models.CharField(max_length=16, choices=Relation.choices)
    full_name = models.CharField(max_length=80, blank=True, default="")
    dob = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=8, choices=Gender.choices, blank=True, default="")
    photo_key = models.CharField(max_length=255, blank=True, default="")
    phone = models.CharField(max_length=16, blank=True, default="")
    language = models.CharField(max_length=8, blank=True, default="")
    conditions = models.TextField(blank=True, default="")
    allergies = models.TextField(blank=True, default="")
    mobility = models.CharField(max_length=16, choices=Mobility.choices, blank=True, default="")
    sensory_notes = models.TextField(blank=True, default="")
    emergency_name = models.CharField(max_length=80, blank=True, default="")
    emergency_phone = models.CharField(max_length=16, blank=True, default="")
    consent_at = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = "members"
        indexes = [models.Index(fields=["owner", "is_active"], name="members_owner_active_idx")]
        constraints: ClassVar[list[models.BaseConstraint]] = [
            models.UniqueConstraint(
                fields=["owner"],
                condition=models.Q(relation="SELF"),
                name="members_one_self_per_owner",
            )
        ]

    def __str__(self) -> str:
        return f"Member {self.id} ({self.relation})"


class AccountDeletion(BaseModel):
    """A patient's "delete my account" request (§12 privacy, PHASES 4.5).

    The patient is logged out at once. After the `account_deletion_days` setting (default 7,
    at most 30) a daily task removes their personal
    data (profile, family members, addresses, documents, inbox); payment records stay. Logging in
    again before then cancels the request.
    """

    class Status(models.TextChoices):
        PENDING = "PENDING", "Waiting"
        CANCELLED = "CANCELLED", "Cancelled (logged in again)"
        DONE = "DONE", "Deleted"

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="account_deletions"
    )
    status = models.CharField(max_length=12, choices=Status.choices, default=Status.PENDING)
    due_at = models.DateTimeField()
    cancelled_at = models.DateTimeField(null=True, blank=True)
    done_at = models.DateTimeField(null=True, blank=True)
    phone_last4 = models.CharField(max_length=4, blank=True, default="")
    kept_partner = models.BooleanField(
        default=False, help_text="Also a partner: only the patient data was removed"
    )
    source = models.CharField(
        max_length=8,
        choices=[("APP", "The app"), ("WEB", "The website"), ("ADMIN", "An admin")],
        default="APP",
        help_text="Where the request came from (§6.20)",
    )

    class Meta:
        db_table = "account_deletions"
        indexes = [models.Index(fields=["status", "due_at"], name="deletions_status_due_idx")]
        constraints: ClassVar[list[models.BaseConstraint]] = [
            models.UniqueConstraint(
                fields=["user"],
                condition=models.Q(status="PENDING"),
                name="deletions_one_pending_per_user",
            )
        ]

    def __str__(self) -> str:
        return f"AccountDeletion {self.id} ({self.status})"
