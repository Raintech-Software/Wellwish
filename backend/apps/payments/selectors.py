"""Reading payments and refunds."""

import datetime as dt
from collections import defaultdict
from typing import Any

from django.db.models import Q, QuerySet

from apps.bookings.times import IST
from apps.payments.models import GatewayKeys, Payment, PaymentStatus, Refund, RefundStatus
from common.errors import NotFound
from common.ids import uid


def booking_payments(booking_id: str) -> list[Payment]:
    return list(Payment.objects.filter(booking_id=uid(booking_id)).order_by("created_at"))


def booking_refunds(booking_id: str) -> list[Refund]:
    return list(
        Refund.objects.filter(payment__booking_id=uid(booking_id))
        .select_related("requested_by", "approved_by", "payment")
        .order_by("created_at")
    )


def paid_paise(booking_id: str) -> int:
    """The fee that paid for this booking (0 if not paid). A payment the system gave back in full
    (paid twice, too late) doesn't count."""
    payment = (
        Payment.objects.filter(booking_id=uid(booking_id), status=PaymentStatus.CAPTURED)
        .exclude(refunds__requested_by_type="SYSTEM")
        .order_by("captured_at")
        .first()
    )
    return payment.amount_paise if payment else 0


# --- Admin ---


def admin_payments(*, status: str = "", q: str = "") -> QuerySet[Payment]:
    rows = Payment.objects.select_related("booking").order_by("-created_at")
    if status:
        rows = rows.filter(status=status)
    q = q.strip()
    if q:
        code = q.upper() if q.upper().startswith("WW-") else f"WW-{q}"
        rows = rows.filter(
            Q(booking__code=code) | Q(razorpay_order_id=q) | Q(razorpay_payment_id=q)
        )
    return rows


def admin_refunds(*, status: str = "") -> QuerySet[Refund]:
    rows = Refund.objects.select_related(
        "payment__booking", "requested_by", "approved_by"
    ).order_by("-created_at")
    return rows.filter(status=status) if status else rows


def get_refund(refund_id: str) -> Refund:
    refund = admin_refunds().filter(pk=uid(refund_id)).first()
    if refund is None:
        raise NotFound()
    return refund


def fee_report(start: dt.date, end: dt.date) -> list[dict[str, Any]]:
    """Booking fees per India date: payments captured, fees collected, refunds processed, net
    (paise). `end` included."""
    since = dt.datetime.combine(start, dt.time(0, 0), tzinfo=IST)
    until = dt.datetime.combine(end + dt.timedelta(days=1), dt.time(0, 0), tzinfo=IST)
    days: dict[dt.date, dict[str, int]] = defaultdict(
        lambda: {"payments": 0, "collected": 0, "refunded": 0}
    )
    for captured_at, amount in Payment.objects.filter(
        status=PaymentStatus.CAPTURED, captured_at__gte=since, captured_at__lt=until
    ).values_list("captured_at", "amount_paise"):
        if captured_at is None:
            continue
        day = days[captured_at.astimezone(IST).date()]
        day["payments"] += 1
        day["collected"] += amount
    for processed_at, amount in Refund.objects.filter(
        status=RefundStatus.PROCESSED, processed_at__gte=since, processed_at__lt=until
    ).values_list("processed_at", "amount_paise"):
        if processed_at is not None:
            days[processed_at.astimezone(IST).date()]["refunded"] += amount
    return [
        {"date": day, **values, "net": values["collected"] - values["refunded"]}
        for day, values in sorted(days.items())
    ]


def gateway_keys() -> GatewayKeys | None:
    return GatewayKeys.objects.select_related("updated_by").first()


# --- Reports (Phase 9.2) ---


def cancellations_report(start: dt.date, end: dt.date) -> list[dict[str, Any]]:
    """Cancellations and refunds report: each booking cancelled on these India dates (who, why,
    the refund %), then each refund asked for another booking (after a visit, through support),
    with the fee paid and what was refunded (paise). `end` included."""
    from apps.bookings import selectors as bookings

    since = dt.datetime.combine(start, dt.time(0, 0), tzinfo=IST)
    until = dt.datetime.combine(end + dt.timedelta(days=1), dt.time(0, 0), tzinfo=IST)

    def money(booking_id: Any) -> dict[str, Any]:
        paid = sum(
            Payment.objects.filter(
                booking_id=booking_id, status=PaymentStatus.CAPTURED
            ).values_list("amount_paise", flat=True)
        )
        refunds = list(Refund.objects.filter(payment__booking_id=booking_id).order_by("created_at"))
        refunded = sum(r.amount_paise for r in refunds if r.status == RefundStatus.PROCESSED)
        return {
            "fee_paid_paise": paid,
            "refunded_paise": refunded,
            "refund_status": refunds[-1].status if refunds else "",
        }

    rows: list[dict[str, Any]] = []
    cancelled = bookings.cancelled_between(start, end)
    for booking, at in cancelled:
        rows.append(
            {
                "kind": "CANCELLED",
                "booking_id": str(booking.pk),
                "code": booking.code,
                "visit_date": booking.pickup_at.astimezone(IST).date(),
                "service": str(booking.price_snapshot.get("name", "")),
                "at": at,
                "by": booking.cancelled_by,
                "reason": booking.cancel_reason,
                "refund_percent": booking.refund_percent,
                **money(booking.pk),
            }
        )
    done = {booking.pk for booking, _ in cancelled}
    after = (
        Refund.objects.filter(created_at__gte=since, created_at__lt=until)
        .exclude(payment__booking_id__in=done)
        .exclude(payment__booking__status="CANCELLED")
        .select_related("payment__booking")
        .order_by("created_at")
    )
    for refund in after:
        booking = refund.payment.booking
        rows.append(
            {
                "kind": "REFUND",
                "booking_id": str(booking.pk),
                "code": booking.code,
                "visit_date": booking.pickup_at.astimezone(IST).date(),
                "service": str(booking.price_snapshot.get("name", "")),
                "at": refund.created_at,
                "by": refund.requested_by_type,
                "reason": refund.reason,
                "refund_percent": refund.percent,
                "fee_paid_paise": refund.payment.amount_paise,
                "refunded_paise": refund.amount_paise
                if refund.status == RefundStatus.PROCESSED
                else 0,
                "refund_status": refund.status,
            }
        )
    return rows
