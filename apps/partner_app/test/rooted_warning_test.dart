import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'jobs_test.dart' show approved;
import 'support.dart';

/// §12 / PHASES 9.3: a rooted phone gets a warning on Home, never a block.

void main() {
  testWidgets('a rooted phone: a warning on Home, and the partner can still work', (tester) async {
    final backend = Backend(approved(extra: {'GET /v1/partner/home': () => (200, homeJson(selfie: true))}));
    await pumpPartnerApp(tester, backend, rooted: true);
    expect(find.byKey(const Key('rooted-warning')), findsOneWidget);
    expect(find.textContaining('This phone looks rooted'), findsOneWidget);
    expect(find.byKey(const Key('available-today')), findsOneWidget); // Home works as usual
  });

  testWidgets('a normal phone: no warning', (tester) async {
    final backend = Backend(approved(extra: {'GET /v1/partner/home': () => (200, homeJson(selfie: true))}));
    await pumpPartnerApp(tester, backend);
    expect(find.byKey(const Key('rooted-warning')), findsNothing);
  });
}
