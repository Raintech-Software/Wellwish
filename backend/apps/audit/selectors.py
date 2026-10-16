"""Read queries for the audit log page (§9.1): filter, list and export."""

import uuid
from dataclasses import dataclass
from datetime import date, datetime, time, timedelta
from zoneinfo import ZoneInfo

from django.conf import settings
from django.db.models import QuerySet

from apps.audit.models import AuditLog


@dataclass(frozen=True)
class AuditFilter:
    staff_id: str | None = None
    action: str = ""
    entity_type: str = ""
    entity_id: str = ""
    from_date: date | None = None
    to_date: date | None = None


def _day_start(day: date) -> datetime:
    """Midnight in India time (the admin picks dates in IST)."""
    return datetime.combine(day, time.min, tzinfo=ZoneInfo(settings.DISPLAY_TIME_ZONE))


def last_status_change(entity_type: str, entity_id: str, status: str) -> datetime | None:
    """When the entity last became `status` (its `*.status_changed` rows), or None."""
    return (
        AuditLog.objects.filter(entity_type=entity_type, entity_id=entity_id, after__status=status)
        .order_by("-at")
        .values_list("at", flat=True)
        .first()
    )


def entity_history(entity_type: str, entity_id: str, limit: int = 100) -> list[AuditLog]:
    """What happened to one record, newest first (e.g. a partner's status history)."""
    return list(
        AuditLog.objects.select_related("staff")
        .filter(entity_type=entity_type, entity_id=entity_id)
        .order_by("-at")[:limit]
    )


def audit_entries(f: AuditFilter) -> QuerySet[AuditLog]:
    """Newest first. `action` matches the start ("staff." = every staff action)."""
    qs = AuditLog.objects.select_related("staff").order_by("-at", "-id")
    if f.staff_id:
        qs = qs.filter(staff_id=uuid.UUID(f.staff_id))
    if f.action:
        qs = qs.filter(action__startswith=f.action)
    if f.entity_type:
        qs = qs.filter(entity_type=f.entity_type)
    if f.entity_id:
        qs = qs.filter(entity_id=f.entity_id)
    if f.from_date:
        qs = qs.filter(at__gte=_day_start(f.from_date))
    if f.to_date:
        qs = qs.filter(at__lt=_day_start(f.to_date + timedelta(days=1)))
    return qs


def filter_choices() -> tuple[list[str], list[str], list[tuple[str, str]]]:
    """Actions, entity types and staff (id, name) that appear in the log, for the filter menus."""
    from apps.staff.models import StaffUser

    actions = sorted(set(AuditLog.objects.values_list("action", flat=True).distinct()))
    entity_types = sorted(set(AuditLog.objects.values_list("entity_type", flat=True).distinct()))
    staff = [
        (str(pk), name) for pk, name in StaffUser.objects.order_by("name").values_list("pk", "name")
    ]
    return actions, entity_types, staff
