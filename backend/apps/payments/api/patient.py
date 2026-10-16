"""Patient payment endpoints (§10.3): the Razorpay order for a booking and the app's callback.
The booking becomes NEW only when Razorpay says the money was captured (§6.12)."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.bookings import selectors as booking_selectors
from apps.bookings.api.patient import booking_out
from apps.bookings.schemas import BookingDetailOut
from apps.payments import services
from apps.payments.schemas import CheckoutOut, VerifyIn
from common.auth import get_principal

router = Router(tags=["patient"])


@router.post(
    "/bookings/{uuid:booking_id}/checkout",
    response=CheckoutOut,
    by_alias=True,
    operation_id="patientBookingCheckout",
)
def checkout(request: HttpRequest, booking_id: UUID) -> CheckoutOut:
    """The Razorpay order to pay this booking's fee with (P15 "Pay ₹X", or "Pay now" on the
    booking). The same open order is returned again on a retry. 409 BOOKING_NOT_PAYABLE after the
    payment time; 503 PAYMENTS_NOT_SET_UP before the keys are entered."""
    booking = booking_selectors.own_booking(get_principal(request).subject_id, str(booking_id))
    c = services.checkout(booking=booking)
    return CheckoutOut(
        key_id=c.key_id,
        order_id=c.order_id,
        amount_paise=c.amount_paise,
        currency=c.currency,
        booking_code=c.booking_code,
        pay_by=c.pay_by,
    )


@router.post(
    "/payments/verify",
    response=BookingDetailOut,
    by_alias=True,
    operation_id="patientPaymentVerify",
)
def verify(request: HttpRequest, data: VerifyIn) -> BookingDetailOut:
    """What Razorpay Checkout returned. Returns the booking: `NEW` once Razorpay confirms the
    money, else still `PENDING_PAYMENT` (show "processing": the webhook finishes it). 422
    INVALID_SIGNATURE if the signature doesn't match."""
    user_id = get_principal(request).subject_id
    booking = services.verify(
        user_id=user_id,
        order_id=data.razorpay_order_id,
        payment_id=data.razorpay_payment_id,
        signature=data.razorpay_signature,
    )
    return booking_out(booking_selectors.own_booking(user_id, str(booking.pk)))
