"""Every upload URL handed out (ARCHITECTURE §6.8). Uploads never attached to a form within
24 hours are deleted by the daily cleanup, so abandoned files don't pile up."""

from django.db import models

from common.models import BaseModel


class Upload(BaseModel):
    key = models.CharField(max_length=255, unique=True)
    purpose = models.CharField(max_length=32)
    owner = models.CharField(max_length=64, blank=True, default="", help_text="User or staff id")
    attached_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "uploads"
        indexes = [models.Index(fields=["attached_at", "created_at"], name="uploads_cleanup_idx")]

    def __str__(self) -> str:
        return f"Upload {self.purpose}"
