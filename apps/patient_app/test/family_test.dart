import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ww_core/ww_core.dart';

import 'fixtures.dart';
import 'support.dart';

/// Family, addresses, documents and settings (PHASES 4.6–4.11).

void main() {
  testWidgets('add Mother with her details and consent (P22, P28)', (tester) async {
    var members = <Object?>[self];
    Map<String, dynamic>? sent;
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, members),
      'POST /v1/patient/members': (request) {
        sent = bodyOf(request);
        members = [self, member()];
        return (200, member());
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Family');
    expect(find.text('Stay connected with your loved ones'), findsOneWidget);
    expect(find.text('No family members yet'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-member')));
    await tester.pumpAndSettle();
    expect(find.text('Add family member'), findsOneWidget);

    // nothing filled in: the form says what is missing and doesn't send
    await scrollTo(tester, find.byKey(const Key('member-save')));
    await tester.tap(find.byKey(const Key('member-save')));
    await tester.pumpAndSettle();
    expect(sent, isNull);
    expect(find.text('Please tick to confirm their permission.'), findsOneWidget);
    expect(find.text('Some details are missing. Check the fields marked in red.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // the snackbar goes away
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text('Mother'), up: true);
    await tester.tap(find.text('Mother'));
    await tester.enterText(find.byKey(const Key('member-name')), 'Sabitri Gouda');
    await tester.tap(find.byKey(const Key('member-dob')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Female'));
    await scrollTo(tester, find.byKey(const Key('member-phone')));
    await tester.enterText(
      find.descendant(of: find.byKey(const Key('member-phone')), matching: find.byType(TextField)),
      '9876500011',
    );
    await scrollTo(tester, find.byKey(const Key('member-consent')));
    await tester.tap(find.byKey(const Key('member-consent')));
    await scrollTo(tester, find.byKey(const Key('member-save')));
    await tester.tap(find.byKey(const Key('member-save')));
    await tester.pumpAndSettle();

    expect(sent!['relation'], 'MOTHER');
    expect(sent!['fullName'], 'Sabitri Gouda');
    expect(sent!['phone'], '9876500011');
    expect(sent!['consent'], true);
    expect(sent!['language'], '');
    expect(find.text('Sabitri Gouda'), findsOneWidget); // back on the list
    expect(find.text('Mother · 72 yrs'), findsOneWidget);
  });

  testWidgets('member profile: health notes, address outside the area, documents, remove (P29)', (tester) async {
    var removed = false;
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, removed ? [self] : [self, member(addresses: 1, documents: 1)]),
      'GET /v1/patient/members/m-2': (_) => (
        200,
        {
          'member': member(addresses: 1, documents: 1),
          'addresses': [address(inside: false)],
          'documents': [document()],
          'bookings': [],
        },
      ),
      'DELETE /v1/patient/members/m-2': (_) {
        removed = true;
        return (200, {'ok': true});
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Family');
    await tester.tap(find.byKey(const Key('member-m-2')));
    await tester.pumpAndSettle();

    expect(find.text('BP, diabetes'), findsOneWidget);
    expect(find.text('Needs support'), findsOneWidget);
    await scrollTo(tester, find.text('No bookings yet.'));
    expect(find.text("WellWish doesn't serve this area yet."), findsOneWidget);
    expect(find.text('Blood test'), findsOneWidget);

    await scrollTo(tester, find.byKey(const Key('member-remove')));
    await tester.tap(find.byKey(const Key('member-remove')));
    await tester.pumpAndSettle();
    expect(find.text('Remove Sabitri Gouda?'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(removed, isTrue);
    expect(find.text('No family members yet'), findsOneWidget);
  });

  testWidgets('add an address with the map pin and current location (P24)', (tester) async {
    Map<String, dynamic>? sent;
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, [self, member()]),
      'GET /v1/patient/members/m-2': (_) => (
        200,
        {
          'member': member(),
          'addresses': sent == null ? [] : [address()],
          'documents': [],
          'bookings': [],
        },
      ),
      'POST /v1/patient/addresses': (request) {
        sent = bodyOf(request);
        return (200, address(inside: false));
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Family');
    await tester.tap(find.byKey(const Key('member-m-2')));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('address-add')));
    await tester.tap(find.byKey(const Key('address-add')));
    await tester.pumpAndSettle();
    expect(find.text('For Sabitri Gouda'), findsOneWidget);
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);

    await tester.tap(find.byKey(const Key('use-location')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').first);
    await tester.enterText(find.byKey(const Key('address-line')), 'Plot 12, Saheed Nagar, Bhubaneswar 751007');
    await scrollTo(tester, find.byKey(const Key('address-save')));
    await tester.tap(find.byKey(const Key('address-save')));
    await tester.pumpAndSettle();

    expect(sent!['memberId'], 'm-2');
    expect(sent!['label'], 'Home');
    expect(sent!['lat'], '20.290000'); // from "use my current location"
    expect(sent!['lng'], '85.840000');
    expect(find.textContaining("doesn't serve this area yet, so it can't be booked"), findsOneWidget);
  });

  testWidgets('documents: tabs, upload from the camera with progress, delete (P21)', (tester) async {
    var docs = <Object?>[document(), document(id: 'd-2', type: 'PRESCRIPTION', title: 'BP tablets')];
    final queries = <Map<String, dynamic>>[];
    Map<String, dynamic>? saved;
    final picker = FakePicker();
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, [self, member()]),
      'GET /v1/patient/documents': (RequestOptions request) {
        queries.add(request.queryParameters);
        final group = request.queryParameters['group'];
        final items = docs.where((d) {
          final type = (d! as Map)['type'];
          return group == null || (group == 'prescriptions' ? type == 'PRESCRIPTION' : type != 'PRESCRIPTION');
        }).toList();
        return (200, page(items));
      },
      'POST /v1/patient/documents/upload-url': (request) {
        expect(bodyOf(request)['mime'], 'image/png');
        return (
          200,
          {
            'fileKey': 'documents/u-1/x.png',
            'uploadUrl': '/v1/files/upload/tok',
            'uploadFields': {'Content-Type': 'image/png'},
            'mime': 'image/png',
            'maxBytes': 10485760,
          },
        );
      },
      'POST http://10.0.2.2:8000/v1/files/upload/tok': (_) => (200, <String, Object>{}),
      'POST /v1/patient/documents': (request) {
        saved = bodyOf(request);
        final added = document(id: 'd-3', type: 'SCAN', title: 'Knee X-ray');
        docs = [added, ...docs];
        return (200, added);
      },
      'DELETE /v1/patient/documents/d-1': (_) {
        docs = docs.where((d) => (d! as Map)['id'] != 'd-1').toList();
        return (200, {'ok': true});
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true, picker: picker);
    await openTab(tester, 'Reports');
    expect(find.text('Blood test'), findsOneWidget);
    expect(find.text('BP tablets'), findsOneWidget);

    await tester.tap(find.text('Prescriptions'));
    await tester.pumpAndSettle();
    expect(queries.last['group'], 'prescriptions');
    expect(find.text('Blood test'), findsNothing);
    await tester.tap(find.text('All').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('document-upload')));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byKey(const Key('upload-member')), matching: find.text('Sabitri')));
    await tester.tap(find.text('X-ray / scan'));
    await tester.enterText(find.byKey(const Key('upload-title')), 'Knee X-ray');
    await scrollTo(tester, find.byKey(const Key('upload-camera')));
    await tester.tap(find.byKey(const Key('upload-camera')));
    await tester.pumpAndSettle();
    expect(find.textContaining('File ready'), findsOneWidget);
    await scrollTo(tester, find.byKey(const Key('upload-save')));
    await tester.tap(find.byKey(const Key('upload-save')));
    await tester.pumpAndSettle();

    expect(picker.picked, [PickSource.camera]);
    expect(backend.calls, contains('POST http://10.0.2.2:8000/v1/files/upload/tok'));
    expect(saved!['memberId'], 'm-2');
    expect(saved!['type'], 'SCAN');
    expect(saved!['fileKey'], 'documents/u-1/x.png');
    expect(find.text('Knee X-ray'), findsOneWidget); // the list reloaded

    await tester.tap(find.byKey(const Key('document-menu-d-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last); // confirm
    await tester.pumpAndSettle();
    expect(backend.calls, contains('DELETE /v1/patient/documents/d-1'));
    expect(find.text('Blood test'), findsNothing);
  });

  testWidgets('delete my account logs out with the 7-day message (P27)', (tester) async {
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, [self]),
      'POST /v1/patient/me/delete-request': (_) => (200, {'dueAt': '2026-10-16T10:00:00Z'}),
    });
    final opened = <String>[];
    final storage = await pumpPatientApp(tester, backend, loggedIn: true, openedPages: opened);
    await openTab(tester, 'Profile');
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    // §6.20: the legal pages are there too
    await scrollTo(tester, find.text('Refund Policy'));
    await tester.tap(find.text('Refund Policy'));
    await tester.pumpAndSettle();
    expect(opened, ['http://10.0.2.2:8000/legal/refunds?l=en']);
    await scrollTo(tester, find.byKey(const Key('settings-delete-account')));
    await tester.tap(find.byKey(const Key('settings-delete-account')));
    await tester.pumpAndSettle();
    expect(find.text('Delete your account?'), findsOneWidget);
    expect(find.textContaining('deleted after 10 days'), findsOneWidget); // the admin's setting (app default 7)
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    expect(backend.calls, contains('POST /v1/patient/me/delete-request'));
    expect(await storage.readAccessToken(), isNull);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(
      find.text('Your account will be deleted on 16 Oct 2026. Log in again before then to keep it.'),
      findsOneWidget,
    );
  });

  testWidgets('family screens in Hindi', (tester) async {
    final backend = FakeBackend({
      ...loggedInRoutes(language: 'hi'),
      'GET /v1/patient/members': (_) => (200, [self, member()]),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await tester.tap(find.byIcon(Icons.groups_outlined));
    await tester.pumpAndSettle();
    expect(find.text('अपनों से जुड़े रहें'), findsOneWidget);
    expect(find.text('माँ · 72 वर्ष'), findsOneWidget);
  });

  testWidgets('a new address needs the pin placed first', (tester) async {
    var sent = false;
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, [self, member()]),
      'GET /v1/patient/members/m-2': (_) =>
          (200, {'member': member(), 'addresses': [], 'documents': [], 'bookings': []}),
      'POST /v1/patient/addresses': (_) {
        sent = true;
        return (200, address());
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Family');
    await tester.tap(find.byKey(const Key('member-m-2')));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('address-add')));
    await tester.tap(find.byKey(const Key('address-add')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').first);
    await tester.enterText(find.byKey(const Key('address-line')), 'Plot 12, Saheed Nagar, Bhubaneswar 751007');
    await scrollTo(tester, find.byKey(const Key('address-save')));
    await tester.tap(find.byKey(const Key('address-save')));
    await tester.pumpAndSettle();
    expect(sent, isFalse); // still the default point in the middle of the city
    expect(find.textContaining('Move the map so the pin sits on the house, or use'), findsOneWidget);
  });

  testWidgets('editing yourself updates the name shown everywhere', (tester) async {
    var name = 'Asha Das';
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/me': (_) => (200, me(fullName: name, complete: true, consents: false)),
      'GET /v1/patient/members': (_) => (200, [member(id: 'm-1', relation: 'SELF', name: name)]),
      'GET /v1/patient/members/m-1': (_) => (
        200,
        {'member': member(id: 'm-1', relation: 'SELF', name: name), 'addresses': [], 'documents': [], 'bookings': []},
      ),
      'PUT /v1/patient/members/m-1': (request) {
        name = bodyOf(request)['fullName'] as String;
        return (200, member(id: 'm-1', relation: 'SELF', name: name));
      },
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    expect(find.textContaining('Hello, Asha'), findsOneWidget);
    await openTab(tester, 'Family');
    await tester.tap(find.byKey(const Key('member-m-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('member-edit')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('member-name')), 'Rina Das');
    await scrollTo(tester, find.byKey(const Key('member-save')));
    await tester.tap(find.byKey(const Key('member-save')));
    await tester.pumpAndSettle();
    expect(backend.calls.where((c) => c == 'GET /v1/patient/me').length, greaterThan(1)); // reloaded
    expect(find.text('Rina Das'), findsWidgets); // back on the profile page, not a broken form
    await tester.pageBack();
    await tester.pumpAndSettle();
    await openTab(tester, 'Home');
    expect(find.textContaining('Hello, Rina'), findsOneWidget);
  });

  testWidgets('a PDF opens in the phone\'s PDF app, not the browser', (tester) async {
    final opener = FakeOpener();
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, [self, member()]),
      'GET /v1/patient/documents': (_) => (200, page([document()])),
      'GET /v1/patient/documents/d-1/view-url': (_) => (200, {'url': '/v1/files/view/tok', 'mime': 'application/pdf'}),
    });
    await pumpPatientApp(tester, backend, loggedIn: true, opener: opener);
    await openTab(tester, 'Reports');
    await tester.tap(find.text('View').first);
    await tester.pumpAndSettle();
    expect(opener.opened, ['d-1']);
  });

  testWidgets('removing a member can delete their documents too', (tester) async {
    String? query;
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, [self, member(documents: 1)]),
      'GET /v1/patient/members/m-2': (_) => (
        200,
        {
          'member': member(documents: 1),
          'addresses': [],
          'documents': [document()],
          'bookings': [],
        },
      ),
      'DELETE /v1/patient/members/m-2': (request) {
        query = request.uri.query;
        return (200, {'ok': true});
      },
      'GET /v1/patient/documents': (_) => (200, page([])),
    });
    await pumpPatientApp(tester, backend, loggedIn: true);
    await openTab(tester, 'Family');
    await tester.tap(find.byKey(const Key('member-m-2')));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('member-remove')));
    await tester.tap(find.byKey(const Key('member-remove')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remove-delete-documents')));
    await tester.pump();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(query, contains('deleteDocuments=true'));
  });

  testWidgets('a file over 10 MB is refused before it is sent', (tester) async {
    final backend = FakeBackend({
      ...loggedInRoutes(),
      'GET /v1/patient/members': (_) => (200, [self, member()]),
      'GET /v1/patient/documents': (_) => (200, page([])),
    });
    await pumpPatientApp(tester, backend, loggedIn: true, picker: _BigPicker());
    await openTab(tester, 'Reports');
    await tester.tap(find.byKey(const Key('document-upload')));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('upload-pdf')));
    await tester.tap(find.byKey(const Key('upload-pdf')));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.textContaining('too large'));
    expect(find.textContaining('too large'), findsOneWidget);
    expect(backend.calls, isNot(contains('POST /v1/patient/documents/upload-url')));
  });
}

class _BigPicker implements FilePickerService {
  @override
  Future<PickedFile?> pick(PickSource source) async =>
      PickedFile(bytes: Uint8List(10 * 1024 * 1024 + 1), mime: 'application/pdf');
}
