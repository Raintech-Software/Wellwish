import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_l10n/ww_l10n.dart';

import '../../providers.dart';
import '../session/session_controller.dart';

/// R02 Login: primary phone + OTP (same layout as mockup 2, with the Partner badge).
class LoginRoute extends ConsumerWidget {
  const LoginRoute({super.key});

  static const path = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final endReason = ref.watch(sessionProvider.select((s) => s.endReason));
    // §6.19: a temporary partner's access ended with their job
    final jobOver = ref.watch(sessionProvider.select((s) => s.jobOver));
    return PhoneLoginScreen(
      auth: ref.watch(authRepositoryProvider),
      smsReader: ref.watch(smsCodeReaderProvider),
      partner: true,
      notice: jobOver ? l10n.tempJobOver : sessionEndMessage(l10n, endReason),
      onCodeSent: (args) => context.push(OtpRoute.path, extra: args),
    );
  }
}

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
      partner: true,
      onVerified: (_) => ref.read(sessionProvider.notifier).loggedIn(),
      onChangeNumber: () => context.canPop() ? context.pop() : context.go(LoginRoute.path),
    );
  }
}
