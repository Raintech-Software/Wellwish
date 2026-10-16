import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../session/session_controller.dart';

/// P01 Splash (mockup 1): version check and token refresh, then the router moves on
/// (login, profile setup or home).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const path = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(sessionProvider.notifier).start());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final failed = ref.watch(sessionProvider.select((s) => s.status)) == SessionStatus.startupFailed;
    if (failed) {
      return Scaffold(
        body: SafeArea(
          child: WWErrorState(
            message: l10n.noInternet,
            retryLabel: l10n.tryAgain,
            onRetry: () => ref.read(sessionProvider.notifier).start(),
          ),
        ),
      );
    }
    return WWSplash(semanticLabel: '${l10n.appName}. ${l10n.brandTagline}');
  }
}
