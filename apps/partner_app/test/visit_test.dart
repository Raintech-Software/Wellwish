import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:partner_app/features/jobs/collect_balance_screen.dart';
import 'package:partner_app/features/jobs/visit_outbox.dart';
import 'package:ww_core/ww_core.dart';

import 'jobs_test.dart' show approved, tapKey;
import 'support.dart';

/// The visit in the partner app: R12 active job, live location, offline steps, R13 care note,
/// R14 balance, R15 totals (PHASES 8.10-8.12).

Future<void> openJob(WidgetTester tester) async {
  final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
  router.push('/job/b-1');
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('On the way: the step goes up with GPS and the location is shared live', (tester) async {
    var done = <String>[];
    final socket = FakeSocket();
    final tracker = FakeTracker();
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: done.isEmpty ? 'ACCEPTED' : 'IN_PROGRESS',
              visit: visitJson(done: done),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () {
            done = [...done, 'ON_THE_WAY'];
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
    await pumpPartnerApp(tester, backend, socket: socket, tracker: tracker);
    socket.messages.add({'type': 'auth.ok', 'data': {}});
    await tester.pump();
    await openJob(tester);
    expect(find.byKey(const Key('active-job')), findsOneWidget);
    expect(find.text('On the way'), findsOneWidget); // the big button
    await tapKey(tester, 'next-step');
    final body = jsonDecode(backend.bodies['POST /v1/partner/bookings/b-1/steps']! as String) as Map;
    expect(body['step'], 'ON_THE_WAY');
    expect(body['lat'], '20.296100');
    expect(body['mock'], isNot(isTrue));
    expect(tracker.running, isTrue);
    expect(find.text('Sharing your location with the patient'), findsOneWidget);
    expect(find.text('Reached the patient'), findsOneWidget); // next
    tracker.points.add(TrackPoint(lat: 20.29, lng: 85.84, accuracy: 9, mock: false, at: DateTime.now().toUtc()));
    await tester.pump();
    expect(socket.sent.single['type'], 'location.update');
    expect(socket.sent.single['bookingId'], 'b-1');
    expect(find.byKey(const Key('sos')), findsOneWidget);
  });

  testWidgets('SOS sends the point just shared (no wait for a fresh fix indoors) (deep check)', (tester) async {
    final socket = FakeSocket();
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
          'POST /v1/partner/bookings/b-1/sos': () =>
              (200, {'id': 's-1', 'status': 'OPEN', 'createdAt': '2026-10-13T10:00:00Z'}),
        },
      ),
    );
    await pumpPartnerApp(tester, backend, socket: socket, tracker: tracker);
    socket.messages.add({'type': 'auth.ok', 'data': {}});
    await tester.pump();
    await openJob(tester);
    tracker.points.add(TrackPoint(lat: 20.29, lng: 85.84, accuracy: 9, mock: false, at: DateTime.now().toUtc()));
    await tester.pump();
    await tapKey(tester, 'sos');
    await tester.tap(find.byKey(const Key('send-sos')));
    await tester.pumpAndSettle();
    final body = jsonDecode(backend.bodies['POST /v1/partner/bookings/b-1/sos']! as String) as Map;
    expect(body['lat'], '20.290000'); // the shared point, not a new fix (20.296100)
    expect(body['mock'], isFalse);
    expect(find.byKey(const Key('sos-sent')), findsOneWidget);
  });

  testWidgets('a fake (mock) location goes up marked as fake: the server doesn\'t keep it (§12)', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'ACCEPTED',
              visit: visitJson(done: []),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(done: ['ON_THE_WAY']),
            ),
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend, location: FakeLocation(mock: true));
    await openJob(tester);
    await tapKey(tester, 'next-step');
    final body = jsonDecode(backend.bodies['POST /v1/partner/bookings/b-1/steps']! as String) as Map;
    expect(body['step'], 'ON_THE_WAY');
    expect(body['mock'], isTrue);
  });

  testWidgets('the OTP step asks for the family\'s code; a wrong one says how many tries are left', (tester) async {
    var tries = 0;
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: 'IN_PROGRESS',
              visit: visitJson(
                done: tries < 3 ? ['ON_THE_WAY', 'REACHED_PATIENT'] : ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP'],
              ),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () {
            tries++;
            if (tries == 1) {
              return (
                422,
                {
                  'error': {
                    'code': 'WRONG_OTP',
                    'message': 'wrong',
                    'details': {'triesLeft': 3},
                  },
                },
              );
            }
            if (tries == 2) {
              // the 4th wrong code: a wait before the next try (§6.11)
              return (
                422,
                {
                  'error': {
                    'code': 'WRONG_OTP',
                    'message': 'wrong',
                    'details': {'triesLeft': 0, 'retryAt': '2026-10-12T05:10:00Z'},
                  },
                },
              );
            }
            return (
              200,
              jobJson(
                status: 'IN_PROGRESS',
                visit: visitJson(done: ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP']),
              ),
            );
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await openJob(tester);
    await tapKey(tester, 'next-step');
    expect(find.text('Ask for the visit code'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('otp-input')), '1111');
    await tester.tap(find.byKey(const Key('confirm-otp')));
    await tester.pumpAndSettle();
    expect(find.text('Wrong code. 3 tries left.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('confirm-otp')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Too many wrong codes. Try again at 10:40'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('otp-input')), '4821');
    await tester.tap(find.byKey(const Key('confirm-otp')));
    await tester.pumpAndSettle();
    expect(backend.bodies['POST /v1/partner/bookings/b-1/steps'], contains('"otp":"4821"'));
    expect(find.text('Ask for the visit code'), findsNothing);
  });

  testWidgets('no network: the step is kept on the phone and sent when back online', (tester) async {
    var online = false;
    var done = ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP'];
    final socket = FakeSocket();
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
            done = [...done, 'REACHED_HOSPITAL'];
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
    await pumpPartnerApp(tester, backend, socket: socket, outbox: outbox);
    await openJob(tester);
    expect(find.text('At the hospital'), findsOneWidget);
    // picked up: Maps goes to the hospital now, not the home
    for (var i = 0; i < 6 && find.byKey(const Key('navigate-hospital')).evaluate().isEmpty; i++) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -400));
      await tester.pumpAndSettle();
    }
    expect(find.byKey(const Key('navigate-hospital')), findsOneWidget);
    expect(find.byKey(const Key('navigate')), findsNothing);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 3000)); // back to the top
    await tester.pumpAndSettle();
    await tapKey(tester, 'next-step');
    expect(find.text("Saved on your phone. It'll be sent when you're back online."), findsOneWidget);
    expect(find.text('Waiting for network: 1 step to send'), findsOneWidget);
    expect(find.text('Visit done'), findsOneWidget); // the next one, already
    expect(outbox.stepList.single['step'], 'REACHED_HOSPITAL');
    // back online: the socket says hello again and the kept step goes up
    online = true;
    socket.messages.add({'type': 'auth.ok', 'data': {}});
    await tester.pumpAndSettle();
    expect(outbox.stepList, isEmpty);
    expect(find.byKey(const Key('pending-steps')), findsNothing);
    expect(done.last, 'REACHED_HOSPITAL');
  });

  testWidgets('R13 care note with vitals; R14 the balance after completed', (tester) async {
    var done = ['ON_THE_WAY', 'REACHED_HOME', 'STARTED'];
    int? balance;
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/jobs/b-1': () => (
            200,
            jobJson(
              status: done.contains('COMPLETED') ? 'COMPLETED' : 'IN_PROGRESS',
              visit: visitJson(type: 'HOME_VISIT', done: done, balance: balance, mode: balance == null ? '' : 'UPI'),
            ),
          ),
          'POST /v1/partner/bookings/b-1/steps': () {
            done = [...done, done.contains('CARE_DONE') ? 'COMPLETED' : 'CARE_DONE'];
            return (
              200,
              jobJson(
                status: 'IN_PROGRESS',
                visit: visitJson(type: 'HOME_VISIT', done: done),
              ),
            );
          },
          'POST /v1/partner/bookings/b-1/balance': () {
            balance = 40000;
            return (
              200,
              jobJson(
                status: 'COMPLETED',
                visit: visitJson(type: 'HOME_VISIT', done: done, balance: balance, mode: 'UPI'),
              ),
            );
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await openJob(tester);
    await tapKey(tester, 'next-step'); // Care done → the care note
    expect(find.text('Care note'), findsWidgets);
    await tester.enterText(find.byKey(const Key('care-note')), 'Dressing changed, wound clean.');
    await tester.enterText(find.byKey(const Key('vital-bp')), '130/85');
    await tester.enterText(find.byKey(const Key('vital-pulse')), '300'); // out of range
    await tapKey(tester, 'save-care-note');
    expect(find.text('Check this value'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('vital-pulse')), '78');
    await tapKey(tester, 'save-care-note');
    final sent = backend.bodies['POST /v1/partner/bookings/b-1/steps']! as String;
    expect(sent, contains('"step":"CARE_DONE"'));
    expect(sent, contains('"bp":"130/85"'));
    expect(sent, contains('"pulse":78'));
    // back on the job: Completed → the balance (pre-filled ₹400)
    expect(find.text('Completed'), findsWidgets);
    await tapKey(tester, 'next-step');
    expect(find.text('Collect balance'), findsOneWidget);
    expect(find.widgetWithText(TextField, '400'), findsOneWidget);
    await tester.tap(find.byKey(const Key('mode-upi')));
    await tester.pumpAndSettle();
    // rupees with paise (9.11)
    await tester.enterText(find.byKey(const Key('balance-amount')), '400.50');
    await tapKey(tester, 'save-balance');
    expect(backend.bodies['POST /v1/partner/bookings/b-1/balance'], contains('"amountPaise":40050'));
    expect(backend.bodies['POST /v1/partner/bookings/b-1/balance'], contains('"mode":"UPI"'));
    expect(find.text('Collected ₹400.50 (UPI)'), findsWidgets);
  });

  testWidgets('R15 totals from the Home numbers', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/totals': () => (
            200,
            {
              'jobs': {'today': 1, 'thisWeek': 3, 'thisMonth': 9, 'allTime': 21},
              'balanceWeek': {'cashPaise': 80000, 'upiPaise': 40000},
              'balanceMonth': {'cashPaise': 200000, 'upiPaise': 100000},
              'balanceAll': {'cashPaise': 500000, 'upiPaise': 300000},
              'offersReceived': 25,
              'offersAccepted': 21,
              'offersDeclined': 3,
              'offersNotAnswered': 1,
              'ratingAvg': '4.8',
              'ratingCount': 12,
              'recentReviews': [
                {
                  'stars': 5,
                  'tags': ['KIND', 'LATE'],
                  'comment': 'Very patient',
                  'createdAt': '2026-10-09T08:00:00Z',
                  'serviceName': 'Doctor visit companion',
                },
              ],
              'upcoming': 2,
            },
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Done today'));
    await tester.pumpAndSettle();
    expect(find.text('Totals'), findsOneWidget);
    expect(find.text('21'), findsOneWidget);
    expect(find.text('Cash ₹5,000 · UPI ₹3,000'), findsOneWidget);
    expect(find.text('25 received · 21 accepted · 3 declined · 1 not answered in 2 min'), findsOneWidget);
    expect(find.text('Very patient'), findsOneWidget);
    expect(find.text('Kind'), findsOneWidget); // the tags the family picked (9.11)
    expect(find.text('Late'), findsOneWidget);
  });

  test('rupees typed with paise become whole paise, never a float (9.11)', () {
    expect(rupeesToPaise('400'), 40000);
    expect(rupeesToPaise(' 450.5 '), 45050);
    expect(rupeesToPaise('0.05'), 5);
    expect(rupeesToPaise('450.505'), isNull);
    expect(rupeesToPaise('450.'), 45000); // deep check: typed so far, a sensible amount
    expect(rupeesToPaise('450,50'), 45050); // a keyboard with a decimal comma
    expect(rupeesToPaise('abc'), isNull);
    expect(rupeesToPaise(''), isNull);
    expect(paiseToRupeesText(40000), '400');
    expect(paiseToRupeesText(45050), '450.50');
    expect(paiseToRupeesText(5), '0.05');
  });
}
