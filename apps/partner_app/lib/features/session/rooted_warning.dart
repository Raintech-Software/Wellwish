import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

/// §12: signs that the phone is rooted (Android: test-keys build, an `su` binary, Magisk),
/// from MainActivity.kt. Anything else (iOS, a failed check) counts as not rooted. Swapped in
/// tests.
final looksRootedProvider = FutureProvider<bool>((ref) async {
  try {
    return await const MethodChannel('in.wellwish.partner/device').invokeMethod<bool>('looksRooted') ?? false;
  } catch (_) {
    return false;
  }
});

/// A warning on Home when the phone looks rooted. Never a block: the partner can still work.
class RootedWarning extends ConsumerWidget {
  const RootedWarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!(ref.watch(looksRootedProvider).value ?? false)) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: WWSpacing.lg),
      child: WWMessageBox(
        key: const Key('rooted-warning'),
        message: WWLocalizations.of(context).rootedWarning,
        isError: true,
        icon: Icons.gpp_maybe_outlined,
      ),
    );
  }
}
