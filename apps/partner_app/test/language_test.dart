import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ww_l10n/ww_l10n.dart';

import 'fixtures.dart';
import 'support.dart';

/// The app's language (PHASES 9.1, ARCHITECTURE §5): partners choose English, Hindi or Odia in
/// any app bar; the app switches at once and the server keeps it for their messages.
void main() {
  testWidgets('the language button switches the app and saves the choice', (tester) async {
    var language = 'en';
    final backend = Backend({
      ...baseRoutes(null, kyc),
      'GET /v1/partner/me': () => (200, {...meJson(null), 'language': language}),
      'PUT /v1/partner/me/language': () {
        language = 'hi';
        return (200, {...meJson(null), 'language': 'hi'});
      },
    });
    await pumpPartnerApp(tester, backend);
    final en = lookupWWLocalizations(const Locale('en'));
    final hi = lookupWWLocalizations(const Locale('hi'));
    expect(find.text(en.registerRoleTitle), findsOneWidget);

    await tester.tap(find.byKey(const Key('language-button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('language-en')), findsOneWidget);
    await tester.tap(find.byKey(const Key('language-hi')));
    await tester.pumpAndSettle();

    expect(backend.bodies['PUT /v1/partner/me/language'], contains('"hi"'));
    expect(find.byKey(const Key('language-hi')), findsNothing); // the sheet closed
    expect(find.text(hi.registerRoleTitle), findsOneWidget); // the app speaks Hindi now
    expect(find.text(en.registerRoleTitle), findsNothing);
  });

  testWidgets('choosing the language already in use changes nothing', (tester) async {
    final backend = Backend(baseRoutes(null, kyc));
    await pumpPartnerApp(tester, backend);
    await tester.tap(find.byKey(const Key('language-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language-en')));
    await tester.pumpAndSettle();
    expect(backend.calls, isNot(contains('PUT /v1/partner/me/language')));
    expect(find.byKey(const Key('language-en')), findsNothing);
  });

  testWidgets("document hints and conditions in the partner's language (Odia)", (tester) async {
    final backend = Backend({
      ...baseRoutes('REGISTERING', () => kyc()),
      'GET /v1/partner/me': () => (200, {...meJson('REGISTERING'), 'language': 'or'}),
      'GET /v1/partner/kyc/status': () => (
        200,
        kyc(
          documents: [
            docState({
              ...requiredDoc('AADHAAR', numberRule: 'AADHAAR'),
              'help': 'Front and back in one photo or PDF.',
              'helpOr': 'ଆଗ ଓ ପଛ ଉଭୟ ଗୋଟିଏ ଫଟୋ ବା PDFରେ।',
            }, 'MISSING'),
            docState({
              ...requiredDoc('DRIVING_LICENCE', mandatory: false),
              'condition': 'If you will drive the patient',
              'conditionOr': 'ଯଦି ଆପଣ ରୋଗୀଙ୍କୁ ଗାଡ଼ିରେ ନେବେ',
            }, 'MISSING'),
          ],
        ),
      ),
    });
    await pumpPartnerApp(tester, backend);
    final or = lookupWWLocalizations(const Locale('or'));
    await tester.tap(find.text(or.stepDocuments));
    await tester.pumpAndSettle();
    expect(find.text('ଆଗ ଓ ପଛ ଉଭୟ ଗୋଟିଏ ଫଟୋ ବା PDFରେ।'), findsOneWidget);
    expect(find.textContaining('ଯଦି ଆପଣ ରୋଗୀଙ୍କୁ ଗାଡ଼ିରେ ନେବେ'), findsOneWidget);
    expect(find.textContaining('If you will drive'), findsNothing);
  });
}
