"""Admin: payments, refunds (Finance approval), the fee report and the Razorpay keys (§9.1
Payments, §9.5). Permissions from §9.2: payments.view, refunds.request, refunds.approve,
settings.manage (the keys)."""

import datetime as dt
from typing import Literal
from uuid import UUID

from django.http import HttpRequest, HttpResponse
from ninja import Query, Router
from ninja.pagination import paginate

from apps.audit.services import record
from apps.bookings.times import IST
from apps.payments import gateway as gw
from apps.payments import selectors, services
from apps.payments.models import Payment, Refund
from apps.payments.schemas import (
    AdminPaymentOut,
    AdminRefundOut,
    CancellationRowOut,
    CancellationsReportOut,
    FeeDayOut,
    FeeReportOut,
    GatewayKeysIn,
    GatewayKeysOut,
    RefundDecisionIn,
)
from apps.staff.selectors import acting_staff
from common import crypto
from common.auth import staff_permission
from common.errors import ApiError
from common.pagination import Mapped, WWPagination
from common.reports import CSV_OPENAPI, csv_response, report_range, rupees
from common.request import client_ip

router = Router(tags=["admin"])

PaymentStatusIn = Literal["CREATED", "AUTHORIZED", "CAPTURED", "FAILED"]
RefundStatusIn = Literal["AWAITING_APPROVAL", "PENDING", "PROCESSED", "FAILED", "REJECTED"]


def payment_out(p: Payment) -> AdminPaymentOut:
    return AdminPaymentOut(
        id=str(p.pk),
        booking_id=str(p.booking_id),
        booking_code=p.booking.code,
        amount_paise=p.amount_paise,
        status=p.status,
        method=p.method,
        mode=p.mode,
        razorpay_order_id=p.razorpay_order_id,
        razorpay_payment_id=p.razorpay_payment_id,
        created_at=p.created_at,
        captured_at=p.captured_at,
        failure_reason=p.failure_reason,
    )


def refund_out(r: Refund) -> AdminRefundOut:
    return AdminRefundOut(
        id=str(r.pk),
        booking_id=str(r.payment.booking_id),
        booking_code=r.payment.booking.code,
        amount_paise=r.amount_paise,
        percent=r.percent,
        reason=r.reason,
        status=r.status,
        razorpay_refund_id=r.razorpay_refund_id,
        requested_by_type=r.requested_by_type,
        requested_by_name=r.requested_by.name if r.requested_by else "",
        approved_by_name=r.approved_by.name if r.approved_by else "",
        created_at=r.created_at,
        decided_at=r.decided_at,
        processed_at=r.processed_at,
        failure_reason=r.failure_reason,
    )


@router.get(
    "/payments", response=list[AdminPaymentOut], by_alias=True, operation_id="adminPaymentList"
)
@staff_permission("payments.view")
@paginate(WWPagination)
def list_payments(
    request: HttpRequest,
    status: PaymentStatusIn | None = None,
    q: str = Query("", max_length=64),
) -> list[AdminPaymentOut]:
    """Booking-fee payments, newest first. `q`: booking code, Razorpay order or payment id."""
    return Mapped(selectors.admin_payments(status=status or "", q=q), payment_out)  # type: ignore[return-value]


@router.get(
    "/refunds", response=list[AdminRefundOut], by_alias=True, operation_id="adminRefundList"
)
@staff_permission("refunds.request")
@paginate(WWPagination)
def list_refunds(
    request: HttpRequest, status: RefundStatusIn | None = None
) -> list[AdminRefundOut]:
    """Refunds, newest first. AWAITING_APPROVAL: above the limit, waiting for Finance."""
    return Mapped(selectors.admin_refunds(status=status or ""), refund_out)  # type: ignore[return-value]


@router.post(
    "/refunds/{uuid:refund_id}/approve",
    response=AdminRefundOut,
    by_alias=True,
    operation_id="adminRefundApprove",
)
@staff_permission("refunds.approve")
def approve_refund(request: HttpRequest, refund_id: UUID, data: RefundDecisionIn) -> AdminRefundOut:
    """Finance approves a refund above the limit: it is sent to Razorpay (logged)."""
    services.decide_refund(
        actor=acting_staff(request),
        refund_id=str(refund_id),
        approve=True,
        reason=data.reason,
        ip=client_ip(request),
    )
    return refund_out(selectors.get_refund(str(refund_id)))


@router.post(
    "/refunds/{uuid:refund_id}/reject",
    response=AdminRefundOut,
    by_alias=True,
    operation_id="adminRefundReject",
)
@staff_permission("refunds.approve")
def reject_refund(request: HttpRequest, refund_id: UUID, data: RefundDecisionIn) -> AdminRefundOut:
    """Finance refuses a refund above the limit, with a reason (logged)."""
    services.decide_refund(
        actor=acting_staff(request),
        refund_id=str(refund_id),
        approve=False,
        reason=data.reason,
        ip=client_ip(request),
    )
    return refund_out(selectors.get_refund(str(refund_id)))


@router.post(
    "/refunds/{uuid:refund_id}/retry",
    response=AdminRefundOut,
    by_alias=True,
    operation_id="adminRefundRetry",
)
@staff_permission("refunds.approve")
def retry_refund(request: HttpRequest, refund_id: UUID, data: RefundDecisionIn) -> AdminRefundOut:
    """A refund Razorpay refused or failed: send it again, with a note (logged)."""
    services.retry_refund(
        actor=acting_staff(request),
        refund_id=str(refund_id),
        reason=data.reason,
        ip=client_ip(request),
    )
    return refund_out(selectors.get_refund(str(refund_id)))


@router.get(
    "/reports/fees",
    operation_id="adminFeeReport",
    openapi_extra={
        "responses": {
            200: {
                "description": "CSV file",
                "content": {"text/csv": {"schema": {"type": "string"}}},
            }
        }
    },
)
@staff_permission("payments.view")
def fee_report(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> HttpResponse:
    """CSV of booking fees per India date: payments, collected, refunded, net (in ₹). Default:
    this month so far. Logged."""
    start, end = report_range(start, end)
    rows = selectors.fee_report(start, end)
    totals = {k: sum(r[k] for r in rows) for k in ("payments", "collected", "refunded", "net")}
    lines = [
        [
            row["date"].isoformat(),
            row["payments"],
            rupees(row["collected"]),
            rupees(row["refunded"]),
            rupees(row["net"]),
        ]
        for row in rows
    ]
    lines.append(
        [
            "Total",
            totals["payments"],
            rupees(totals["collected"]),
            rupees(totals["refunded"]),
            rupees(totals["net"]),
        ]
    )
    record(
        acting_staff(request),
        "payments.report_exported",
        ("payments.payment", ""),
        after={"from": start.isoformat(), "to": end.isoformat(), "days": len(rows)},
        ip=client_ip(request),
    )
    return csv_response(
        f"wellwish-fees-{start}-to-{end}.csv",
        ["Date (IST)", "Payments", "Fees collected (₹)", "Refunded (₹)", "Net (₹)"],
        lines,
    )


@router.get(
    "/reports/fees/days",
    response=FeeReportOut,
    by_alias=True,
    operation_id="adminFeeReportDays",
)
@staff_permission("payments.view")
def fee_report_days(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> FeeReportOut:
    """The fee report on screen (9.2): the same days as the CSV, in paise. Not logged (no file
    leaves the panel)."""
    start, end = report_range(start, end)
    rows = selectors.fee_report(start, end)
    days = [
        FeeDayOut(
            date=row["date"],
            payments=row["payments"],
            collected_paise=row["collected"],
            refunded_paise=row["refunded"],
            net_paise=row["net"],
        )
        for row in rows
    ]
    return FeeReportOut(
        start=start,
        end=end,
        days=days,
        total=FeeDayOut(
            date=None,
            payments=sum(d.payments for d in days),
            collected_paise=sum(d.collected_paise for d in days),
            refunded_paise=sum(d.refunded_paise for d in days),
            net_paise=sum(d.net_paise for d in days),
        ),
    )


def _last4(encrypted: str) -> str:
    return crypto.decrypt(encrypted)[-4:] if encrypted else ""


def keys_out() -> GatewayKeysOut:
    row = selectors.gateway_keys()
    if row and row.key_id and row.key_secret_enc:
        return GatewayKeysOut(
            source="ADMIN",
            key_id=row.key_id,
            mode=gw.keys().mode,
            key_secret_set=True,
            key_secret_last4=_last4(row.key_secret_enc),
            webhook_secret_set=bool(row.webhook_secret_enc),
            webhook_secret_last4=_last4(row.webhook_secret_enc),
            webhook_path="/v1/webhooks/razorpay",
            updated_at=row.updated_at,
            updated_by=row.updated_by.name if row.updated_by else "",
        )
    env = gw.keys()
    return GatewayKeysOut(
        source="ENVIRONMENT" if env.key_id and env.key_secret else "NONE",
        key_id=env.key_id,
        mode=env.mode,
        key_secret_set=bool(env.key_secret),
        key_secret_last4=env.key_secret[-4:] if env.key_secret else "",
        webhook_secret_set=bool(env.webhook_secret),
        webhook_secret_last4=env.webhook_secret[-4:] if env.webhook_secret else "",
        webhook_path="/v1/webhooks/razorpay",
        updated_at=None,
        updated_by="",
    )


@router.get(
    "/payment-keys", response=GatewayKeysOut, by_alias=True, operation_id="adminPaymentKeysGet"
)
@staff_permission("settings.manage")
def get_keys(request: HttpRequest) -> GatewayKeysOut:
    """Which Razorpay keys are in use (secrets never shown, only their last 4 characters)."""
    return keys_out()


class SecretRequired(ApiError):
    status = 422
    code = "SECRET_REQUIRED"
    message = "Enter the key secret too."


@router.put(
    "/payment-keys", response=GatewayKeysOut, by_alias=True, operation_id="adminPaymentKeysSave"
)
@staff_permission("settings.manage")
def save_keys(request: HttpRequest, data: GatewayKeysIn) -> GatewayKeysOut:
    """Save the Razorpay key id and secrets (stored encrypted; blank secret = keep the saved one;
    a new key id needs its secret). Logged without the values."""
    current = selectors.gateway_keys()
    if not data.key_secret and (
        current is None or not current.key_secret_enc or current.key_id != data.key_id
    ):
        raise SecretRequired(details={"field": "keySecret"})
    services.save_keys(
        actor=acting_staff(request),
        key_id=data.key_id,
        key_secret=data.key_secret,
        webhook_secret=data.webhook_secret,
        ip=client_ip(request),
    )
    return keys_out()


# --- Cancellations and refunds report (Phase 9.2, §9.1 Reports) ---


def _cancellations(start: dt.date, end: dt.date) -> CancellationsReportOut:
    rows = [CancellationRowOut(**row) for row in selectors.cancellations_report(start, end)]
    return CancellationsReportOut(
        start=start,
        end=end,
        rows=rows,
        cancelled=sum(1 for r in rows if r.kind == "CANCELLED"),
        refunded_paise=sum(r.refunded_paise for r in rows),
    )


@router.get(
    "/reports/cancellations",
    response=CancellationsReportOut,
    by_alias=True,
    operation_id="adminCancellationsReport",
)
@staff_permission("payments.view")
def cancellations_report(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> CancellationsReportOut:
    """Bookings cancelled on these dates (who, why, the refund %) and refunds asked for other
    bookings, with the fee paid and what was refunded. Default: this month so far."""
    return _cancellations(*report_range(start, end))


@router.get(
    "/reports/cancellations/csv",
    operation_id="adminCancellationsReportCsv",
    openapi_extra=CSV_OPENAPI,
)
@staff_permission("payments.view")
def cancellations_report_csv(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> HttpResponse:
    """The cancellations and refunds report as a CSV file. Logged."""
    report = _cancellations(*report_range(start, end))
    lines = [
        [
            "Cancelled" if r.kind == "CANCELLED" else "Refund after the visit",
            r.code,
            r.visit_date.isoformat(),
            r.service,
            r.at.astimezone(IST).strftime("%Y-%m-%d %H:%M"),
            r.by,
            r.reason,
            "" if r.refund_percent is None else r.refund_percent,
            rupees(r.fee_paid_paise),
            rupees(r.refunded_paise),
            r.refund_status,
        ]
        for r in report.rows
    ]
    record(
        acting_staff(request),
        "reports.exported",
        ("payments.refund", ""),
        after={
            "report": "cancellations",
            "from": report.start.isoformat(),
            "to": report.end.isoformat(),
        },
        ip=client_ip(request),
    )
    return csv_response(
        f"wellwish-cancellations-{report.start}-to-{report.end}.csv",
        [
            "Type",
            "Booking",
            "Visit date",
            "Service",
            "When (IST)",
            "By",
            "Reason",
            "Refund %",
            "Fee paid (₹)",
            "Refunded (₹)",
            "Refund status",
        ],
        lines,
    )
