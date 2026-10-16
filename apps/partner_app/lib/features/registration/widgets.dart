import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

/// A document's name in the app's language (labels come from the server: the admin can add
/// documents without an app release, §6.3).
String docLabel(BuildContext context, RequiredDocumentOut required) =>
    _inLanguage(context, required.label, required.labelHi, required.labelOr);

/// Its hint ("Front and back in one photo") in the app's language (Phase 9.1).
String docHelp(BuildContext context, RequiredDocumentOut required) =>
    _inLanguage(context, required.help, required.helpHi ?? '', required.helpOr ?? '');

/// When an optional one is needed ("If you will drive the patient"), in the app's language.
String docCondition(BuildContext context, RequiredDocumentOut required) =>
    _inLanguage(context, required.condition, required.conditionHi ?? '', required.conditionOr ?? '');

/// The Hindi or Odia text when the admin gave one, else the English.
String _inLanguage(BuildContext context, String english, String hindi, String odia) {
  final translated = switch (Localizations.localeOf(context).languageCode) {
    'hi' => hindi,
    'or' => odia,
    _ => '',
  };
  return translated.isNotEmpty ? translated : english;
}

String formatDate(BuildContext context, DateTime date) =>
    DateFormat('d MMM y', Localizations.localeOf(context).toString()).format(date);

/// Status chip for one document line (R06).
class DocStatusChip extends StatelessWidget {
  const DocStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final (label, color, background, icon) = switch (status) {
      'APPROVED' => (l10n.docApproved, WWColors.brandGreen, WWColors.greenTint, Icons.check_circle),
      'PENDING' => (l10n.docPending, WWColors.brandBlue, WWColors.tint, Icons.hourglass_top),
      'REJECTED' => (l10n.docRejected, WWColors.danger, WWColors.dangerTint, Icons.error_outline),
      'EXPIRED' => (l10n.docExpired, WWColors.warning, WWColors.warningTint, Icons.event_busy),
      _ => (l10n.docMissing, WWColors.textSecondary, WWColors.background, Icons.upload_file),
    };
    return WWBadge(label: label, color: color, background: background, icon: icon);
  }
}

/// One registration step on the hub: tick when done.
class StepTile extends StatelessWidget {
  const StepTile({super.key, required this.icon, required this.title, required this.done, this.subtitle, this.onTap});

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool done;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return WWCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(WWSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: done ? WWColors.greenTint : WWColors.tint, shape: BoxShape.circle),
              child: Icon(done ? Icons.check : icon, color: done ? WWColors.brandGreen : WWColors.primary),
            ),
            const SizedBox(width: WWSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: WWType.cardTitle),
                  if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: WWType.caption)],
                ],
              ),
            ),
            WWBadge(
              label: done ? l10n.stepDone : l10n.stepTodo,
              color: done ? WWColors.brandGreen : WWColors.textSecondary,
              background: done ? WWColors.greenTint : WWColors.background,
            ),
            if (onTap != null) const Icon(Icons.chevron_right, color: WWColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Error box shown under a form.
class ErrorNote extends StatelessWidget {
  const ErrorNote(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: WWSpacing.md),
      child: WWMessageBox(message: message!, isError: true),
    );
  }
}
