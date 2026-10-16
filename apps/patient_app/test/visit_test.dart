import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_app/features/booking/review_screen.dart';
import 'package:patient_app/features/visit/live_tracking_screen.dart';
import 'package:ww_l10n/ww_l10n.dart';

import 'booking_test.dart' show bookingDetail, bookingRoutes, tapKey;
import 'fixtures.dart';
import 'payments_test.dart' show openBooking, withBooking;
import 'support.dart';

/// The visit in the patient app: P19 live tracking, the visit code, SOS, share link; P20 pay
/// the partner, rating, report a problem; the nurse's care note in the documents (PHASES 8.13, 8.14).

const _partner = {
  'fullName': 'Rashmita Behera',
  'role': 'COMPANION',
  'photoUrl': null,
  'phone': '+919000000011',
  'ratingAvg': '4.80',
  'ratingCount': 12,
};

Map<String, Object?> visit(List<String> done) {
  const steps = [
    'ON_THE_WAY',
    'REACHED_PATIENT',
    'PICKED_UP',
    'REACHED_HOSPITAL',
    'VISIT_DONE',
    'DROPPED_HOME',
    'COMPLETED',
  ];
  return {
    'steps': steps,
    'done': [
      for (final s in done) {'step': s, 'at': '2026-10-10T04:00:00Z', 'by': 'PARTNER', 'far': false},
    ],
    'currentStep': done.isEmpty ? '' : done.last,
    'nextStep': done.length < steps.length ? steps[done.length] : null,
    'otpStep': 'PICKED_UP',
    'otpLocked': false,
    'noShowReadyAt': null,
    'balanceCollectedPaise': null,
    'balanceMode': '',
  };
}

Map<String, Object?> visitDetail({
  required String status,
  List<String> done = const [],
  String? otp,
  bool canReview = false,
  bool canReport = false,
  Map<String, Object?>? review,
  List<Object?> tickets = const [],
}) => {
  ...bookingDetail(status: status, paid: 10000, partner: status == 'COMPLETED' ? {..._partner, 'phone': ''} : _partner),
  'visit': visit(done),
  'jobOtp': otp,
  'canReview': canReview,
  'canReport': canReport,
  'review': review,
  'tickets': tickets,
};

/// Records what the app put on the clipboard.
List<String> captureClipboard(WidgetTester tester) {
  final copied = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'Clipboard.setData') copied.add((call.arguments as Map)['text'] as String);
    return null;
  });
  addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
  return copied;
}

void main() {
  testWidgets('P19: the visit code, then the live map moves with the partner and stops at Completed', (tester) async {
    final socket = FakeSocket();
    var status = 'IN_PROGRESS';
    RequestOptions? sos;
    final copied = captureClipboard(tester);
    final backend = FakeBackend(
      withBooking(
        () => visitDetail(
          status: status,
          done: status == 'COMPLETED' ? ['ON_THE_WAY', 'COMPLETED'] : ['ON_THE_WAY'],
          otp: status == 'COMPLETED' ? null : '4821',
        ),
        more: {
          'GET /v1/patient/bookings/b-1/live': (_) =>
              (200, {'bookingId': 'b-1', 'lat': null, 'lng': null, 'at': null, 'etaMin': null, 'step': 'ON_THE_WAY'}),
          'POST /v1/patient/bookings/b-1/share-link': (_) =>
              (200, {'url': 'https://wellwish.in/t/abc123', 'expiresAt': '2026-10-10T16:00:00Z'}),
          'POST /v1/patient/bookings/b-1/sos': (request) {
            sos = request;
            return (200, {'id': 'sos-1', 'status': 'OPEN', 'createdAt': '2026-10-10T05:00:00Z'});
          },
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true, socket: socket);
    await openBooking(tester);
    expect(find.text('Now: On the way'), findsOneWidget);
    expect(find.byKey(const Key('visit-code')), findsOneWidget);
    expect(find.text('4821'), findsOneWidget);
    await tapKey(tester, 'track-live');
    expect(find.text('Live visit'), findsOneWidget);
    expect(find.text("Waiting for Rashmita's location…"), findsOneWidget);
    expect(find.byKey(const Key('partner-marker')), findsNothing);
    // the partner's phone sends a point: the family's map moves
    socket.messages.add({
      'type': 'booking.location',
      'data': {
        'bookingId': 'b-1',
        'lat': '20.290000',
        'lng': '85.840000',
        'at': DateTime.now().toUtc().toIso8601String(),
        'etaMin': 6,
        'step': 'ON_THE_WAY',
      },
    });
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('partner-marker')), findsOneWidget);
    expect(find.textContaining('About 6 min away'), findsOneWidget);
    expect(etaText(lookupWWLocalizations(const Locale('en')), 125), 'About 2 h 5 min away');
    // share the trip: a link on the clipboard
    await tapKey(tester, 'share-trip');
    expect(copied, ['https://wellwish.in/t/abc123']);
    expect(find.text('Link copied. Send it on WhatsApp or SMS.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // the message goes away
    await tester.pumpAndSettle();
    // SOS with the phone's location
    await tapKey(tester, 'sos');
    await tester.tap(find.byKey(const Key('send-sos')));
    await tester.pumpAndSettle();
    expect(bodyOf(sos!), {'lat': '20.290000', 'lng': '85.840000', 'mock': false});
    expect(find.byKey(const Key('sos-sent')), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // close the sheet
    await tester.pumpAndSettle();
    // Completed: the live map stops
    status = 'COMPLETED';
    socket.messages.add({
      'type': 'booking.updated',
      'data': {'bookingId': 'b-1', 'status': 'COMPLETED'},
    });
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('live-ended')), findsOneWidget);
    expect(find.byKey(const Key('live-map')), findsNothing);
  });

  testWidgets('P20: pay the partner, rate with tags, report a problem and see the reply', (tester) async {
    RequestOptions? rated;
    RequestOptions? reported;
    final backend = FakeBackend(
      withBooking(
        () => visitDetail(
          status: 'COMPLETED',
          done: ['ON_THE_WAY', 'COMPLETED'],
          canReview: rated == null,
          canReport: reported == null,
          review: rated == null
              ? null
              : {
                  'stars': 5,
                  'tags': ['KIND'],
                  'comment': 'Very patient',
                  'createdAt': '2026-10-10T08:00:00Z',
                },
          tickets: reported == null
              ? []
              : [
                  {
                    'id': 't-1',
                    'text': 'Arrived 30 minutes late',
                    'status': 'OPEN',
                    'createdAt': '2026-10-10T08:05:00Z',
                    'replies': [
                      {
                        'by': 'STAFF',
                        'name': 'Ops',
                        'text': 'Sorry, we have spoken to the partner.',
                        'at': '2026-10-10T09:00:00Z',
                      },
                    ],
                  },
                ],
        ),
        more: {
          'POST /v1/patient/bookings/b-1/review': (request) {
            rated = request;
            return (
              200,
              {
                'stars': 5,
                'tags': ['KIND'],
                'comment': 'Very patient',
                'createdAt': '2026-10-10T08:00:00Z',
              },
            );
          },
          'POST /v1/patient/bookings/b-1/report-problem': (request) {
            reported = request;
            return (
              200,
              {
                'id': 't-1',
                'text': 'Arrived 30 minutes late',
                'status': 'OPEN',
                'createdAt': '2026-10-10T08:05:00Z',
                'replies': [],
              },
            );
          },
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.text('Visit completed'), findsOneWidget);
    expect(find.text('Pay ₹400 to Rashmita'), findsOneWidget);
    expect(find.byKey(const Key('track-live')), findsNothing);
    expect(find.byKey(const Key('visit-code')), findsNothing);
    // rating
    await tapKey(tester, 'send-rating');
    expect(find.text('Choose 1 to 5 stars'), findsOneWidget);
    await tapKey(tester, 'star-2');
    expect(find.byKey(const Key('tag-LATE')), findsOneWidget); // problems for a low rating
    await tapKey(tester, 'star-5');
    expect(find.byKey(const Key('tag-LATE')), findsNothing);
    await tapKey(tester, 'tag-KIND');
    await tester.enterText(find.byKey(const Key('review-comment')), 'Very patient');
    await tapKey(tester, 'send-rating');
    expect(bodyOf(rated!), {
      'stars': 5,
      'tags': ['KIND'],
      'comment': 'Very patient',
    });
    await scrollTo(tester, find.byKey(const Key('your-rating')), up: true);
    expect(find.byKey(const Key('your-rating')), findsOneWidget);
    expect(find.byKey(const Key('rate-visit')), findsNothing);
    // report a problem
    await tapKey(tester, 'report-problem');
    await tester.enterText(find.byKey(const Key('report-text')), 'late');
    await tester.tap(find.byKey(const Key('send-report')));
    await tester.pumpAndSettle();
    expect(find.text('Please write a few words'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('report-text')), 'Arrived 30 minutes late');
    await tester.tap(find.byKey(const Key('send-report')));
    await tester.pumpAndSettle();
    expect(bodyOf(reported!), {'text': 'Arrived 30 minutes late'});
    expect(find.text('Sent. WellWish will get back to you.'), findsOneWidget);
    await scrollTo(tester, find.byKey(const Key('ticket-t-1')));
    expect(find.text('Sorry, we have spoken to the partner.'), findsOneWidget);
    expect(find.byKey(const Key('report-problem')), findsNothing);
  });

  testWidgets('P20 once the partner recorded the balance: "Paid", not "Pay" (9.11)', (tester) async {
    final detail = visitDetail(status: 'COMPLETED', done: ['ON_THE_WAY', 'COMPLETED']);
    (detail['visit']! as Map<String, Object?>)
      ..['balanceCollectedPaise'] = 40000
      ..['balanceMode'] = 'CASH';
    await pumpPatientApp(tester, FakeBackend(withBooking(() => detail)), loggedIn: true);
    await openBooking(tester);
    await scrollTo(tester, find.byKey(const Key('visit-completed')));
    expect(find.text('Paid ₹400 to Rashmita'), findsOneWidget);
    expect(find.textContaining('Pay ₹'), findsNothing);
  });

  testWidgets('the timeline shows the visit steps', (tester) async {
    final backend = FakeBackend(
      withBooking(
        () => {
          ...visitDetail(status: 'IN_PROGRESS', done: ['ON_THE_WAY', 'REACHED_PATIENT']),
          'timeline': [
            {'status': 'PENDING_PAYMENT', 'event': 'CREATE', 'step': '', 'at': '2026-10-09T10:00:00Z'},
            {'status': 'IN_PROGRESS', 'event': 'START', 'step': 'ON_THE_WAY', 'at': '2026-10-10T04:00:00Z'},
            {'status': 'IN_PROGRESS', 'event': 'STEP', 'step': 'REACHED_PATIENT', 'at': '2026-10-10T04:20:00Z'},
          ],
        },
      ),
    );
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openBooking(tester);
    expect(find.text('Now: Reached the patient'), findsOneWidget);
    await scrollTo(tester, find.text('Reached the patient'));
    expect(find.text('Reached the patient'), findsOneWidget);
    expect(find.text('On the way'), findsOneWidget);
  });

  testWidgets("the nurse's care note opens as text with the vitals", (tester) async {
    final backend = FakeBackend({
      ...bookingRoutes(),
      'GET /v1/patient/members': (_) => (200, [self, member()]),
      'GET /v1/patient/documents': (_) => (
        200,
        page([
          {
            ...document(id: 'd-5', type: 'CARE_NOTE', title: 'Care note · WW-10001'),
            'mime': 'text/plain',
            'sizeBytes': 0,
            'text': 'Dressing changed, wound clean.',
            'vitals': {'bp': '130/85', 'pulse': 78},
          },
        ]),
      ),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Reports');
    expect(find.textContaining('Care note'), findsWidgets);
    await tester.tap(find.text('View').first);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('care-note-sheet')), findsOneWidget);
    expect(find.text('Dressing changed, wound clean.'), findsOneWidget);
    expect(find.text('BP: 130/85'), findsOneWidget);
    expect(find.text('Pulse: 78'), findsOneWidget);
    expect(backend.calls.where((c) => c.contains('view-url')), isEmpty);
  });

  testWidgets('a booking paid in full in the app shows nothing to pay the partner', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: WWLocalizations.localizationsDelegates,
        supportedLocales: WWLocalizations.supportedLocales,
        home: Scaffold(body: PriceBox(total: 50000, fee: 50000, balance: 0, isNurse: false)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('paid-in-full')), findsOneWidget);
    expect(find.text('Pay your companion after the visit'), findsNothing);
  });
}
