import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_l10n/ww_l10n.dart';

import '../../providers.dart';
import '../session/session_controller.dart';

/// P02 Login (mockup 2), wired to this app's providers.
class LoginRoute extends ConsumerWidget {
  const LoginRoute({super.key});

  static const path = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final google = ref.watch(googleSignInServiceProvider);
    final endReason = ref.watch(sessionProvider.select((s) => s.endReason));
    final deletionDueAt = ref.watch(sessionProvider.select((s) => s.deletionDueAt));
    return PhoneLoginScreen(
      auth: ref.watch(authRepositoryProvider),
      smsReader: ref.watch(smsCodeReaderProvider),
      notice: deletionDueAt != null
          ? l10n.accountDeletionOn(
              DateFormat('d MMM y', Localizations.localeOf(context).toString()).format(deletionDueAt.toLocal()),
            )
          : sessionEndMessage(l10n, endReason),
      onCodeSent: (args) => context.push(OtpRoute.path, extra: args),
      onGoogle: google.enabled
          ? () async {
              final idToken = await google.idToken();
              if (idToken == null) return const GoogleResult.cancelled();
              final link = await ref.read(authRepositoryProvider).signInWithGoogle(idToken);
              if (link != null) return GoogleResult.phoneRequired(link);
              await ref.read(sessionProvider.notifier).loggedIn();
              return const GoogleResult.loggedIn();
            }
          : null,
    );
  }
}

/// P03 OTP.
class OtpRoute extends ConsumerWidget {
  const OtpRoute({super.key, required this.args});

  static const path = '/otp';

  final OtpArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OtpScreen(
      auth: ref.watch(authRepositoryProvider),
      smsReader: ref.watch(smsCodeReaderProvider),
      args: args,
      // The router moves on to profile setup or home once the session is loaded.
      onVerified: (_) => ref.read(sessionProvider.notifier).loggedIn(),
      onChangeNumber: () => context.canPop() ? context.pop() : context.go(LoginRoute.path),
    );
  }
}
