"""Schemas for the audit log page."""

from datetime import datetime
from typing import Any

from pydantic import Field

from common.schemas import CamelSchema


class AuditStaffOut(CamelSchema):
    id: str
    name: str


class AuditEntryOut(CamelSchema):
    id: str
    at: datetime
    staff: AuditStaffOut | None = Field(None, description="Empty = the system")
    action: str
    entity_type: str
    entity_id: str
    before: dict[str, Any] | None
    after: dict[str, Any] | None
    reason: str
    ip: str | None

    # Read straight from AuditLog rows (the list is paginated as a queryset).
    @staticmethod
    def resolve_id(obj: Any) -> str:
        return str(obj.pk)

    @staticmethod
    def resolve_staff(obj: Any) -> dict[str, str] | None:
        if isinstance(obj, dict):
            return obj.get("staff")
        return {"id": str(obj.staff.pk), "name": obj.staff.name} if obj.staff_id else None


class AuditFiltersOut(CamelSchema):
    actions: list[str]
    entity_types: list[str]
    staff: list[AuditStaffOut]
