"""Patient medical documents (ARCHITECTURE §6.8, §11): uploaded once, filed under a family
member, reused in bookings. Titles can be medical text: never log them."""

import datetime as dt

from django.conf import settings
from django.db import models

from apps.patients.models import Member
from common.models import BaseModel


class PatientDocument(BaseModel):
    class Type(models.TextChoices):
        PRESCRIPTION = "PRESCRIPTION", "Prescription"
        LAB_REPORT = "LAB_REPORT", "Lab report"
        SCAN = "SCAN", "X-ray / scan"
        DISCHARGE = "DISCHARGE", "Discharge summary"
        ID = "ID", "ID"
        OTHER = "OTHER", "Other"
        CARE_NOTE = "CARE_NOTE", "Care note"  # written by the nurse at "Care done" (§6.11)

    # The "Reports" tab in the app (mockup 7).
    REPORT_TYPES = (Type.LAB_REPORT, Type.SCAN, Type.DISCHARGE)

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="patient_documents"
    )
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name="documents")
    type = models.CharField(max_length=16, choices=Type.choices)
    title = models.CharField(max_length=80)
    doc_date = models.DateField(null=True, blank=True)
    file_key = models.CharField(
        max_length=255, unique=True, null=True, blank=True, help_text="Empty for a care note"
    )
    text = models.TextField(blank=True, default="", help_text="A care note's text")
    vitals = models.JSONField(null=True, blank=True, help_text="A care note's BP, pulse...")
    mime = models.CharField(max_length=40)
    size_bytes = models.PositiveIntegerField()
    uploaded_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="+",
    )
    deleted_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "patient_documents"
        indexes = [
            models.Index(fields=["owner", "deleted_at"], name="pdocs_owner_deleted_idx"),
            models.Index(fields=["member", "type"], name="pdocs_member_type_idx"),
        ]

    def __str__(self) -> str:
        return f"PatientDocument {self.id} ({self.type})"

    @property
    def date(self) -> "dt.date | None":
        return self.doc_date

    @property
    def member_name(self) -> str:
        return self.member.full_name
