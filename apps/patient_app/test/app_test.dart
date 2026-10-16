import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_app/features/session/session_controller.dart';
import 'package:patient_app/router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_ui/ww_ui.dart';

import 'support.dart';

void main() {
  testWidgets('no saved login: splash, then the login screen (mockup 2)', (tester) async {
    final backend = FakeBackend({'GET /v1/public/app-config': (_) => (200, appConfig())});
    await pumpPatientApp(tester, backend);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);
    expect(find.byType(WWLogoLockup), findsOneWidget);
    expect(find.text('Google'), findsNothing); // Google sign-in off without a client id
  });

  testWidgets('sign up: OTP → profile → consent → location → Home', (tester) async {
    var profile = me();
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'POST /v1/auth/otp/send': (_) => (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 30, 'length': 6}),
      'POST /v1/auth/otp/verify': (_) => (200, {...tokens, 'isNewUser': true}),
      'GET /v1/patient/me': (_) => (200, profile),
      'PUT /v1/patient/me': (request) {
        final body = bodyOf(request);
        expect(body['fullName'], 'Asha Das');
        expect(body['gender'], 'FEMALE');
        expect(body['language'], 'en');
        profile = me(fullName: 'Asha Das', complete: true);
        return (200, profile);
      },
      'POST /v1/patient/me/consents': (request) {
        expect((bodyOf(request)['items'] as List).length, 3);
        profile = me(fullName: 'Asha Das', complete: true, consents: false);
        return (200, {'ok': true});
      },
      'PUT /v1/patient/me/device': (_) => (200, {'ok': true}),
    });
    final opened = <String>[];
    final storage = await pumpPatientApp(tester, backend, openedPages: opened);

    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    expect(find.text('Verify your number'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('ww-otp-input')), '123456');
    await tester.pumpAndSettle();
    expect(await storage.readAccessToken(), 'access');
    expect(find.text('Tell us about you'), findsOneWidget);

    // nothing filled in → three messages
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please select your date of birth'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Asha Das');
    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    // the full date, with the year
    expect(find.text('1 Jan ${DateTime.now().year - 30}'), findsOneWidget);
    await tester.tap(find.text('Female'));
    await scrollTo(tester, find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Before you start'), findsOneWidget);
    // §6.20: each line can be read in the browser, in the app's language
    await tester.tap(find.text('Read the Terms of Use'));
    await tester.pumpAndSettle();
    expect(opened, ['http://10.0.2.2:8000/legal/terms?l=en']);
    expect(find.text('Read the Privacy Policy'), findsNWidgets(2)); // privacy and health data
    await tester.tap(find.byKey(const Key('consent-read-HEALTH_DATA')));
    await tester.pumpAndSettle();
    expect(opened.last, 'http://10.0.2.2:8000/legal/privacy?l=en'); // health data is explained there
    final agree = find.widgetWithText(ElevatedButton, 'Agree and continue');
    expect(tester.widget<ElevatedButton>(agree).onPressed, isNull);
    await tester.tap(find.text('I accept the Terms of Use'));
    await tester.tap(find.text('I accept the Privacy Policy'));
    await tester.tap(find.text('I allow WellWish to keep my health documents'));
    await tester.pump();
    await tester.tap(agree);
    await tester.pumpAndSettle();

    expect(find.text('Find hospitals near you'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Asha 👋'), findsOneWidget);
    expect(find.text('Book a Companion'), findsOneWidget);
    expect(find.text('Book a Nurse'), findsOneWidget);
    expect(find.text('Coming soon'), findsNothing); // every tile works since Phase 5
    expect(backend.calls, contains('PUT /v1/patient/me/device'));
  });

  testWidgets('saved login with a complete profile goes straight to Home', (tester) async {
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'GET /v1/patient/me': (_) => (200, me(fullName: 'Priyansu Gouda', complete: true, consents: false)),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    expect(find.text('Hello, Priyansu 👋'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget); // bottom nav
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('expired access token is refreshed on start', (tester) async {
    var meCalls = 0;
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'GET /v1/patient/me': (_) => ++meCalls == 1
          ? (
              401,
              {
                'error': {'code': 'UNAUTHORIZED', 'message': '', 'details': {}},
              },
            )
          : (200, me(fullName: 'Priyansu Gouda', complete: true, consents: false)),
      'POST /v1/auth/refresh': (_) => (200, {'accessToken': 'access-2', 'refreshToken': 'refresh-2', 'expiresIn': 900}),
    });
    final storage = await pumpPatientApp(tester, backend, loggedIn: true);
    expect(find.text('Hello, Priyansu 👋'), findsOneWidget);
    expect(await storage.readRefreshToken(), 'refresh-2');
  });

  testWidgets('a revoked session lands on login with a message', (tester) async {
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'GET /v1/patient/me': (_) => (
        401,
        {
          'error': {'code': 'UNAUTHORIZED', 'message': '', 'details': {}},
        },
      ),
      'POST /v1/auth/refresh': (_) => (
        401,
        {
          'error': {
            'code': 'SESSION_REVOKED',
            'message': '',
            'details': {'reason': 'REUSE_DETECTED'},
          },
        },
      ),
    });
    final storage = await pumpPatientApp(tester, backend, loggedIn: true);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Your session ended. Please log in again.'), findsOneWidget);
    expect(await storage.readRefreshToken(), isNull);
  });

  testWidgets('blocked by WellWish: the login screen says so (9.10)', (tester) async {
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'GET /v1/patient/me': (_) => (
        401,
        {
          'error': {'code': 'UNAUTHORIZED', 'message': '', 'details': {}},
        },
      ),
      'POST /v1/auth/refresh': (_) => (
        401,
        {
          'error': {
            'code': 'SESSION_REVOKED',
            'message': '',
            'details': {'reason': 'ACCOUNT_BLOCKED'},
          },
        },
      ),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('This account is blocked. Please contact WellWish support.'), findsOneWidget);
  });

  testWidgets('logout from Profile', (tester) async {
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'GET /v1/patient/me': (_) => (200, me(fullName: 'Priyansu Gouda', complete: true, consents: false)),
      'POST /v1/auth/logout': (_) => (200, {'ok': true}),
    });
    final storage = await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Priyansu Gouda'), findsOneWidget);
    expect(find.text('+91 98765 43210'), findsOneWidget);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(await storage.readAccessToken(), isNull);
    expect(backend.calls, contains('POST /v1/auth/logout'));
  });

  testWidgets('right code but the profile fails to load: try again, not stuck on OTP', (tester) async {
    var online = false;
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'POST /v1/auth/otp/send': (_) => (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 30, 'length': 6}),
      'POST /v1/auth/otp/verify': (_) => (200, tokens),
      'GET /v1/patient/me': (_) => online
          ? (200, me(fullName: 'Asha Das', complete: true, consents: false))
          : (
              503,
              {
                'error': {'code': 'X', 'message': '', 'details': {}},
              },
            ),
      'PUT /v1/patient/me/device': (_) => (200, {'ok': true}),
    });
    await pumpPatientApp(tester, backend);
    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('ww-otp-input')), '123456');
    await tester.pumpAndSettle();
    expect(find.text('Verify your number'), findsNothing);
    expect(find.text('Try again'), findsOneWidget);

    online = true;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Asha 👋'), findsOneWidget);
  });

  testWidgets('too-old app shows the force-update screen', (tester) async {
    final backend = FakeBackend({'GET /v1/public/app-config': (_) => (200, appConfig(minVersion: '0.2.0'))});
    await pumpPatientApp(tester, backend, version: '0.1.0');
    expect(find.text('Update WellWish'), findsOneWidget);
    expect(find.text('Update now'), findsOneWidget);
  });

  testWidgets('offline at start shows try again', (tester) async {
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (
        503,
        {
          'error': {'code': 'X', 'message': '', 'details': {}},
        },
      ),
    });
    await pumpPatientApp(tester, backend);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('the app speaks the language chosen in the profile', (tester) async {
    final backend = FakeBackend({
      'GET /v1/public/app-config': (_) => (200, appConfig()),
      'GET /v1/patient/me': (_) =>
          (200, me(fullName: 'Priyansu Gouda', complete: true, consents: false, language: 'or')),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    expect(find.text('ନମସ୍କାର, Priyansu 👋'), findsOneWidget);
    expect(find.text('ହୋମ୍'), findsOneWidget);
  });

  group('redirectFor', () {
    PatientMeOut meOut({bool complete = true, bool consents = false}) =>
        PatientMeOut.fromJson(me(complete: complete, consents: consents));

    test('signed out users can only see login and OTP', () {
      const s = SessionState(status: SessionStatus.loggedOut);
      expect(redirectFor(s, '/home'), '/login');
      expect(redirectFor(s, '/otp'), isNull);
    });

    test('signed in: profile, then consent, then location, then home', () {
      expect(
        redirectFor(SessionState(status: SessionStatus.loggedIn, me: meOut(complete: false)), '/home'),
        '/setup/profile',
      );
      expect(
        redirectFor(SessionState(status: SessionStatus.loggedIn, me: meOut(consents: true)), '/home'),
        '/setup/consent',
      );
      expect(
        redirectFor(SessionState(status: SessionStatus.loggedIn, me: meOut(), askLocation: true), '/home'),
        '/setup/location',
      );
      expect(redirectFor(SessionState(status: SessionStatus.loggedIn, me: meOut()), '/login'), '/home');
      expect(redirectFor(SessionState(status: SessionStatus.loggedIn, me: meOut()), '/profile'), isNull);
    });
  });
}
