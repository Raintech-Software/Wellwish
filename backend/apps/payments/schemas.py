"""Request/response schemas for payments and refunds."""

import datetime as dt
from typing import Annotated

from pydantic import Field, StringConstraints

from common.schemas import CamelSchema, Reason, StrictIn

Secret = Annotated[str, StringConstraints(strip_whitespace=True, max_length=128)]


class CheckoutOut(CamelSchema):
    """What the app opens Razorpay Checkout with."""

    key_id: str
    order_id: str
    amount_paise: int = Field(..., description="The booking fee, from the booking's snapshot")
    currency: str
    booking_code: str
    pay_by: dt.datetime


class VerifyIn(StrictIn):
    """What Razorpay Checkout gave the app."""

    razorpay_order_id: str = Field(..., min_length=1, max_length=64)
    razorpay_payment_id: str = Field(..., min_length=1, max_length=64)
    razorpay_signature: str = Field(..., min_length=1, max_length=128)


class BookingRefundOut(CamelSchema):
    """A refund as the patient sees it."""

    amount_paise: int
    percent: int
    status: str = Field(..., description="AWAITING_APPROVAL, PENDING, PROCESSED, FAILED, REJECTED")
    created_at: dt.datetime
    processed_at: dt.datetime | None


# --- Admin ---


class AdminPaymentOut(CamelSchema):
    id: str
    booking_id: str
    booking_code: str
    amount_paise: int
    status: str
    method: str
    mode: str
    razorpay_order_id: str
    razorpay_payment_id: str
    created_at: dt.datetime
    captured_at: dt.datetime | None
    failure_reason: str


class AdminRefundOut(CamelSchema):
    id: str
    booking_id: str
    booking_code: str
    amount_paise: int
    percent: int
    reason: str
    status: str
    razorpay_refund_id: str
    requested_by_type: str
    requested_by_name: str
    approved_by_name: str
    created_at: dt.datetime
    decided_at: dt.datetime | None
    processed_at: dt.datetime | None
    failure_reason: str


class RefundDecisionIn(StrictIn):
    reason: Reason


class GatewayKeysOut(CamelSchema):
    """The Razorpay keys in use. Secrets are never sent back: only whether they are set and their
    last 4 characters."""

    source: str = Field(..., description="ADMIN (entered here), ENVIRONMENT or NONE")
    key_id: str
    mode: str = Field(..., description="TEST, LIVE or empty")
    key_secret_set: bool
    key_secret_last4: str
    webhook_secret_set: bool
    webhook_secret_last4: str
    webhook_path: str = Field(..., description="Add this to the API's address in Razorpay")
    updated_at: dt.datetime | None
    updated_by: str


class GatewayKeysIn(StrictIn):
    key_id: str = Field(..., pattern=r"^rzp_(test|live)_[A-Za-z0-9]{6,40}$")
    key_secret: Secret = Field("", description="Blank = keep the saved one")
    webhook_secret: Secret = Field("", description="Blank = keep the saved one")


class FeeDayOut(CamelSchema):
    date: dt.date | None = Field(None, description="India date; null on the total row")
    payments: int
    collected_paise: int
    refunded_paise: int
    net_paise: int


class FeeReportOut(CamelSchema):
    """Fees collected per India date (Reports, 9.2), in paise."""

    start: dt.date
    end: dt.date
    days: list[FeeDayOut]
    total: FeeDayOut


class CancellationRowOut(CamelSchema):
    kind: str = Field(..., description="CANCELLED (a booking cancelled) · REFUND (after a visit)")
    booking_id: str
    code: str
    visit_date: dt.date
    service: str
    at: dt.datetime = Field(..., description="When it was cancelled / the refund was asked")
    by: str = Field(..., description="PATIENT · STAFF (an admin) · SYSTEM")
    reason: str
    refund_percent: int | None = None
    fee_paid_paise: int
    refunded_paise: int
    refund_status: str = Field(..., description="The latest refund's status, empty if none")


class CancellationsReportOut(CamelSchema):
    """Cancellations and refunds report (§9.1 Reports)."""

    start: dt.date
    end: dt.date
    rows: list[CancellationRowOut]
    cancelled: int
    refunded_paise: int
