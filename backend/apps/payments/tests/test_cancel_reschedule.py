"""Cancel and refund, Finance approval, reschedule, the Razorpay keys and the fee report
(PHASES 6.5-6.7, 6.10, 6.11)."""

import datetime as dt
import json

import pytest
from django.core.cache import cache
from django.utils import timezone

from apps.app_config.models import AppSetting
from apps.app_config.selectors import CACHE_KEY
from apps.audit.models import AuditLog
from apps.bookings.models import Booking, BookingStatus
from apps.bookings.services import SYSTEM, transition
from apps.bookings.tests.support import body, book, make_world, tomorrow_at
from apps.notifications.models import Notification
from apps.payments import gateway as gw
from apps.payments.models import GatewayKeys, Payment, Refund, RefundStatus
from conftest import staff_token

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


def setting(key, value):
    AppSetting.objects.update_or_create(key=key, defaults={"value": value})
    cache.delete(CACHE_KEY)


def paid_booking(api, world, fake, capture, **change) -> Booking:
    """A booking whose fee (₹100) was paid."""
    data = book(api, world.token, body(world, **change)).json()
    order = api.post(f"/patient/bookings/{data['id']}/checkout", token=world.token).json()[
        "orderId"
    ]
    p = fake.pay(order)
    raw = json.dumps(
        {
            "event": "payment.captured",
            "payload": {
                "payment": {
                    "entity": {
                        "id": p.id,
                        "order_id": order,
                        "status": "captured",
                        "amount": p.amount,
                        "currency": "INR",
                    }
                }
            },
        }
    ).encode()
    with capture(execute=True):
        api.client.post(
            "/v1/webhooks/razorpay",
            raw,
            content_type="application/json",
            HTTP_X_RAZORPAY_SIGNATURE=fake.webhook_signature(raw),
            HTTP_X_RAZORPAY_EVENT_ID=p.id,
        )
    booking = Booking.objects.get(pk=data["id"])
    assert booking.status == BookingStatus.NEW
    return booking


# --- Patient cancel (W-P4) ---


def test_cancel_refunds_exactly_half(api, world, fake, django_capture_on_commit_callbacks):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    preview = api.get(f"/patient/bookings/{booking.pk}/cancel-preview", world.token).json()
    assert preview == {
        "allowed": True,
        "paidPaise": 10000,
        "refundPercent": 50,
        "refundPaise": 5000,
    }
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/patient/bookings/{booking.pk}/cancel", {"reason": "Plans changed"}, world.token
        )
    assert resp.status_code == 200, resp.json()
    data = resp.json()
    assert data["status"] == "CANCELLED"
    assert data["canCancel"] is False
    assert data["refunds"][0]["amountPaise"] == 5000
    refund = Refund.objects.get()
    assert (refund.amount_paise, refund.percent, refund.status) == (5000, 50, RefundStatus.PENDING)
    assert refund.razorpay_refund_id
    assert any(c.endswith(":5000") for c in fake.calls)
    booking.refresh_from_db()
    assert (booking.cancelled_by, booking.cancel_reason, booking.refund_percent) == (
        "PATIENT",
        "Plans changed",
        50,
    )
    assert Notification.objects.filter(type="BOOKING_CANCELLED").exists()


def test_refund_rounds_to_whole_paise(api, world, fake, django_capture_on_commit_callbacks):
    service = world.service("Doctor visit companion")
    service.booking_fee_paise = 6001
    service.save()
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    preview = api.get(f"/patient/bookings/{booking.pk}/cancel-preview", world.token).json()
    assert preview["refundPaise"] == 3001  # 3000.5 → half up


def test_no_cancel_once_on_the_way_or_unpaid(api, world, fake, django_capture_on_commit_callbacks):
    unpaid = book(
        api, world.token, body(world, pickupAt=tomorrow_at(12).isoformat(), appointmentAt=None)
    ).json()
    resp = api.post(f"/patient/bookings/{unpaid['id']}/cancel", {"reason": "x" * 5}, world.token)
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "CANCEL_NOT_ALLOWED"
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    for event in ("OFFER", "ACCEPT", "START"):
        transition(Booking.objects.get(pk=booking.pk), event, SYSTEM)
    preview = api.get(f"/patient/bookings/{booking.pk}/cancel-preview", world.token).json()
    assert preview["allowed"] is False
    resp = api.post(f"/patient/bookings/{booking.pk}/cancel", {"reason": "Too late"}, world.token)
    assert resp.status_code == 409
    assert Refund.objects.count() == 0


# --- Admin cancel and Finance approval (§9.5) ---


def test_admin_cancel_with_full_refund_and_approval(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    setting("refund_approval_above_paise", 5000)  # ₹50, so ₹100 needs approval
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    ops = staff_token(api, staff_roles, "OPERATIONS")
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/admin/bookings/{booking.pk}/cancel",
            {"reason": "No partner free", "refundPercent": 100},
            ops,
        )
    assert resp.status_code == 200, resp.json()
    data = resp.json()
    assert data["status"] == "CANCELLED"
    assert data["refunds"][0]["status"] == "AWAITING_APPROVAL"
    assert data["payments"][0]["status"] == "CAPTURED"
    refund = Refund.objects.get()
    assert not refund.razorpay_refund_id  # not sent yet
    assert AuditLog.objects.filter(action="booking.cancelled").exists()

    support = staff_token(api, staff_roles, "SUPPORT")
    assert (
        api.post(
            f"/admin/refunds/{refund.pk}/approve", {"reason": "Looks fine"}, support
        ).status_code
        == 403
    )
    finance = staff_token(api, staff_roles, "FINANCE")
    with django_capture_on_commit_callbacks(execute=True):
        ok = api.post(f"/admin/refunds/{refund.pk}/approve", {"reason": "Our side"}, finance)
    assert ok.status_code == 200, ok.json()
    assert ok.json()["status"] == "PENDING"
    assert ok.json()["approvedByName"]
    refund.refresh_from_db()
    assert refund.razorpay_refund_id
    again = api.post(f"/admin/refunds/{refund.pk}/approve", {"reason": "twice"}, finance)
    assert again.status_code == 409


def test_finance_can_reject_and_zero_percent_refunds_nothing(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    setting("refund_approval_above_paise", 0)
    first = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    second = paid_booking(
        api,
        world,
        fake,
        django_capture_on_commit_callbacks,
        pickupAt=tomorrow_at(12).isoformat(),
        appointmentAt=None,
    )
    ops = staff_token(api, staff_roles, "OPERATIONS")
    with django_capture_on_commit_callbacks(execute=True):
        api.post(
            f"/admin/bookings/{first.pk}/cancel",
            {"reason": "Patient asked", "refundPercent": 50},
            ops,
        )
        api.post(
            f"/admin/bookings/{second.pk}/cancel", {"reason": "Abuse", "refundPercent": 0}, ops
        )
    refund = Refund.objects.get()  # nothing for 0 %
    assert refund.payment.booking_id == first.pk
    finance = staff_token(api, staff_roles, "FINANCE")
    rejected = api.post(f"/admin/refunds/{refund.pk}/reject", {"reason": "Not eligible"}, finance)
    assert rejected.json()["status"] == "REJECTED"
    listed = api.get("/admin/refunds?status=REJECTED", finance).json()
    assert [r["id"] for r in listed["items"]] == [str(refund.pk)]
    assert listed["items"][0]["bookingCode"] == first.code


# --- Reschedule (§6.17, W-P7) ---


def test_reschedule_rules(api, world, fake, django_capture_on_commit_callbacks):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    later = tomorrow_at(12)
    with django_capture_on_commit_callbacks(execute=True):
        moved = api.post(
            f"/patient/bookings/{booking.pk}/reschedule",
            {"pickupAt": later.isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
            world.token,
        )
    assert moved.status_code == 200, moved.json()
    data = moved.json()
    assert dt.datetime.fromisoformat(data["pickupAt"]) == later
    assert data["reschedulesLeft"] == 1
    assert data["paidPaise"] == 10000  # same fee
    booking.refresh_from_db()
    assert booking.reschedule_count == 1
    assert booking.busy_window.lower == later - dt.timedelta(hours=1)
    assert booking.events.filter(event="RESCHEDULE").count() == 1
    assert Notification.objects.filter(type="BOOKING_RESCHEDULED").exists()

    same = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": later.isoformat(), "appointmentAt": tomorrow_at(13).isoformat()},
        world.token,
    )
    assert same.status_code == 422
    second = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": tomorrow_at(14).isoformat()},
        world.token,
    )
    assert second.status_code == 200
    third = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": tomorrow_at(15).isoformat()},
        world.token,
    )
    assert third.status_code == 409
    assert third.json()["error"]["details"] == {"reason": "LIMIT"}  # a 3rd change is refused


def test_reschedule_too_close_to_pickup(api, world, fake, django_capture_on_commit_callbacks):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    soon = timezone.now() + dt.timedelta(hours=2)
    Booking.objects.filter(pk=booking.pk).update(pickup_at=soon)
    resp = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": tomorrow_at(12).isoformat()},
        world.token,
    )
    assert resp.status_code == 409
    assert resp.json()["error"]["details"] == {"reason": "TOO_LATE"}
    detail = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert (detail["canReschedule"], detail["rescheduleProblem"]) == (False, "TOO_LATE")


def test_reschedule_checks_the_new_time_and_flags_the_partner(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    blocked_inside_notice = (timezone.now() + dt.timedelta(hours=1)).replace(
        minute=0, second=0, microsecond=0
    )
    resp = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": blocked_inside_notice.isoformat()},
        world.token,
    )
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "TIME_NOT_AVAILABLE"
    transition(Booking.objects.get(pk=booking.pk), "OFFER", SYSTEM)
    moved = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": tomorrow_at(12).isoformat()},
        world.token,
    )
    assert moved.json()["reconfirmNeeded"] is True  # the partner confirms again (Phase 7)
    # the admin isn't held to the limit and may pick a time inside the notice
    Booking.objects.filter(pk=booking.pk).update(reschedule_count=2)
    ops = staff_token(api, staff_roles, "OPERATIONS")
    urgent = api.post(
        f"/admin/bookings/{booking.pk}/reschedule", {"pickupAt": tomorrow_at(16).isoformat()}, ops
    )
    assert urgent.status_code == 200, urgent.json()
    assert Booking.objects.get(pk=booking.pk).reschedule_count == 2  # not counted
    assert AuditLog.objects.filter(action="booking.rescheduled").exists()


# --- Keys (Settings → Payments) ---


def test_payment_keys_are_encrypted_and_never_shown(api, staff_roles):
    admin = staff_token(api, staff_roles)
    empty = api.get("/admin/payment-keys", admin).json()
    assert empty["source"] == "NONE"
    secret = "abcdefghijklmnopWXYZ"
    saved = api.put(
        "/admin/payment-keys",
        {"keyId": "rzp_test_ABCDEF123456", "keySecret": secret, "webhookSecret": "whsec_test_9876"},
        admin,
    )
    assert saved.status_code == 200, saved.json()
    data = saved.json()
    assert (data["source"], data["mode"], data["keySecretLast4"], data["webhookSecretLast4"]) == (
        "ADMIN",
        "TEST",
        "WXYZ",
        "9876",
    )
    assert secret not in json.dumps(data)
    row = GatewayKeys.objects.get()
    assert secret not in row.key_secret_enc
    assert gw.keys().key_secret == secret
    audit = AuditLog.objects.get(action="payments.keys_changed")
    assert secret not in json.dumps(audit.after)
    # blank secret keeps the saved one; a new key id needs its secret
    keep = api.put("/admin/payment-keys", {"keyId": "rzp_test_ABCDEF123456"}, admin)
    assert keep.status_code == 200
    assert gw.keys().key_secret == secret
    other = api.put("/admin/payment-keys", {"keyId": "rzp_live_ZZZZZZ999999"}, admin)
    assert other.json()["error"]["code"] == "SECRET_REQUIRED"
    bad = api.put("/admin/payment-keys", {"keyId": "sk_live_x", "keySecret": "x"}, admin)
    assert bad.status_code == 422
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert api.get("/admin/payment-keys", ops).status_code == 403


def test_signatures_use_the_saved_secrets(api, staff_roles):
    admin = staff_token(api, staff_roles)
    api.put(
        "/admin/payment-keys",
        {
            "keyId": "rzp_test_ABCDEF123456",
            "keySecret": "s3cret-key",
            "webhookSecret": "hook-secret",
        },
        admin,
    )
    import hashlib
    import hmac

    good = hmac.new(b"s3cret-key", b"order_1|pay_1", hashlib.sha256).hexdigest()
    assert gw.checkout_signature_ok("order_1", "pay_1", good)
    assert not gw.checkout_signature_ok("order_1", "pay_2", good)
    body = b'{"event":"payment.captured"}'
    assert gw.webhook_signature_ok(body, hmac.new(b"hook-secret", body, hashlib.sha256).hexdigest())


# --- Payments list and fee report ---


def test_payments_list_and_fee_report(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    finance = staff_token(api, staff_roles, "FINANCE")
    rows = api.get("/admin/payments", finance).json()
    assert rows["items"][0]["bookingCode"] == booking.code
    assert rows["items"][0]["amountPaise"] == 10000
    assert api.get(f"/admin/payments?q={booking.code}", finance).json()["count"] == 1
    Refund.objects.create(
        payment=Payment.objects.get(),
        percent=50,
        amount_paise=5000,
        reason="test",
        status=RefundStatus.PROCESSED,
        requested_by_type="PATIENT",
        processed_at=timezone.now(),
    )
    csv = api.get("/admin/reports/fees", finance)
    assert csv.status_code == 200
    text = csv.content.decode("utf-8-sig")
    assert "Fees collected" in text
    assert text.strip().splitlines()[-1] == "Total,1,100.00,50.00,50.00"
    assert AuditLog.objects.filter(action="payments.report_exported").exists()
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert api.get("/admin/payments", ops).status_code == 403


def test_reschedule_times_leave_the_booking_itself_out(
    api, world, fake, django_capture_on_commit_callbacks
):
    setting("max_per_slot", 1)
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    day = booking.pickup_at.astimezone(tomorrow_at(0).tzinfo).date().isoformat()
    service = world.service("Doctor visit companion")
    general = api.get(
        f"/patient/booking-times?serviceId={service.pk}&date={day}", world.token
    ).json()
    own = api.get(f"/patient/bookings/{booking.pk}/reschedule-times?date={day}", world.token).json()
    taken = booking.pickup_at
    assert taken not in [dt.datetime.fromisoformat(t) for t in general["times"]]  # full for others
    assert taken in [dt.datetime.fromisoformat(t) for t in own["times"]]  # its own place is free
    from apps.patients.tests.support import OTHER, patient

    other = patient(api, OTHER, "other-device")
    assert api.get(f"/patient/bookings/{booking.pk}/reschedule-times", other).status_code == 404


def test_environment_webhook_secret_kept_for_the_same_account(api, staff_roles, settings):
    """Moving the environment's keys into the panel with a blank webhook secret keeps the
    environment's one for the same key id; another account needs its own."""
    settings.RAZORPAY_KEY_ID = "rzp_test_ENVKEY123456"
    settings.RAZORPAY_KEY_SECRET = "env-secret"
    settings.RAZORPAY_WEBHOOK_SECRET = "env-hook"
    admin = staff_token(api, staff_roles)
    assert api.get("/admin/payment-keys", admin).json()["source"] == "ENVIRONMENT"
    same = api.put(
        "/admin/payment-keys",
        {"keyId": "rzp_test_ENVKEY123456", "keySecret": "panel-secret"},
        admin,
    )
    assert same.status_code == 200, same.json()
    assert gw.keys().webhook_secret == "env-hook"
    api.put(
        "/admin/payment-keys",
        {"keyId": "rzp_test_OTHER0123456", "keySecret": "other-secret"},
        admin,
    )
    assert gw.keys().webhook_secret == ""


def test_admin_reschedules_inside_the_notice_and_cut_off(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    setting("min_notice_hours", 48)  # tomorrow is now inside the notice ...
    setting("reschedule_cutoff_hours", 48)  # ... and inside the cut-off
    patient = api.post(
        f"/patient/bookings/{booking.pk}/reschedule",
        {"pickupAt": tomorrow_at(16).isoformat()},
        world.token,
    )
    assert patient.json()["error"]["details"]["reason"] == "TOO_LATE"
    ops = staff_token(api, staff_roles, "OPERATIONS")
    admin = api.post(
        f"/admin/bookings/{booking.pk}/reschedule", {"pickupAt": tomorrow_at(16).isoformat()}, ops
    )
    assert admin.status_code == 200, admin.json()
    assert admin.json()["timeStepMin"] == 30


# --- Sending refunds safely ---


def test_a_refund_whose_answer_was_lost_is_not_made_twice(
    api, world, fake, django_capture_on_commit_callbacks
):
    from apps.payments import services

    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    fake.lose_refund_answer = True  # Razorpay makes it, the answer times out
    with django_capture_on_commit_callbacks(execute=False) as callbacks:
        api.post(f"/patient/bookings/{booking.pk}/cancel", {"reason": "PLANS_CHANGED"}, world.token)
    refund = Refund.objects.get()
    with pytest.raises(gw.GatewayError):
        services.send_refund(str(refund.pk))
    refund.refresh_from_db()
    assert (refund.razorpay_refund_id, refund.failure_reason) == ("", "GATEWAY_ERROR")
    services.send_refund(str(refund.pk))  # the retry finds the refund Razorpay already made
    refund.refresh_from_db()
    assert refund.razorpay_refund_id
    assert [c for c in fake.calls if c.startswith("refund:")] == [
        f"refund:{refund.payment.razorpay_payment_id}:5000"
    ]
    assert callbacks  # the first send was queued after the cancel


def test_a_refused_refund_fails_and_finance_can_send_it_again(
    api, world, fake, staff_roles, django_capture_on_commit_callbacks
):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    fake.refuse_refunds = True
    with django_capture_on_commit_callbacks(execute=True):
        api.post(f"/patient/bookings/{booking.pk}/cancel", {"reason": "PLANS_CHANGED"}, world.token)
    refund = Refund.objects.get()
    assert (refund.status, refund.failure_reason) == (RefundStatus.FAILED, "REFUSED_BY_RAZORPAY")
    fake.refuse_refunds = False
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert (
        api.post(f"/admin/refunds/{refund.pk}/retry", {"reason": "Try again"}, ops).status_code
        == 403
    )
    finance = staff_token(api, staff_roles, "FINANCE")
    with django_capture_on_commit_callbacks(execute=True):
        again = api.post(f"/admin/refunds/{refund.pk}/retry", {"reason": "Bank fixed"}, finance)
    assert again.status_code == 200, again.json()
    refund.refresh_from_db()
    assert refund.status == RefundStatus.PENDING and refund.razorpay_refund_id
    assert AuditLog.objects.filter(action="refund.retried").exists()
    twice = api.post(f"/admin/refunds/{refund.pk}/retry", {"reason": "Again"}, finance)
    assert twice.json()["error"]["code"] == "REFUND_NOT_FAILED"


def test_the_cancel_refund_uses_the_payment_that_paid(
    api, world, fake, django_capture_on_commit_callbacks
):
    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    first = Payment.objects.get(booking=booking)
    assert first.captured_at is not None
    # a second payment for the same booking, given back in full by the system
    second = Payment.objects.create(
        booking=booking,
        amount_paise=10000,
        razorpay_order_id="order_second",
        razorpay_payment_id="pay_second",
        status="CAPTURED",
        mode="TEST",
        captured_at=first.captured_at - dt.timedelta(seconds=1),  # even if it looks earlier
    )
    Refund.objects.create(
        payment=second,
        percent=100,
        amount_paise=10000,
        reason="Paid twice",
        status="PENDING",
        requested_by_type="SYSTEM",
    )
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/patient/bookings/{booking.pk}/cancel", {"reason": "PLANS_CHANGED"}, world.token
        )
    assert resp.json()["paidPaise"] == 10000
    cancel_refund = Refund.objects.get(reason__startswith="Cancelled")
    assert (cancel_refund.payment_id, cancel_refund.amount_paise) == (first.pk, 5000)


def test_an_admins_cancel_or_new_time_reaches_the_familys_open_app(
    api, world, fake, staff_roles, monkeypatch, django_capture_on_commit_callbacks
):
    """Full test, 16 Oct 2026: an admin's cancel left Home on "Partner assigned" (§10.4)."""
    from common import realtime

    booking = paid_booking(api, world, fake, django_capture_on_commit_callbacks)
    sent = []
    monkeypatch.setattr(
        realtime, "send_to_group", lambda g, kind, data: sent.append((g, kind, data))
    )
    family = f"user.patient.{booking.booked_by_id}"
    ops = staff_token(api, staff_roles, "OPERATIONS")
    with django_capture_on_commit_callbacks(execute=True):
        moved = api.post(
            f"/admin/bookings/{booking.pk}/reschedule",
            {"pickupAt": tomorrow_at(16).isoformat()},
            ops,
        )
    assert moved.status_code == 200, moved.json()
    update = {"bookingId": str(booking.pk), "status": "NEW"}
    assert (family, "booking.updated", update) in sent
    with django_capture_on_commit_callbacks(execute=True):
        api.post(
            f"/admin/bookings/{booking.pk}/cancel",
            {"reason": "No partner free", "refundPercent": 100},
            ops,
        )
    update = {"bookingId": str(booking.pk), "status": "CANCELLED"}
    assert (family, "booking.updated", update) in sent
