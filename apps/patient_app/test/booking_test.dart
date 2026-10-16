import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

/// Directory and booking (PHASES 5.7–5.13).

/// India's date today (the server's dates are India dates).
DateTime istToday() {
  final ist = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
  return DateTime(ist.year, ist.month, ist.day);
}

String ymd(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// The instant of an India time on [day], as the server sends it.
String istAt(DateTime day, int hour, int minute) => DateTime.utc(
  day.year,
  day.month,
  day.day,
  hour,
  minute,
).subtract(const Duration(hours: 5, minutes: 30)).toIso8601String();

final tomorrow = istToday().add(const Duration(days: 1));

Map<String, Object?> service({
  String id = 's-1',
  String name = 'Doctor visit companion',
  String partnerType = 'COMPANION',
  String visitType = 'HOSPITAL_VISIT',
  int price = 50000,
  int fee = 10000,
  int minutes = 240,
  bool docs = false,
}) => {
  'id': id,
  'name': name,
  'nameHi': '',
  'nameOr': '',
  'description': '',
  'descriptionHi': '',
  'descriptionOr': '',
  'partnerType': partnerType,
  'visitType': visitType,
  'pricePaise': price,
  'bookingFeePaise': fee,
  'balancePaise': price - fee,
  'durationMin': minutes,
  'docsRequired': docs,
  'isActive': true,
  'sort': 0,
};

const cardiology = {'id': 'sp-1', 'name': 'Cardiology', 'nameHi': '', 'nameOr': '', 'icon': 'heart', 'doctorCount': 2};

Map<String, Object?> doctor({String id = 'dr-1', String name = 'Dr. Ananya Mishra'}) => {
  'id': id,
  'fullName': name,
  'photoUrl': null,
  'speciality': cardiology,
  'qualifications': 'MBBS, MD',
  'opdInfo': 'Mon to Sat 9:00 to 13:00',
  'languages': ['Odia', 'English'],
  'hospitals': [
    {'id': 'h-1', 'name': 'Capital Hospital'},
  ],
};

Map<String, Object?> hospital() => {
  'id': 'h-1',
  'name': 'Capital Hospital',
  'type': 'HOSPITAL',
  'address': 'Unit 6, Bhubaneswar',
  'city': 'Bhubaneswar',
  'lat': '20.259300',
  'lng': '85.836600',
  'phone': '06742391983',
  'opdHours': 'Mon to Sat 9:00 to 13:00',
  'photoUrl': null,
  'distanceKm': 2.4,
  'doctorCount': 2,
};

Map<String, Object?> times({DateTime? day}) {
  final d = day ?? tomorrow;
  return {
    'date': ymd(d),
    'times': [istAt(d, 9, 0), istAt(d, 9, 30), istAt(d, 10, 0)],
    'days': [
      for (var i = 0; i <= 30; i++) {'date': ymd(istToday().add(Duration(days: i))), 'available': i != 3},
    ],
    'timeStepMin': 30,
    'travelBufferMin': 60,
  };
}

Map<String, Object?> bookingRow({String status = 'PENDING_PAYMENT', String? payBy}) => {
  'id': 'b-1',
  'code': 'WW-10001',
  'status': status,
  'service': {
    'name': 'Doctor visit companion',
    'nameHi': '',
    'nameOr': '',
    'partnerType': 'COMPANION',
    'visitType': 'HOSPITAL_VISIT',
    'durationMin': 240,
    'docsRequired': false,
    'pricePaise': 50000,
    'bookingFeePaise': 10000,
    'balancePaise': 40000,
  },
  'memberName': 'Sabitri Gouda',
  'pickupAt': istAt(tomorrow, 9, 30),
  'appointmentAt': null,
  'hospitalName': 'Capital Hospital',
  'createdAt': '2026-10-09T10:00:00Z',
  'payBy': status == 'PENDING_PAYMENT' ? (payBy ?? '2026-10-09T10:30:00Z') : null,
};

/// Unpaid until 15 minutes from now (Pay works).
String payableUntil() => DateTime.now().toUtc().add(const Duration(minutes: 15)).toIso8601String();

Map<String, Object?> bookingDetail({
  String status = 'PENDING_PAYMENT',
  String? payBy,
  int paid = 0,
  List<Object?> refunds = const [],
  bool? canCancel,
  bool? canReschedule,
  String? rescheduleProblem,
  int reschedulesLeft = 2,
  bool reconfirm = false,
  Map<String, Object?>? partner,
}) {
  final reschedulable = const {'NEW', 'OFFERED', 'ACCEPTED'}.contains(status);
  return {
    ...bookingRow(status: status, payBy: payBy),
    'paidPaise': paid,
    'refunds': refunds,
    'canCancel': canCancel ?? reschedulable,
    'canReschedule': canReschedule ?? (reschedulable && rescheduleProblem == null),
    'rescheduleProblem': rescheduleProblem ?? (reschedulable ? null : 'STATUS'),
    'reschedulesLeft': reschedulesLeft,
    'reconfirmNeeded': reconfirm,
    'partner': partner,
    'member': {
      'id': 'm-2',
      'fullName': 'Sabitri Gouda',
      'relation': 'MOTHER',
      'gender': 'FEMALE',
      'age': 72,
      'phone': '+919876500011',
      'language': 'Odia',
    },
    'address': {
      'label': 'Home',
      'line1': 'Plot 12, Saheed Nagar, Bhubaneswar 751007',
      'landmark': '',
      'notes': '',
      'lat': '20.296100',
      'lng': '85.824500',
    },
    'hospitalId': 'h-1',
    'doctorId': 'dr-1',
    'doctorName': 'Dr. Ananya Mishra',
    'notes': 'Wheelchair at the gate',
    'documents': [
      {'id': 'bd-1', 'documentId': 'd-9', 'type': 'PRESCRIPTION', 'title': 'Dr. Rath BP tablets', 'removed': false},
    ],
    'timeline': [
      {'status': 'PENDING_PAYMENT', 'event': 'CREATE', 'at': '2026-10-09T10:00:00Z'},
      if (status != 'PENDING_PAYMENT') {'status': 'NEW', 'event': 'PAY', 'at': '2026-10-09T10:02:00Z'},
    ],
  };
}

Map<String, Object?> checkoutFor({String code = 'WW-10001'}) => {
  'keyId': 'rzp_test_abcdef123456',
  'orderId': 'order_test_1',
  'amountPaise': 10000,
  'currency': 'INR',
  'bookingCode': code,
  'payBy': payableUntil(),
};

Map<String, Handler> bookingRoutes({List<Object?>? services, List<Object?>? docs}) => {
  ...loggedInRoutes(),
  'GET /v1/patient/members': (_) => (200, [self, member(addresses: 1, documents: 1)]),
  'GET /v1/public/services': (request) => (
    200,
    services ??
        [
          service(),
          service(id: 's-2', name: 'Medicine pickup', visitType: 'ERRAND', price: 20000, fee: 5000, minutes: 120),
        ],
  ),
  'GET /v1/public/specialities': (_) => (200, [cardiology]),
  'GET /v1/patient/booking-times': (request) {
    final date = request.queryParameters['date'];
    // what goes on the wire: the India date first ("2026-10-10 00:00:00.000" is read as it)
    if (date != null) expect(request.uri.queryParameters['date'], startsWith(ymd(DateTime.parse('$date'))));
    return (200, times(day: date == null ? null : DateTime.parse(date.toString().substring(0, 10))));
  },
  'GET /v1/patient/hospitals/nearby': (_) => (
    200,
    {
      'radiusKm': 10,
      'items': [hospital()],
    },
  ),
  'GET /v1/patient/hospitals/h-1': (_) => (
    200,
    {
      ...hospital(),
      'departments': ['Cardiology', 'Orthopaedics'],
      'doctors': [doctor()],
    },
  ),
  'GET /v1/patient/members/m-2': (_) => (
    200,
    {
      'member': member(addresses: 1, documents: 1),
      'addresses': [address()],
      'documents': [],
      'bookings': [],
    },
  ),
  'GET /v1/patient/addresses': (_) => (200, [address()]),
  'GET /v1/patient/documents': (_) =>
      (200, page(docs ?? [document(id: 'd-9', type: 'PRESCRIPTION', title: 'Dr. Rath BP tablets')])),
  'GET /v1/patient/bookings': (_) => (200, page([])),
  'GET /v1/patient/bookings/b-1': (_) => (200, bookingDetail()),
};

Future<void> tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await scrollTo(tester, finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('book a doctor visit companion for Mother tomorrow and pay (W-P2, P10-P16)', (tester) async {
    final posted = <RequestOptions>[];
    final verified = <RequestOptions>[];
    var paid = false;
    final checkout = FakeCheckout();
    final backend = FakeBackend({
      ...bookingRoutes(),
      'POST /v1/patient/bookings': (request) {
        posted.add(request);
        return (200, bookingDetail(payBy: payableUntil()));
      },
      'POST /v1/patient/bookings/b-1/checkout': (_) => (200, checkoutFor()),
      'POST /v1/patient/payments/verify': (request) {
        verified.add(request);
        paid = true;
        return (200, bookingDetail(status: 'NEW', paid: 10000));
      },
      'GET /v1/patient/bookings/b-1': (_) => (200, paid ? bookingDetail(status: 'NEW', paid: 10000) : bookingDetail()),
      'GET /v1/patient/bookings': (request) =>
          (200, page(paid && request.queryParameters['bucket'] == 'upcoming' ? [bookingRow(status: 'NEW')] : [])),
    });
    await pumpPatientApp(tester, backend, loggedIn: true, checkout: checkout);
    expect(find.byKey(const Key('next-booking')), findsNothing);

    await tester.tap(find.text('Book a Companion'));
    await tester.pumpAndSettle();
    expect(find.text('Choose the service you need'), findsOneWidget);
    expect(find.text('Total ₹500'), findsOneWidget);
    await tester.tap(find.byKey(const Key('service-s-1')));
    await tester.pumpAndSettle();

    // P12: Mother, the hospital from the nearby list, her doctor, a time tomorrow
    expect(find.text('Visit details'), findsOneWidget);
    await tapKey(tester, 'for-m-2');
    await tapKey(tester, 'choose-hospital');
    expect(find.text('Hospitals within 10 km'), findsOneWidget);
    expect(find.text('2.4 km away · 2 doctors'), findsOneWidget);
    await tester.tap(find.byKey(const Key('hospital-h-1')));
    await tester.pumpAndSettle();
    expect(find.text('Capital Hospital'), findsOneWidget);
    await tapKey(tester, 'doctor-choice');
    await tester.tap(find.text('Dr. Ananya Mishra · Cardiology').last);
    await tester.pumpAndSettle();
    expect(find.text('Tomorrow'), findsOneWidget);
    await tapKey(tester, 'time-09:30');
    await scrollTo(tester, find.byKey(const Key('booking-notes')));
    await tester.enterText(find.byKey(const Key('booking-notes')), 'Wheelchair at the gate');
    await tapKey(tester, 'details-next');

    // P13: her address
    expect(find.text("Sabitri's addresses"), findsOneWidget);
    await tapKey(tester, 'address-a-1');
    await tapKey(tester, 'address-next');

    // P14: her prescription
    await tapKey(tester, 'attach-d-9');
    await tapKey(tester, 'documents-next');

    // P15: total, pay now, pay after, the rule
    expect(find.text('Review and pay'), findsOneWidget);
    expect(find.text('₹500'), findsOneWidget);
    expect(find.text('₹100'), findsOneWidget);
    expect(find.text('₹400'), findsOneWidget);
    await scrollTo(tester, find.textContaining('get 50% of the booking fee back'));
    expect(find.textContaining('get 50% of the booking fee back'), findsOneWidget);
    // a double tap books once (the button waits, and the key is the same anyway)
    await scrollTo(tester, find.text('Pay ₹100'));
    await tester.tap(find.text('Pay ₹100'));
    await tester.tap(find.text('Pay ₹100'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(posted, hasLength(1));
    final sent = bodyOf(posted.single);
    expect(sent['serviceId'], 's-1');
    expect(sent['memberId'], 'm-2');
    expect(sent['addressId'], 'a-1');
    expect(sent['hospitalId'], 'h-1');
    expect(sent['doctorId'], 'dr-1');
    expect(sent['documentIds'], ['d-9']);
    expect(sent['notes'], 'Wheelchair at the gate');
    expect(sent['pickupAt'], istAt(tomorrow, 9, 30)); // 9:30 India time, sent as UTC
    expect(posted.single.headers['Idempotency-Key'], matches(RegExp(r'^[0-9a-f]{32}$')));

    // Checkout opened with the server's order; what it returned went to the server
    expect(checkout.opened.single.orderId, 'order_test_1');
    final proof = bodyOf(verified.single);
    expect(proof['razorpayOrderId'], 'order_test_1');
    expect(proof['razorpayPaymentId'], 'pay_test_1');
    expect(proof['razorpaySignature'], 'sig');

    // P16: confirmed; back goes Home, which shows it
    expect(find.byKey(const Key('pay-result-confirmed')), findsOneWidget);
    expect(find.text('Booking confirmed'), findsOneWidget);
    expect(find.text('Paid ₹100'), findsOneWidget);
    await scrollTo(tester, find.text('Back to Home'));
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('next-booking')), findsOneWidget);
    expect(find.text("Booked. We're assigning your partner."), findsOneWidget);
  });

  testWidgets('an injection needs a prescription; a taken time goes back to the times (W-P3)', (tester) async {
    var posts = 0;
    final backend = FakeBackend({
      ...bookingRoutes(
        services: [
          service(
            id: 's-7',
            name: 'Injection visit',
            partnerType: 'NURSE',
            visitType: 'HOME_VISIT',
            price: 30000,
            fee: 6000,
            minutes: 45,
            docs: true,
          ),
        ],
        docs: [
          document(id: 'd-1'),
          document(id: 'd-9', type: 'PRESCRIPTION', title: 'Dr. Rath BP tablets'),
        ],
      ),
      'POST /v1/patient/bookings': (_) {
        posts++;
        return (
          409,
          {
            'error': {
              'code': 'TIME_NOT_AVAILABLE',
              'message': 'taken',
              'details': {'reason': 'FULL'},
            },
          },
        );
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.text('Book a Nurse'));
    await tester.pumpAndSettle();
    expect(find.text('Prescription needed'), findsOneWidget);
    await tester.tap(find.byKey(const Key('service-s-7')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('choose-hospital')), findsNothing); // a home visit
    expect(find.text('Visit time'), findsOneWidget);
    await tapKey(tester, 'for-m-2');
    await tapKey(tester, 'time-09:00');
    await tapKey(tester, 'details-next');
    await tapKey(tester, 'address-a-1');
    await tapKey(tester, 'address-next');

    expect(find.text('This service needs a prescription.'), findsOneWidget);
    await tapKey(tester, 'attach-d-1'); // a lab report is not enough
    await tapKey(tester, 'documents-next');
    expect(find.text('Please attach a prescription.'), findsOneWidget);
    expect(find.text('Review and pay'), findsNothing);
    await tapKey(tester, 'attach-d-9');
    await tapKey(tester, 'documents-next');
    expect(find.text('Pay your nurse after the visit'), findsOneWidget);

    await scrollTo(tester, find.text('Pay ₹60'));
    await tester.tap(find.text('Pay ₹60'));
    await tester.pumpAndSettle();
    expect(posts, 1);
    // back on the times, with the time cleared
    expect(find.text('Visit details'), findsOneWidget);
    expect(find.text('This time is no longer available. Please pick another time.'), findsOneWidget);
    // the snack bar goes, then Next really is tapped: the time was cleared
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tapKey(tester, 'details-next');
    expect(find.text('Choose a time.'), findsOneWidget);
    expect(find.text('Review and pay'), findsNothing);
  });

  testWidgets('doctor directory: search, profile, book a companion for this doctor (P08, P09)', (tester) async {
    final searches = <String>[];
    final backend = FakeBackend({
      ...bookingRoutes(),
      'GET /v1/patient/doctors': (request) {
        final q = (request.queryParameters['q'] ?? '').toString();
        searches.add(q);
        final all = [doctor(), doctor(id: 'dr-2', name: 'Dr. Rahul Sharma')];
        return (
          200,
          page(q.isEmpty ? all : all.where((d) => d['fullName'].toString().toLowerCase().contains(q)).toList()),
        );
      },
      'GET /v1/patient/doctors/dr-1': (_) => (200, doctor()),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.text('Doctors').last);
    await tester.pumpAndSettle();
    expect(find.text('Dr. Ananya Mishra'), findsOneWidget);
    expect(find.text('Dr. Rahul Sharma'), findsOneWidget);
    expect(find.text('View Profile'), findsNWidgets(2));

    await tester.enterText(find.byKey(const Key('doctor-search')), 'mishra');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(searches.last, 'mishra');
    expect(find.text('Dr. Rahul Sharma'), findsNothing);

    await tester.tap(find.text('View Profile'));
    await tester.pumpAndSettle();
    expect(find.text('MBBS, MD'), findsOneWidget);
    expect(find.text('Mon to Sat 9:00 to 13:00'), findsOneWidget);
    await tapKey(tester, 'book-for-doctor');
    // only services that go to a hospital, for this doctor
    expect(find.text('For Dr. Ananya Mishra'), findsOneWidget);
    expect(find.byKey(const Key('service-s-1')), findsOneWidget);
    expect(find.byKey(const Key('service-s-2')), findsNothing);
    await tester.tap(find.byKey(const Key('service-s-1')));
    await tester.pumpAndSettle();
    expect(find.text('Capital Hospital'), findsOneWidget);
    expect(find.text('Dr. Ananya Mishra · Cardiology'), findsOneWidget);
  });

  testWidgets('nearby hospitals: list, map, hospital page (P06, P07)', (tester) async {
    final backend = FakeBackend({
      ...bookingRoutes(),
      'GET /v1/patient/doctors': (_) => (200, page([doctor()])),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.text('Doctors').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hospitals'));
    await tester.pumpAndSettle();
    expect(find.text('Hospitals within 10 km'), findsOneWidget);
    expect(find.text('Hospital · Bhubaneswar'), findsOneWidget);
    expect(backend.calls, contains('GET /v1/patient/hospitals/nearby'));

    await tester.tap(find.byKey(const Key('hospital-map-toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hospital-pin-h-1')));
    await tester.pumpAndSettle();
    expect(find.text('OPD hours'), findsOneWidget);
    expect(find.text('Orthopaedics'), findsOneWidget);
    expect(find.text('Dr. Ananya Mishra'), findsOneWidget);
    await tapKey(tester, 'book-at-hospital');
    expect(find.text('For Capital Hospital'), findsOneWidget);
  });

  testWidgets('a family member profile lists their bookings and books for them (P29)', (tester) async {
    final backend = FakeBackend({
      ...bookingRoutes(),
      'GET /v1/patient/members/m-2': (_) => (
        200,
        {
          'member': member(addresses: 1, documents: 1),
          'addresses': [address()],
          'documents': [],
          'bookings': [bookingRow(status: 'NEW')],
        },
      ),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Family');
    await tester.tap(find.text('Sabitri Gouda'));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Doctor visit companion'));
    expect(find.textContaining("We're assigning your partner"), findsOneWidget);
    await tapKey(tester, 'member-book');
    await tester.tap(find.byKey(const Key('book-type-companion')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('service-s-1')));
    await tester.pumpAndSettle();
    final chip = tester.widget<ChoiceChip>(find.byKey(const Key('for-m-2')));
    expect(chip.selected, isTrue); // started from her profile
  });

  testWidgets('booking screens in Odia', (tester) async {
    final backend = FakeBackend({...bookingRoutes(), ...loggedInRoutes(language: 'or')});
    await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.text('ସାଥୀ ବୁକ୍ କରନ୍ତୁ'));
    await tester.pumpAndSettle();
    expect(find.text('ଆପଣଙ୍କୁ ଦରକାର ସେବା ବାଛନ୍ତୁ'), findsOneWidget);
    expect(find.text('ମୋଟ ₹500'), findsOneWidget);
    await tester.tap(find.byKey(const Key('service-s-1')));
    await tester.pumpAndSettle();
    expect(find.text('ଭିଜିଟ୍ ବିବରଣୀ'), findsOneWidget);
    expect(find.text('କାଲି'), findsOneWidget); // Tomorrow
  });

  testWidgets('an unpaid booking past its time does not make Home reload again and again', (tester) async {
    final backend = FakeBackend({
      ...bookingRoutes(),
      'GET /v1/patient/bookings': (_) => (
        200,
        page([
          {...bookingRow(), 'payBy': DateTime.now().toUtc().subtract(const Duration(hours: 1)).toIso8601String()},
        ]),
      ),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    expect(find.byKey(const Key('next-booking')), findsOneWidget);
    final calls = backend.calls.where((c) => c == 'GET /v1/patient/bookings').length;
    await tester.pump(const Duration(seconds: 30));
    await tester.pumpAndSettle();
    expect(backend.calls.where((c) => c == 'GET /v1/patient/bookings').length, calls); // not before a minute
  });
}
