import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import 'features/session/session_controller.dart';
import 'router.dart';

class PatientApp extends ConsumerWidget {
  const PatientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Once logged in, the app speaks the language chosen in the profile; before that,
    // the phone's language (when it's English, Hindi or Odia).
    final language = ref.watch(sessionProvider.select((s) => s.me?.language));
    return MaterialApp.router(
      onGenerateTitle: (context) => WWLocalizations.of(context).appName,
      theme: WWTheme.light(),
      locale: language == null ? null : Locale(language),
      localizationsDelegates: WWLocalizations.localizationsDelegates,
      supportedLocales: WWLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
