import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

/// Registration, documents, status and the approved home (PHASES 3.12–3.15).

void main() {
  testWidgets('choosing a role opens the registration steps', (tester) async {
    final backend = Backend({...baseRoutes(null, kyc), 'POST /v1/partner/register/start': () => (200, kyc())});
    await pumpPartnerApp(tester, backend);
    expect(find.text('What work will you do?'), findsOneWidget);
    // wrong number or app: a way out
    await tester.scrollUntilVisible(find.text('Logout'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Logout'), findsOneWidget);
    await tester.ensureVisible(find.text('Companion')); // back up past the account links (§6.20)
    await tester.pumpAndSettle();
    await tester.tap(find.text('Companion'));
    await tester.pumpAndSettle();
    expect(backend.bodies['POST /v1/partner/register/start'], contains('COMPANION'));
    expect(find.text('Alternate number and email'), findsOneWidget);
    expect(find.text('0 of 2 uploaded'), findsOneWidget);
    expect(find.text('Finish every step to send your application.'), findsOneWidget);
  });

  testWidgets('after sending the code, typing goes into the code boxes', (tester) async {
    final backend = Backend({
      ...baseRoutes('REGISTERING', kyc),
      'POST /v1/partner/register/alternate-phone': () =>
          (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 30, 'length': 6}),
      'POST /v1/partner/register/alternate-phone/verify': () => (200, kyc()),
    });
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Alternate number and email'));
    await tester.pumpAndSettle();
    final phone = find.descendant(of: find.byKey(const Key('alternate-block')), matching: find.byType(TextField));
    await tester.tap(phone.first);
    await tester.enterText(phone.first, '9876500000');
    await tester.tap(find.text('Send code').first);
    await tester.pumpAndSettle();
    // the keyboard now types the code (the number field must not keep the focus)
    tester.testTextInput.enterText('123456');
    await tester.pumpAndSettle();
    expect(backend.bodies['POST /v1/partner/register/alternate-phone/verify'], contains('123456'));
  });

  testWidgets('saving an incomplete profile says what is wrong', (tester) async {
    final backend = Backend(baseRoutes('REGISTERING', kyc));
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Your profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Save'), 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Some details are missing. Check the fields marked in red.'), findsOneWidget);
    expect(backend.calls, isNot(contains('PUT /v1/partner/register/profile')));
  });

  testWidgets('saving the profile goes back to the steps when the status moves on', (tester) async {
    var saved = false;
    final backend = Backend({
      ...baseRoutes(
        'REGISTERING',
        () => saved ? kyc(status: 'REGISTERED', done: true, filled: true) : kyc(filled: true),
      ),
      'PUT /v1/partner/register/profile': () {
        saved = true;
        return (200, kyc(status: 'REGISTERED', done: true, filled: true));
      },
    });
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Your profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Save'), 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(backend.bodies['PUT /v1/partner/register/profile'], contains('Asha Behera'));
    // REGISTERING → REGISTERED keeps the same screens: the form closes, back on the steps
    expect(find.text('Save'), findsNothing);
    expect(find.text('Your profile'), findsOneWidget);
  });

  testWidgets('submit sends the application and shows the status', (tester) async {
    var submitted = false;
    final docs = [
      docState(requiredDoc('AADHAAR', numberRule: 'AADHAAR'), 'PENDING'),
      docState(requiredDoc('PAN', numberRule: 'PAN'), 'PENDING'),
    ];
    final backend = Backend({
      ...baseRoutes(
        'REGISTERED',
        () => submitted
            ? kyc(status: 'SUBMITTED', done: true, documents: docs, applicationStatus: 'SUBMITTED')
            : kyc(status: 'REGISTERED', done: true, canSubmit: true, documents: docs),
      ),
      'POST /v1/partner/kyc/submit': () {
        submitted = true;
        return (200, kyc(status: 'SUBMITTED', done: true, documents: docs, applicationStatus: 'SUBMITTED'));
      },
    });
    await pumpPartnerApp(tester, backend);
    expect(find.text('2 of 2 uploaded'), findsOneWidget);
    await tester.tap(find.text('Send for review'));
    await tester.pumpAndSettle();
    expect(find.text('Application status'), findsOneWidget);
    expect(find.text('We received your application and will check your documents soon.'), findsOneWidget);
  });

  testWidgets('changes needed shows the reason for each document', (tester) async {
    final docs = [
      docState(requiredDoc('AADHAAR', numberRule: 'AADHAAR'), 'APPROVED'),
      docState(requiredDoc('PAN', numberRule: 'PAN'), 'REJECTED', reason: 'Photo is blurred'),
    ];
    final backend = Backend(
      baseRoutes(
        'CHANGES_REQUESTED',
        () => kyc(
          status: 'CHANGES_REQUESTED',
          done: true,
          documents: docs,
          applicationStatus: 'CHANGES_REQUESTED',
          notes: 'Please upload a clear PAN card.',
        ),
      ),
    );
    await pumpPartnerApp(tester, backend);
    expect(find.text('Changes needed'), findsWidgets);
    expect(find.text('Photo is blurred'), findsOneWidget);
    expect(find.text('Please upload a clear PAN card.'), findsOneWidget);
    expect(find.text('Fix documents'), findsOneWidget);
  });

  testWidgets('upload a document from the camera', (tester) async {
    var uploaded = false;
    final backend = Backend({
      ...baseRoutes(
        'REGISTERING',
        () =>
            kyc(documents: [docState(requiredDoc('AADHAAR', numberRule: 'AADHAAR'), uploaded ? 'PENDING' : 'MISSING')]),
      ),
      'POST /v1/partner/kyc/upload-url': () => (
        200,
        {
          'fileKey': 'kyc/u-1/a.jpg',
          'uploadUrl': '/v1/files/upload/tok',
          'uploadFields': {'Content-Type': 'image/jpeg'},
          'mime': 'image/jpeg',
          'maxBytes': 10485760,
        },
      ),
      'POST http://10.0.2.2:8000/v1/files/upload/tok': () => (200, <String, Object>{}),
      'POST /v1/partner/kyc/documents': () {
        uploaded = true;
        return (200, kyc(documents: [docState(requiredDoc('AADHAAR', numberRule: 'AADHAAR'), 'PENDING')]));
      },
    });
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Documents'));
    await tester.pumpAndSettle();
    expect(find.text('Not uploaded'), findsOneWidget);
    await tester.tap(find.byKey(const Key('upload-AADHAAR')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take photo'));
    await tester.pumpAndSettle();
    // the number is required for Aadhaar
    await tester.tap(find.text('Upload').last);
    await tester.pumpAndSettle();
    expect(find.text('Enter the number.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('doc-number')), '234567891234');
    await tester.tap(find.text('Upload').last);
    await tester.pumpAndSettle();
    expect(backend.calls, contains('POST http://10.0.2.2:8000/v1/files/upload/tok'));
    expect(backend.bodies['POST /v1/partner/kyc/documents'], contains('"docType":"AADHAAR"'));
    expect(backend.bodies['POST /v1/partner/kyc/documents'], contains('234567891234'));
    expect(find.text('Being checked'), findsOneWidget);
  });

  testWidgets('approved partner lands on home and sets availability', (tester) async {
    var available = false;
    final backend = Backend({
      ...baseRoutes('APPROVED', () => kyc(status: 'APPROVED', done: true)),
      'GET /v1/partner/home': () => (200, homeJson(available: available, selfie: true)),
      'PATCH /v1/partner/me/availability': () {
        available = true;
        return (200, {'availableToday': true, 'selfieToday': true});
      },
    });
    await pumpPartnerApp(tester, backend);
    expect(find.text('Hello, Asha'), findsOneWidget);
    expect(find.text("You're an approved WellWish partner"), findsOneWidget);
    expect(find.text('Jobs'), findsOneWidget); // only approved partners see the jobs tab
    await tester.tap(find.byKey(const Key('available-today')));
    await tester.pumpAndSettle();
    expect(backend.bodies['PATCH /v1/partner/me/availability'], contains('true'));
    expect(tester.widget<Switch>(find.byKey(const Key('available-today'))).value, isTrue);
  });

  testWidgets('approved partner added by an admin is asked to verify contact details', (tester) async {
    final backend = Backend(baseRoutes('APPROVED', () => kyc(status: 'APPROVED', addedByAdmin: true)));
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.text('Verify your contact details'));
    await tester.pumpAndSettle();
    // the admin typed them in: already filled, the partner only asks for the codes
    expect(find.widgetWithText(TextField, '9876500000'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'asha@example.com'), findsOneWidget);
  });

  testWidgets('suspended partner sees the paused screen with a support call', (tester) async {
    final backend = Backend(
      baseRoutes('SUSPENDED', () => kyc(status: 'SUSPENDED', done: true, suspendedReason: 'DOCUMENT_EXPIRED')),
    );
    await pumpPartnerApp(tester, backend);
    expect(find.text('Account paused'), findsOneWidget);
    expect(find.textContaining('A document has expired'), findsOneWidget);
    expect(find.text('Call WellWish support'), findsOneWidget);
    expect(find.text('Jobs'), findsNothing);
  });
}
