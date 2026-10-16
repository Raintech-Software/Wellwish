"""Admin reports (§9.1 Reports, Phase 9.2): bookings, fees collected, cancellations and refunds,
partner performance; on screen and as CSV (formula-safe, every export logged)."""

import csv
import io

import pytest

from apps.audit.models import AuditLog
from apps.bookings.times import IST
from common.dates import today_ist
from common.reports import safe_cell
from conftest import staff_token

pytestmark = pytest.mark.django_db


def _range(booking):
    day = booking.pickup_at.astimezone(IST).date()
    first = min(day, today_ist())
    return f"?from={first.isoformat()}&to={day.isoformat()}", day


def _csv(resp):
    assert resp.status_code == 200
    assert resp["Content-Type"].startswith("text/csv") and resp["Cache-Control"] == "no-store"
    text = resp.content.decode("utf-8")
    assert text.startswith("﻿")  # Excel opens it as UTF-8
    return list(csv.reader(io.StringIO(text[1:])))


def test_bookings_report_by_date_and_service(api, booking, staff_roles):
    query, day = _range(booking)
    ops = staff_token(api, staff_roles, "OPERATIONS")
    report = api.get(f"/admin/reports/bookings{query}", ops).json()
    row = next(d for d in report["days"] if d["date"] == day.isoformat())
    assert (row["booked"], row["open"], row["completed"]) == (1, 1, 0)
    assert report["services"][0]["service"] == "Doctor visit companion"
    assert report["total"]["booked"] == 1
    rows = _csv(api.get(f"/admin/reports/bookings/csv{query}", ops))
    assert rows[0][:2] == ["Date (IST)", "Booked"]
    assert ["Total", "1", "0", "0", "0", "1"] in rows
    assert AuditLog.objects.filter(action="reports.exported", after__report="bookings").exists()
    finance = staff_token(api, staff_roles, "FINANCE")  # no bookings.view
    assert api.get(f"/admin/reports/bookings{query}", finance).status_code == 403
    too_long = api.get("/admin/reports/bookings?from=2025-01-01&to=2026-10-13", ops)
    assert too_long.json()["error"]["code"] == "RANGE_TOO_LONG"


def test_fees_on_screen(api, booking, staff_roles):
    finance = staff_token(api, staff_roles, "FINANCE")
    report = api.get("/admin/reports/fees/days", finance).json()
    assert report["total"]["collectedPaise"] == 10000 and report["total"]["payments"] == 1
    assert report["days"][0]["date"] == today_ist().isoformat()
    ops = staff_token(api, staff_roles, "OPERATIONS")  # no payments.view
    assert api.get("/admin/reports/fees/days", ops).status_code == 403


def test_cancellations_and_refunds(
    api, world, booking, staff_roles, django_capture_on_commit_callbacks
):
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/patient/bookings/{booking.pk}/cancel",
            {"reason": '=HYPERLINK("http://x")'},  # looks like a spreadsheet formula
            world.token,
        )
    assert resp.status_code == 200, resp.json()
    finance = staff_token(api, staff_roles, "FINANCE")
    report = api.get("/admin/reports/cancellations", finance).json()
    assert report["cancelled"] == 1
    row = report["rows"][0]
    assert (row["kind"], row["code"], row["by"], row["refundPercent"]) == (
        "CANCELLED",
        booking.code,
        "PATIENT",
        50,
    )
    assert row["feePaidPaise"] == 10000 and row["refundStatus"] == "PENDING"
    rows = _csv(api.get("/admin/reports/cancellations/csv", finance))
    assert rows[1][0] == "Cancelled" and rows[1][1] == booking.code
    assert rows[1][6] == '\'=HYPERLINK("http://x")'  # shown as text, never run
    assert rows[1][8] == "100.00"  # ₹, a number
    assert AuditLog.objects.filter(
        action="reports.exported", after__report="cancellations"
    ).exists()
    support = staff_token(api, staff_roles, "SUPPORT")  # no payments.view
    assert api.get("/admin/reports/cancellations", support).status_code == 403


def test_partner_performance(api, booking, asha, staff_roles):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    _, asha_id = asha
    api.post(
        f"/admin/bookings/{booking.pk}/assign",
        {"partnerId": asha_id, "expectedAssignmentId": None},
        ops,
    )
    report = api.get("/admin/reports/partners", ops).json()
    row = next(r for r in report["rows"] if r["name"] == "Asha Behera")
    assert (row["offersReceived"], row["offersAccepted"], row["jobs"]) == (1, 0, 0)
    assert row["acceptancePercent"] == 0 and row["role"] == "COMPANION"
    rows = _csv(api.get("/admin/reports/partners/csv", ops))
    assert rows[0][0] == "Partner" and any(r[0] == "Asha Behera" for r in rows[1:])
    assert AuditLog.objects.filter(action="reports.exported", after__report="partners").exists()
    support = staff_token(api, staff_roles, "SUPPORT")  # no partners.view
    assert api.get("/admin/reports/partners", support).status_code == 403


def test_formula_guard_keeps_numbers_as_numbers():
    from decimal import Decimal

    assert safe_cell("=SUM(A1)") == "'=SUM(A1)"
    assert safe_cell("+91 98765 43210") == "'+91 98765 43210"
    assert safe_cell("-50.00") == "'-50.00"  # text that looks like a formula
    assert safe_cell(Decimal("-50.00")) == Decimal("-50.00")  # a number stays a number
    assert safe_cell(3) == 3 and safe_cell("Asha") == "Asha"


def test_a_temporary_assign_is_not_an_offer_in_the_report(api, booking, staff_roles):
    from apps.partners.tests.test_temporary import NEW_PERSON, temp_assign

    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert temp_assign(api, ops, booking.pk).status_code == 200
    rows = api.get("/admin/reports/partners", ops).json()["rows"]
    # the temporary partner (no visit done yet) isn't listed with an unanswered "offer"
    assert not [r for r in rows if r["name"] == "Mamata Sahoo" and r["offersReceived"]]
    assert NEW_PERSON
