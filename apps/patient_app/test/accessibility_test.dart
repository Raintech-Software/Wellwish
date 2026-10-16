import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'booking_test.dart' show bookingRoutes, tapKey;
import 'payments_test.dart' show openBooking, withBooking;
import 'support.dart';
import 'visit_test.dart' show visitDetail;

/// PHASES 9.8: the key screens have big tap targets (at least 48 × 48 dp, Android's guideline)
/// and a label on everything tappable (for TalkBack), also with the phone's largest text (200 %).
Future<void> meetsTapGuidelines(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
}

void largestText(WidgetTester tester) {
  tester.platformDispatcher.textScaleFactorTestValue = 2;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

void main() {
  for (final scale in [1.0, 2.0]) {
    group('text ${(scale * 100).round()} %', () {
      testWidgets('login and the code screen', (tester) async {
        final semantics = tester.ensureSemantics();
        if (scale > 1) largestText(tester);
        final backend = FakeBackend({
          'GET /v1/public/app-config': (_) => (200, appConfig()),
          'POST /v1/auth/otp/send': (_) => (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 30, 'length': 6}),
        });
        await pumpPatientApp(tester, backend);
        await meetsTapGuidelines(tester);
        await tester.enterText(find.byType(TextField), '9876543210');
        await scrollTo(tester, find.text('Send OTP'));
        await tester.tap(find.text('Send OTP'));
        await tester.pumpAndSettle();
        expect(find.text('Verify your number'), findsOneWidget);
        await meetsTapGuidelines(tester);
        semantics.dispose();
      });

      testWidgets('Home, the services and the visit details', (tester) async {
        final semantics = tester.ensureSemantics();
        if (scale > 1) largestText(tester);
        await pumpPatientApp(tester, FakeBackend({...bookingRoutes()}), loggedIn: true);
        await meetsTapGuidelines(tester);
        await scrollTo(tester, find.text('Book a Companion'));
        await tester.tap(find.text('Book a Companion'));
        await tester.pumpAndSettle();
        expect(find.text('Choose the service you need'), findsOneWidget);
        await meetsTapGuidelines(tester);
        await tapKey(tester, 'service-s-1');
        expect(find.text('Visit details'), findsOneWidget);
        await meetsTapGuidelines(tester);
        semantics.dispose();
      });

      testWidgets('a visit in progress: the booking, live tracking and SOS', (tester) async {
        final semantics = tester.ensureSemantics();
        if (scale > 1) largestText(tester);
        final backend = FakeBackend(
          withBooking(
            () => visitDetail(status: 'IN_PROGRESS', done: ['ON_THE_WAY'], otp: '4821'),
            more: {
              'GET /v1/patient/bookings/b-1/live': (_) => (
                200,
                {'bookingId': 'b-1', 'lat': null, 'lng': null, 'at': null, 'etaMin': null, 'step': 'ON_THE_WAY'},
              ),
            },
          ),
        );
        await pumpPatientApp(tester, backend, loggedIn: true);
        await openBooking(tester);
        await meetsTapGuidelines(tester);
        await tapKey(tester, 'track-live');
        expect(find.text('Live visit'), findsOneWidget);
        await meetsTapGuidelines(tester);
        await tapKey(tester, 'sos');
        expect(find.byKey(const Key('send-sos')), findsOneWidget);
        await meetsTapGuidelines(tester);
        semantics.dispose();
      });
    });
  }
}
