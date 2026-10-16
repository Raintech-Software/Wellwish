"""Talking to Razorpay (Orders, Payments, Refunds) and checking its signatures.

Only the REST API with HTTP basic auth (key id + secret) is used, no SDK. The keys come from
the admin panel (`GatewayKeys`, encrypted) or, if none were entered, from the environment
(`RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET`, `RAZORPAY_WEBHOOK_SECRET`).

Tests swap the gateway with `use_gateway(FakeGateway())`.
"""

import datetime as dt
import hashlib
import hmac
from dataclasses import dataclass, field
from typing import Any, Protocol

import requests
from django.conf import settings
from django.utils import timezone

from common import crypto
from common.errors import ApiError

API = "https://api.razorpay.com/v1"
TIMEOUT = 15


class PaymentsNotSetUp(ApiError):
    status = 503
    code = "PAYMENTS_NOT_SET_UP"
    message = "Online payment isn't available yet. Please try again later."


class GatewayError(ApiError):
    status = 502
    code = "PAYMENT_GATEWAY_ERROR"
    message = "The payment service didn't answer. Please try again."

    @property
    def refused(self) -> bool:
        """Razorpay answered with a 4xx (not "too many requests"): trying again won't help."""
        code = int(self.details.get("status") or 0)
        return 400 <= code < 500 and code != 429


@dataclass(frozen=True)
class Keys:
    key_id: str
    key_secret: str
    webhook_secret: str

    @property
    def mode(self) -> str:
        if self.key_id.startswith("rzp_live_"):
            return "LIVE"
        return "TEST" if self.key_id.startswith("rzp_test_") else ""


@dataclass(frozen=True)
class GatewayPayment:
    id: str
    order_id: str
    status: str  # created, authorized, captured, refunded, failed
    amount: int
    currency: str = "INR"
    method: str = ""
    error: str = ""


@dataclass(frozen=True)
class GatewayRefund:
    id: str
    status: str  # pending, processed, failed


class Gateway(Protocol):
    key_id: str
    mode: str

    def create_order(self, amount_paise: int, receipt: str, notes: dict[str, str]) -> str: ...

    def order_payments(self, order_id: str) -> list[GatewayPayment]: ...

    def capture(self, payment_id: str, amount_paise: int) -> GatewayPayment: ...

    def refund(
        self, payment_id: str, amount_paise: int, notes: dict[str, str]
    ) -> GatewayRefund: ...

    def fetch_refund(self, payment_id: str, refund_id: str) -> GatewayRefund: ...

    def find_refund(self, payment_id: str, our_refund_id: str) -> GatewayRefund | None: ...


def keys() -> Keys:
    """The keys in use: the admin panel's, else the environment's."""
    from apps.payments.models import GatewayKeys

    row = GatewayKeys.objects.first()
    if row and row.key_id and row.key_secret_enc:
        webhook = crypto.decrypt(row.webhook_secret_enc) if row.webhook_secret_enc else ""
        if not webhook and row.key_id == settings.RAZORPAY_KEY_ID:
            # Same account as the environment's keys: its webhook secret still applies.
            webhook = settings.RAZORPAY_WEBHOOK_SECRET
        return Keys(
            key_id=row.key_id, key_secret=crypto.decrypt(row.key_secret_enc), webhook_secret=webhook
        )
    return Keys(
        key_id=settings.RAZORPAY_KEY_ID,
        key_secret=settings.RAZORPAY_KEY_SECRET,
        webhook_secret=settings.RAZORPAY_WEBHOOK_SECRET,
    )


def _payment(data: dict[str, Any]) -> GatewayPayment:
    return GatewayPayment(
        id=str(data.get("id", "")),
        order_id=str(data.get("order_id") or ""),
        status=str(data.get("status", "")),
        amount=int(data.get("amount") or 0),
        currency=str(data.get("currency") or "INR"),
        method=str(data.get("method") or ""),
        error=str(data.get("error_code") or ""),
    )


class RazorpayGateway:
    def __init__(self, k: Keys) -> None:
        self._keys = k
        self.key_id = k.key_id
        self.mode = k.mode

    def _call(self, method: str, path: str, body: dict[str, Any] | None = None) -> Any:
        try:
            response = requests.request(
                method,
                f"{API}{path}",
                json=body,
                auth=(self._keys.key_id, self._keys.key_secret),
                timeout=TIMEOUT,
            )
        except requests.RequestException as exc:
            raise GatewayError() from exc
        if response.status_code >= 400:
            # The error text is Razorpay's (no card or personal data); kept short for the logs.
            raise GatewayError(details={"status": response.status_code})
        return response.json()

    def create_order(self, amount_paise: int, receipt: str, notes: dict[str, str]) -> str:
        data = self._call(
            "POST",
            "/orders",
            {"amount": amount_paise, "currency": "INR", "receipt": receipt, "notes": notes},
        )
        return str(data["id"])

    def order_payments(self, order_id: str) -> list[GatewayPayment]:
        data = self._call("GET", f"/orders/{order_id}/payments")
        return [_payment(item) for item in data.get("items", [])]

    def capture(self, payment_id: str, amount_paise: int) -> GatewayPayment:
        return _payment(
            self._call(
                "POST",
                f"/payments/{payment_id}/capture",
                {"amount": amount_paise, "currency": "INR"},
            )
        )

    def refund(self, payment_id: str, amount_paise: int, notes: dict[str, str]) -> GatewayRefund:
        data = self._call(
            "POST", f"/payments/{payment_id}/refund", {"amount": amount_paise, "notes": notes}
        )
        return GatewayRefund(id=str(data["id"]), status=str(data.get("status", "pending")))

    def fetch_refund(self, payment_id: str, refund_id: str) -> GatewayRefund:
        data = self._call("GET", f"/payments/{payment_id}/refunds/{refund_id}")
        return GatewayRefund(id=str(data["id"]), status=str(data.get("status", "pending")))

    def find_refund(self, payment_id: str, our_refund_id: str) -> GatewayRefund | None:
        """A refund Razorpay already made for our refund (its notes carry our id): an earlier
        try whose answer was lost must not be sent twice."""
        data = self._call("GET", f"/payments/{payment_id}/refunds?count=100")
        for item in data.get("items", []):
            notes = item.get("notes") or {}
            status = str(item.get("status", "pending"))
            ours = isinstance(notes, dict) and notes.get("refund_id") == our_refund_id
            if ours and status != "failed":
                return GatewayRefund(id=str(item["id"]), status=status)
        return None


_override: Gateway | None = None


def use_gateway(gateway: Gateway | None) -> None:
    """Tests: answer with a fake instead of calling Razorpay (None = back to normal)."""
    global _override
    _override = gateway


def gateway() -> Gateway:
    if _override is not None:
        return _override
    k = keys()
    if not (k.key_id and k.key_secret):
        raise PaymentsNotSetUp()
    return RazorpayGateway(k)


def is_set_up() -> bool:
    if _override is not None:
        return True
    k = keys()
    return bool(k.key_id and k.key_secret)


def _sign(secret: str, message: bytes) -> str:
    return hmac.new(secret.encode(), message, hashlib.sha256).hexdigest()


def checkout_signature_ok(order_id: str, payment_id: str, signature: str) -> bool:
    """What Razorpay Checkout gives the app: HMAC-SHA256(order_id|payment_id, key secret)."""
    secret = _override_secret("key") if _override is not None else keys().key_secret
    if not secret or not signature:
        return False
    return hmac.compare_digest(_sign(secret, f"{order_id}|{payment_id}".encode()), signature)


def webhook_signature_ok(body: bytes, signature: str) -> bool:
    """X-Razorpay-Signature: HMAC-SHA256(raw body, webhook secret)."""
    secret = _override_secret("webhook") if _override is not None else keys().webhook_secret
    if not secret or not signature:
        return False
    return hmac.compare_digest(_sign(secret, body), signature)


def _override_secret(kind: str) -> str:
    return str(getattr(_override, f"{kind}_secret", ""))


# --- A fake Razorpay for tests (and nothing else) ---


@dataclass
class FakeGateway:
    key_id: str = "rzp_test_fake"
    mode: str = "TEST"
    key_secret: str = "fake-key-secret"  # noqa: S105 (tests only)
    webhook_secret: str = "fake-webhook-secret"  # noqa: S105 (tests only)
    orders: dict[str, int] = field(default_factory=dict)
    payments: dict[str, list[GatewayPayment]] = field(default_factory=dict)
    refunds: dict[str, GatewayRefund] = field(default_factory=dict)
    refund_notes: dict[str, dict[str, str]] = field(default_factory=dict)
    fail: bool = False
    # The next refund is made at Razorpay but its answer is lost (timeout).
    lose_refund_answer: bool = False
    # Razorpay refuses refunds (a 4xx).
    refuse_refunds: bool = False
    calls: list[str] = field(default_factory=list)

    def _check(self, name: str) -> None:
        self.calls.append(name)
        if self.fail:
            raise GatewayError()

    def create_order(self, amount_paise: int, receipt: str, notes: dict[str, str]) -> str:
        self._check("create_order")
        order_id = f"order_{len(self.orders) + 1:06d}"
        self.orders[order_id] = amount_paise
        self.payments[order_id] = []
        return order_id

    def pay(
        self, order_id: str, *, status: str = "captured", amount: int | None = None
    ) -> GatewayPayment:
        """What a patient paying in Checkout would do."""
        payment = GatewayPayment(
            id=f"pay_{order_id[6:]}_{len(self.payments[order_id]) + 1}",
            order_id=order_id,
            status=status,
            amount=self.orders[order_id] if amount is None else amount,
            method="upi",
        )
        self.payments[order_id].append(payment)
        return payment

    def order_payments(self, order_id: str) -> list[GatewayPayment]:
        self._check("order_payments")
        return list(self.payments.get(order_id, []))

    def capture(self, payment_id: str, amount_paise: int) -> GatewayPayment:
        self._check("capture")
        for items in self.payments.values():
            for i, p in enumerate(items):
                if p.id == payment_id:
                    items[i] = GatewayPayment(
                        p.id, p.order_id, "captured", p.amount, p.currency, p.method
                    )
                    return items[i]
        raise GatewayError()

    def refund(self, payment_id: str, amount_paise: int, notes: dict[str, str]) -> GatewayRefund:
        self._check("refund")
        if self.refuse_refunds:
            raise GatewayError(details={"status": 400})
        refund = GatewayRefund(id=f"rfnd_{len(self.refunds) + 1:06d}", status="pending")
        self.refunds[refund.id] = refund
        self.refund_notes[refund.id] = {"payment_id": payment_id, **notes}
        self.calls.append(f"refund:{payment_id}:{amount_paise}")
        if self.lose_refund_answer:
            self.lose_refund_answer = False
            raise GatewayError()
        return refund

    def fetch_refund(self, payment_id: str, refund_id: str) -> GatewayRefund:
        self._check("fetch_refund")
        return self.refunds[refund_id]

    def find_refund(self, payment_id: str, our_refund_id: str) -> GatewayRefund | None:
        self._check("find_refund")
        for refund_id, notes in self.refund_notes.items():
            ours = notes.get("payment_id") == payment_id and notes.get("refund_id") == our_refund_id
            if ours and self.refunds[refund_id].status != "failed":
                return self.refunds[refund_id]
        return None

    def checkout_signature(self, order_id: str, payment_id: str) -> str:
        return _sign(self.key_secret, f"{order_id}|{payment_id}".encode())

    def webhook_signature(self, body: bytes) -> str:
        return _sign(self.webhook_secret, body)


def now() -> dt.datetime:
    return timezone.now()
