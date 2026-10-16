"""POST /v1/webhooks/razorpay (§10.3). No login: the signature (webhook secret) proves it is
Razorpay. Each event is handled once."""

from django.http import HttpRequest
from ninja import Router

from apps.payments import services
from common import metrics
from common.schemas import OkOut

router = Router(tags=["webhooks"])


@router.post("/razorpay", response=OkOut, auth=None, operation_id="webhookRazorpay")
def razorpay(request: HttpRequest) -> OkOut:
    """Razorpay events: payment.captured / order.paid (the booking becomes NEW), payment.failed,
    refund.processed / refund.failed. 400 BAD_SIGNATURE if the signature doesn't match."""
    try:
        services.handle_webhook(
            body=request.body,
            signature=request.headers.get("X-Razorpay-Signature", ""),
            event_id=request.headers.get("X-Razorpay-Event-Id", ""),
        )
    except services.BadWebhook:
        # §13: anyone can post a bad signature; many in a row = a wrong webhook secret
        metrics.count("WebhookBadSignatures")
        raise
    except Exception:
        metrics.count("WebhookFailures")  # §13 alarm (Razorpay retries a failed one)
        raise
    return OkOut()
