"""Legal pages (ARCHITECTURE §6.20): every published version of each document is a row, so
it is always clear which text someone accepted."""

from django.db import models

from common.models import BaseModel


class LegalKind(models.TextChoices):
    TERMS = "TERMS", "Terms of Use"
    PRIVACY = "PRIVACY", "Privacy Policy"
    REFUNDS = "REFUNDS", "Refund Policy"
    PARTNER_TERMS = "PARTNER_TERMS", "Partner Terms"


class LegalDocument(BaseModel):
    """One published version. Rows are never changed: a new text is a new version."""

    kind = models.CharField(max_length=16, choices=LegalKind.choices)
    version = models.PositiveIntegerField()
    consent_version = models.CharField(
        max_length=32,
        help_text="What people accept. Changes only when a version asks everyone again.",
    )
    asked_again = models.BooleanField(default=True)
    title_en = models.CharField(max_length=120)
    title_hi = models.CharField(max_length=120, blank=True, default="")
    title_or = models.CharField(max_length=120, blank=True, default="")
    body_en = models.TextField()
    body_hi = models.TextField(blank=True, default="")
    body_or = models.TextField(blank=True, default="")
    published_by = models.ForeignKey(
        "staff.StaffUser",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="+",
        help_text="Empty for the first drafts",
    )
    published_at = models.DateTimeField()

    class Meta:
        db_table = "legal_documents"
        constraints = [
            models.UniqueConstraint(
                fields=["kind", "version"], name="legal_documents_kind_version_uniq"
            )
        ]
        ordering = ["kind", "-version"]

    def __str__(self) -> str:
        return f"{self.kind} v{self.version}"
