import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';


/// tests for WebhooksApi
void main() {
  final instance = WwApi().getWebhooksApi();

  group(WebhooksApi, () {
    // Razorpay
    //
    // Razorpay events: payment.captured / order.paid (the booking becomes NEW), payment.failed, refund.processed / refund.failed. 400 BAD_SIGNATURE if the signature doesn't match.
    //
    //Future<OkOut> webhookRazorpay() async
    test('test webhookRazorpay', () async {
      // TODO
    });

  });
}
