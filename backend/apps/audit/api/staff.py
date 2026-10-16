"""Admin: the audit log page (/v1/admin/audit-log, §9.1). Read-only; needs audit.view."""

import json
from datetime import date
from uuid import UUID
from zoneinfo import ZoneInfo

from django.conf import settings
from django.db.models import QuerySet
from django.http import HttpRequest, HttpResponse
from django.utils import timezone
from ninja import Query, Router, Schema
from ninja.pagination import paginate
from pydantic import Field

from apps.audit.models import AuditLog
from apps.audit.schemas import AuditEntryOut, AuditFiltersOut, AuditStaffOut
from apps.audit.selectors import AuditFilter, audit_entries, filter_choices
from apps.audit.services import record
from apps.staff.selectors import acting_staff
from common.auth import staff_permission
from common.pagination import WWPagination
from common.reports import csv_response
from common.request import client_ip

router = Router(tags=["admin"])

EXPORT_MAX_ROWS = 10_000


class AuditQuery(Schema):
    staff_id: UUID | None = Field(None, alias="staffId")
    action: str = Field("", max_length=64, description="Starts with, e.g. `service.`")
    entity_type: str = Field("", max_length=64, alias="entityType")
    entity_id: str = Field("", max_length=64, alias="entityId")
    from_date: date | None = Field(None, alias="from", description="IST date, inclusive")
    to_date: date | None = Field(None, alias="to", description="IST date, inclusive")

    def to_filter(self) -> AuditFilter:
        return AuditFilter(
            staff_id=str(self.staff_id) if self.staff_id else None,
            action=self.action.strip(),
            entity_type=self.entity_type.strip(),
            entity_id=self.entity_id.strip(),
            from_date=self.from_date,
            to_date=self.to_date,
        )


@router.get(
    "/audit-log", response=list[AuditEntryOut], by_alias=True, operation_id="adminAuditLogList"
)
@staff_permission("audit.view")
@paginate(WWPagination)
def list_audit_log(request: HttpRequest, filters: Query[AuditQuery]) -> QuerySet[AuditLog]:
    """Newest first, 20 a page."""
    return audit_entries(filters.to_filter())


@router.get(
    "/audit-log/filters",
    response=AuditFiltersOut,
    by_alias=True,
    operation_id="adminAuditLogFilters",
)
@staff_permission("audit.view")
def audit_filters(request: HttpRequest) -> AuditFiltersOut:
    actions, entity_types, staff = filter_choices()
    return AuditFiltersOut(
        actions=actions,
        entity_types=entity_types,
        staff=[AuditStaffOut(id=i, name=n) for i, n in staff],
    )


def _text(value: object) -> str:
    """One cell's text (the before / after details as JSON). `csv_response` keeps a cell that
    starts like a formula from running in a spreadsheet (§12)."""
    if value is None:
        return ""
    return value if isinstance(value, str) else json.dumps(value, ensure_ascii=False)


@router.get(
    "/audit-log/export",
    operation_id="adminAuditLogExport",
    openapi_extra={
        "responses": {
            200: {
                "description": "CSV file",
                "content": {"text/csv": {"schema": {"type": "string"}}},
            }
        }
    },
)
@staff_permission("audit.view")
def export_audit_log(request: HttpRequest, filters: Query[AuditQuery]) -> HttpResponse:
    """CSV of the filtered log (newest first, at most 10,000 rows). The export is logged too."""
    rows = list(audit_entries(filters.to_filter())[:EXPORT_MAX_ROWS])
    shown_tz = ZoneInfo(settings.DISPLAY_TIME_ZONE)
    lines = [
        [
            e.at.astimezone(shown_tz).strftime("%Y-%m-%d %H:%M:%S"),
            e.staff.name if e.staff else "System",
            e.action,
            e.entity_type,
            e.entity_id,
            _text(e.before),
            _text(e.after),
            _text(e.reason),
            _text(e.ip),
        ]
        for e in rows
    ]
    record(
        acting_staff(request),
        "audit.exported",
        ("audit.auditlog", ""),
        after={
            "rows": len(rows),
            **{k: str(v) for k, v in filters.model_dump(by_alias=True).items() if v},
        },
        ip=client_ip(request),
    )
    stamp = timezone.now().strftime("%Y%m%d-%H%M")
    return csv_response(
        f"wellwish-audit-{stamp}.csv",
        [
            "At (IST)",
            "Staff",
            "Action",
            "Entity type",
            "Entity id",
            "Before",
            "After",
            "Reason",
            "IP",
        ],
        lines,
    )
