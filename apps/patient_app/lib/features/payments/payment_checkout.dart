import 'dart:async';

import 'package:flutter/widgets.dart' show Color;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_ui/ww_ui.dart';

/// Razorpay Checkout (UPI, card, netbanking) for a booking's fee (ARCHITECTURE §6.12). The app
/// never decides that a booking is paid: it sends what Checkout returned to the server, which
/// asks Razorpay. Swapped for a fake in tests.

sealed class CheckoutOutcome {
  const CheckoutOutcome();
}

/// Checkout says the patient paid (the server still confirms it).
class CheckoutPaid extends CheckoutOutcome {
  const CheckoutPaid({required this.orderId, required this.paymentId, required this.signature});

  final String orderId;
  final String paymentId;
  final String signature;
}

/// No answer from Checkout (it was closed by the phone, or never answered): only the server can
/// tell whether money arrived.
class CheckoutUnknown extends CheckoutOutcome {
  const CheckoutUnknown();
}

/// Closed by the patient, or the payment failed (also an outside wallet: Razorpay doesn't take
/// that money for us).
class CheckoutNotPaid extends CheckoutOutcome {
  const CheckoutNotPaid({required this.cancelled});

  final bool cancelled;
}

abstract class PaymentCheckout {
  Future<CheckoutOutcome> open({required CheckoutOut checkout, required String description, String contact = ''});
}

class RazorpayCheckout implements PaymentCheckout {
  /// Waited for after Checkout's own timeout before giving up on an answer.
  static const _margin = Duration(minutes: 2);

  @override
  Future<CheckoutOutcome> open({required CheckoutOut checkout, required String description, String contact = ''}) {
    final razorpay = Razorpay();
    final done = Completer<CheckoutOutcome>();
    Timer? giveUp;
    void finish(CheckoutOutcome outcome) {
      if (done.isCompleted) return;
      giveUp?.cancel();
      done.complete(outcome);
      razorpay.clear();
    }

    razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
        // An answer left over from an earlier Checkout (another order) isn't this one's.
        if (r.orderId != null && r.orderId != checkout.orderId) return;
        finish(CheckoutPaid(orderId: checkout.orderId, paymentId: r.paymentId ?? '', signature: r.signature ?? ''));
      })
      ..on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
        finish(CheckoutNotPaid(cancelled: r.code == Razorpay.PAYMENT_CANCELLED));
      })
      ..on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        (ExternalWalletResponse _) => finish(const CheckoutNotPaid(cancelled: false)),
      );
    // Checkout closes when the booking's payment time is up (at least a minute).
    var seconds = checkout.payBy.difference(DateTime.now()).inSeconds;
    if (seconds < 60) seconds = 60;
    giveUp = Timer(Duration(seconds: seconds) + _margin, () => finish(const CheckoutUnknown()));
    try {
      razorpay.open({
        'key': checkout.keyId,
        'order_id': checkout.orderId,
        'amount': checkout.amountPaise,
        'currency': checkout.currency,
        'name': 'WellWish',
        'description': description,
        if (contact.isNotEmpty) 'prefill': {'contact': contact},
        'theme': {'color': _hex(WWColors.primary)},
        'timeout': seconds,
        'retry': {'enabled': true, 'max_count': 3},
      });
    } catch (_) {
      finish(const CheckoutNotPaid(cancelled: false));
    }
    return done.future;
  }

  static String _hex(Color color) =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

final paymentCheckoutProvider = Provider<PaymentCheckout>((ref) => RazorpayCheckout());
