import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partner_app/features/home/approved_shell.dart';
import 'package:partner_app/features/registration/role_screen.dart';
import 'package:partner_app/features/session/session_controller.dart';
import 'package:partner_app/features/temporary/temporary_home.dart';
import 'package:partner_app/router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';

import 'fixtures.dart';
import 'jobs_test.dart' show tapKey;
import 'support.dart';

/// A temporary partner in the Partner app (PHASES 8B.7, ARCHITECTURE §6.19): only their one job,
/// today's selfie first, nothing that answers 403 to them, and a thank-you when the job is over.

final tempMe = {...meJson('TEMPORARY'), 'temporaryBookingId': 'b-1'};

/// Their job; [pickupAt] defaults to now (the visit is today).
Map<String, dynamic> tempJob({DateTime? pickupAt, String status = 'ACCEPTED', List<String> done = const []}) => {
  ...jobJson(
    status: status,
    visit: visitJson(done: done),
  ),
  'pickupAt': (pickupAt ?? DateTime.now()).toUtc().toIso8601String(),
};

/// What a temporary partner may call (the server answers 403 to everything else, 404 to another
/// booking): the same list as the backend's rule.
final temporaryMay = RegExp(
  r'^(GET /v1/public/app-config'
  r'|GET /v1/partner/me|PUT /v1/partner/me/device|POST /v1/partner/me/selfie'
  r'|POST /v1/partner/kyc/upload-url|POST http://10\.0\.2\.2:8000/v1/files/upload/\w+'
  r'|\w+ /v1/partner/notifications.*'
  r'|GET /v1/partner/jobs/b-1(/documents/[^/]+/view-url)?'
  r'|POST /v1/partner/bookings/b-1/(steps|calls|balance|track-batch|sos|patient-not-available)'
  r'|POST /v1/auth/\w+)$',
);

Map<String, (int, Object) Function()> selfieRoutes(void Function() taken) => {
  'POST /v1/partner/kyc/upload-url': () => (
    200,
    {
      'fileKey': 'partners/selfies/u-1/s.jpg',
      'uploadUrl': 'http://10.0.2.2:8000/v1/files/upload/tok',
      'uploadFields': {'Content-Type': 'image/jpeg'},
      'mime': 'image/jpeg',
      'maxBytes': 5242880,
    },
  ),
  'POST http://10.0.2.2:8000/v1/files/upload/tok': () => (200, {}),
  'POST /v1/partner/me/selfie': () {
    taken();
    return (200, {'availableToday': false, 'selfieToday': true});
  },
};

Map<String, (int, Object) Function()> tempRoutes({
  required Map<String, dynamic> Function() job,
  Map<String, (int, Object) Function()> extra = const {},
}) => {
  'GET /v1/public/app-config': () => (200, appConfigJson),
  'GET /v1/partner/me': () => (200, tempMe),
  'PUT /v1/partner/me/device': () => (200, {'ok': true}),
  'GET /v1/partner/jobs/b-1': () => (200, job()),
  ...extra,
};

void main() {
  testWidgets('a temporary partner sees only their job: today\'s selfie asked first, above the job', (tester) async {
    var selfie = false;
    var done = <String>[];
    final tracker = FakeTracker();
    final backend = Backend(
      tempRoutes(
        job: () => tempJob(status: done.isEmpty ? 'ACCEPTED' : 'IN_PROGRESS', done: done),
        extra: {
          ...selfieRoutes(() => selfie = true),
          'POST /v1/partner/bookings/b-1/steps': () {
            done = ['ON_THE_WAY'];
            return (200, tempJob(status: 'IN_PROGRESS', done: done));
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend, tracker: tracker);
    expect(find.text('Your WellWish job'), findsOneWidget);
    expect(find.byKey(const Key('temp-selfie-step')), findsOneWidget);
    // the job stays readable below it (address, health notes, calls)
    expect(find.byKey(const Key('active-job')), findsOneWidget);
    // none of the approved partner's home: no tabs, no "Available today", no totals
    expect(find.byKey(const Key('available-today')), findsNothing);
    expect(find.text('Jobs'), findsNothing);
    expect(find.text('Home'), findsNothing);
    expect(find.byKey(const Key('totals-row')), findsNothing);
    expect(find.byKey(const Key('temp-logout')), findsOneWidget);
    expect(find.byKey(const Key('language-button')), findsOneWidget); // their language (9.1)

    await tester.tap(find.byKey(const Key('temp-take-selfie')));
    await tester.pumpAndSettle();
    expect(find.text("Today's selfie"), findsOneWidget);
    expect(
      find.text('Take a selfie before you start. The family and WellWish see it as your photo for this visit.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('take-selfie')));
    await tester.pumpAndSettle();
    expect(selfie, isTrue);
    expect(backend.bodies['POST /v1/partner/kyc/upload-url'], contains('partner_selfie'));
    expect(backend.bodies['POST /v1/partner/me/selfie'], contains('partners/selfies/u-1/s.jpg'));
    expect(find.text('Selfie saved. You can start the job now.'), findsOneWidget);

    // back home: the normal job screen with its steps
    expect(find.text('Your WellWish job'), findsOneWidget);
    expect(find.byKey(const Key('temp-selfie-step')), findsNothing);
    expect(find.byKey(const Key('active-job')), findsOneWidget);
    expect(find.text('On the way'), findsOneWidget);
    await tapKey(tester, 'next-step');
    expect(backend.bodies['POST /v1/partner/bookings/b-1/steps'], contains('ON_THE_WAY'));
    expect(tracker.running, isTrue);
    expect(find.text('Reached the patient'), findsOneWidget);

    // nothing closed to a temporary partner was called (Home, offers, jobs, totals,
    // availability, registration answer 403)
    expect(backend.calls.where((c) => !temporaryMay.hasMatch(c)), isEmpty);
    for (final closed in [
      'GET /v1/partner/home',
      'GET /v1/partner/offers',
      'GET /v1/partner/jobs',
      'GET /v1/partner/totals',
      'GET /v1/partner/me/availability',
      'PATCH /v1/partner/me/availability',
      'GET /v1/partner/kyc/status',
    ]) {
      expect(backend.calls, isNot(contains(closed)));
    }
  });

  testWidgets('"On the way" without today\'s selfie (409 SELFIE_REQUIRED): the selfie, then back to the job', (
    tester,
  ) async {
    var selfie = false;
    var tries = 0;
    var done = <String>[];
    // the visit is on a later day: no selfie step yet, the job straight away
    final later = DateTime.now().add(const Duration(days: 2));
    final backend = Backend(
      tempRoutes(
        job: () => tempJob(pickupAt: later, status: done.isEmpty ? 'ACCEPTED' : 'IN_PROGRESS', done: done),
        extra: {
          ...selfieRoutes(() => selfie = true),
          'POST /v1/partner/bookings/b-1/steps': () {
            tries++;
            if (!selfie) {
              return (
                409,
                {
                  'error': {
                    'code': 'SELFIE_REQUIRED',
                    'message': "Take today's selfie before you start.",
                    'details': {},
                  },
                },
              );
            }
            done = ['ON_THE_WAY'];
            return (200, tempJob(pickupAt: later, status: 'IN_PROGRESS', done: done));
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    expect(find.byKey(const Key('temp-selfie-step')), findsNothing);
    expect(find.byKey(const Key('active-job')), findsOneWidget);
    await tapKey(tester, 'next-step');
    // the selfie screen
    expect(find.byKey(const Key('take-selfie')), findsOneWidget);
    expect(find.byKey(const Key('active-job')), findsNothing);
    await tester.tap(find.byKey(const Key('take-selfie')));
    await tester.pumpAndSettle();
    expect(selfie, isTrue);
    // back to the job; "On the way" works now
    expect(find.byType(TemporaryHome), findsOneWidget);
    expect(find.byKey(const Key('take-selfie')), findsNothing);
    expect(find.byKey(const Key('active-job')), findsOneWidget);
    await tapKey(tester, 'next-step');
    expect(tries, 2);
    expect(find.text('Reached the patient'), findsOneWidget);
    expect(backend.calls.where((c) => !temporaryMay.hasMatch(c)), isEmpty);
  });

  testWidgets('today\'s selfie known to the server (a restart, another phone): not asked again', (tester) async {
    final backend = Backend({
      ...tempRoutes(job: () => tempJob()),
      'GET /v1/partner/me': () => (200, {...tempMe, 'selfieToday': true}),
    });
    await pumpPartnerApp(tester, backend);
    expect(find.text('Your WellWish job'), findsOneWidget);
    expect(find.byKey(const Key('temp-selfie-step')), findsNothing);
    expect(find.byKey(const Key('active-job')), findsOneWidget);
  });

  testWidgets('a double tap on "Take selfie" opens one selfie screen', (tester) async {
    var selfies = 0;
    final backend = Backend(tempRoutes(job: () => tempJob(), extra: selfieRoutes(() => selfies++)));
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.byKey(const Key('temp-take-selfie')));
    await tester.tap(find.byKey(const Key('temp-take-selfie')), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('take-selfie')));
    await tester.pumpAndSettle();
    expect(selfies, 1);
    // straight back to the job, not onto a second selfie screen
    expect(find.byKey(const Key('take-selfie')), findsNothing);
    expect(find.byType(TemporaryHome), findsOneWidget);
  });

  testWidgets('logging out asks first (it stops the live location mid-visit)', (tester) async {
    final backend = Backend({
      ...tempRoutes(
        job: () => tempJob(status: 'IN_PROGRESS', done: ['ON_THE_WAY']),
      ),
      'POST /v1/auth/logout': () => (200, {'ok': true}),
    });
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.byKey(const Key('temp-logout')));
    await tester.pumpAndSettle();
    expect(find.text('Log out?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Your WellWish job'), findsOneWidget); // still there
    await tester.tap(find.byKey(const Key('temp-logout')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('temp-logout-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('given a temporary job again while on the role choice: the job opens by itself', (tester) async {
    final socket = FakeSocket();
    var assigned = false;
    final backend = Backend({
      ...baseRoutes('TEMP_ENDED', kyc),
      'GET /v1/partner/me': () => (200, assigned ? tempMe : meJson('TEMP_ENDED')),
      'GET /v1/partner/jobs/b-1': () => (200, tempJob(pickupAt: DateTime.now().add(const Duration(days: 1)))),
    });
    await pumpPartnerApp(tester, backend, socket: socket);
    expect(find.text('What work will you do?'), findsOneWidget);
    assigned = true; // an admin temporary-assigned them meanwhile
    socket.messages.add({
      'type': 'booking.updated',
      'data': {'bookingId': 'b-1'},
    });
    await tester.pumpAndSettle();
    expect(find.text('Your WellWish job'), findsOneWidget);
    expect(find.text('What work will you do?'), findsNothing);
  });

  testWidgets('after the temporary job (TEMP_ENDED): the "not registered" start', (tester) async {
    final backend = Backend({...baseRoutes('TEMP_ENDED', kyc), 'POST /v1/partner/register/start': () => (200, kyc())});
    await pumpPartnerApp(tester, backend);
    expect(find.text('What work will you do?'), findsOneWidget);
    expect(find.text('Your WellWish job'), findsNothing);
    // like anyone not registered: the way out is there and nothing else is loaded
    await tester.scrollUntilVisible(find.text('Logout'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Logout'), findsOneWidget);
    expect(backend.calls, isNot(contains('GET /v1/partner/kyc/status')));
    await tester.ensureVisible(find.text('Companion')); // back up past the account links (§6.20)
    await tester.pumpAndSettle();
    await tester.tap(find.text('Companion'));
    await tester.pumpAndSettle();
    expect(backend.bodies['POST /v1/partner/register/start'], contains('COMPANION'));
    expect(find.text('Alternate number and email'), findsOneWidget);
  });

  testWidgets('job over (JOB_OVER on the socket): logged out at once with a thank-you; sharing stops', (tester) async {
    final socket = FakeSocket();
    final tracker = FakeTracker();
    final backend = Backend(
      tempRoutes(
        job: () => tempJob(status: 'IN_PROGRESS', done: ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP']),
      ),
    );
    await pumpPartnerApp(tester, backend, socket: socket, tracker: tracker);
    expect(find.byKey(const Key('active-job')), findsOneWidget);
    expect(tracker.running, isTrue); // mid-visit: the location is shared again

    socket.messages.add({
      'type': 'session.revoked',
      'data': {'reason': 'JOB_OVER'},
    });
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Your WellWish job is over. Thank you!'), findsOneWidget);
    expect(find.text('Your session ended. Please log in again.'), findsNothing);
    expect(tracker.running, isFalse);
  });

  testWidgets('job over found by the next call (socket down): the same thank-you', (tester) async {
    var over = false;
    const unauthorized = (
      401,
      {
        'error': {'code': 'UNAUTHORIZED', 'message': '', 'details': {}},
      },
    );
    final backend = Backend({
      ...tempRoutes(
        job: () => tempJob(status: 'IN_PROGRESS', done: ['ON_THE_WAY']),
      ),
      'GET /v1/partner/me': () => over ? unauthorized : (200, tempMe),
      'GET /v1/partner/jobs/b-1': () =>
          over ? unauthorized : (200, tempJob(status: 'IN_PROGRESS', done: ['ON_THE_WAY'])),
      'POST /v1/auth/refresh': () => (
        401,
        {
          'error': {
            'code': 'SESSION_REVOKED',
            'message': '',
            'details': {'reason': 'JOB_OVER'},
          },
        },
      ),
    });
    await pumpPartnerApp(tester, backend);
    over = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Your WellWish job is over. Thank you!'), findsOneWidget);
  });

  testWidgets('another revoked session still says "your session ended"', (tester) async {
    final socket = FakeSocket();
    final backend = Backend(
      tempRoutes(
        job: () => tempJob(status: 'IN_PROGRESS', done: ['ON_THE_WAY']),
      ),
    );
    await pumpPartnerApp(tester, backend, socket: socket);
    socket.messages.add({
      'type': 'session.revoked',
      'data': {'reason': 'REUSE_DETECTED'},
    });
    await tester.pumpAndSettle();
    expect(find.text('Your session ended. Please log in again.'), findsOneWidget);
    expect(find.text('Your WellWish job is over. Thank you!'), findsNothing);
  });

  test('the router: TEMPORARY opens only their job, TEMP_ENDED the role choice', () {
    SessionState loggedIn(String? status, {String? booking}) => SessionState(
      status: SessionStatus.loggedIn,
      me: PartnerMeOut(
        id: 'u-1',
        phone: '+919876543210',
        language: 'en',
        partnerStatus: status,
        role: status == null ? null : 'COMPANION',
        temporaryBookingId: booking,
      ),
    );

    final temp = loggedIn('TEMPORARY', booking: 'b-1');
    for (final open in ['/my-job', '/selfie', '/notifications', '/job/b-1', '/job/b-1/care-note', '/job/b-1/balance']) {
      expect(redirectFor(temp, open), isNull, reason: open);
    }
    for (final closed in [
      '/home',
      '/totals',
      '/offer/a-1',
      '/job/b-2',
      '/job/b-2/balance',
      '/register/role',
      '/register',
      '/documents',
      '/status',
    ]) {
      expect(redirectFor(temp, closed), TemporaryHome.path, reason: closed);
    }

    final ended = loggedIn('TEMP_ENDED');
    expect(redirectFor(ended, TemporaryHome.path), RoleScreen.path);
    expect(redirectFor(ended, '/job/b-1'), RoleScreen.path);
    expect(redirectFor(ended, RoleScreen.path), isNull);

    // the other statuses as before
    expect(redirectFor(loggedIn(null), TemporaryHome.path), RoleScreen.path);
    expect(redirectFor(loggedIn('APPROVED'), TemporaryHome.path), ApprovedShell.path);
    expect(redirectFor(loggedIn('APPROVED'), '/job/b-2'), isNull);
  });

  test('the temporary partner texts are in Hindi and Odia', () {
    final en = lookupWWLocalizations(const Locale('en'));
    final hi = lookupWWLocalizations(const Locale('hi'));
    expect(hi.tempJobOver, 'आपका WellWish काम पूरा हो गया। धन्यवाद!');
    for (final l10n in [hi, lookupWWLocalizations(const Locale('or'))]) {
      expect(l10n.tempJobOver, isNot(en.tempJobOver));
      expect(l10n.tempHomeTitle, isNot(en.tempHomeTitle));
      expect(l10n.tempHomeBody, isNot(en.tempHomeBody));
      expect(l10n.tempSelfieBody, isNot(en.tempSelfieBody));
      expect(l10n.tempSelfieSaved, isNot(en.tempSelfieSaved));
    }
  });
}
