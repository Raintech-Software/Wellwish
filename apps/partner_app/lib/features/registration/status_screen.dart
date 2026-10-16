import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../notifications/notifications_screen.dart';
import '../session/session_controller.dart';
import 'documents_screen.dart';
import 'partner_errors.dart';
import 'registration_controller.dart';
import 'widgets.dart';
import '../session/language_button.dart';
import '../session/account_actions.dart';

/// R07 Verification status: Submitted → Under review → Changes needed (reason per document)
/// → Approved. Also shows rejected, suspended and closed accounts (§6.3).
class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  static const path = '/status';

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  bool _submitting = false;
  String? _error;

  Future<void> _refresh() async {
    await ref.read(sessionProvider.notifier).reloadMe();
    await ref.read(registrationProvider.notifier).refresh();
  }

  Future<void> _resubmit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(registrationProvider.notifier).submit();
    } catch (e) {
      if (mounted) setState(() => _error = partnerErrorMessage(WWLocalizations.of(context), e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final status = ref.watch(registrationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statusTitle),
        actions: [
          const LanguageButton(),
          IconButton(
            tooltip: l10n.notificationsTitle,
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push(NotificationsScreen.path),
          ),
        ],
      ),
      body: SafeArea(
        child: status.when(
          loading: () => const WWLoading(),
          error: (e, _) => WWErrorState(
            message: partnerErrorMessage(l10n, e),
            retryLabel: l10n.tryAgain,
            onRetry: () => ref.invalidate(registrationProvider),
          ),
          data: (data) =>
              data == null ? const WWLoading() : RefreshIndicator(onRefresh: _refresh, child: _body(context, data)),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, KycStatusOut data) {
    final l10n = WWLocalizations.of(context);
    final s = data.profile.status;
    final support = ref.watch(sessionProvider.select((st) => st.supportPhone));
    final phone = ref.watch(sessionProvider.select((st) => st.me?.phone)) ?? '';
    final notes = data.application?.notes ?? '';
    final rejected = data.documents.where((d) => d.status == 'REJECTED').toList();
    return ListView(
      padding: const EdgeInsets.all(WWSpacing.screen),
      children: [
        if (const {'SUBMITTED', 'UNDER_REVIEW', 'CHANGES_REQUESTED'}.contains(s)) ...[
          _Timeline(status: s),
          const SizedBox(height: WWSpacing.lg),
        ],
        switch (s) {
          'SUBMITTED' => _Message(icon: Icons.mark_email_read_outlined, text: l10n.statusSubmittedBody),
          'UNDER_REVIEW' => _Message(icon: Icons.manage_search, text: l10n.statusUnderReviewBody),
          'CHANGES_REQUESTED' => _Message(icon: Icons.edit_note, text: l10n.statusChangesBody, warning: true),
          'REJECTED' => _Message(
            icon: Icons.cancel_outlined,
            title: l10n.statusRejectedTitle,
            text: notes.isEmpty ? l10n.somethingWentWrong : notes,
            warning: true,
          ),
          'SUSPENDED' => _Message(
            icon: Icons.pause_circle_outline,
            title: l10n.statusSuspendedTitle,
            text: data.profile.suspendedReason == 'DOCUMENT_EXPIRED'
                ? l10n.suspendedExpiredBody
                : l10n.statusSuspendedBody,
            warning: true,
          ),
          'DEACTIVATED' => _Message(
            icon: Icons.block,
            title: l10n.statusDeactivatedTitle,
            text: l10n.statusSuspendedBody,
            warning: true,
          ),
          _ => const SizedBox.shrink(),
        },
        if (s == 'CHANGES_REQUESTED') ...[
          if (notes.isNotEmpty) ...[
            const SizedBox(height: WWSpacing.md),
            Text(l10n.noteFromWellWish, style: WWType.cardTitle),
            const SizedBox(height: WWSpacing.xs),
            WWMessageBox(message: notes),
          ],
          for (final d in rejected) ...[
            const SizedBox(height: WWSpacing.sm),
            WWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(docLabel(context, d.required_), style: WWType.cardTitle)),
                      DocStatusChip(status: d.status),
                    ],
                  ),
                  if (d.document?.rejectReason.isNotEmpty ?? false) ...[
                    const SizedBox(height: WWSpacing.xs),
                    Text(d.document!.rejectReason, style: WWType.body.copyWith(color: WWColors.danger)),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: WWSpacing.lg),
          WWSecondaryButton(
            label: l10n.fixDocuments,
            icon: const Icon(Icons.upload_file),
            onPressed: () => context.push(DocumentsScreen.path),
          ),
          const SizedBox(height: WWSpacing.sm),
          WWPrimaryButton(
            label: l10n.submitForReview,
            loading: _submitting,
            onPressed: data.canSubmit ? _resubmit : null,
          ),
          ErrorNote(_error),
        ],
        if (s == 'SUSPENDED' && data.profile.suspendedReason == 'DOCUMENT_EXPIRED') ...[
          const SizedBox(height: WWSpacing.lg),
          WWPrimaryButton(label: l10n.uploadNew, onPressed: () => context.push(DocumentsScreen.path)),
        ],
        if (support != null && const {'REJECTED', 'SUSPENDED', 'DEACTIVATED'}.contains(s)) ...[
          const SizedBox(height: WWSpacing.lg),
          WWSecondaryButton(
            label: l10n.callSupport,
            icon: const Icon(Icons.call),
            onPressed: () => launchUrl(Uri.parse('tel:$support')),
          ),
        ],
        const SizedBox(height: WWSpacing.xxl),
        Text(l10n.loggedInAs(formatIndianPhone(phone)), style: WWType.caption, textAlign: TextAlign.center),
        const SizedBox(height: WWSpacing.sm),
        const AccountLinks(), // §6.20: legal pages, delete my account
        const SizedBox(height: WWSpacing.lg),
        WWSecondaryButton(
          label: l10n.logout,
          icon: const Icon(Icons.logout, color: WWColors.danger),
          onPressed: () => ref.read(sessionProvider.notifier).logout(),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.title, this.warning = false});

  final IconData icon;
  final String? title;
  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning ? WWColors.warning : WWColors.primary;
    return WWCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[Text(title!, style: WWType.section), const SizedBox(height: WWSpacing.xs)],
                Text(text, style: WWType.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Submitted → Under review → Changes needed / Approved.
class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final changes = status == 'CHANGES_REQUESTED';
    final steps = [
      (l10n.statusSubmitted, true),
      (l10n.statusUnderReview, status != 'SUBMITTED'),
      (changes ? l10n.statusChangesNeeded : l10n.statusApproved, changes),
    ];
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: steps[i].$2
                      ? (changes && i == 2 ? WWColors.warning : WWColors.primary)
                      : WWColors.border,
                  child: Icon(changes && i == 2 ? Icons.priority_high : Icons.check, size: 16, color: Colors.white),
                ),
                const SizedBox(height: WWSpacing.xs),
                Text(steps[i].$1, style: WWType.caption, textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
