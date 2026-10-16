"""Paying the booking fee (PHASES 6.1-6.4, 6.11): order, verify, webhook, reconcile, late
payments. Razorpay is replaced by `FakeGateway`."""

import datetime as dt
import json
import uuid

import pytest
from django.core.cache import cache
from django.utils import timezone

from apps.app_config.models import AppSetting
from apps.app_config.selectors import CACHE_KEY
from apps.bookings.models import Booking, BookingStatus
from apps.bookings.services import expire_unpaid
from apps.bookings.tests.support import body, book, make_world
from apps.notifications.models import Notification
from apps.payments import gateway as gw
from apps.payments import services
from apps.payments.models import Payment, PaymentStatus, Refund, RefundStatus, WebhookEvent

pytestmark = pytest.mark.django_db


@pytest.fixture
def fake():
    gateway = gw.FakeGateway()
    gw.use_gateway(gateway)
    yield gateway
    gw.use_gateway(None)


@pytest.fixture
def world(api):
    return make_world(api)


@pytest.fixture
def booking(api, world):
    data = book(api, world.token, body(world)).json()
    return Booking.objects.get(pk=data["id"])


def setting(key, value):
    AppSetting.objects.update_or_create(key=key, defaults={"value": value})
    cache.delete(CACHE_KEY)


def checkout(api, token, booking_id):
    return api.post(f"/patient/bookings/{booking_id}/checkout", token=token)


def webhook(api, fake, event, *, payment=None, refund=None, event_id=None, signature=None):
    payload = {"event": event, "payload": {}}
    if payment:
        payload["payload"]["payment"] = {"entity": payment}
    if refund:
        payload["payload"]["refund"] = {"entity": refund}
    raw = json.dumps(payload).encode()
    return api.client.post(
        "/v1/webhooks/razorpay",
        raw,
        content_type="application/json",
        HTTP_X_RAZORPAY_SIGNATURE=signature or fake.webhook_signature(raw),
        HTTP_X_RAZORPAY_EVENT_ID=event_id or uuid.uuid4().hex,
    )


def captured_entity(fake, order_id, amount=None):
    p = fake.pay(order_id, amount=amount)
    return {
        "id": p.id,
        "order_id": order_id,
        "status": "captured",
        "amount": p.amount,
        "currency": "INR",
        "method": "upi",
        "email": "x@example.com",
        "contact": "+919876543210",
    }


def test_checkout_uses_the_snapshot_and_reuses_the_order(api, world, booking, fake):
    service = world.service("Doctor visit companion")
    service.booking_fee_paise = 25000  # a new price after booking changes nothing
    service.save()
    first = checkout(api, world.token, booking.pk)
    assert first.status_code == 200, first.json()
    data = first.json()
    assert data["amountPaise"] == 10000
    assert data["keyId"] == "rzp_test_fake"
    assert data["bookingCode"] == booking.code
    again = checkout(api, world.token, booking.pk).json()
    assert again["orderId"] == data["orderId"]  # a retry doesn't make a second order
    assert fake.calls.count("create_order") == 1


def test_checkout_refused_when_not_payable_or_not_set_up(api, world, booking, fake):
    Booking.objects.filter(pk=booking.pk).update(created_at=timezone.now() - dt.timedelta(hours=1))
    late = checkout(api, world.token, booking.pk)
    assert late.status_code == 409
    assert late.json()["error"]["code"] == "BOOKING_NOT_PAYABLE"
    gw.use_gateway(None)
    Booking.objects.filter(pk=booking.pk).update(created_at=timezone.now())
    off = checkout(api, world.token, booking.pk)
    assert off.status_code == 503
    assert off.json()["error"]["code"] == "PAYMENTS_NOT_SET_UP"


def test_pay_verify_confirms(api, world, booking, fake, django_capture_on_commit_callbacks):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    paid = fake.pay(order)
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            "/patient/payments/verify",
            {
                "razorpayOrderId": order,
                "razorpayPaymentId": paid.id,
                "razorpaySignature": fake.checkout_signature(order, paid.id),
            },
            world.token,
        )
    assert resp.status_code == 200, resp.json()
    assert resp.json()["status"] == "NEW"
    assert resp.json()["paidPaise"] == 10000
    payment = Payment.objects.get()
    assert (payment.status, payment.razorpay_payment_id, payment.method) == (
        "CAPTURED",
        paid.id,
        "upi",
    )
    note = Notification.objects.get(type="BOOKING_CONFIRMED")
    assert booking.code in note.body
    assert note.user_id == booking.booked_by_id


def test_verify_waits_for_razorpay_and_the_webhook_finishes(
    api, world, booking, fake, django_capture_on_commit_callbacks
):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    authorized = fake.pay(order, status="authorized")
    fake.payments[order] = []  # Razorpay hasn't recorded it yet
    resp = api.post(
        "/patient/payments/verify",
        {
            "razorpayOrderId": order,
            "razorpayPaymentId": authorized.id,
            "razorpaySignature": fake.checkout_signature(order, authorized.id),
        },
        world.token,
    )
    assert resp.json()["status"] == "PENDING_PAYMENT"  # the app shows "processing"
    assert Payment.objects.get().status == PaymentStatus.AUTHORIZED
    # the payment time passes: the booking doesn't expire while its payment is being confirmed
    assert expire_unpaid(now=timezone.now() + dt.timedelta(minutes=31)) == 0
    with django_capture_on_commit_callbacks(execute=True):
        hook = webhook(api, fake, "payment.captured", payment=captured_entity(fake, order))
    assert hook.status_code == 200, hook.json()
    booking.refresh_from_db()
    assert booking.status == BookingStatus.NEW
    stored = WebhookEvent.objects.get()
    assert "contact" not in json.dumps(stored.payload) and "email" not in json.dumps(stored.payload)


def test_bad_signatures_are_rejected(api, world, booking, fake):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    paid = fake.pay(order)
    resp = api.post(
        "/patient/payments/verify",
        {"razorpayOrderId": order, "razorpayPaymentId": paid.id, "razorpaySignature": "0" * 64},
        world.token,
    )
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == "INVALID_SIGNATURE"
    hook = webhook(
        api, fake, "payment.captured", payment=captured_entity(fake, order), signature="bad"
    )
    assert hook.status_code == 400
    booking.refresh_from_db()
    assert booking.status == BookingStatus.PENDING_PAYMENT
    assert WebhookEvent.objects.count() == 0


def test_a_duplicate_webhook_is_ignored(
    api, world, booking, fake, django_capture_on_commit_callbacks
):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    entity = captured_entity(fake, order)
    with django_capture_on_commit_callbacks(execute=True):
        assert (
            webhook(api, fake, "payment.captured", payment=entity, event_id="evt_1").status_code
            == 200
        )
        assert (
            webhook(api, fake, "payment.captured", payment=entity, event_id="evt_1").status_code
            == 200
        )
    assert WebhookEvent.objects.count() == 1
    assert Notification.objects.filter(type="BOOKING_CONFIRMED").count() == 1
    assert booking.events.filter(event="PAY").count() == 1


def test_amount_tampering_has_no_effect(api, world, booking, fake):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    # the app can't send an amount at all
    extra = api.post(
        "/patient/payments/verify",
        {
            "razorpayOrderId": order,
            "razorpayPaymentId": "pay_x",
            "razorpaySignature": "x",
            "amountPaise": 100,
        },
        world.token,
    )
    assert extra.status_code == 422
    # a capture of another amount doesn't confirm the booking, and that money goes back
    webhook(api, fake, "payment.captured", payment=captured_entity(fake, order, amount=100))
    booking.refresh_from_db()
    assert booking.status == BookingStatus.PENDING_PAYMENT
    payment = Payment.objects.get(razorpay_order_id=order)
    assert (payment.status, payment.failure_reason) == ("CREATED", "AMOUNT_MISMATCH")
    refund = Refund.objects.get()
    assert (refund.amount_paise, refund.requested_by_type) == (100, "SYSTEM")
    # the right amount on the same order still confirms it
    webhook(api, fake, "payment.captured", payment=captured_entity(fake, order))
    booking.refresh_from_db()
    assert booking.status == BookingStatus.NEW
    assert api.get(f"/patient/bookings/{booking.pk}", world.token).json()["paidPaise"] == 10000


def test_a_late_payment_is_refunded_in_full(
    api, world, booking, fake, django_capture_on_commit_callbacks
):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    assert expire_unpaid(now=timezone.now() + dt.timedelta(minutes=31)) == 1
    with django_capture_on_commit_callbacks(execute=True):
        webhook(api, fake, "payment.captured", payment=captured_entity(fake, order))
    booking.refresh_from_db()
    assert booking.status == BookingStatus.EXPIRED
    refund = Refund.objects.get()
    assert (refund.amount_paise, refund.percent, refund.requested_by_type) == (10000, 100, "SYSTEM")
    assert refund.razorpay_refund_id  # sent to Razorpay
    assert any(c.startswith("refund:") for c in fake.calls)


def test_a_payment_after_the_last_place_was_taken_is_refunded(
    api, world, booking, fake, django_capture_on_commit_callbacks
):
    setting("max_per_slot", 1)
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    # its payment time passes, someone else takes the place, then the money arrives
    Booking.objects.filter(pk=booking.pk).update(
        created_at=timezone.now() - dt.timedelta(minutes=40)
    )
    other = book(api, world.token, body(world))
    assert other.status_code == 200, other.json()
    with django_capture_on_commit_callbacks(execute=True):
        webhook(api, fake, "payment.captured", payment=captured_entity(fake, order))
    booking.refresh_from_db()
    assert booking.status == BookingStatus.EXPIRED
    assert Refund.objects.get().amount_paise == 10000


def test_reconcile_finds_what_we_did_not_hear(
    api, world, booking, fake, django_capture_on_commit_callbacks
):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    fake.pay(order, status="authorized")  # not auto-captured, no webhook
    Payment.objects.update(created_at=timezone.now() - dt.timedelta(minutes=5))
    with django_capture_on_commit_callbacks(execute=True):
        assert services.reconcile() == 1
    assert "capture" in fake.calls
    booking.refresh_from_db()
    assert booking.status == BookingStatus.NEW


def test_failed_payments_leave_the_booking_payable(api, world, booking, fake):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    failed = fake.pay(order, status="failed")
    entity = {
        "id": failed.id,
        "order_id": order,
        "status": "failed",
        "amount": 10000,
        "currency": "INR",
        "error_code": "BAD_REQUEST_ERROR",
    }
    webhook(api, fake, "payment.failed", payment=entity)
    payment = Payment.objects.get()
    # Checkout tries again on the same order: it stays open
    assert (payment.status, payment.failure_reason) == (PaymentStatus.CREATED, "BAD_REQUEST_ERROR")
    assert checkout(api, world.token, booking.pk).json()["orderId"] == order


def test_a_later_try_on_the_same_order_is_found_by_reconcile(
    api, world, booking, fake, django_capture_on_commit_callbacks
):
    """A failed try, then a good one whose webhook never came: reconcile still confirms it."""
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    failed = fake.pay(order, status="failed")
    failed_entity = {
        "id": failed.id,
        "order_id": order,
        "status": "failed",
        "amount": 10000,
        "currency": "INR",
        "error_code": "BAD_REQUEST_ERROR",
    }
    webhook(api, fake, "payment.failed", payment=failed_entity)
    fake.pay(order)  # the retry in Checkout succeeds; the app was closed, no webhook
    Payment.objects.update(created_at=timezone.now() - dt.timedelta(minutes=5))
    with django_capture_on_commit_callbacks(execute=True):
        assert services.reconcile() == 1
    booking.refresh_from_db()
    assert booking.status == BookingStatus.NEW


def test_reconcile_closes_abandoned_orders(api, world, booking, fake):
    checkout(api, world.token, booking.pk)
    Payment.objects.update(created_at=timezone.now() - dt.timedelta(minutes=5))
    assert services.reconcile() == 0  # still within the payment time: keep asking
    later = timezone.now() + dt.timedelta(minutes=31) + services.CLOSE_AFTER
    assert services.reconcile(now=later) == 1
    payment = Payment.objects.get()
    assert (payment.status, payment.failure_reason) == (PaymentStatus.FAILED, "NOT_PAID")
    fake.calls.clear()
    assert services.reconcile(now=later) == 0
    assert "order_payments" not in fake.calls  # not asked again


def test_a_payment_being_confirmed_blocks_a_second_order(api, world, booking, fake):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    paid = fake.pay(order, status="authorized")
    fake.fail = True  # Razorpay doesn't answer while the app reports the payment
    resp = api.post(
        "/patient/payments/verify",
        {
            "razorpayOrderId": order,
            "razorpayPaymentId": paid.id,
            "razorpaySignature": fake.checkout_signature(order, paid.id),
        },
        world.token,
    )
    assert resp.json()["paymentPending"] is True
    fake.fail = False
    again = checkout(api, world.token, booking.pk)
    assert again.json()["error"]["code"] == "PAYMENT_IN_PROGRESS"


def test_a_webhook_that_failed_is_handled_on_razorpays_retry(
    api, world, booking, fake, monkeypatch
):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    entity = captured_entity(fake, order)
    real = services.captured
    calls = []

    def flaky(order_id, item):
        calls.append(order_id)
        if len(calls) == 1:
            raise RuntimeError("database hiccup")
        real(order_id, item)

    monkeypatch.setattr(services, "captured", flaky)
    try:
        first = webhook(api, fake, "payment.captured", payment=entity, event_id="evt_retry_1")
        assert first.status_code == 500
    except RuntimeError:
        pass  # the test client raises what the view raised
    assert not WebhookEvent.objects.exists()  # nothing kept: the retry isn't a duplicate
    webhook(api, fake, "payment.captured", payment=entity, event_id="evt_retry_1")
    booking.refresh_from_db()
    assert booking.status == BookingStatus.NEW


def test_another_patient_cannot_pay_or_verify(api, world, booking, fake):
    from apps.patients.tests.support import OTHER, patient

    other = patient(api, OTHER, "other-device")
    assert checkout(api, other, booking.pk).status_code == 404
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    resp = api.post(
        "/patient/payments/verify",
        {"razorpayOrderId": order, "razorpayPaymentId": "pay_1", "razorpaySignature": "x"},
        other,
    )
    assert resp.status_code == 404


def test_refund_status_sweep(api, world, booking, fake, django_capture_on_commit_callbacks):
    order = checkout(api, world.token, booking.pk).json()["orderId"]
    with django_capture_on_commit_callbacks(execute=True):
        webhook(api, fake, "payment.captured", payment=captured_entity(fake, order))
        api.post(f"/patient/bookings/{booking.pk}/cancel", {"reason": "Plans changed"}, world.token)
    refund = Refund.objects.get()
    assert refund.status == RefundStatus.PENDING
    fake.refunds[refund.razorpay_refund_id] = gw.GatewayRefund(
        refund.razorpay_refund_id, "processed"
    )
    with django_capture_on_commit_callbacks(execute=True):
        assert services.refund_status_sweep() == 1
    refund.refresh_from_db()
    assert refund.status == RefundStatus.PROCESSED
    assert Notification.objects.filter(type="REFUND_PROCESSED").exists()
