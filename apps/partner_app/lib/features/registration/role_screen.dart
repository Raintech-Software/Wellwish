import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../session/language_button.dart';
import '../session/session_controller.dart';
import 'hub_screen.dart';
import 'partner_errors.dart';
import 'registration_controller.dart';
import 'widgets.dart';
import '../session/account_actions.dart';

/// R03 Register — role: Companion or Nurse (§6.3 step 1).
class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

  static const path = '/register/role';

  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen> {
  StartInRoleEnum? _saving;
  String? _error;

  Future<void> _choose(StartInRoleEnum role) async {
    setState(() {
      _saving = role;
      _error = null;
    });
    try {
      await ref.read(registrationProvider.notifier).start(role);
      if (mounted) context.go(HubScreen.path);
    } catch (e) {
      // §6.19: WellWish gave them a temporary job meanwhile: reloading /me opens it
      if (e is ApiException && e.code == 'ROLE_LOCKED') unawaited(ref.read(sessionProvider.notifier).reloadMe());
      if (mounted) setState(() => _error = partnerErrorMessage(WWLocalizations.of(context), e));
    } finally {
      if (mounted) setState(() => _saving = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    // §6.19: after a temporary job the role isn't chosen yet (the start, like anyone new)
    final current = ref.watch(sessionProvider.select((s) => isUnregistered(s.me?.partnerStatus) ? null : s.me?.role));
    final phone = ref.watch(sessionProvider.select((s) => s.me?.phone)) ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.partnerRegisterTitle), actions: const [LanguageButton()]),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Text(l10n.registerRoleTitle, style: WWType.screenTitle),
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.registerRoleSubtitle, style: WWType.caption.copyWith(fontSize: 13)),
            const SizedBox(height: WWSpacing.xl),
            _RoleCard(
              icon: Icons.volunteer_activism_outlined,
              title: l10n.roleCompanion,
              body: l10n.roleCompanionBody,
              selected: current == 'COMPANION',
              loading: _saving == StartInRoleEnum.COMPANION,
              onTap: _saving == null ? () => _choose(StartInRoleEnum.COMPANION) : null,
            ),
            const SizedBox(height: WWSpacing.md),
            _RoleCard(
              icon: Icons.medical_services_outlined,
              title: l10n.roleNurse,
              body: l10n.roleNurseBody,
              selected: current == 'NURSE',
              loading: _saving == StartInRoleEnum.NURSE,
              onTap: _saving == null ? () => _choose(StartInRoleEnum.NURSE) : null,
            ),
            ErrorNote(_error),
            // First screen after login: the only way out if this is the wrong number or app.
            if (current == null) ...[
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
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.selected,
    required this.loading,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool selected;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(WWRadius.card),
        child: Container(
          padding: const EdgeInsets.all(WWSpacing.lg),
          decoration: BoxDecoration(
            color: WWColors.surface,
            borderRadius: BorderRadius.circular(WWRadius.card),
            border: Border.all(color: selected ? WWColors.primary : WWColors.border, width: selected ? 2 : 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(color: WWColors.tint, shape: BoxShape.circle),
                child: Icon(icon, color: WWColors.primary, size: 28),
              ),
              const SizedBox(width: WWSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: WWType.section),
                    const SizedBox(height: WWSpacing.xs),
                    Text(body, style: WWType.body),
                  ],
                ),
              ),
              if (loading)
                const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4))
              else
                const Icon(Icons.chevron_right, color: WWColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
