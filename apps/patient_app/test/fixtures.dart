import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

/// Fake server answers shared by the family and booking tests.

Map<String, Object?> member({
  String id = 'm-2',
  String relation = 'MOTHER',
  String name = 'Sabitri Gouda',
  int addresses = 0,
  int documents = 0,
}) => {
  'id': id,
  'relation': relation,
  'isSelf': relation == 'SELF',
  'fullName': name,
  'dob': '1954-03-02',
  'age': 72,
  'gender': 'FEMALE',
  'photoKey': '',
  'photoUrl': null,
  'phone': relation == 'SELF' ? '' : '+919876500011',
  'language': 'Odia',
  'conditions': 'BP, diabetes',
  'allergies': '',
  'mobility': 'NEEDS_SUPPORT',
  'sensoryNotes': 'Hard of hearing',
  'emergencyName': '',
  'emergencyPhone': '',
  'consentAt': relation == 'SELF' ? null : '2026-10-09T10:00:00Z',
  'addressCount': addresses,
  'documentCount': documents,
};

final self = member(id: 'm-1', relation: 'SELF', name: 'Asha Das');

Map<String, Object?> address({bool inside = true}) => {
  'id': 'a-1',
  'memberId': 'm-2',
  'label': 'Home',
  'line1': 'Plot 12, Saheed Nagar, Bhubaneswar 751007',
  'landmark': '',
  'notes': '',
  'lat': '20.296100',
  'lng': '85.824500',
  'inServiceArea': inside,
  'createdAt': '2026-10-09T10:00:00Z',
};

Map<String, Object?> document({String id = 'd-1', String type = 'LAB_REPORT', String title = 'Blood test'}) => {
  'id': id,
  'memberId': 'm-2',
  'memberName': 'Sabitri Gouda',
  'type': type,
  'title': title,
  'date': '2026-08-12',
  'mime': 'application/pdf',
  'sizeBytes': 120000,
  'createdAt': '2026-10-09T10:00:00Z',
};

Map<String, Object?> page(List<Object?> items) => {'items': items, 'count': items.length, 'page': 1, 'pageSize': 20};

Map<String, Handler> loggedInRoutes({String language = 'en'}) => {
  'GET /v1/public/app-config': (_) => (200, appConfig()),
  'GET /v1/patient/me': (_) => (200, me(fullName: 'Asha Das', complete: true, consents: false, language: language)),
  'PUT /v1/patient/me/device': (_) => (200, {'ok': true}),
  'GET /v1/patient/documents/storage': (_) => (200, {'usedBytes': 120000, 'quotaBytes': 209715200}),
  'GET /v1/patient/notifications/unread-count': (_) => (200, {'unread': 0}),
};

Future<void> openTab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}
