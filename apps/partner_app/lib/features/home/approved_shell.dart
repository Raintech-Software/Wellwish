import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../jobs/jobs_providers.dart';
import '../jobs/jobs_tab.dart';
import '../jobs/offer_card.dart';
import '../jobs/visit_controller.dart';
import '../notifications/notifications_screen.dart';
import '../registration/contact_screen.dart';
import '../registration/documents_screen.dart';
import '../registration/partner_errors.dart';
import '../registration/registration_controller.dart';
import '../session/session_controller.dart';
import 'selfie_screen.dart';
import 'totals_screen.dart';
import '../session/language_button.dart';
import '../session/rooted_warning.dart';
import '../session/account_actions.dart';

/// The approved partner's app: Home R08 (availability, offers, today's jobs), Jobs R10 and
/// Profile R16 (details and documents).
class ApprovedShell extends ConsumerStatefulWidget {
  const ApprovedShell({super.key});

  static const path = '/home';

  @override
  ConsumerState<ApprovedShell> createState() => _ApprovedShellState();
}

class _ApprovedShellState extends ConsumerState<ApprovedShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final status = ref.watch(registrationProvider);
    return Scaffold(
      appBar: AppBar(
        // Mark + wordmark: the full lockup (with tagline) is too tall for the app bar.
        title: Semantics(
          label: l10n.appName,
          excludeSemantics: true,
          // shrinks on a narrow phone or with large text rather than pushing the icons out
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WWLogo(width: 36),
                SizedBox(width: WWSpacing.sm),
                WWWordmark(fontSize: 22),
              ],
            ),
          ),
        ),
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
          data: (data) => data == null
              ? const WWLoading()
              : switch (_tab) {
                  0 => _HomeTab(status: data),
                  1 => const JobsTab(),
                  _ => _ProfileTab(status: data),
                },
        ),
      ),
      bottomNavigationBar: WWBottomNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: [
          WWNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: l10n.navHome),
          WWNavItem(icon: Icons.work_outline, activeIcon: Icons.work, label: l10n.navJobs),
          WWNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: l10n.navProfile),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerStatefulWidget {
  const _HomeTab({required this.status});

  final KycStatusOut status;

  @override
  ConsumerState<_HomeTab> createState() => _HomeTabState();
}

/// R08 Home: "Available today" (today's selfie first), new offers with their countdown,
/// today's jobs and quick totals.
class _HomeTabState extends ConsumerState<_HomeTab> {
  bool _saving = false;
  String? _error;

  Future<void> _setAvailable(PartnerHomeOut home, bool value) async {
    if (_saving) return;
    if (value && !home.selfieToday) {
      await context.push<bool>(SelfieScreen.path);
      return; // the selfie screen switches it on
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(partnerApiProvider).partnerAvailabilitySet(availabilityIn: AvailabilityIn(availableToday: value));
      ref.invalidate(partnerHomeProvider);
    } catch (e) {
      if (!mounted) return;
      if (toApiException(e).code == 'SELFIE_REQUIRED') {
        // a new day since Home was loaded: today's selfie first
        ref.invalidate(partnerHomeProvider);
        setState(() => _saving = false);
        await context.push<bool>(SelfieScreen.path);
        return;
      }
      setState(() => _error = partnerErrorMessage(WWLocalizations.of(context), e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final profile = widget.status.profile;
    final contactMissing = !widget.status.steps.alternatePhone || !widget.status.steps.email;
    final homeAsync = ref.watch(partnerHomeProvider);
    final home = homeAsync.value;
    // a job in progress after the app was closed: share the location again (§6.11)
    ref.listen(partnerHomeProvider, (_, next) {
      final today = next.value?.today;
      if (today != null) {
        final l10n = WWLocalizations.of(context);
        ref.read(visitControllerProvider.notifier)
          ..notificationTitle = l10n.fgsTitle
          ..notificationText = l10n.fgsText
          ..resumeIfNeeded(today);
      }
    });
    return RefreshIndicator(
      onRefresh: () => ref.refresh(partnerHomeProvider.future),
      child: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          Text(l10n.helloName(profile.fullName.split(' ').first), style: WWType.screenTitle),
          const SizedBox(height: WWSpacing.xs),
          WWBadge(
            label: l10n.youAreApproved,
            icon: Icons.verified,
            color: WWColors.brandGreen,
            background: WWColors.greenTint,
          ),
          const SizedBox(height: WWSpacing.lg),
          const RootedWarning(),
          WWCard(
            child: MergeSemantics(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.availableToday, style: WWType.section),
                        const SizedBox(height: 2),
                        Text(l10n.availableTodayHelp, style: WWType.caption),
                      ],
                    ),
                  ),
                  Switch(
                    key: const Key('available-today'),
                    value: home?.availableToday ?? false,
                    onChanged: home == null || _saving ? null : (v) => _setAvailable(home, v),
                  ),
                ],
              ),
            ),
          ),
          if (_error != null) ...[const SizedBox(height: WWSpacing.sm), WWMessageBox(message: _error!, isError: true)],
          if (contactMissing) ...[
            const SizedBox(height: WWSpacing.md),
            WWCard(
              onTap: () => context.push(ContactScreen.path),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: WWColors.primary),
                  const SizedBox(width: WWSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.verifyContactTitle, style: WWType.cardTitle),
                        const SizedBox(height: 2),
                        Text(l10n.verifyContactBody, style: WWType.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: WWColors.textSecondary),
                ],
              ),
            ),
          ],
          if (homeAsync.hasError && home == null) ...[
            const SizedBox(height: WWSpacing.lg),
            WWErrorState(
              message: partnerErrorMessage(l10n, homeAsync.error!),
              retryLabel: l10n.tryAgain,
              onRetry: () => ref.invalidate(partnerHomeProvider),
            ),
          ] else if (home == null) ...[
            const SizedBox(height: WWSpacing.lg),
            const WWLoading(),
          ] else ...[
            if (home.offers.isNotEmpty) ...[
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.offersTitle, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              for (final o in home.offers) ...[OfferCard(offer: o), const SizedBox(height: WWSpacing.sm)],
            ],
            const SizedBox(height: WWSpacing.lg),
            Row(
              key: const Key('totals-row'),
              children: [
                _Total(label: l10n.totalsDoneToday, value: home.totals.today),
                const SizedBox(width: WWSpacing.sm),
                _Total(label: l10n.totalsThisWeek, value: home.totals.thisWeek),
                const SizedBox(width: WWSpacing.sm),
                _Total(label: l10n.totalsUpcoming, value: home.totals.upcoming),
              ],
            ),
            const SizedBox(height: WWSpacing.lg),
            Text(l10n.todayJobsTitle, style: WWType.section),
            const SizedBox(height: WWSpacing.sm),
            if (home.today.isEmpty)
              WWCard(child: Text(l10n.noJobsToday, style: WWType.caption))
            else
              for (final j in home.today) ...[JobRowCard(job: j), const SizedBox(height: WWSpacing.sm)],
          ],
        ],
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WWCard(
        onTap: () => context.push(TotalsScreen.path),
        child: Column(
          children: [
            Text('$value', style: WWType.screenTitle.copyWith(color: WWColors.primary)),
            Text(label, style: WWType.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// R16 Profile and documents.
class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({required this.status});

  final KycStatusOut status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    final p = status.profile;
    final phones = {for (final ph in p.phones) ph.kind: ph};
    return RefreshIndicator(
      onRefresh: () => ref.read(registrationProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: WWColors.tint,
                backgroundImage: p.photoUrl == null ? null : NetworkImage(fileUrl(config, p.photoUrl!)),
              ),
              const SizedBox(width: WWSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.fullName, style: WWType.section),
                    Text(p.role == 'NURSE' ? l10n.roleNurse : l10n.roleCompanion, style: WWType.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: WWSpacing.lg),
          WWCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                WWListTile(
                  icon: Icons.phone_android,
                  title: l10n.loginNumber,
                  subtitle: formatIndianPhone(phones['PRIMARY']?.phone ?? ''),
                  showChevron: false,
                ),
                WWListTile(
                  icon: Icons.phone,
                  title: l10n.alternateNumber,
                  subtitle: phones['ALTERNATE'] == null ? '—' : formatIndianPhone(phones['ALTERNATE']!.phone),
                  onTap: () => context.push(ContactScreen.path),
                ),
                WWListTile(
                  icon: Icons.email_outlined,
                  title: l10n.emailLabel,
                  subtitle: p.email.isEmpty ? '—' : p.email,
                  onTap: () => context.push(ContactScreen.path),
                ),
              ],
            ),
          ),
          const SizedBox(height: WWSpacing.lg),
          Text(l10n.stepDocuments, style: WWType.section),
          const SizedBox(height: WWSpacing.sm),
          DocumentList(status: status),
          const SizedBox(height: WWSpacing.xl),
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
