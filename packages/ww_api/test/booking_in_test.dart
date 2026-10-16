import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for BookingIn
void main() {
  final BookingIn? instance = /* BookingIn(...) */ null;
  // TODO add properties to the entity

  group(BookingIn, () {
    // String serviceId
    test('to test the property `serviceId`', () async {
      // TODO
    });

    // Who the booking is for
    // String memberId
    test('to test the property `memberId`', () async {
      // TODO
    });

    // Pickup or home address (inside a service area)
    // String addressId
    test('to test the property `addressId`', () async {
      // TODO
    });

    // One of the times from booking-times
    // DateTime pickupAt
    test('to test the property `pickupAt`', () async {
      // TODO
    });

    // Hospital visits: the doctor appointment (same day, after pickup)
    // DateTime appointmentAt
    test('to test the property `appointmentAt`', () async {
      // TODO
    });

    // String hospitalId
    test('to test the property `hospitalId`', () async {
      // TODO
    });

    // Hospital not in the list: its name and area, typed in
    // String hospitalText (default value: '')
    test('to test the property `hospitalText`', () async {
      // TODO
    });

    // A doctor at the chosen hospital
    // String doctorId
    test('to test the property `doctorId`', () async {
      // TODO
    });

    // List<String> documentIds
    test('to test the property `documentIds`', () async {
      // TODO
    });

    // String notes (default value: '')
    test('to test the property `notes`', () async {
      // TODO
    });

  });
}
