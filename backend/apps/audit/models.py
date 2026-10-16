"""The audit log (ARCHITECTURE §9.1, §11, §12): every admin action. Nobody can change it.

Rows can only be added. `save()` refuses updates, `delete()` refuses deletes, and a database
trigger (migration 0002) blocks UPDATE and DELETE even from raw SQL.
"""

import uuid
from typing import Any

from django.db import models
from django.utils import timezone


class AuditLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    staff = models.ForeignKey(
        "staff.StaffUser",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="+",
        help_text="Who did it. Empty = the system.",
    )
    action = models.CharField(max_length=64)
    entity_type = models.CharField(max_length=64)
    entity_id = models.CharField(max_length=64, blank=True, default="")
    before = models.JSONField(null=True, blank=True)
    after = models.JSONField(null=True, blank=True)
    reason = models.TextField(blank=True, default="")
    ip = models.GenericIPAddressField(null=True, blank=True)
    at = models.DateTimeField(default=timezone.now, db_index=True)

    class Meta:
        db_table = "audit_log"
        ordering = ("-at",)
        indexes = [models.Index(fields=["entity_type", "entity_id"], name="audit_entity_idx")]

    def __str__(self) -> str:
        return f"{self.action} {self.entity_type}:{self.entity_id}"

    def save(self, *args: Any, **kwargs: Any) -> None:
        if not self._state.adding:
            raise RuntimeError("The audit log can't be changed.")
        super().save(*args, **kwargs)

    def delete(self, *args: Any, **kwargs: Any) -> tuple[int, dict[str, int]]:
        raise RuntimeError("The audit log can't be deleted.")
