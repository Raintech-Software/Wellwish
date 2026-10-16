import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for BookingTimesOut
void main() {
  final BookingTimesOut? instance = /* BookingTimesOut(...) */ null;
  // TODO add properties to the entity

  group(BookingTimesOut, () {
    // The date the times are for
    // DateTime date
    test('to test the property `date`', () async {
      // TODO
    });

    // Times that can be picked, soonest first
    // List<DateTime> times
    test('to test the property `times`', () async {
      // TODO
    });

    // Every date in the booking window
    // List<BookingDayOut> days
    test('to test the property `days`', () async {
      // TODO
    });

    // int timeStepMin
    test('to test the property `timeStepMin`', () async {
      // TODO
    });

    // Suggested pickup = doctor appointment minus this
    // int travelBufferMin
    test('to test the property `travelBufferMin`', () async {
      // TODO
    });

  });
}
