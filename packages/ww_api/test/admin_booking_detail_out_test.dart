import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for AdminBookingDetailOut
void main() {
  final AdminBookingDetailOut? instance = /* AdminBookingDetailOut(...) */ null;
  // TODO add properties to the entity

  group(AdminBookingDetailOut, () {
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

    // The account was erased (§12)
    // bool patientDeleted
    test('to test the property `patientDeleted`', () async {
      // TODO
    });

    // String serviceName
    test('to test the property `serviceName`', () async {
      // TODO
    });

    // String partnerType
    test('to test the property `partnerType`', () async {
      // TODO
    });

    // String visitType
    test('to test the property `visitType`', () async {
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

    // String memberName
    test('to test the property `memberName`', () async {
      // TODO
    });

    // String patientPhone
    test('to test the property `patientPhone`', () async {
      // TODO
    });

    // String hospitalName
    test('to test the property `hospitalName`', () async {
      // TODO
    });

    // int bookingFeePaise
    test('to test the property `bookingFeePaise`', () async {
      // TODO
    });

    // DateTime createdAt
    test('to test the property `createdAt`', () async {
      // TODO
    });

    // §6.19: the partner is a temporary one (admin panel only)
    // bool temporaryPartner (default value: false)
    test('to test the property `temporaryPartner`', () async {
      // TODO
    });

    // BookingServiceOut service
    test('to test the property `service`', () async {
      // TODO
    });

    // AdminBookingPatientOut patient
    test('to test the property `patient`', () async {
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

    // String hospitalText
    test('to test the property `hospitalText`', () async {
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

    // Empty when notes_visible is false
    // String notes
    test('to test the property `notes`', () async {
      // TODO
    });

    // The patient's notes can be medical: only roles with patients.documents
    // bool notesVisible
    test('to test the property `notesVisible`', () async {
      // TODO
    });

    // int rescheduleCount
    test('to test the property `rescheduleCount`', () async {
      // TODO
    });

    // False: the role can't see patient documents (titles hidden)
    // bool documentsVisible
    test('to test the property `documentsVisible`', () async {
      // TODO
    });

    // List<BookingDocumentOut> documents
    test('to test the property `documents`', () async {
      // TODO
    });

    // List<AdminBookingEventOut> timeline
    test('to test the property `timeline`', () async {
      // TODO
    });

    // bool reconfirmNeeded
    test('to test the property `reconfirmNeeded`', () async {
      // TODO
    });

    // List<AdminPaymentOut> payments
    test('to test the property `payments`', () async {
      // TODO
    });

    // List<AdminRefundOut> refunds
    test('to test the property `refunds`', () async {
      // TODO
    });

    // bool canCancel
    test('to test the property `canCancel`', () async {
      // TODO
    });

    // bool canReschedule
    test('to test the property `canReschedule`', () async {
      // TODO
    });

    // Pickup times are on this step (reschedule picker)
    // int timeStepMin
    test('to test the property `timeStepMin`', () async {
      // TODO
    });

    // From acceptance: the job's steps
    // VisitOut visit
    test('to test the property `visit`', () async {
      // TODO
    });

    // The fee that paid for the booking
    // int paidPaise
    test('to test the property `paidPaise`', () async {
      // TODO
    });

  });
}
