import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'booking_test.dart' show bookingDetail;
import 'fixtures.dart';
import 'payments_test.dart' show withBooking;
import 'support.dart';

/// P25 Notifications and the bell on Home (Phase 9C, ARCHITECTURE v2.32).

Map<String, Object?> message(String id, String type, String title, {String? bookingId, bool read = false}) => {
  'id': id,
  'type': type,
  'title': title,
  'body': '$title body',
  'data': {'type': type, 'bookingId': ?bookingId},
  'createdAt': '2026-10-16T05:00:00Z',
  'readAt': read ? '2026-10-16T05:01:00Z' : null,
};

Finder badgeWith(String text) => find.descendant(of: find.byKey(const Key('notification-bell')), matching: find.text(text));

void main() {
  testWidgets('the bell shows the unread count; the inbox lists the messages, marks them read and opens the booking', (
    tester,
  ) async {
    var unread = 2;
    var reads = 0;
    Object? marked;
    final backend = FakeBackend({
      ...withBooking(() => bookingDetail(status: 'ACCEPTED', paid: 10000)),
      'GET /v1/patient/notifications/unread-count': (_) => (200, {'unread': unread}),
      'GET /v1/patient/notifications': (_) => (
        200,
        page([
          message('n-2', 'BOOKING_ASSIGNED', 'Your companion is confirmed', bookingId: 'b-1'),
          message('n-1', 'BOOKING_CONFIRMED', 'Booking confirmed', bookingId: 'b-1'),
          message('n-0', 'TICKET_REPLY', 'WellWish replied', read: true),
        ]),
      ),
      'POST /v1/patient/notifications/read': (request) {
        reads++;
        marked = bodyOf(request)['ids'];
        unread = 0;
        return (200, {'unread': 0});
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    expect(badgeWith('2'), findsOneWidget);
    expect(find.byTooltip('Notifications, 2 unread'), findsOneWidget);

    await tester.tap(find.byKey(const Key('notification-bell')));
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Your companion is confirmed'), findsOneWidget);
    expect(find.text('Booking confirmed'), findsOneWidget);
    expect(find.text('WellWish replied'), findsOneWidget);
    expect(reads, 1); // opening the inbox marks what it shows as read
    expect(marked, ['n-2', 'n-1']); // by id: a message saved meanwhile stays new

    // a message about a booking opens it
    await tester.tap(find.byKey(const Key('notification-n-2')));
    await tester.pumpAndSettle();
    expect(find.text('Booking WW-10001'), findsOneWidget);

    // back on Home the bell is at 0
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(badgeWith('2'), findsNothing);
    expect(find.byTooltip('Notifications'), findsOneWidget);
  });

  testWidgets('a new message arrives live: the bell counts it at once', (tester) async {
    final socket = FakeSocket();
    final backend = FakeBackend({...loggedInRoutes()});
    await pumpPatientApp(tester, backend, loggedIn: true, socket: socket);
    expect(find.byTooltip('Notifications'), findsOneWidget);
    socket.messages.add({
      'type': 'notification.new',
      'data': {'type': 'BOOKING_CONFIRMED', 'unread': 3},
    });
    await tester.pumpAndSettle();
    expect(badgeWith('3'), findsOneWidget);
  });

  testWidgets('older messages load with "Load more"; a failed "mark read" still shows the list', (tester) async {
    final pages = <String>[];
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/notifications': (request) {
        final number = request.queryParameters['page'].toString();
        pages.add(number);
        final items = number == '1'
            ? [for (var i = 0; i < 30; i++) message('n-$i', 'BOOKING_CONFIRMED', 'Message $i')]
            : [message('n-old', 'TICKET_REPLY', 'The oldest message')];
        return (200, {'items': items, 'count': 31, 'page': int.parse(number), 'pageSize': 30});
      },
      'POST /v1/patient/notifications/read': (_) => (
        500,
        {
          'error': {'code': 'SERVER_ERROR', 'message': 'down', 'details': {}},
        },
      ),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.byKey(const Key('notification-bell')));
    await tester.pumpAndSettle();
    expect(find.text('Message 0'), findsOneWidget); // the list shows although "mark read" failed
    await scrollTo(tester, find.byKey(const Key('notifications-more')));
    await tester.tap(find.byKey(const Key('notifications-more')));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('The oldest message'));
    expect(find.text('The oldest message'), findsOneWidget);
    expect(find.byKey(const Key('notifications-more')), findsNothing);
    expect(find.text('Messages from the last 30 days are kept here.'), findsOneWidget);
    expect(pages, ['1', '2']);
  });

  testWidgets('after logout the next person on the phone gets their own count', (tester) async {
    final socket = FakeSocket();
    var count = 4;
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/notifications/unread-count': (_) => (200, {'unread': count}),
      'POST /v1/auth/otp/send': (_) => (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 30, 'length': 6}),
      'POST /v1/auth/otp/verify': (_) => (200, tokens),
    });
    await pumpPatientApp(tester, backend, loggedIn: true, socket: socket);
    expect(badgeWith('4'), findsOneWidget);
    // signed out (here the server revokes the session), then someone else logs in on this phone
    socket.messages.add({
      'type': 'session.revoked',
      'data': {'reason': 'LOGOUT'},
    });
    await tester.pumpAndSettle();
    count = 0;
    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('ww-otp-input')), '123456');
    await tester.pumpAndSettle();
    expect(find.text('Hello, Asha 👋'), findsOneWidget);
    expect(badgeWith('4'), findsNothing); // not the previous person's number
    expect(find.byTooltip('Notifications'), findsOneWidget);
  });

  testWidgets('an empty inbox says so', (tester) async {
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/notifications': (_) => (200, page([])),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.byKey(const Key('notification-bell')));
    await tester.pumpAndSettle();
    expect(find.text('No messages yet.'), findsOneWidget);
  });
}
