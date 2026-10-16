"""Partner verification (ARCHITECTURE §6.3, §9.4, §11): which documents each role needs,
the uploaded documents and the review of the application.

Aadhaar and PAN numbers are stored masked (last 4 characters only). Never the full number.
"""

from django.db import models

from common.models import BaseModel


class NumberRule(models.TextChoices):
    NONE = "NONE", "No number"
    AADHAAR = "AADHAAR", "Aadhaar (12 digits, stored masked)"
    PAN = "PAN", "PAN (10 characters, stored masked)"
    TEXT = "TEXT", "Licence / registration number (stored as typed)"


class RequiredDocument(BaseModel):
    """One row per role and document type. The admin can change the list without an app
    release (§6.3), so labels live here, not in the app."""

    role = models.CharField(max_length=16, help_text="COMPANION / NURSE")
    doc_type = models.CharField(max_length=40, help_text="e.g. AADHAAR, POLICE_VERIFICATION")
    label = models.CharField(max_length=80)
    label_hi = models.CharField(max_length=80, blank=True, default="")
    label_or = models.CharField(max_length=80, blank=True, default="")
    help = models.CharField(max_length=200, blank=True, default="")
    help_hi = models.CharField(max_length=200, blank=True, default="")
    help_or = models.CharField(max_length=200, blank=True, default="")
    mandatory = models.BooleanField(default=True)
    condition = models.CharField(
        max_length=120, blank=True, default="", help_text="When an optional one is needed"
    )
    condition_hi = models.CharField(max_length=120, blank=True, default="")
    condition_or = models.CharField(max_length=120, blank=True, default="")
    has_expiry = models.BooleanField(default=False)
    number_rule = models.CharField(
        max_length=8, choices=NumberRule.choices, default=NumberRule.NONE
    )
    camera_only = models.BooleanField(default=False, help_text="Live selfie: camera, not gallery")
    sort = models.PositiveIntegerField(default=0)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = "required_documents"
        ordering = ("role", "sort", "label")
        constraints = [
            models.UniqueConstraint(fields=["role", "doc_type"], name="required_doc_role_type_uniq")
        ]

    def __str__(self) -> str:
        return f"{self.role} {self.doc_type}"


class PartnerDocument(BaseModel):
    """An uploaded document. A new upload of the same type replaces the current one; the old
    row is kept (is_current=False) for the history."""

    class Status(models.TextChoices):
        PENDING = "PENDING", "Waiting for review"
        APPROVED = "APPROVED", "Approved"
        REJECTED = "REJECTED", "Rejected"
        EXPIRED = "EXPIRED", "Expired"

    partner = models.ForeignKey(
        "partners.PartnerProfile", on_delete=models.CASCADE, related_name="documents"
    )
    doc_type = models.CharField(max_length=40)
    file_key = models.CharField(max_length=255)
    mime = models.CharField(max_length=40, blank=True, default="")
    number_masked = models.CharField(max_length=40, blank=True, default="")
    expires_on = models.DateField(null=True, blank=True)
    status = models.CharField(max_length=16, choices=Status.choices, default=Status.PENDING)
    reject_reason = models.CharField(max_length=300, blank=True, default="")
    reviewed_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )
    reviewed_at = models.DateTimeField(null=True, blank=True)
    is_current = models.BooleanField(default=True)
    expiry_reminded_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "partner_documents"
        constraints = [
            models.UniqueConstraint(
                fields=["partner", "doc_type"],
                condition=models.Q(is_current=True),
                name="partner_document_current_uniq",
            )
        ]
        indexes = [
            models.Index(fields=["status", "expires_on"], name="partner_doc_expiry_idx"),
        ]

    def __str__(self) -> str:
        return f"PartnerDocument {self.doc_type}"


class PartnerApplication(BaseModel):
    """The review of a partner's registration. One row per partner; a re-submission after
    "changes requested" reuses it."""

    class Status(models.TextChoices):
        SUBMITTED = "SUBMITTED", "Submitted"
        UNDER_REVIEW = "UNDER_REVIEW", "Under review"
        CHANGES_REQUESTED = "CHANGES_REQUESTED", "Changes requested"
        APPROVED = "APPROVED", "Approved"
        REJECTED = "REJECTED", "Rejected"

    partner = models.OneToOneField(
        "partners.PartnerProfile", on_delete=models.CASCADE, related_name="application"
    )
    status = models.CharField(max_length=24, choices=Status.choices, default=Status.SUBMITTED)
    submitted_at = models.DateTimeField()
    first_submitted_at = models.DateTimeField()
    claimed_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )
    claimed_until = models.DateTimeField(null=True, blank=True)
    decided_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )
    decided_at = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(blank=True, default="", help_text="Message to the partner")

    class Meta:
        db_table = "partner_applications"
        indexes = [models.Index(fields=["status", "submitted_at"], name="application_queue_idx")]

    def __str__(self) -> str:
        return f"PartnerApplication {self.status}"
