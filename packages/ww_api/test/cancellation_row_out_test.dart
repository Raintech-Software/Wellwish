import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for CancellationRowOut
void main() {
  final CancellationRowOut? instance = /* CancellationRowOut(...) */ null;
  // TODO add properties to the entity

  group(CancellationRowOut, () {
    // CANCELLED (a booking cancelled) · REFUND (after a visit)
    // String kind
    test('to test the property `kind`', () async {
      // TODO
    });

    // String bookingId
    test('to test the property `bookingId`', () async {
      // TODO
    });

    // String code
    test('to test the property `code`', () async {
      // TODO
    });

    // DateTime visitDate
    test('to test the property `visitDate`', () async {
      // TODO
    });

    // String service
    test('to test the property `service`', () async {
      // TODO
    });

    // When it was cancelled / the refund was asked
    // DateTime at
    test('to test the property `at`', () async {
      // TODO
    });

    // PATIENT · STAFF (an admin) · SYSTEM
    // String by
    test('to test the property `by`', () async {
      // TODO
    });

    // String reason
    test('to test the property `reason`', () async {
      // TODO
    });

    // int refundPercent
    test('to test the property `refundPercent`', () async {
      // TODO
    });

    // int feePaidPaise
    test('to test the property `feePaidPaise`', () async {
      // TODO
    });

    // int refundedPaise
    test('to test the property `refundedPaise`', () async {
      // TODO
    });

    // The latest refund's status, empty if none
    // String refundStatus
    test('to test the property `refundStatus`', () async {
      // TODO
    });

  });
}
