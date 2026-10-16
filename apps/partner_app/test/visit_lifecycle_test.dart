import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:partner_app/features/jobs/visit_controller.dart';
import 'package:partner_app/features/jobs/visit_outbox.dart';
import 'package:partner_app/features/session/session_controller.dart';
import 'package:partner_app/providers.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';

import 'jobs_test.dart' show approved, tapKey;
import 'support.dart';
import 'visit_test.dart' show openJob;

/// The visit's edge cases in the partner app (Phase 8 deep check): sharing stops when the job
/// is over or at logout and never switches jobs; kept steps go in order and come back after a
/// restart; points go before steps; a GPS problem can be fixed; the outbox file is safe.

TrackPoint _point() => TrackPoint(lat: 20.29, lng: 85.84, accuracy: 9, mock: false, at: DateTime.now().toUtc());

void main() {
  testWidgets('sharing stops when WellWish ends the job, and at logout', (tester) async {
    var status = 'IN_PROGRESS';
    final socket = FakeSocket();
    final tracker = FakeTracker();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: status,
              visit: visitJson(done: ['ON_THE_WAY']),
            ),
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend, socket: socket, tracker: tracker);
    socket.messages.add({'type': 'auth.ok', 'data': {}});
    await tester.pump();
    await openJob(tester);
    expect(tracker.running, isTrue); // after the app was closed mid-job: shared again
    // WellWish marked "Completed" for the partner: the job reloads and sharing stops
    status = 'COMPLETED';
    socket.messages.add({
      'type': 'booking.updated',
      'data': {'bookingId': 'b-1'},
    });
    await tester.pumpAndSettle();
    expect(tracker.running, isFalse);
    // in progress again (test only): shared again; logging out stops it too
    status = 'IN_PROGRESS';
    socket.messages.add({
      'type': 'booking.updated',
      'data': {'bookingId': 'b-1'},
    });
    await tester.pumpAndSettle();
    expect(tracker.running, isTrue);
    final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));
    await container.read(sessionManagerProvider).end(SessionEndReason.loggedOut);
    await tester.pumpAndSettle();
    expect(tracker.running, isFalse);
  });

  testWidgets('a step waits behind the kept ones; the visit code needs the network', (tester) async {
    final outbox = MemoryVisitOutbox();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: ['ON_THE_WAY']),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () => (0, {}), // no network
        },
      ),
    );
    await pumpPartnerApp(tester, backend, outbox: outbox);
    await openJob(tester);
    await tapKey(tester, 'next-step'); // Reached the patient: kept
    expect(outbox.stepList.map((s) => s['step']), ['REACHED_PATIENT']);
    await tapKey(tester, 'next-step'); // Picked up: asks for the code
    await tester.enterText(find.byKey(const Key('otp-input')), '4821');
    await tester.tap(find.byKey(const Key('confirm-otp')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('otp-error')), findsOneWidget);
    expect(outbox.stepList.map((s) => s['step']), ['REACHED_PATIENT']); // not kept
  });

  testWidgets('back online: kept points go first as a batch, then the kept steps in order', (tester) async {
    var online = false;
    var done = ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP'];
    final socket = FakeSocket();
    final tracker = FakeTracker();
    final outbox = MemoryVisitOutbox();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: done),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () {
            if (!online) return (0, {});
            done = [...done, done.length == 3 ? 'REACHED_HOSPITAL' : 'VISIT_DONE'];
            return (
              200,
              jobJson(
                status: 'IN_PROGRESS',
                visit: visitJson(done: done),
              ),
            );
          },
          'POST /v1/partner/bookings/b-1/track-batch': () => (200, {'accepted': 1}),
        },
      ),
    );
    await pumpPartnerApp(tester, backend, socket: socket, tracker: tracker, outbox: outbox);
    await openJob(tester);
    tracker.points.add(_point());
    await tester.pump();
    expect(outbox.pointMap['b-1'], hasLength(1)); // no live connection: kept
    await tapKey(tester, 'next-step'); // At the hospital
    await tapKey(tester, 'next-step'); // Visit done, behind it
    expect(outbox.stepList.map((s) => s['step']), ['REACHED_HOSPITAL', 'VISIT_DONE']);
    online = true;
    socket.messages.add({'type': 'auth.ok', 'data': {}});
    await tester.pumpAndSettle();
    final posts = backend.sent.map((r) => r.$1).where((k) => k.startsWith('POST /v1/partner/bookings/b-1/')).toList();
    final firstSent = posts.indexWhere((k) => k.endsWith('/track-batch'));
    final firstStepOnline = backend.sent.indexWhere(
      (r) => r.$1.endsWith('/steps') && (jsonDecode(r.$2) as Map)['step'] == 'REACHED_HOSPITAL',
    );
    expect(firstSent, greaterThanOrEqualTo(0));
    expect(
      backend.sent.indexWhere((r) => r.$1.endsWith('/track-batch')),
      lessThan(backend.sent.lastIndexWhere((r) => r.$1.endsWith('/steps'))),
    );
    expect(firstStepOnline, greaterThanOrEqualTo(0));
    final steps = backend.sent
        .where((r) => r.$1.endsWith('/steps'))
        .map((r) => (jsonDecode(r.$2) as Map)['step'])
        .toList();
    expect(steps.sublist(steps.length - 2), ['REACHED_HOSPITAL', 'VISIT_DONE']);
    expect(outbox.stepList, isEmpty);
    expect(outbox.pointMap, isEmpty);
    expect(done.last, 'VISIT_DONE');
  });

  testWidgets('after a restart the kept steps show again; a refused one is dropped and said', (tester) async {
    final outbox = MemoryVisitOutbox()
      ..stepList.add({
        'bookingId': 'b-1',
        'step': 'REACHED_HOSPITAL',
        'clientTs': DateTime.now().toUtc().toIso8601String(),
      });
    final socket = FakeSocket();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP']),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () => (
            409,
            {
              'error': {
                'code': 'STEP_OUT_OF_ORDER',
                'message': 'order',
                'details': {'expected': 'VISIT_DONE'},
              },
            },
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend, socket: socket, outbox: outbox);
    await openJob(tester);
    expect(find.byKey(const Key('pending-steps')), findsOneWidget);
    expect(find.text('Visit done'), findsOneWidget); // the next one after the kept step
    socket.messages.add({'type': 'auth.ok', 'data': {}});
    await tester.pumpAndSettle();
    expect(outbox.stepList, isEmpty);
    expect(find.byKey(const Key('pending-steps')), findsNothing);
    expect(find.byKey(const Key('steps-refused')), findsOneWidget);
  });

  testWidgets('a GPS problem can be fixed and sharing started again', (tester) async {
    final tracker = FakeTracker();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: ['ON_THE_WAY']),
            ),
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend, tracker: tracker);
    await openJob(tester);
    tracker.points.addError(Exception('location off'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('share-again')), findsOneWidget);
    tracker.running = false;
    await tapKey(tester, 'share-again');
    expect(tracker.running, isTrue);
    tracker.points.add(_point());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('share-again')), findsNothing);
  });

  testWidgets('a failed SOS says so in the sheet; patient not available stops sharing', (tester) async {
    final tracker = FakeTracker();
    var status = 'IN_PROGRESS';
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: status,
              visit: visitJson(
                done: ['ON_THE_WAY', 'REACHED_PATIENT'],
                noShowReadyAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)).toIso8601String(),
              ),
            ),
          ),
          'POST /v1/partner/bookings/b-1/sos': () => (
            503,
            {
              'error': {'code': 'UNAVAILABLE', 'message': 'down', 'details': {}},
            },
          ),
          'POST /v1/partner/bookings/b-1/patient-not-available': () {
            status = 'PATIENT_NO_SHOW';
            return (
              200,
              jobJson(
                status: status,
                visit: visitJson(done: ['ON_THE_WAY', 'REACHED_PATIENT']),
              ),
            );
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend, tracker: tracker);
    await openJob(tester);
    expect(tracker.running, isTrue);
    await tapKey(tester, 'sos');
    await tester.tap(find.byKey(const Key('send-sos')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sos-error')), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // close the sheet
    await tester.pumpAndSettle();
    await tapKey(tester, 'patient-not-available');
    await tester.tap(find.text('Patient not available').last);
    await tester.pumpAndSettle();
    expect(tracker.running, isFalse);
  });

  test('the outbox file keeps steps and points across restarts and survives a broken file', () async {
    final dir = await Directory.systemTemp.createTemp('ww_outbox');
    addTearDown(() => dir.delete(recursive: true));
    TrackPoint at(int minute) =>
        TrackPoint(lat: 20.29, lng: 85.84, accuracy: 9, mock: false, at: DateTime.utc(2026, 10, 10, 9, minute));
    final first = FileVisitOutbox(partnerId: 'u-1', directory: () async => dir);
    await Future.wait([
      first.addStep({'bookingId': 'b-1', 'step': 'REACHED_HOSPITAL'}),
      first.addStep({'bookingId': 'b-1', 'step': 'VISIT_DONE'}),
      first.addPoint('b-1', at(1)),
    ]);
    final again = FileVisitOutbox(partnerId: 'u-1', directory: () async => dir);
    expect((await again.steps()).map((s) => s['step']), ['REACHED_HOSPITAL', 'VISIT_DONE']);
    expect((await again.points())['b-1'], hasLength(1));
    // another partner on this phone has their own (empty) outbox
    final other = FileVisitOutbox(partnerId: 'u-2', directory: () async => dir);
    expect(await other.steps(), isEmpty);
    expect(await other.points(), isEmpty);
    // after an upload only the uploaded points go, not one kept meanwhile
    final uploaded = (await again.points())['b-1']!;
    await again.addPoint('b-1', at(2));
    await again.removePoints('b-1', uploaded);
    expect((await again.points())['b-1']!.map((p) => p.at), [DateTime.utc(2026, 10, 10, 9, 2)]);
    File('${dir.path}/visit_outbox_u-1.json').writeAsStringSync('{broken');
    final broken = FileVisitOutbox(partnerId: 'u-1', directory: () async => dir);
    expect(await broken.steps(), isEmpty);
    expect(File('${dir.path}/visit_outbox_u-1.json.bad').existsSync(), isTrue); // kept aside, not lost
  });

  testWidgets('"On the way" too early says from when it can be tapped', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (200, jobJson(visit: visitJson())),
          'POST /v1/partner/bookings/b-1/steps': () => (
            409,
            {
              'error': {
                'code': 'TOO_EARLY_TO_START',
                'message': 'early',
                'details': {'from': '2026-10-11T02:30:00+00:00'},
              },
            },
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await openJob(tester);
    await tapKey(tester, 'next-step');
    expect(find.textContaining('Too early to start. You can tap "On the way" from Sun, 11 Oct'), findsOneWidget);
  });

  testWidgets('paid in full in the app: Completed asks for no balance', (tester) async {
    var done = ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP', 'REACHED_HOSPITAL', 'VISIT_DONE', 'DROPPED_HOME'];
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            {
              ...jobJson(
                status: done.length == 7 ? 'COMPLETED' : 'IN_PROGRESS',
                visit: visitJson(done: done),
              ),
              'balancePaise': 0,
            },
          ),
          'POST /v1/partner/bookings/b-1/steps': () {
            done = [...done, 'COMPLETED'];
            return (
              200,
              {
                ...jobJson(
                  status: 'COMPLETED',
                  visit: visitJson(done: done),
                ),
                'balancePaise': 0,
              },
            );
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await openJob(tester);
    await tapKey(tester, 'next-step'); // Completed
    expect(find.text('Collect balance'), findsNothing);
    expect(find.byKey(const Key('balance-card')), findsNothing);
  });

  testWidgets('a wrong code that starts a wait: the panel shows the wait once the sheet is closed', (tester) async {
    String? retryAt;
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: ['ON_THE_WAY', 'REACHED_PATIENT'], otpRetryAt: retryAt),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () {
            retryAt = DateTime.now().toUtc().add(const Duration(minutes: 5)).toIso8601String();
            return (
              422,
              {
                'error': {
                  'code': 'WRONG_OTP',
                  'message': 'wrong',
                  'details': {'triesLeft': 0, 'retryAt': retryAt},
                },
              },
            );
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await openJob(tester);
    await tapKey(tester, 'next-step'); // Picked up: the family's code
    await tester.enterText(find.byKey(const Key('otp-input')), '1111');
    await tester.tap(find.byKey(const Key('confirm-otp')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('otp-error')), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // close the sheet
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('otp-wait')), findsOneWidget); // "Try again at …", call WellWish
    expect(find.byKey(const Key('next-step')), findsNothing);
  });

  testWidgets('a nurse\'s care note needs a few words before it is sent or kept', (tester) async {
    final outbox = MemoryVisitOutbox();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/me': () => (200, {...meJson('APPROVED'), 'role': 'NURSE'}),
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(type: 'HOME_VISIT', done: ['ON_THE_WAY', 'REACHED_HOME', 'STARTED']),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () => (0, {}), // no network: it would be kept
        },
      ),
    );
    await pumpPartnerApp(tester, backend, outbox: outbox);
    await openJob(tester);
    await tapKey(tester, 'next-step'); // Care done → the care note
    await tester.enterText(find.byKey(const Key('care-note')), ' ok ');
    await tapKey(tester, 'save-care-note');
    expect(find.text('Please write a short care note.'), findsOneWidget);
    expect(backend.calls, isNot(contains('POST /v1/partner/bookings/b-1/steps')));
    expect(outbox.stepList, isEmpty);
    await tester.enterText(find.byKey(const Key('care-note')), 'Dressing changed.');
    await tapKey(tester, 'save-care-note');
    expect(outbox.stepList.single['note'], 'Dressing changed.');
  });

  testWidgets('another partner logging in on this phone never sends or sees the kept steps', (tester) async {
    var me = 'u-1';
    final mine = MemoryVisitOutbox()
      ..stepList.add({
        'bookingId': 'b-1',
        'step': 'REACHED_HOSPITAL',
        'clientTs': DateTime.now().toUtc().toIso8601String(),
      });
    final theirs = MemoryVisitOutbox();
    final socket = FakeSocket();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/me': () => (200, {...meJson('APPROVED'), 'id': me}),
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP']),
            ),
          ),
          // the first partner is offline; for the second one it would be refused
          'POST /v1/partner/bookings/b-1/steps': () => me == 'u-1'
              ? (0, {})
              : (
                  409,
                  {
                    'error': {'code': 'STEP_OUT_OF_ORDER', 'message': 'order', 'details': {}},
                  },
                ),
        },
      ),
    );
    int stepPosts() => backend.calls.where((c) => c == 'POST /v1/partner/bookings/b-1/steps').length;
    await pumpPartnerApp(tester, backend, socket: socket, outboxes: {'u-1': mine, 'u-2': theirs});
    await openJob(tester);
    expect(find.byKey(const Key('pending-steps')), findsOneWidget);
    final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));
    await container.read(sessionManagerProvider).end(SessionEndReason.loggedOut);
    await tester.pumpAndSettle();
    final atLogout = stepPosts();
    await tester.pump(VisitController.retryEvery * 3); // no retries without a login
    expect(stepPosts(), atLogout);
    // the second partner logs in on the same phone
    me = 'u-2';
    await container.read(tokenStorageProvider).save(accessToken: 'access-2', refreshToken: 'refresh-2');
    unawaited(container.read(sessionProvider.notifier).loggedIn());
    await tester.pumpAndSettle();
    socket.messages.add({'type': 'auth.ok', 'data': {}});
    await tester.pumpAndSettle();
    await tester.pump(VisitController.retryEvery * 2);
    expect(stepPosts(), atLogout); // the first partner's step isn't sent with this login
    expect(container.read(visitControllerProvider).pending, isEmpty);
    await openJob(tester);
    expect(find.byKey(const Key('pending-steps')), findsNothing);
    expect(find.byKey(const Key('steps-refused')), findsNothing);
    expect(mine.stepList.single['step'], 'REACHED_HOSPITAL'); // still kept for its partner
  });

  testWidgets('a step reuses the job\'s latest shared point, never a fake (mock) one', (tester) async {
    final tracker = FakeTracker();
    var done = ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP'];
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: done),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () {
            done = [...done, done.length == 3 ? 'REACHED_HOSPITAL' : 'VISIT_DONE'];
            return (
              200,
              jobJson(
                status: 'IN_PROGRESS',
                visit: visitJson(done: done),
              ),
            );
          },
        },
      ),
    );
    String? sentLat() =>
        (jsonDecode(backend.bodies['POST /v1/partner/bookings/b-1/steps']! as String) as Map)['lat'] as String?;
    await pumpPartnerApp(tester, backend, tracker: tracker);
    await openJob(tester);
    tracker.points.add(TrackPoint(lat: 21.5, lng: 86.5, accuracy: 5, mock: true, at: DateTime.now().toUtc()));
    await tester.pump();
    await tapKey(tester, 'next-step'); // At the hospital
    expect(sentLat(), '20.296100'); // a fresh fix, not the fake point
    tracker.points.add(_point());
    await tester.pump();
    await tapKey(tester, 'next-step'); // Visit done
    expect(sentLat(), '20.290000'); // the shared point
  });

  testWidgets('the location notification is in the partner\'s language, also from the job screen', (tester) async {
    final tracker = FakeTracker();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/me': () => (200, {...meJson('APPROVED'), 'language': 'hi'}),
          // Home didn't load: the job screen is the first to share
          'GET /v1/partner/home': () => (
            503,
            {
              'error': {'code': 'UNAVAILABLE', 'message': 'down', 'details': {}},
            },
          ),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: ['ON_THE_WAY']),
            ),
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend, tracker: tracker);
    await openJob(tester);
    expect(tracker.running, isTrue);
    expect(tracker.notificationText, lookupWWLocalizations(const Locale('hi')).fgsText);
  });

  testWidgets('Completed kept offline: the balance screen waits until the server has it', (tester) async {
    final outbox = MemoryVisitOutbox();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(
                done: ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP', 'REACHED_HOSPITAL', 'VISIT_DONE', 'DROPPED_HOME'],
              ),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () => (0, {}), // no network
        },
      ),
    );
    await pumpPartnerApp(tester, backend, outbox: outbox);
    await openJob(tester);
    await tapKey(tester, 'next-step'); // Completed: kept
    expect(outbox.stepList.single['step'], 'COMPLETED');
    expect(find.text('Collect balance'), findsNothing);
  });

  testWidgets('R14: the server\'s balance refusals are said in the partner\'s language', (tester) async {
    var tries = 0;
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'COMPLETED',
              visit: visitJson(done: visitJson()['steps'] as List<String>),
            ),
          ),
          'POST /v1/partner/bookings/b-1/balance': () => ++tries == 1
              ? (
                  409,
                  {
                    'error': {'code': 'BALANCE_NOT_DUE', 'message': 'none', 'details': {}},
                  },
                )
              : (
                  422,
                  {
                    'error': {
                      'code': 'BALANCE_TOO_HIGH',
                      'message': 'high',
                      'details': {'duePaise': 40000},
                    },
                  },
                ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push('/job/b-1/balance');
    await tester.pumpAndSettle();
    await tapKey(tester, 'save-balance');
    expect(find.text('Nothing to collect: the family paid the full price in the app.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('balance-amount')), '500');
    await tapKey(tester, 'save-balance');
    expect(find.text("That's more than the balance to collect (₹400)."), findsOneWidget);
  });
}
