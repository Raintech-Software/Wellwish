import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import 'app.dart';
import 'providers.dart';

/// Starts the app for a flavor. Called from main_dev.dart / main_staging.dart / main_prod.dart.
/// Errors go to Sentry when the build has a SENTRY_DSN (off otherwise; ww_core monitoring).
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await runMonitored(
    flavor,
    () => runApp(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(AppConfig.forFlavor(flavor))],
        child: const PatientApp(),
      ),
    ),
  );
}
