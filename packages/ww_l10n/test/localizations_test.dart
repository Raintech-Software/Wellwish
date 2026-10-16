import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ww_l10n/ww_l10n.dart';

void main() {
  test('supports English, Hindi and Odia', () {
    final codes = WWLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
    expect(codes, containsAll(<String>['en', 'hi', 'or']));
  });

  for (final code in ['en', 'hi', 'or']) {
    testWidgets('loads $code, including Flutter\'s own Material texts', (tester) async {
      late WWLocalizations l10n;
      late MaterialLocalizations material;
      await tester.pumpWidget(MaterialApp(
        locale: Locale(code),
        localizationsDelegates: WWLocalizations.localizationsDelegates,
        supportedLocales: WWLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          l10n = WWLocalizations.of(context);
          material = MaterialLocalizations.of(context);
          return const SizedBox();
        }),
      ));
      expect(l10n.appName, 'WellWish');
      expect(l10n.tryAgain, isNotEmpty);
      expect(l10n.brandTagline, 'आपकी सेहत, हमारी ज़िम्मेदारी');
      expect(material.okButtonLabel, isNotEmpty);
    });
  }

  test('every English text is translated to Hindi and Odia', () {
    Set<String> keys(String code) {
      final json = jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync()) as Map;
      return json.keys.cast<String>().where((k) => !k.startsWith('@')).toSet();
    }

    final english = keys('en');
    expect(english.length, greaterThan(80));
    expect(keys('hi'), english);
    expect(keys('or'), english);
  });

  testWidgets('Partner badge is translated', (tester) async {
    final labels = <String, String>{};
    for (final code in ['en', 'hi', 'or']) {
      await tester.pumpWidget(MaterialApp(
        locale: Locale(code),
        localizationsDelegates: WWLocalizations.localizationsDelegates,
        supportedLocales: WWLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          labels[code] = WWLocalizations.of(context).partnerBadge;
          return const SizedBox();
        }),
      ));
    }
    expect(labels['en'], 'Partner');
    expect(labels['hi'], isNot('Partner'));
    expect(labels['or'], isNot('Partner'));
  });
}
