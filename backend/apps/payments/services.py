"""Booking-fee payments, refunds and the Razorpay webhook (ARCHITECTURE §6.12, §9.5).

Paying:
1. `checkout`: a Razorpay order for the fee (amount from the booking's snapshot only).
2. The app opens Razorpay Checkout, then `verify` with the signature it got back: the signature is
   checked and Razorpay is asked whether the money was captured. The app shows "processing".
3. `handle_webhook` (`payment.captured`): the money is captured, the booking becomes NEW.
   `reconcile` (every 10 min) asks Razorpay about payments we didn't hear back about.
A payment that arrives too late (booking expired or cancelled, or its place was taken) is
refunded in full.

Refunds: cancelling refunds a share of the fee (`booking.cancelled` event). Refunds above the
setting `refund_approval_above_paise` (₹500) wait for Finance (`refunds.approve`).
"""

import datetime as dt
import json
import logging
from dataclasses import dataclass
from typing import Any

from django.db import IntegrityError, transaction
from django.utils import timezone

from apps.app_config.selectors import get_setting
from apps.audit.services import record
from apps.bookings import services as bookings
from apps.bookings.models import Booking, BookingStatus
from apps.payments import gateway as gw
from apps.payments.models import (
    GatewayKeys,
    Payment,
    PaymentStatus,
    Refund,
    RefundStatus,
    RequestedBy,
    WebhookEvent,
)
from apps.staff.models import StaffUser
from common import crypto, events
from common.errors import ApiError, Conflict, NotFound
from common.ids import uid
from common.money import percent_of

logger = logging.getLogger(__name__)


# --- Keys (Settings → Payments, Super Admin) ---


def save_keys(
    *, actor: StaffUser, key_id: str, key_secret: str, webhook_secret: str, ip: str | None
) -> GatewayKeys:
    """Blank secret = keep the one saved. The values are never logged or shown again; the audit
    log only says which ones changed."""
    with transaction.atomic():
        row = GatewayKeys.objects.select_for_update().first() or GatewayKeys()
        changed = []
        if key_id != row.key_id:
            changed.append("key_id")
            row.key_id = key_id
        if key_secret:
            changed.append("key_secret")
            row.key_secret_enc = crypto.encrypt(key_secret)
        if webhook_secret:
            changed.append("webhook_secret")
            row.webhook_secret_enc = crypto.encrypt(webhook_secret)
        row.updated_by = actor
        row.save()
        record(
            actor,
            "payments.keys_changed",
            ("payments.gatewaykeys", str(row.pk)),
            after={"changed": changed, "mode": gw.keys().mode},
            ip=ip,
        )
        return row


# --- Paying ---


class NotPayable(Conflict):
    code = "BOOKING_NOT_PAYABLE"
    message = "This booking can't be paid any more. Please book again."


class PaymentInProgress(Conflict):
    code = "PAYMENT_IN_PROGRESS"
    message = "Your payment for this booking is being confirmed. Please wait a moment."


class InvalidSignature(ApiError):
    status = 422
    code = "INVALID_SIGNATURE"
    message = (
        "We couldn't confirm this payment. If money was taken, it will be confirmed or refunded."
    )


@dataclass(frozen=True)
class Checkout:
    key_id: str
    order_id: str
    amount_paise: int
    currency: str
    booking_code: str
    pay_by: dt.datetime


def pay_by(booking: Booking) -> dt.datetime:
    return booking.created_at + dt.timedelta(minutes=int(get_setting("payment_expiry_min")))


def checkout(*, booking: Booking, now: dt.datetime | None = None) -> Checkout:
    """The order the app opens Razorpay Checkout with. Reused while it is open, so a retry
    doesn't make a second order."""
    now = now or timezone.now()
    if booking.status != BookingStatus.PENDING_PAYMENT or now > pay_by(booking):
        raise NotPayable(details={"status": booking.status})
    if payment_in_progress(str(booking.pk), now=now):
        # The app said "paid" and Razorpay hasn't answered yet: a new order could charge twice.
        raise PaymentInProgress()
    amount = int(booking.price_snapshot["booking_fee_paise"])
    gateway = gw.gateway()
    payment = (
        Payment.objects.filter(
            booking=booking,
            status=PaymentStatus.CREATED,
            amount_paise=amount,
            mode=gateway.mode,
        )
        .order_by("-created_at")
        .first()
    )
    if payment is None:
        order_id = gateway.create_order(
            amount,
            receipt=booking.code,
            notes={"booking": booking.code, "booking_id": str(booking.pk)},
        )
        payment = Payment.objects.create(
            booking=booking, amount_paise=amount, razorpay_order_id=order_id, mode=gateway.mode
        )
    return Checkout(
        key_id=gateway.key_id,
        order_id=payment.razorpay_order_id,
        amount_paise=payment.amount_paise,
        currency=payment.currency,
        booking_code=booking.code,
        pay_by=pay_by(booking),
    )


def _own_payment(user_id: str, order_id: str) -> Payment:
    payment = (
        Payment.objects.select_related("booking")
        .filter(razorpay_order_id=order_id, booking__booked_by_id=uid(user_id))
        .first()
    )
    if payment is None:
        raise NotFound()
    return payment


def verify(*, user_id: str, order_id: str, payment_id: str, signature: str) -> Booking:
    """The app's callback after Checkout. A good signature means the patient paid; whether the
    money was captured is asked from Razorpay (the webhook says it too). Returns the booking:
    NEW once captured, else still PENDING_PAYMENT ("processing")."""
    payment = _own_payment(user_id, order_id)
    if not gw.checkout_signature_ok(order_id, payment_id, signature):
        logger.warning("Bad checkout signature for payment %s", payment.pk)
        raise InvalidSignature()
    with transaction.atomic():
        locked = Payment.objects.select_for_update().get(pk=payment.pk)
        if locked.status == PaymentStatus.CREATED:
            locked.status = PaymentStatus.AUTHORIZED
            locked.razorpay_payment_id = locked.razorpay_payment_id or payment_id
            locked.save(update_fields=["status", "razorpay_payment_id", "updated_at"])
    try:
        sync_order(payment.pk)
    except gw.GatewayError:
        logger.warning("Razorpay didn't answer while confirming payment %s", payment.pk)
    return Booking.objects.get(pk=payment.booking_id)


IN_PROGRESS_FOR = dt.timedelta(hours=2)


def payment_in_progress(booking_id: str, *, now: dt.datetime | None = None) -> bool:
    """A payment the app reported in the last 2 hours that Razorpay hasn't confirmed yet. The
    bookings app doesn't expire such a booking; after 2 hours (reconcile gave up) it may."""
    now = now or timezone.now()
    return Payment.objects.filter(
        booking_id=uid(booking_id),
        status=PaymentStatus.AUTHORIZED,
        updated_at__gte=now - IN_PROGRESS_FOR,
    ).exists()


def sync_order(payment_pk: Any) -> str:
    """Ask Razorpay about this order's payments and apply what it says. Returns our status."""
    payment = Payment.objects.get(pk=payment_pk)
    if payment.status == PaymentStatus.CAPTURED:
        return payment.status
    gateway = gw.gateway()
    found = gateway.order_payments(payment.razorpay_order_id)
    for item in found:
        if item.status == "captured":
            captured(payment.razorpay_order_id, item)
            return PaymentStatus.CAPTURED
    for item in found:
        if item.status == "authorized":
            # Not captured automatically (account setting): capture it ourselves.
            captured(payment.razorpay_order_id, gateway.capture(item.id, payment.amount_paise))
            return PaymentStatus.CAPTURED
    if found and all(item.status == "failed" for item in found):
        _failed(payment.razorpay_order_id, found[-1])
    return Payment.objects.values_list("status", flat=True).get(pk=payment.pk)


def captured(order_id: str, item: gw.GatewayPayment) -> None:
    """Razorpay captured money for this order (webhook, verify or reconcile; safe to repeat).
    The amount must be the fee we asked for; the booking becomes NEW, or the money goes back."""
    with transaction.atomic():
        payment = Payment.objects.select_for_update().filter(razorpay_order_id=order_id).first()
        if payment is None:
            logger.warning("Captured payment for an unknown order")
            return
        if payment.status == PaymentStatus.CAPTURED and payment.razorpay_payment_id == item.id:
            return  # already done
        wrong_amount = item.amount != payment.amount_paise or item.currency != payment.currency
        if payment.status == PaymentStatus.CAPTURED or wrong_amount:
            # A second payment on the same order, or a wrong amount: give it back.
            if Payment.objects.filter(razorpay_order_id=f"{order_id}#{item.id}").exists():
                return  # already given back
            second = Payment.objects.create(
                booking=payment.booking,
                amount_paise=item.amount,
                razorpay_order_id=f"{order_id}#{item.id}",
                razorpay_payment_id=item.id,
                status=PaymentStatus.CAPTURED,
                method=item.method,
                mode=payment.mode,
                captured_at=timezone.now(),
            )
            if wrong_amount:
                # Never trust another amount (§12): don't confirm the booking, give it back.
                logger.error("Payment %s: captured amount differs from the fee", payment.pk)
                if payment.status != PaymentStatus.CAPTURED:
                    payment.failure_reason = "AMOUNT_MISMATCH"
                    payment.save(update_fields=["failure_reason", "updated_at"])
                second.failure_reason = "AMOUNT_MISMATCH"
                second.save(update_fields=["failure_reason", "updated_at"])
                _refund_in_full(second, "Paid a wrong amount")
            else:
                _refund_in_full(second, "Paid twice for the same booking")
            return
        payment.status = PaymentStatus.CAPTURED
        payment.razorpay_payment_id = item.id
        payment.method = item.method
        payment.captured_at = timezone.now()
        payment.failure_reason = ""
        payment.save(
            update_fields=[
                "status",
                "razorpay_payment_id",
                "method",
                "captured_at",
                "failure_reason",
                "updated_at",
            ]
        )
        result = bookings.mark_paid(booking_id=str(payment.booking_id))
        if result in ("TOO_LATE", "TIME_TAKEN"):
            _refund_in_full(payment, "Paid after the booking expired")
        elif result == "ALREADY_PAID":
            # The booking was paid with another order: give this one back.
            _refund_in_full(payment, "Paid twice for the same booking")


def _failed(order_id: str, item: gw.GatewayPayment) -> None:
    """One try failed. The order stays open: Checkout lets the patient try again on it, and a
    later try may still succeed. Only the reason is kept (shown to the admin)."""
    with transaction.atomic():
        payment = Payment.objects.select_for_update().filter(razorpay_order_id=order_id).first()
        if payment is None or payment.status in (PaymentStatus.CAPTURED, PaymentStatus.FAILED):
            return
        fields = ["failure_reason", "updated_at"]
        if payment.status == PaymentStatus.AUTHORIZED and payment.razorpay_payment_id == item.id:
            # The try the app reported failed after all: payable again.
            payment.status = PaymentStatus.CREATED
            fields.append("status")
        payment.failure_reason = (item.error or "PAYMENT_FAILED")[:200]
        payment.save(update_fields=fields)


# --- Webhook ---


class BadWebhook(ApiError):
    status = 400
    code = "BAD_SIGNATURE"
    message = "Signature check failed."


def _entity(payload: dict[str, Any], name: str) -> dict[str, Any]:
    return dict(payload.get("payload", {}).get(name, {}).get("entity", {}) or {})


def handle_webhook(*, body: bytes, signature: str, event_id: str) -> str:
    """POST /v1/webhooks/razorpay. Signature checked, each event handled once. Returns what was
    done (for tests and logs)."""
    if not gw.webhook_signature_ok(body, signature):
        logger.warning("Razorpay webhook with a bad signature")
        raise BadWebhook()
    try:
        data = json.loads(body)
    except ValueError:
        raise BadWebhook(message="Not JSON.") from None
    kind = str(data.get("event", ""))
    event_id = event_id or str(data.get("id") or "")
    if not event_id or len(event_id) > 64:
        raise BadWebhook(message="No event id.")
    payment_entity = _entity(data, "payment")
    refund_entity = _entity(data, "refund")
    # Keep ids, amounts and statuses only (never the payer's email or phone).
    kept = {
        "payment": {
            k: payment_entity.get(k)
            for k in ("id", "order_id", "status", "amount", "currency", "method", "error_code")
        },
        "refund": {k: refund_entity.get(k) for k in ("id", "payment_id", "status", "amount")},
    }
    # Recorded and handled in one transaction: if handling fails, nothing is kept and Razorpay's
    # retry is handled again (not taken for a duplicate).
    with transaction.atomic():
        event = WebhookEvent.objects.select_for_update().filter(event_id=event_id).first()
        if event is not None and event.processed_at is not None:
            return "duplicate"
        if event is None:
            try:
                with transaction.atomic():
                    event = WebhookEvent.objects.create(event_id=event_id, type=kind, payload=kept)
            except IntegrityError:
                return "duplicate"  # the same event arriving twice at once
        if kind in ("payment.captured", "order.paid") and payment_entity.get("order_id"):
            captured(str(payment_entity["order_id"]), gw._payment(payment_entity))
        elif kind == "payment.failed" and payment_entity.get("order_id"):
            _failed(str(payment_entity["order_id"]), gw._payment(payment_entity))
        elif kind in ("refund.processed", "refund.failed") and refund_entity.get("id"):
            _refund_update(str(refund_entity["id"]), str(refund_entity.get("status", "")))
        event.processed_at = timezone.now()
        event.save(update_fields=["processed_at", "updated_at"])
    return kind


# --- Reconcile (every 10 min) ---


CLOSE_AFTER = dt.timedelta(hours=1)


def _close(payment: Payment, status: str, reason: str, now: dt.datetime) -> bool:
    """Stop checking an order (only from `status`; a webhook may have just captured it). Money
    that still arrives later is refunded in full by `captured()`."""
    return bool(
        Payment.objects.filter(pk=payment.pk, status=status).update(
            status=PaymentStatus.FAILED, failure_reason=reason, updated_at=now
        )
    )


def reconcile(*, now: dt.datetime | None = None) -> int:
    """Every 10 min: orders we didn't hear back about, newest first, asked from Razorpay. An order
    nobody paid an hour after its booking's payment time (or once the booking is no longer
    unpaid) is closed, so abandoned orders aren't checked for ever. Returns how many changed."""
    now = now or timezone.now()
    if not gw.is_set_up():
        return 0
    mode = gw.gateway().mode
    changed = 0
    open_ = (
        Payment.objects.select_related("booking")
        .filter(
            status__in=(PaymentStatus.CREATED, PaymentStatus.AUTHORIZED),
            created_at__lte=now - dt.timedelta(minutes=2),
            created_at__gte=now - dt.timedelta(days=3),
            mode=mode,  # orders of other keys (test vs live) can't be asked with these
        )
        .order_by("-created_at")
    )
    for payment in list(open_[:200]):
        before = payment.status
        try:
            after = sync_order(payment.pk)
        except gw.GatewayError as exc:
            logger.warning("Razorpay didn't answer about payment %s", payment.pk)
            if exc.refused and now > pay_by(payment.booking) + CLOSE_AFTER:
                changed += _close(payment, before, "NOT_FOUND_AT_RAZORPAY", now)
            continue
        if after != before:
            changed += 1
        elif after == PaymentStatus.AUTHORIZED and now - payment.updated_at > CLOSE_AFTER:
            # The app said "paid" but Razorpay has nothing captured after an hour.
            changed += _close(payment, PaymentStatus.AUTHORIZED, "NOT_CAPTURED", now)
        elif after == PaymentStatus.CREATED and (
            payment.booking.status != BookingStatus.PENDING_PAYMENT
            or now > pay_by(payment.booking) + CLOSE_AFTER
        ):
            changed += _close(payment, PaymentStatus.CREATED, "NOT_PAID", now)
    return changed


# --- Refunds ---


def _approval_needed(amount_paise: int) -> bool:
    return amount_paise > int(get_setting("refund_approval_above_paise"))


def _refund_in_full(payment: Payment, reason: str) -> Refund:
    """The system gives the money back (too late, paid twice, wrong amount): no approval."""
    refund = Refund.objects.create(
        payment=payment,
        percent=100,
        amount_paise=payment.amount_paise,
        reason=reason,
        status=RefundStatus.PENDING,
        requested_by_type=RequestedBy.SYSTEM,
    )
    _send_after_commit(refund)
    return refund


def _send_after_commit(refund: Refund) -> None:
    from apps.payments.tasks import send_refund

    transaction.on_commit(lambda: send_refund.delay(str(refund.pk)))


def refund_for_cancel(
    *, booking_id: str, percent: int, by: str, staff_id: str | None, reason: str
) -> Refund | None:
    """The cancel hook: refund `percent` of the fee that paid for the booking (not a payment the
    system already gave back in full), never more than is left of it. Safe to repeat."""
    payment = (
        Payment.objects.filter(booking_id=uid(booking_id), status=PaymentStatus.CAPTURED)
        .exclude(refunds__requested_by_type=RequestedBy.SYSTEM)
        .order_by("captured_at")
        .first()
    )
    if payment is None or percent <= 0:
        return None
    with transaction.atomic():
        Payment.objects.select_for_update().get(pk=payment.pk)
        if payment.refunds.filter(reason__startswith="Cancelled").exists():
            return None
        given = sum(
            payment.refunds.exclude(
                status__in=(RefundStatus.REJECTED, RefundStatus.FAILED)
            ).values_list("amount_paise", flat=True)
        )
        amount = min(percent_of(payment.amount_paise, percent), payment.amount_paise - given)
        if amount <= 0:
            return None
        staff = StaffUser.objects.filter(pk=staff_id).first() if staff_id else None
        refund = Refund.objects.create(
            payment=payment,
            percent=percent,
            amount_paise=amount,
            reason=f"Cancelled: {reason}"[:300],
            status=RefundStatus.AWAITING_APPROVAL
            if _approval_needed(amount)
            else RefundStatus.PENDING,
            requested_by_type=RequestedBy.STAFF if by == "STAFF" else RequestedBy.PATIENT,
            requested_by=staff,
        )
        if refund.status == RefundStatus.PENDING:
            _send_after_commit(refund)
        return refund


def send_refund(refund_id: str) -> str:
    """Celery: ask Razorpay to refund. First looks for a refund an earlier try already made
    (its answer may have been lost), so a refund is never made twice. Razorpay refusing it (a
    4xx) is final: FAILED, for the admin to look at. Once sent, the status comes from the
    webhook or the 30-minute sweep."""
    error: gw.GatewayError | None = None
    with transaction.atomic():
        refund = Refund.objects.select_for_update().select_related("payment").get(pk=uid(refund_id))
        if refund.status != RefundStatus.PENDING or refund.razorpay_refund_id:
            return refund.status
        gateway = gw.gateway()
        payment_id = refund.payment.razorpay_payment_id
        try:
            sent = gateway.find_refund(payment_id, str(refund.pk)) or gateway.refund(
                payment_id,
                refund.amount_paise,
                notes={"booking_id": str(refund.payment.booking_id), "refund_id": str(refund.pk)},
            )
        except gw.GatewayError as exc:
            error = exc
        else:
            refund.razorpay_refund_id = sent.id
            refund.failure_reason = ""
            refund.save(update_fields=["razorpay_refund_id", "failure_reason", "updated_at"])
    if error is not None:
        if error.refused:
            Refund.objects.filter(pk=refund.pk, razorpay_refund_id="").update(
                status=RefundStatus.FAILED, failure_reason="REFUSED_BY_RAZORPAY"
            )
            logger.error("Razorpay refused refund %s", refund.pk)
            return RefundStatus.FAILED
        Refund.objects.filter(pk=refund.pk).update(failure_reason="GATEWAY_ERROR")
        raise error
    if sent.status == "processed":
        _refund_update(sent.id, "processed")
    return refund.status


def _refund_update(razorpay_refund_id: str, status: str) -> None:
    with transaction.atomic():
        refund = (
            Refund.objects.select_for_update().filter(razorpay_refund_id=razorpay_refund_id).first()
        )
        if refund is None or refund.status in (RefundStatus.PROCESSED, RefundStatus.FAILED):
            return
        if status == "processed":
            refund.status = RefundStatus.PROCESSED
            refund.processed_at = timezone.now()
            refund.save(update_fields=["status", "processed_at", "updated_at"])
            events.publish("refund.processed", {"refund_id": str(refund.pk)})
        elif status == "failed":
            refund.status = RefundStatus.FAILED
            refund.failure_reason = "REFUND_FAILED"
            refund.save(update_fields=["status", "failure_reason", "updated_at"])
            logger.error("Refund %s failed at Razorpay", refund.pk)


def refund_status_sweep() -> int:
    """Every 30 min: refunds sent but not reported back."""
    if not gw.is_set_up():
        return 0
    done = 0
    for refund in (
        Refund.objects.filter(status=RefundStatus.PENDING)
        .exclude(razorpay_refund_id="")
        .select_related("payment")[:200]
    ):
        try:
            state = gw.gateway().fetch_refund(
                refund.payment.razorpay_payment_id, refund.razorpay_refund_id
            )
        except gw.GatewayError:
            continue
        if state.status in ("processed", "failed"):
            _refund_update(refund.razorpay_refund_id, state.status)
            done += 1
    # Refunds that couldn't be sent (Razorpay down): try again.
    for refund in Refund.objects.filter(status=RefundStatus.PENDING, razorpay_refund_id="")[:50]:
        _send_after_commit(refund)
    return done


class RefundNotWaiting(Conflict):
    code = "REFUND_NOT_WAITING"
    message = "This refund isn't waiting for approval."


class RefundNotFailed(Conflict):
    code = "REFUND_NOT_FAILED"
    message = "Only a failed refund can be sent again."


def retry_refund(*, actor: StaffUser, refund_id: str, reason: str, ip: str | None) -> Refund:
    """A refund Razorpay refused or failed: send it again (a new Razorpay refund). Logged."""
    with transaction.atomic():
        refund = Refund.objects.select_for_update().filter(pk=uid(refund_id)).first()
        if refund is None:
            raise NotFound()
        if refund.status != RefundStatus.FAILED:
            raise RefundNotFailed()
        refund.status = RefundStatus.PENDING
        refund.razorpay_refund_id = ""
        refund.failure_reason = ""
        refund.save(update_fields=["status", "razorpay_refund_id", "failure_reason", "updated_at"])
        record(
            actor,
            "refund.retried",
            ("payments.refund", str(refund.pk)),
            after={"amount_paise": refund.amount_paise},
            reason=reason,
            ip=ip,
        )
        _send_after_commit(refund)
        return refund


def decide_refund(
    *, actor: StaffUser, refund_id: str, approve: bool, reason: str, ip: str | None
) -> Refund:
    """Finance approves (it is sent) or rejects a refund above the limit (§9.5)."""
    with transaction.atomic():
        refund = Refund.objects.select_for_update().filter(pk=uid(refund_id)).first()
        if refund is None:
            raise NotFound()
        if refund.status != RefundStatus.AWAITING_APPROVAL:
            raise RefundNotWaiting()
        refund.status = RefundStatus.PENDING if approve else RefundStatus.REJECTED
        refund.approved_by = actor
        refund.decided_at = timezone.now()
        if not approve:
            refund.failure_reason = reason[:200]
        refund.save(
            update_fields=["status", "approved_by", "decided_at", "failure_reason", "updated_at"]
        )
        record(
            actor,
            "refund.approved" if approve else "refund.rejected",
            ("payments.refund", str(refund.pk)),
            after={"amount_paise": refund.amount_paise, "percent": refund.percent},
            reason=reason,
            ip=ip,
        )
        if approve:
            _send_after_commit(refund)
        return refund
