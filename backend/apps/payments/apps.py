from django.apps import AppConfig


class PaymentsConfig(AppConfig):
    name = "apps.payments"
    label = "payments"
    verbose_name = "Payments and refunds"

    def ready(self) -> None:
        from apps.bookings.services import register_cancel_hook, register_expiry_guard
        from apps.payments.services import payment_in_progress, refund_for_cancel

        # A booking whose payment is being confirmed doesn't expire meanwhile.
        register_expiry_guard(payment_in_progress)
        # Cancelling refunds the decided share of the fee, in the same transaction.
        register_cancel_hook(refund_for_cancel)
