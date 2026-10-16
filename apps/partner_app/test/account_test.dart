import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partner_app/features/home/approved_shell.dart';
import 'package:partner_app/features/session/consent_screen.dart';
import 'package:partner_app/features/session/session_controller.dart';
import 'package:partner_app/router.dart';
import 'package:ww_core/ww_core.dart';

import 'fixtures.dart';
import 'support.dart';

/// The Partner Terms and Privacy Policy, and "Delete my account" (ARCHITECTURE §6.20, 9B.8).

Map<String, dynamic> withConsents(Map<String, dynamic> me) => {
  ...me,
  'consentsNeeded': [
    {'type': 'PARTNER_TERMS', 'version': '2026-10'},
    {'type': 'PRIVACY', 'version': '2026-10'},
  ],
};

Map<String, Object> refusal(String code) => {
  'error': {'code': code, 'message': 'x', 'details': <String, Object>{}},
};

void main() {
  testWidgets('the Partner Terms and Privacy Policy come first, each readable', (tester) async {
    var me = withConsents(meJson(null));
    final opened = <String>[];
    final backend = Backend({
      ...baseRoutes(null, kyc),
      'GET /v1/partner/me': () => (200, me),
      'POST /v1/partner/me/consents': () {
        me = meJson(null);
        return (200, me);
      },
    });
    await pumpPartnerApp(tester, backend, openedPages: opened);
    expect(find.text('Before you start'), findsOneWidget);
    expect(find.text('Become a WellWish partner'), findsNothing); // registration waits

    await tester.tap(find.text('Read the Partner Terms'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Read the Privacy Policy'));
    await tester.pumpAndSettle();
    expect(opened, ['http://10.0.2.2:8000/legal/partner-terms?l=en', 'http://10.0.2.2:8000/legal/privacy?l=en']);

    final agree = find.byKey(const Key('consent-agree'));
    await tester.tap(find.text('I accept the Partner Terms'));
    await tester.pump();
    expect(
      tester.widget<ElevatedButton>(find.descendant(of: agree, matching: find.byType(ElevatedButton))).onPressed,
      isNull,
    ); // both are needed
    await tester.tap(find.text('I accept the Privacy Policy'));
    await tester.pump();
    await tester.tap(agree);
    await tester.pumpAndSettle();
    expect(backend.bodies['POST /v1/partner/me/consents'], contains('PARTNER_TERMS'));
    expect(find.text('Become a WellWish partner'), findsOneWidget);
  });

  testWidgets('an approved partner is asked too, before the work screens', (tester) async {
    final backend = Backend({
      ...baseRoutes('APPROVED', () => kyc(status: 'APPROVED', done: true)),
      'GET /v1/partner/me': () => (200, withConsents(meJson('APPROVED'))),
      'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
    });
    await pumpPartnerApp(tester, backend);
    expect(find.text('Before you start'), findsOneWidget);
    expect(find.text('Hello, Asha'), findsNothing);
  });

  testWidgets('delete my account from the Profile tab logs out; a job still theirs refuses it', (tester) async {
    var refuse = true;
    final backend = Backend({
      ...baseRoutes('APPROVED', () => kyc(status: 'APPROVED', done: true)),
      'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
      'POST /v1/partner/me/delete': () =>
          refuse ? (409, refusal('ACTIVE_JOBS')) : (200, {'dueAt': '2026-10-21T10:00:00Z', 'done': false}),
    });
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    final delete = find.byKey(const Key('delete-account'));
    await tester.scrollUntilVisible(delete, 300, scrollable: find.byType(Scrollable).hitTestable().first);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(find.text('Delete your account?'), findsOneWidget);
    expect(find.textContaining('deleted after 10 days'), findsOneWidget); // the admin's setting (app default 7)
    await tester.tap(find.byKey(const Key('confirm-delete-account')));
    await tester.pumpAndSettle();
    expect(find.text('You have an accepted or ongoing job. Ask WellWish to move it, then try again.'), findsOneWidget);

    refuse = false;
    await tester.tap(delete);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete-account')));
    await tester.pumpAndSettle();
    expect(backend.calls.where((c) => c == 'POST /v1/partner/me/delete').length, 2);
    expect(find.text('Your account will be deleted soon. Log in again to keep it.'), findsOneWidget);
  });

  testWidgets('the links open in the app language (Hindi)', (tester) async {
    final opened = <String>[];
    final backend = Backend({
      ...baseRoutes(null, kyc),
      'GET /v1/partner/me': () => (200, withConsents({...meJson(null), 'language': 'hi'})),
    });
    await pumpPartnerApp(tester, backend, openedPages: opened);
    await tester.tap(find.text('पार्टनर की शर्तें पढ़ें'));
    await tester.pumpAndSettle();
    expect(opened, ['http://10.0.2.2:8000/legal/partner-terms?l=hi']);
  });

  testWidgets('terms changed while the screen was open: asked again, nothing pre-ticked', (tester) async {
    var me = withConsents(meJson(null));
    final backend = Backend({
      ...baseRoutes(null, kyc),
      'GET /v1/partner/me': () => (200, me),
      'POST /v1/partner/me/consents': () {
        me = {
          ...meJson(null),
          'consentsNeeded': [
            {'type': 'PARTNER_TERMS', 'version': '2'},
          ],
        };
        return (409, refusal('CONSENT_VERSION_CHANGED'));
      },
    });
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('I accept the Partner Terms'));
    await tester.tap(find.text('I accept the Privacy Policy'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('consent-agree')));
    await tester.pumpAndSettle();
    expect(find.text('WellWish just updated these pages. Please read and accept them again.'), findsOneWidget);
    expect(find.text('I accept the Privacy Policy'), findsNothing); // only the new version is asked
    final agree = find.descendant(of: find.byKey(const Key('consent-agree')), matching: find.byType(ElevatedButton));
    expect(tester.widget<ElevatedButton>(agree).onPressed, isNull); // the new version isn't ticked
  });

  testWidgets('before choosing a role "Delete my account" erases the login at once and says so', (tester) async {
    final backend = Backend({
      ...baseRoutes(null, kyc),
      'POST /v1/partner/me/delete': () => (200, {'dueAt': '2026-10-14T10:00:00Z', 'done': true}),
    });
    await pumpPartnerApp(tester, backend);
    final delete = find.byKey(const Key('delete-account'));
    await tester.scrollUntilVisible(delete, 300, scrollable: find.byType(Scrollable).hitTestable().first);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(find.textContaining('It is deleted now'), findsOneWidget);
    expect(find.textContaining('days'), findsNothing); // no waiting time to promise
    await tester.tap(find.byKey(const Key('confirm-delete-account')));
    await tester.pumpAndSettle();
    expect(find.text('Your account is deleted.'), findsOneWidget);
  });

  test('the consent screen never replaces a visit in progress', () {
    SessionState withNeeded(String status) => SessionState(
      status: SessionStatus.loggedIn,
      me: PartnerMeOut(
        id: 'u-1',
        phone: '+919876543210',
        language: 'en',
        partnerStatus: status,
        role: 'COMPANION',
        temporaryBookingId: status == 'TEMPORARY' ? 'b-1' : null,
        consentsNeeded: [ConsentNeededOut(type: ConsentNeededOutTypeEnum.PARTNER_TERMS, version: '2')],
      ),
    );
    expect(redirectFor(withNeeded('APPROVED'), '/job/b-1'), isNull); // the job and its SOS stay
    expect(redirectFor(withNeeded('TEMPORARY'), '/job/b-1'), isNull);
    expect(redirectFor(withNeeded('APPROVED'), ApprovedShell.path), PartnerConsentScreen.path);
  });
}
