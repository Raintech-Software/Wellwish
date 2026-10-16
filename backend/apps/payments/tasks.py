"""Celery tasks for payments (ARCHITECTURE §10.5)."""

from celery import shared_task

from apps.payments import services
from apps.payments.gateway import GatewayError, PaymentsNotSetUp


@shared_task(name="payments.reconcile")
def reconcile() -> int:
    """Every 10 min: payments we didn't hear back about (§6.12)."""
    return services.reconcile()


@shared_task(name="payments.refund_status_sweep")
def refund_status_sweep() -> int:
    """Every 30 min: refunds sent to Razorpay but not reported back."""
    return services.refund_status_sweep()


@shared_task(
    name="payments.send_refund",
    autoretry_for=(GatewayError,),
    retry_backoff=60,
    max_retries=5,
)
def send_refund(refund_id: str) -> str:
    try:
        return services.send_refund(refund_id)
    except PaymentsNotSetUp:
        return "NOT_SET_UP"  # the 30-minute sweep sends it once the keys are entered
