"""Audit log page: list with filters, CSV export (§9.1 "Audit log": read-only, export)."""

import csv
import io
from datetime import UTC, datetime

import pytest

from apps.audit.models import AuditLog
from apps.audit.services import record
from conftest import make_staff, staff_login

pytestmark = pytest.mark.django_db


@pytest.fixture
def boss(api, staff_roles):
    return staff_login(api, make_staff(staff_roles, email="boss@wellwish.test"))


def test_list_is_newest_first_and_paginated(api, boss):
    for i in range(25):
        record(boss.staff, "service.updated", ("services.service", f"s{i}"))
    resp = api.get("/admin/audit-log?pageSize=10", boss.access_token)
    assert resp.status_code == 200, resp.json()
    body = resp.json()
    assert body["count"] == AuditLog.objects.count()
    assert len(body["items"]) == 10
    first = body["items"][0]
    assert first["entityId"] == "s24"
    assert first["staff"] == {"id": str(boss.staff.pk), "name": "Test Admin"}
    page3 = api.get("/admin/audit-log?pageSize=10&page=3", boss.access_token).json()
    assert len(page3["items"]) == body["count"] - 20


def test_filters(api, boss):
    record(boss.staff, "service.price_changed", ("services.service", "s1"), before={"a": 1})
    record(None, "hospital.updated", ("hospitals.hospital", "h1"))
    token = boss.access_token
    by_action = api.get("/admin/audit-log?action=service.", token).json()
    assert [e["action"] for e in by_action["items"]] == ["service.price_changed"]
    by_entity = api.get("/admin/audit-log?entityType=hospitals.hospital&entityId=h1", token)
    item = by_entity.json()["items"][0]
    assert item["staff"] is None  # the system
    by_staff = api.get(f"/admin/audit-log?staffId={boss.staff.pk}", token).json()
    assert all(e["staff"]["id"] == str(boss.staff.pk) for e in by_staff["items"])
    filters = api.get("/admin/audit-log/filters", token).json()
    assert "service.price_changed" in filters["actions"]
    assert "hospitals.hospital" in filters["entityTypes"]


def test_date_filter_uses_india_time(api, boss):
    # 20:00 UTC on 1 Nov = 01:30 IST on 2 Nov
    AuditLog.objects.create(
        action="late.night", entity_type="x", at=datetime(2026, 11, 1, 20, 0, tzinfo=UTC)
    )
    token = boss.access_token
    nov2 = api.get("/admin/audit-log?action=late.&from=2026-11-02&to=2026-11-02", token).json()
    assert nov2["count"] == 1
    nov1 = api.get("/admin/audit-log?action=late.&from=2026-11-01&to=2026-11-01", token).json()
    assert nov1["count"] == 0


def test_csv_export_is_safe_for_spreadsheets_and_logged(api, boss):
    record(boss.staff, "service.updated", ("services.service", "s1"), reason="=HYPERLINK(1)")
    resp = api.get("/admin/audit-log/export?action=service.", boss.access_token)
    assert resp.status_code == 200
    assert resp["Content-Type"].startswith("text/csv")
    assert resp["Content-Disposition"].startswith('attachment; filename="wellwish-audit-')
    text = resp.content.decode("utf-8-sig")
    rows = list(csv.reader(io.StringIO(text)))
    assert rows[0][0] == "At (IST)"
    assert rows[1][2] == "service.updated"
    assert rows[1][7] == "'=HYPERLINK(1)"  # not run as a formula
    exported = AuditLog.objects.get(action="audit.exported")
    assert exported.after == {"rows": 1, "action": "service."}


def test_only_audit_view(api, staff_roles):
    ops = staff_login(api, make_staff(staff_roles, "OPERATIONS")).access_token
    assert api.get("/admin/audit-log", ops).status_code == 403
    assert api.get("/admin/audit-log/export", ops).status_code == 403
