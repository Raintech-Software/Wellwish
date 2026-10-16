import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'jobs_test.dart' show approved, tapKey;
import 'support.dart';
import 'visit_test.dart' show openJob;

/// PHASES 9.8: the key screens have big tap targets (at least 48 × 48 dp, Android's guideline)
/// and a label on everything tappable (for TalkBack), also with the phone's largest text (200 %).
/// The login and code screens are shared (ww_auth) and checked in the patient app's test.
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
      testWidgets('Home with an offer, and the offer', (tester) async {
        final semantics = tester.ensureSemantics();
        if (scale > 1) largestText(tester);
        final backend = Backend(
          approved(
            extra: {
              'GET /v1/partner/home': () => (200, homeJson(available: true, selfie: true, offers: [offerJson()])),
              'GET /v1/partner/offers/a-1': () => (200, offerJson()),
            },
          ),
        );
        await pumpPartnerApp(tester, backend);
        await meetsTapGuidelines(tester);
        await tapKey(tester, 'offer-a-1');
        expect(find.text('Booking offer'), findsOneWidget);
        await meetsTapGuidelines(tester);
        semantics.dispose();
      });

      testWidgets('the job in progress: steps, the visit code and SOS', (tester) async {
        final semantics = tester.ensureSemantics();
        if (scale > 1) largestText(tester);
        final backend = Backend(
          approved(
            extra: {
              'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
              'GET /v1/partner/jobs/b-1': () => (
                200,
                jobJson(
                  status: 'IN_PROGRESS',
                  visit: visitJson(done: ['ON_THE_WAY', 'REACHED_PATIENT']),
                ),
              ),
            },
          ),
        );
        await pumpPartnerApp(tester, backend);
        await openJob(tester);
        expect(find.byKey(const Key('active-job')), findsOneWidget);
        await meetsTapGuidelines(tester);
        await tapKey(tester, 'next-step'); // "Picked up" needs the family's code
        expect(find.byKey(const Key('otp-input')), findsOneWidget);
        await meetsTapGuidelines(tester);
        await tester.tapAt(const Offset(10, 10)); // close the sheet
        await tester.pumpAndSettle();
        await tapKey(tester, 'sos');
        expect(find.byKey(const Key('send-sos')), findsOneWidget);
        await meetsTapGuidelines(tester);
        semantics.dispose();
      });
    });
  }
}
