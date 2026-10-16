import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import 'features/session/session_controller.dart';
import 'router.dart';

class PartnerApp extends ConsumerStatefulWidget {
  const PartnerApp({super.key});

  @override
  ConsumerState<PartnerApp> createState() => _PartnerAppState();
}

class _PartnerAppState extends ConsumerState<PartnerApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Back in the foreground: check this phone is still the partner's active device.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(sessionProvider.notifier).resumed();
    }
  }

  @override
  Widget build(BuildContext context) {
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
