import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../registration/partner_errors.dart';
import 'session_controller.dart';

/// The app's language (Phase 9.1, ARCHITECTURE §5) in every app bar: English, Hindi or Odia,
/// for the app and the messages the partner gets. A new account starts in the phone's language.
class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return IconButton(
      key: const Key('language-button'),
      tooltip: l10n.language,
      icon: const Icon(Icons.translate),
      onPressed: () =>
          showModalBottomSheet<void>(context: context, showDragHandle: true, builder: (_) => const _LanguageSheet()),
    );
  }
}

class _LanguageSheet extends ConsumerStatefulWidget {
  const _LanguageSheet();

  @override
  ConsumerState<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends ConsumerState<_LanguageSheet> {
  String? _saving;

  Future<void> _choose(String code) async {
    final current = ref.read(sessionProvider).me?.language;
    if (_saving != null || code == current) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _saving = code);
    try {
      await ref.read(sessionProvider.notifier).setLanguage(code);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = null);
      showSnack(context, partnerErrorMessage(WWLocalizations.of(context), e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final current = ref.watch(sessionProvider.select((s) => s.me?.language));
    final options = [('en', l10n.languageEnglish), ('hi', l10n.languageHindi), ('or', l10n.languageOdia)];
    return SafeArea(
      child: SingleChildScrollView(
        // large text (9.8)
        child: Padding(
          padding: const EdgeInsets.fromLTRB(WWSpacing.screen, 0, WWSpacing.screen, WWSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.language, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              for (final (code, label) in options)
                ListTile(
                  key: Key('language-$code'),
                  minTileHeight: 56,
                  contentPadding: EdgeInsets.zero,
                  title: Text(label, style: WWType.body.copyWith(fontSize: 16)),
                  trailing: _saving == code
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : current == code
                      ? const Icon(Icons.check_circle, color: WWColors.primary)
                      : null,
                  onTap: () => _choose(code),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
