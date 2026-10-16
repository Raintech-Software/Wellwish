import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for BookingDetailOut
void main() {
  final BookingDetailOut? instance = /* BookingDetailOut(...) */ null;
  // TODO add properties to the entity

  group(BookingDetailOut, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String code
    test('to test the property `code`', () async {
      // TODO
    });

    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // BookingServiceOut service
    test('to test the property `service`', () async {
      // TODO
    });

    // String memberName
    test('to test the property `memberName`', () async {
      // TODO
    });

    // DateTime pickupAt
    test('to test the property `pickupAt`', () async {
      // TODO
    });

    // DateTime appointmentAt
    test('to test the property `appointmentAt`', () async {
      // TODO
    });

    // String hospitalName
    test('to test the property `hospitalName`', () async {
      // TODO
    });

    // DateTime createdAt
    test('to test the property `createdAt`', () async {
      // TODO
    });

    // Unpaid bookings expire at this time
    // DateTime payBy
    test('to test the property `payBy`', () async {
      // TODO
    });

    // BookingMemberOut member
    test('to test the property `member`', () async {
      // TODO
    });

    // BookingAddressOut address
    test('to test the property `address`', () async {
      // TODO
    });

    // String hospitalId
    test('to test the property `hospitalId`', () async {
      // TODO
    });

    // String doctorId
    test('to test the property `doctorId`', () async {
      // TODO
    });

    // String doctorName
    test('to test the property `doctorName`', () async {
      // TODO
    });

    // String notes
    test('to test the property `notes`', () async {
      // TODO
    });

    // List<BookingDocumentOut> documents
    test('to test the property `documents`', () async {
      // TODO
    });

    // List<BookingTimelineOut> timeline
    test('to test the property `timeline`', () async {
      // TODO
    });

    // The booking fee captured (0 until paid)
    // int paidPaise
    test('to test the property `paidPaise`', () async {
      // TODO
    });

    // List<BookingRefundOut> refunds
    test('to test the property `refunds`', () async {
      // TODO
    });

    // The patient can still cancel in the app
    // bool canCancel
    test('to test the property `canCancel`', () async {
      // TODO
    });

    // bool canReschedule
    test('to test the property `canReschedule`', () async {
      // TODO
    });

    // Why the time can't be changed: STATUS, TOO_LATE or LIMIT
    // String rescheduleProblem
    test('to test the property `rescheduleProblem`', () async {
      // TODO
    });

    // int reschedulesLeft
    test('to test the property `reschedulesLeft`', () async {
      // TODO
    });

    // The partner must confirm the new time
    // bool reconfirmNeeded
    test('to test the property `reconfirmNeeded`', () async {
      // TODO
    });

    // A payment is being confirmed with Razorpay (don't offer Pay)
    // bool paymentPending (default value: false)
    test('to test the property `paymentPending`', () async {
      // TODO
    });

    // Once a partner accepted (shown until the job is over)
    // AssignedPartnerOut partner
    test('to test the property `partner`', () async {
      // TODO
    });

    // From acceptance: the job's steps
    // VisitOut visit
    test('to test the property `visit`', () async {
      // TODO
    });

    // Your rating of the visit
    // ReviewOut review
    test('to test the property `review`', () async {
      // TODO
    });

    // Completed and not rated yet
    // bool canReview (default value: false)
    test('to test the property `canReview`', () async {
      // TODO
    });

    // Within 24 h after the visit
    // bool canReport (default value: false)
    test('to test the property `canReport`', () async {
      // TODO
    });

    // Problems you reported
    // List<TicketOut> tickets
    test('to test the property `tickets`', () async {
      // TODO
    });

    // Give it to the partner when they arrive (until that step is done)
    // String jobOtp
    test('to test the property `jobOtp`', () async {
      // TODO
    });

  });
}
