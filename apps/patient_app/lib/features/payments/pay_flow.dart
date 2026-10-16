import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../booking/booking_flow.dart';
import '../home/home_screen.dart';
import '../session/session_controller.dart';
import 'payment_checkout.dart';
import 'payment_result_screen.dart';

/// Paying a booking's fee (P15 "Pay ₹X", or "Pay" on the booking page): the Razorpay order from
/// the server, Checkout, then the server confirms (§6.12). Ends on the payment result (P16).

enum PayOutcome {
  /// Razorpay confirmed: the booking is NEW.
  confirmed,

  /// Paid (or maybe paid), waiting for Razorpay's word: P16 asks the server again.
  processing,
  failed,
  cancelled,

  /// No Razorpay keys yet: the booking waits for payment.
  notSetUp,

  /// The payment time is over (nothing was paid).
  notPayable,

  /// The money arrived after the booking expired or its time was taken: it goes back in full.
  notBooked,
}

class PayResult {
  const PayResult(this.outcome);

  final PayOutcome outcome;
}

/// Statuses of a booking whose fee was paid.
const paidStatuses = {'NEW', 'OFFERED', 'ACCEPTED', 'IN_PROGRESS', 'COMPLETED', 'PATIENT_NO_SHOW'};

/// What a booking's status says about the payment that was just made.
PayOutcome outcomeOf(String status) => switch (status) {
  'PENDING_PAYMENT' => PayOutcome.processing,
  'EXPIRED' || 'CANCELLED' => PayOutcome.notBooked,
  _ => PayOutcome.confirmed,
};

Future<PayResult> payForBooking(
  ProviderContainer container, {
  required String bookingId,
  required String description,
}) async {
  final api = container.read(patientApiProvider);
  final CheckoutOut checkout;
  try {
    checkout = (await api.patientBookingCheckout(bookingId: bookingId)).data!;
  } catch (e) {
    final error = toApiException(e);
    switch (error.code) {
      case 'PAYMENTS_NOT_SET_UP':
        return const PayResult(PayOutcome.notSetUp);
      case 'PAYMENT_IN_PROGRESS':
        return const PayResult(PayOutcome.processing);
      case 'BOOKING_NOT_PAYABLE':
        // Already paid (a page opened before the confirmation came), or too late.
        final status = '${error.details['status'] ?? ''}';
        return PayResult(paidStatuses.contains(status) ? PayOutcome.confirmed : PayOutcome.notPayable);
    }
    rethrow;
  }
  final phone = container.read(sessionProvider).me?.phone ?? '';
  final outcome = await container
      .read(paymentCheckoutProvider)
      .open(checkout: checkout, description: '$description · ${checkout.bookingCode}', contact: phone);
  switch (outcome) {
    case CheckoutNotPaid(:final cancelled):
      return PayResult(cancelled ? PayOutcome.cancelled : PayOutcome.failed);
    case CheckoutUnknown():
      return const PayResult(PayOutcome.processing);
    case CheckoutPaid(:final orderId, :final paymentId, :final signature):
      try {
        final booking = (await api.patientPaymentVerify(
          verifyIn: VerifyIn(razorpayOrderId: orderId, razorpayPaymentId: paymentId, razorpaySignature: signature),
        )).data!;
        return PayResult(outcomeOf(booking.status));
      } catch (_) {
        // Checkout said paid: never invite a second payment. P16 asks the server until Razorpay
        // has confirmed it (or it is refunded).
        return const PayResult(PayOutcome.processing);
      }
  }
}

/// Pays, then shows the result above Home (back goes Home). Errors other than the expected ones
/// are rethrown for the caller to show.
Future<void> payAndShowResult(BuildContext context, {required String bookingId, required String description}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final router = GoRouter.of(context);
  final result = await payForBooking(container, bookingId: bookingId, description: description);
  bookingsChanged(container);
  container.invalidate(bookingDetailProvider(bookingId));
  router
    ..go(HomeScreen.path)
    ..push(PaymentResultScreen.pathFor(bookingId), extra: result);
}
