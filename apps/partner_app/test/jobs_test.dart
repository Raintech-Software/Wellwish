import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fixtures.dart';
import 'support.dart';

/// Offers and jobs in the partner app (PHASES 7.10, 7.14-7.16).

Map<String, (int, Object) Function()> approved({required Map<String, (int, Object) Function()> extra}) => {
  ...baseRoutes('APPROVED', () => kyc(status: 'APPROVED', done: true)),
  ...extra,
};

/// Scrolls the list until [key] is built and visible, then taps it.
Future<void> tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(finder, 300, scrollable: find.byType(Scrollable).hitTestable().first);
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('going available needs today\'s selfie (7.10)', (tester) async {
    var available = false;
    var selfie = false;
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(available: available, selfie: selfie)),
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
            selfie = true;
            return (200, {'availableToday': false, 'selfieToday': true});
          },
          'PATCH /v1/partner/me/availability': () {
            available = true;
            return (200, {'availableToday': true, 'selfieToday': true});
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.byKey(const Key('available-today')));
    await tester.pumpAndSettle();
    expect(find.text("Today's selfie"), findsOneWidget);
    expect(backend.calls, isNot(contains('PATCH /v1/partner/me/availability')));
    await tester.tap(find.byKey(const Key('take-selfie')));
    await tester.pumpAndSettle();
    expect(backend.bodies['POST /v1/partner/kyc/upload-url'], contains('partner_selfie'));
    expect(backend.bodies['POST /v1/partner/me/selfie'], contains('partners/selfies/u-1/s.jpg'));
    expect(backend.calls, contains('PATCH /v1/partner/me/availability'));
    expect(find.text("Selfie saved. You're available today."), findsOneWidget);
    expect(tester.widget<Switch>(find.byKey(const Key('available-today'))).value, isTrue);
  });

  testWidgets('an offer on Home: summary, countdown, accept → full details (7.14-7.16)', (tester) async {
    var accepted = false;
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () =>
              (200, homeJson(available: true, selfie: true, offers: accepted ? [] : [offerJson()])),
          'GET /v1/partner/offers/a-1': () => (200, offerJson()),
          'POST /v1/partner/offers/a-1/accept': () {
            accepted = true;
            return (200, jobJson());
          },
          'GET /v1/partner/jobs/b-1': () => (200, jobJson()),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    expect(find.text('New offers'), findsOneWidget);
    expect(find.textContaining('left to answer'), findsOneWidget);
    expect(find.text('₹400'), findsOneWidget);
    await tester.tap(find.byKey(const Key('offer-a-1')));
    await tester.pumpAndSettle();
    // R09: no address, no phones, no health notes yet
    expect(find.text('Booking offer'), findsOneWidget);
    expect(find.text('Saheed Nagar, Bhubaneswar 751007\n2.4 km from your home'), findsOneWidget);
    expect(find.text('Needs support · Odia'), findsOneWidget);
    expect(find.textContaining('Plot 12'), findsNothing);
    expect(find.textContaining('BP, diabetes'), findsNothing);
    expect(find.text('You collect ₹400 after the job'), findsOneWidget);
    await tapKey(tester, 'accept-offer');
    // R11: the full details now
    expect(find.text('Job WW-10001'), findsOneWidget);
    expect(find.text('BP, diabetes'), findsOneWidget);
    expect(find.textContaining('Plot 12, Saheed Nagar'), findsOneWidget);
    expect(find.byKey(const Key('call-member')), findsOneWidget);
    expect(find.byKey(const Key('call-booker')), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Dr. Rath BP tablets'), 300);
    expect(find.text('Dr. Rath BP tablets'), findsOneWidget);
  });

  testWidgets('after 2 minutes the card says WellWish is waiting; accepting still works', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true, offers: [offerJson(secondsLeft: -40)])),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    expect(find.text('Please answer: WellWish is waiting'), findsOneWidget);
  });

  testWidgets('decline needs a reason and goes back', (tester) async {
    var declined = false;
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true, offers: declined ? [] : [offerJson()])),
          'GET /v1/partner/offers/a-1': () => (200, offerJson()),
          'POST /v1/partner/offers/a-1/decline': () {
            declined = true;
            return (200, <Object>[]);
          },
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.byKey(const Key('offer-a-1')));
    await tester.pumpAndSettle();
    await tapKey(tester, 'decline-offer');
    expect(find.text("Why can't you take it?"), findsOneWidget);
    await tester.tap(find.byKey(const Key('decline-too-far')));
    await tester.enterText(find.byType(TextField).last, 'No bus');
    await tester.tap(find.byKey(const Key('confirm-decline')));
    await tester.pumpAndSettle();
    expect(backend.bodies['POST /v1/partner/offers/a-1/decline'], contains('"reason":"TOO_FAR"'));
    expect(backend.bodies['POST /v1/partner/offers/a-1/decline'], contains('No bus'));
    expect(find.text('Declined. WellWish will find someone else.'), findsOneWidget);
    expect(find.text('New offers'), findsNothing);
  });

  testWidgets('a withdrawn offer: "no longer yours"', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true, offers: [offerJson()])),
          'GET /v1/partner/offers/a-1': () => (200, offerJson()),
          'POST /v1/partner/offers/a-1/accept': () => (
            409,
            {
              'error': {'code': 'OFFER_NOT_OPEN', 'message': 'gone', 'details': {}},
            },
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.byKey(const Key('offer-a-1')));
    await tester.pumpAndSettle();
    await tapKey(tester, 'accept-offer');
    expect(find.text('This booking is no longer yours.'), findsOneWidget);
  });

  testWidgets('a new offer over the socket appears on Home without a refresh', (tester) async {
    final socket = FakeSocket();
    var offers = <Map<String, dynamic>>[];
    final backend = Backend(
      approved(extra: {'GET /v1/partner/home': () => (200, homeJson(selfie: true, offers: offers))}),
    );
    await pumpPartnerApp(tester, backend, socket: socket);
    expect(find.text('New offers'), findsNothing);
    offers = [offerJson()];
    socket.messages.add({
      'type': 'offer.new',
      'data': {'assignmentId': 'a-1', 'bookingId': 'b-1', 'kind': 'NEW'},
    });
    await tester.pumpAndSettle();
    expect(find.text('New offers'), findsOneWidget);
  });

  testWidgets('accepted by phone meanwhile: Accept opens the job instead of "no longer yours"', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true, offers: [offerJson()])),
          'GET /v1/partner/offers/a-1': () => (200, offerJson()),
          'POST /v1/partner/offers/a-1/accept': () => (
            409,
            {
              'error': {'code': 'OFFER_NOT_OPEN', 'message': 'gone', 'details': {}},
            },
          ),
          'GET /v1/partner/jobs/b-1': () => (200, jobJson()),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.byKey(const Key('offer-a-1')));
    await tester.pumpAndSettle();
    await tapKey(tester, 'accept-offer');
    expect(find.text('Job WW-10001'), findsOneWidget);
    expect(find.text('This booking is no longer yours.'), findsNothing);
  });

  testWidgets('an offer that is already theirs shows "Open the job", not Accept', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/offers/a-1': () => (200, offerJson(response: 'ACCEPTED_BY_PHONE')),
          'GET /v1/partner/jobs/b-1': () => (200, jobJson()),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    final router = tester.element(find.byType(Scaffold).first);
    GoRouter.of(router).push('/offer/a-1');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('accept-offer')), findsNothing);
    expect(find.text('This job is yours.'), findsOneWidget);
    await tapKey(tester, 'open-job');
    expect(find.text('Job WW-10001'), findsOneWidget);
  });

  testWidgets('Jobs tab: new, upcoming, completed (R10)', (tester) async {
    final backend = Backend(
      approved(
        extra: {
          'GET /v1/partner/home': () => (200, homeJson(selfie: true)),
          'GET /v1/partner/offers': () => (200, [offerJson(kind: 'RECONFIRM')]),
          'GET /v1/partner/jobs': () => (
            200,
            {
              'items': [jobRowJson()],
              'count': 1,
              'page': 1,
              'pageSize': 50,
            },
          ),
        },
      ),
    );
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Jobs').last);
    await tester.pumpAndSettle();
    expect(find.text('Time changed: please confirm'), findsOneWidget);
    await tester.tap(find.byKey(const Key('jobs-upcoming')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('job-WW-10001')), findsOneWidget);
    expect(find.text('Accepted'), findsOneWidget);
  });
}
