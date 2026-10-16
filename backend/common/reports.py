"""Admin reports and their CSV files (§9.1 Reports, §12 "CSV exports").

- A date range in India dates, at most `REPORT_MAX_DAYS` long; this month so far by default.
- CSV files open straight in Excel (UTF-8 with a byte-order mark), are never cached, and a text
  cell a spreadsheet would run as a formula (it starts with `=`, `+`, `-`, `@`, a tab or a line
  break) starts with an apostrophe. Numbers stay numbers. Every export is audit-logged by the
  endpoint that makes it.
"""

import csv
import datetime as dt
import io
from collections.abc import Iterable, Sequence
from decimal import Decimal

from django.http import HttpResponse

from common.dates import today_ist
from common.errors import ApiError

REPORT_MAX_DAYS = 366
FORMULA_START = ("=", "+", "-", "@", "\t", "\r")


class ReportRangeTooLong(ApiError):
    status = 422
    code = "RANGE_TOO_LONG"
    message = f"Pick at most {REPORT_MAX_DAYS} days."


def report_range(start: dt.date | None, end: dt.date | None) -> tuple[dt.date, dt.date]:
    """`from`/`to` of a report (both included): this month so far when left out."""
    end = end or today_ist()
    start = start or end.replace(day=1)
    if start > end or (end - start).days >= REPORT_MAX_DAYS:
        raise ReportRangeTooLong()
    return start, end


def rupees(paise: int) -> Decimal:
    """Paise → ₹ with two decimals, as a number (never a float)."""
    return (Decimal(paise) / 100).quantize(Decimal("0.01"))


def safe_cell(value: object) -> object:
    """A text cell that would start a formula gets a leading apostrophe; others as they are."""
    if isinstance(value, str) and value.startswith(FORMULA_START):
        return "'" + value
    return value


def csv_response(
    filename: str, header: Sequence[str], rows: Iterable[Sequence[object]]
) -> HttpResponse:
    out = io.StringIO()
    writer = csv.writer(out)
    writer.writerow(header)
    for row in rows:
        writer.writerow([safe_cell(cell) for cell in row])
    response = HttpResponse("﻿" + out.getvalue(), content_type="text/csv; charset=utf-8")
    response["Content-Disposition"] = f'attachment; filename="{filename}"'
    response["Cache-Control"] = "no-store"
    return response


# `openapi_extra` of an endpoint that answers a CSV file
CSV_OPENAPI = {
    "responses": {
        200: {"description": "CSV file", "content": {"text/csv": {"schema": {"type": "string"}}}}
    }
}
