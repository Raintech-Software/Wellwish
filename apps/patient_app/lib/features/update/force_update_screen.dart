import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../session/session_controller.dart';

/// Shown when this app is older than the minimum version from /v1/public/app-config.
class ForceUpdateScreen extends ConsumerWidget {
  const ForceUpdateScreen({super.key});

  static const path = '/update';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final storeUrl = ref.watch(sessionProvider.select((s) => s.storeUrl));
    return Scaffold(
      backgroundColor: WWColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(WWSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              WWLogoLockup(width: 200, semanticLabel: l10n.appName),
              const SizedBox(height: WWSpacing.xxl),
              Text(l10n.updateTitle, style: WWType.screenTitle, textAlign: TextAlign.center),
              const SizedBox(height: WWSpacing.sm),
              Text(l10n.updateBody, style: WWType.body, textAlign: TextAlign.center),
              const Spacer(),
              WWPrimaryButton(
                label: l10n.updateNow,
                onPressed: storeUrl == null
                    ? null
                    : () => launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
