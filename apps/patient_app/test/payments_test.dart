import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_app/features/payments/payment_checkout.dart';

import 'booking_test.dart'
    show bookingDetail, bookingRoutes, bookingRow, checkoutFor, istAt, payableUntil, tapKey, times, tomorrow;
import 'fixtures.dart';
import 'support.dart';

/// Payment, cancel, refund and reschedule in the patient app (PHASES 6.8, 6.9).

/// Opens booking b-1 from the Home card (scrolled to first: with large text it's lower down).
Future<void> openBooking(WidgetTester tester) async {
  await scrollTo(tester, find.byKey(const Key('next-booking')));
  await tester.tap(find.byKey(const Key('next-booking')));
  await tester.pumpAndSettle();
}

Map<String, Handler> withBooking(Map<String, Object?> Function() detail, {Map<String, Handler> more = const {}}) => {
  ...bookingRoutes(),
  'GET /v1/patient/bookings': (_) => (200, page([bookingRow(status: detail()['status']! as String)])),
  'GET /v1/patient/bookings/b-1': (_) => (200, detail()),
  ...more,
};

void main() {
  testWidgets('payment not set up yet: the booking waits for payment (no Checkout)', (tester) async {
    final checkout = FakeCheckout();
    final backend = FakeBackend(
      withBooking(
        () => bookingDetail(payBy: payableUntil()),
        more: {
          'POST /v1/patient/bookings/b-1/checkout': (_) => (
            503,
            {
              'error': {'code': 'PAYMENTS_NOT_SET_UP', 'message': 'not yet', 'details': {}},
            },
          ),
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true, checkout: checkout);
    await openBooking(tester);
    expect(find.text('Pay by', findRichText: true), findsNothing);
    await tapKey(tester, 'booking-pay');
    expect(checkout.opened, isEmpty);
    expect(find.text('Booking saved'), findsOneWidget);
    expect(find.textContaining("Online payment isn't available right now"), findsOneWidget);
  });

  testWidgets('Checkout closed: "Payment cancelled", then Pay again works (P16)', (tester) async {
    var paid = false;
    var checkouts = 0;
    final checkout = FakeCheckout([const CheckoutNotPaid(cancelled: true)]);
    final backend = FakeBackend(
      withBooking(
        () => paid ? bookingDetail(status: 'NEW', paid: 10000) : bookingDetail(payBy: payableUntil()),
        more: {
          'POST /v1/patient/bookings/b-1/checkout': (_) {
            checkouts++;
            return (200, checkoutFor());
          },
          'POST /v1/patient/payments/verify': (_) {
            paid = true;
            return (200, bookingDetail(status: 'NEW', paid: 10000));
          },
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true, checkout: checkout);
    await openBooking(tester);
    await tapKey(tester, 'booking-pay');
    expect(find.byKey(const Key('pay-result-cancelled')), findsOneWidget);
    expect(find.text('Payment cancelled'), findsOneWidget);
    expect(find.textContaining('You can try again until'), findsOneWidget);
    expect(backend.calls, isNot(contains('POST /v1/patient/payments/verify')));

    await tapKey(tester, 'pay-again');
    expect(checkouts, 2);
    expect(find.byKey(const Key('pay-result-confirmed')), findsOneWidget);
    // back goes Home (one result screen, not two)
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('next-booking')), findsOneWidget);
  });

  testWidgets('paid but not yet confirmed: checks again until Razorpay confirms', (tester) async {
    var gets = 0;
    final backend = FakeBackend(
      withBooking(
        () => gets >= 3 ? bookingDetail(status: 'NEW', paid: 10000) : bookingDetail(payBy: payableUntil()),
        more: {
          'POST /v1/patient/bookings/b-1/checkout': (_) => (200, checkoutFor()),
          'POST /v1/patient/payments/verify': (_) => (200, bookingDetail(payBy: payableUntil())),
        },
      ),
    );
    final get = backend.routes['GET /v1/patient/bookings/b-1']!;
    backend.routes['GET /v1/patient/bookings/b-1'] = (request) {
      gets++;
      return get(request);
    };
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    await tester.tap(find.byKey(const Key('booking-pay')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const Key('pay-result-processing')), findsOneWidget);
    expect(find.text('Confirming your payment…'), findsOneWidget);
    for (var i = 0; i < 4 && find.byKey(const Key('pay-result-confirmed')).evaluate().isEmpty; i++) {
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byKey(const Key('pay-result-confirmed')), findsOneWidget);
    // no more checks once confirmed
    final calls = gets;
    await tester.pump(const Duration(seconds: 10));
    expect(gets, calls);
    await tester.pumpAndSettle();
  });

  testWidgets('cancel before the partner is on the way: refund shown, reason sent (W-P4)', (tester) async {
    var cancelled = false;
    RequestOptions? sent;
    final backend = FakeBackend(
      withBooking(
        () => cancelled
            ? bookingDetail(
                status: 'CANCELLED',
                paid: 10000,
                refunds: [
                  {
                    'amountPaise': 5000,
                    'percent': 50,
                    'status': 'PENDING',
                    'createdAt': '2026-10-09T11:00:00Z',
                    'processedAt': null,
                  },
                ],
              )
            : bookingDetail(status: 'ACCEPTED', paid: 10000),
        more: {
          'GET /v1/patient/bookings/b-1/cancel-preview': (_) =>
              (200, {'allowed': true, 'paidPaise': 10000, 'refundPercent': 50, 'refundPaise': 5000}),
          'POST /v1/patient/bookings/b-1/cancel': (request) {
            sent = request;
            cancelled = true;
            return (200, bookingDetail(status: 'CANCELLED', paid: 10000));
          },
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.text('Paid ₹100'), findsOneWidget);
    await tapKey(tester, 'cancel-booking');
    expect(find.text('Cancel this booking?'), findsOneWidget);
    expect(find.textContaining("You'll get back ₹50 (50% of the booking fee)"), findsOneWidget);
    await tester.tap(find.byKey(const Key('reason-mistake')));
    await tester.enterText(find.byKey(const Key('cancel-more')), 'Wrong day');
    await tester.pumpAndSettle();
    await tapKey(tester, 'confirm-cancel');
    expect(bodyOf(sent!)['reason'], 'BOOKED_BY_MISTAKE: Wrong day');
    expect(find.text('Booking cancelled.'), findsOneWidget);
    await scrollTo(tester, find.text('Cancelled'), up: true);
    expect(find.text('Cancelled'), findsOneWidget);
    await scrollTo(tester, find.text('Refunds'));
    expect(find.text('₹50'), findsOneWidget);
    expect(find.text('On its way'), findsOneWidget);
    expect(find.byKey(const Key('cancel-booking')), findsNothing);
    expect(find.byKey(const Key('change-time')), findsNothing);
  });

  testWidgets('partner on the way: no cancel in the app', (tester) async {
    final backend = FakeBackend(withBooking(() => bookingDetail(status: 'IN_PROGRESS', paid: 10000)));
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.byKey(const Key('cancel-booking')), findsNothing);
    expect(find.byKey(const Key('booking-pay')), findsNothing);
  });

  testWidgets('a partner accepts: the booking updates live and shows Your partner (7.17)', (tester) async {
    final socket = FakeSocket();
    var accepted = false;
    final backend = FakeBackend(
      withBooking(
        () => bookingDetail(
          status: accepted ? 'ACCEPTED' : 'NEW',
          paid: 10000,
          partner: accepted
              ? {
                  'fullName': 'Rashmita Behera',
                  'role': 'COMPANION',
                  'photoUrl': null,
                  'phone': '+919000000011',
                  'ratingAvg': '4.80',
                  'ratingCount': 12,
                }
              : null,
        ),
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true, socket: socket);
    await openBooking(tester);
    expect(find.byKey(const Key('your-partner')), findsNothing);
    accepted = true;
    socket.messages.add({
      'type': 'booking.updated',
      'data': {'bookingId': 'b-1', 'status': 'ACCEPTED'},
    });
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('your-partner')), findsOneWidget);
    expect(find.text('Your partner'), findsOneWidget);
    expect(find.text('Rashmita Behera'), findsOneWidget);
    expect(find.text('Companion'), findsOneWidget);
    expect(find.text('4.8 (12 reviews)'), findsOneWidget);
    expect(find.text('Call Rashmita'), findsOneWidget);
  });

  testWidgets('paid, then a partner accepts while the result is open: it says so (9.11)', (tester) async {
    final socket = FakeSocket();
    var paid = false;
    var accepted = false;
    final backend = FakeBackend(
      withBooking(
        () => bookingDetail(
          status: accepted ? 'ACCEPTED' : (paid ? 'NEW' : 'PENDING_PAYMENT'),
          paid: paid ? 10000 : 0,
          payBy: paid ? null : payableUntil(),
        ),
        more: {
          'POST /v1/patient/bookings/b-1/checkout': (_) => (200, checkoutFor()),
          'POST /v1/patient/payments/verify': (_) {
            paid = true;
            return (200, bookingDetail(status: 'NEW', paid: 10000));
          },
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true, socket: socket);
    await openBooking(tester);
    await scrollTo(tester, find.byKey(const Key('booking-pay')));
    await tester.tap(find.byKey(const Key('booking-pay')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pay-result-confirmed')), findsOneWidget);
    expect(find.textContaining("We're assigning your partner"), findsOneWidget);
    accepted = true;
    socket.messages.add({
      'type': 'booking.updated',
      'data': {'bookingId': 'b-1', 'status': 'ACCEPTED'},
    });
    await tester.pumpAndSettle();
    expect(find.text('Partner assigned'), findsOneWidget);
    expect(find.textContaining("We're assigning your partner"), findsNothing);
  });

  testWidgets('a finished job: the partner stays, their phone does not', (tester) async {
    final backend = FakeBackend(
      withBooking(
        () => bookingDetail(
          status: 'COMPLETED',
          paid: 10000,
          partner: {
            'fullName': 'Rashmita Behera',
            'role': 'NURSE',
            'photoUrl': null,
            'phone': '',
            'ratingAvg': null,
            'ratingCount': 0,
          },
        ),
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.text('Nurse'), findsOneWidget);
    expect(find.text('New partner'), findsOneWidget);
    expect(find.byKey(const Key('call-partner')), findsNothing);
  });

  testWidgets('change the date and time (P30)', (tester) async {
    RequestOptions? sent;
    var moved = false;
    final backend = FakeBackend(
      withBooking(
        () => moved
            ? {
                ...bookingDetail(status: 'ACCEPTED', paid: 10000, reschedulesLeft: 1, reconfirm: true),
                'pickupAt': istAt(tomorrow.add(const Duration(days: 1)), 10, 0),
              }
            : bookingDetail(status: 'ACCEPTED', paid: 10000),
        more: {
          'GET /v1/patient/bookings/b-1/reschedule-times': (request) {
            final date = request.queryParameters['date'];
            return (200, times(day: date == null ? null : DateTime.parse(date.toString().substring(0, 10))));
          },
          'POST /v1/patient/bookings/b-1/reschedule': (request) {
            sent = request;
            moved = true;
            return (200, bookingDetail(status: 'ACCEPTED', paid: 10000));
          },
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.text('2 changes left'), findsOneWidget);
    await tapKey(tester, 'change-time');
    expect(find.text('Change date or time'), findsWidgets);
    expect(find.textContaining('Now:'), findsOneWidget);
    // unchanged: nothing to confirm
    final confirm = find.byKey(const Key('confirm-new-time'));
    await scrollTo(tester, confirm);
    expect(
      tester.widget<ElevatedButton>(find.descendant(of: confirm, matching: find.byType(ElevatedButton))).onPressed,
      isNull,
    );
    expect(find.text('Your partner will confirm the new time.'), findsOneWidget);

    final dayAfter = tomorrow.add(const Duration(days: 1));
    final key =
        'day-${dayAfter.year}-${dayAfter.month.toString().padLeft(2, '0')}-${dayAfter.day.toString().padLeft(2, '0')}';
    await tapKey(tester, key);
    await tapKey(tester, 'time-10:00');
    await tapKey(tester, 'confirm-new-time');
    expect(bodyOf(sent!)['pickupAt'], istAt(dayAfter, 10, 0));
    expect(find.text('Time changed.'), findsOneWidget);
    expect(find.text('1 change left'), findsOneWidget);
    await scrollTo(tester, find.text('Your partner will confirm the new time.'), up: true); // reconfirm note
    expect(find.text('Your partner will confirm the new time.'), findsOneWidget);
  });

  testWidgets('too close to pickup: the time cannot be changed', (tester) async {
    final backend = FakeBackend(
      withBooking(() => bookingDetail(status: 'NEW', paid: 10000, canReschedule: false, rescheduleProblem: 'TOO_LATE')),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.textContaining("It's too close to the pickup"), findsOneWidget);
    final button = find.byKey(const Key('change-time'));
    expect(
      tester.widget<OutlinedButton>(find.descendant(of: button, matching: find.byType(OutlinedButton))).onPressed,
      isNull,
    );
  });

  testWidgets('My bookings: upcoming, ongoing, past tabs (P17)', (tester) async {
    final buckets = <String>[];
    final backend = FakeBackend({
      ...bookingRoutes(),
      'GET /v1/patient/bookings': (request) {
        final bucket = request.queryParameters['bucket'].toString();
        buckets.add(bucket);
        return (200, page(bucket == 'upcoming' ? [bookingRow(status: 'NEW')] : []));
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Profile');
    await tester.tap(find.text('My Bookings'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('booking-WW-10001')), findsOneWidget);
    await tester.tap(find.byKey(const Key('tab-past')));
    await tester.pumpAndSettle();
    expect(find.text('No past bookings yet.'), findsOneWidget);
    expect(buckets, containsAll(['upcoming', 'past']));
    await tester.tap(find.byKey(const Key('tab-upcoming')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('booking-WW-10001')));
    await tester.pumpAndSettle();
    expect(find.text('Booking WW-10001'), findsOneWidget);
  });

  testWidgets('Checkout said paid but verify failed: no second payment, checks instead', (tester) async {
    var checkouts = 0;
    var confirmed = false;
    final backend = FakeBackend(
      withBooking(
        () => confirmed ? bookingDetail(status: 'NEW', paid: 10000) : bookingDetail(payBy: payableUntil()),
        more: {
          'POST /v1/patient/bookings/b-1/checkout': (_) {
            checkouts++;
            return (200, checkoutFor());
          },
          'POST /v1/patient/payments/verify': (_) => (
            500,
            {
              'error': {'code': 'SERVER_ERROR', 'message': 'oops', 'details': {}},
            },
          ),
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    await tester.tap(find.byKey(const Key('booking-pay')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const Key('pay-result-processing')), findsOneWidget);
    expect(find.byKey(const Key('pay-again')), findsNothing);
    confirmed = true; // the webhook arrives
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('pay-result-confirmed')), findsOneWidget);
    expect(checkouts, 1);
    await tester.pumpAndSettle();
  });

  testWidgets('paid after the booking expired: "Booking not made", money returned', (tester) async {
    final backend = FakeBackend(
      withBooking(
        () => bookingDetail(payBy: payableUntil()),
        more: {
          'POST /v1/patient/bookings/b-1/checkout': (_) => (200, checkoutFor()),
          'POST /v1/patient/payments/verify': (_) => (200, bookingDetail(status: 'EXPIRED')),
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    await tapKey(tester, 'booking-pay');
    expect(find.byKey(const Key('pay-result-notBooked')), findsOneWidget);
    expect(find.text('Booking not made'), findsOneWidget);
    expect(find.textContaining('returned in full'), findsOneWidget);
  });

  testWidgets('a payment being confirmed: no Pay button on the booking', (tester) async {
    final backend = FakeBackend(withBooking(() => {...bookingDetail(payBy: payableUntil()), 'paymentPending': true}));
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.byKey(const Key('booking-pay')), findsNothing);
    expect(find.byKey(const Key('payment-confirming')), findsOneWidget);
  });

  testWidgets('an old booking page paying an already paid booking shows it confirmed', (tester) async {
    final backend = FakeBackend(
      withBooking(
        () => bookingDetail(payBy: payableUntil()),
        more: {
          'POST /v1/patient/bookings/b-1/checkout': (_) => (
            409,
            {
              'error': {
                'code': 'BOOKING_NOT_PAYABLE',
                'message': 'paid',
                'details': {'status': 'NEW'},
              },
            },
          ),
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    await tapKey(tester, 'booking-pay');
    expect(find.byKey(const Key('pay-result-confirmed')), findsOneWidget);
  });

  testWidgets('payment result in Hindi', (tester) async {
    final checkout = FakeCheckout([const CheckoutNotPaid(cancelled: false)]);
    final backend = FakeBackend({
      ...withBooking(
        () => bookingDetail(payBy: payableUntil()),
        more: {'POST /v1/patient/bookings/b-1/checkout': (_) => (200, checkoutFor())},
      ),
      ...loggedInRoutes(language: 'hi'),
    });
    await pumpPatientApp(tester, backend, loggedIn: true, checkout: checkout);
    await openBooking(tester);
    await tapKey(tester, 'booking-pay');
    expect(find.byKey(const Key('pay-result-failed')), findsOneWidget);
    expect(find.byKey(const Key('pay-again')), findsOneWidget);
  });
}
