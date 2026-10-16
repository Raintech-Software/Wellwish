import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for PatientDetailOut
void main() {
  final PatientDetailOut? instance = /* PatientDetailOut(...) */ null;
  // TODO add properties to the entity

  group(PatientDetailOut, () {
    // PatientRowOut patient
    test('to test the property `patient`', () async {
      // TODO
    });

    // DateTime dob
    test('to test the property `dob`', () async {
      // TODO
    });

    // String gender
    test('to test the property `gender`', () async {
      // TODO
    });

    // String language
    test('to test the property `language`', () async {
      // TODO
    });

    // List<AdminMemberOut> members
    test('to test the property `members`', () async {
      // TODO
    });

    // List<AddressOut> addresses
    test('to test the property `addresses`', () async {
      // TODO
    });

    // false: this role may not see patient documents (§9.2)
    // bool documentsVisible
    test('to test the property `documentsVisible`', () async {
      // TODO
    });

    // List<PatientDocumentOut> documents
    test('to test the property `documents`', () async {
      // TODO
    });

    // false: this role may not see bookings
    // bool bookingsVisible
    test('to test the property `bookingsVisible`', () async {
      // TODO
    });

    // Latest first (at most 100)
    // List<AdminBookingRowOut> bookings
    test('to test the property `bookings`', () async {
      // TODO
    });

    // why it was blocked (when blocked)
    // String blockedReason (default value: '')
    test('to test the property `blockedReason`', () async {
      // TODO
    });

  });
}
