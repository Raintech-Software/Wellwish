import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../notifications/notifications_screen.dart';
import '../session/session_controller.dart';
import 'contact_screen.dart';
import 'documents_screen.dart';
import 'partner_errors.dart';
import 'profile_form_screen.dart';
import 'registration_controller.dart';
import 'role_screen.dart';
import 'widgets.dart';
import '../session/language_button.dart';
import '../session/account_actions.dart';

/// Registration steps (R04–R06 overview, §8.2): role, alternate phone + email, profile,
/// documents, then "Send for review".
class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({super.key});

  static const path = '/register';

  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  bool _submitting = false;
  String? _error;

  Future<void> _submit() async {
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
    final phone = ref.watch(sessionProvider.select((s) => s.me?.phone)) ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.partnerRegisterTitle),
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
          data: (data) => data == null ? const WWLoading() : _steps(context, data, phone),
        ),
      ),
    );
  }

  Widget _steps(BuildContext context, KycStatusOut data, String phone) {
    final l10n = WWLocalizations.of(context);
    final required = data.documents.where((d) => d.required_.mandatory).toList();
    final uploaded = required.where((d) => d.status != 'MISSING' && d.status != 'REJECTED').length;
    final role = data.profile.role == 'NURSE' ? l10n.roleNurse : l10n.roleCompanion;
    return RefreshIndicator(
      onRefresh: () => ref.read(registrationProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          Text(l10n.registerHubSubtitle, style: WWType.caption.copyWith(fontSize: 13)),
          const SizedBox(height: WWSpacing.lg),
          StepTile(
            icon: Icons.work_outline,
            title: l10n.stepRole,
            subtitle: role,
            done: true,
            onTap: data.canEdit ? () => context.push(RoleScreen.path) : null,
          ),
          const SizedBox(height: WWSpacing.sm),
          StepTile(
            icon: Icons.phone_iphone,
            title: l10n.stepContact,
            done: data.steps.alternatePhone && data.steps.email,
            onTap: () => context.push(ContactScreen.path),
          ),
          const SizedBox(height: WWSpacing.sm),
          StepTile(
            icon: Icons.person_outline,
            title: l10n.stepProfile,
            done: data.steps.profile,
            onTap: () => context.push(ProfileFormScreen.path),
          ),
          const SizedBox(height: WWSpacing.sm),
          StepTile(
            icon: Icons.description_outlined,
            title: l10n.stepDocuments,
            subtitle: l10n.documentsProgress(uploaded, required.length),
            done: data.steps.documents,
            onTap: () => context.push(DocumentsScreen.path),
          ),
          const SizedBox(height: WWSpacing.xl),
          WWPrimaryButton(
            label: l10n.submitForReview,
            loading: _submitting,
            onPressed: data.canSubmit ? _submit : null,
          ),
          if (!data.canSubmit) ...[
            const SizedBox(height: WWSpacing.sm),
            Text(l10n.submitHint, style: WWType.caption, textAlign: TextAlign.center),
          ],
          ErrorNote(_error),
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
      ),
    );
  }
}
