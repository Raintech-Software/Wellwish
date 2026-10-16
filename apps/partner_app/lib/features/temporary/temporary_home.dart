import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../home/selfie_screen.dart';
import '../jobs/job_format.dart';
import '../jobs/job_screen.dart';
import '../jobs/visit_controller.dart';
import '../notifications/notifications_screen.dart';
import '../session/session_controller.dart';
import '../session/language_button.dart';
import '../session/rooted_warning.dart';

/// A temporary partner's home (ARCHITECTURE §6.19): WellWish brought them in for ONE booking, so
/// the app shows only that job: the normal job screen (steps, visit code, calls, health notes,
/// live location, SOS, balance), with today's selfie asked first on the day of the visit (it's
/// their photo for the family, and "On the way" needs it). No offers, "Available today", totals
/// or registration: the server closes those to them, so nothing here loads them.
class TemporaryHome extends ConsumerWidget {
  const TemporaryHome({super.key});

  static const path = '/my-job';

  /// Logging out mid-visit stops the live location the family watches: asked first.
  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = WWLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(
            key: const Key('temp-logout-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.logout, style: const TextStyle(color: WWColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(sessionProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final partnerId = ref.watch(sessionProvider.select((s) => s.me?.id));
    final bookingId = ref.watch(sessionProvider.select((s) => s.me?.temporaryBookingId));
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            key: const Key('temp-logout'),
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: partnerId == null || bookingId == null
            ? WWEmptyState(icon: Icons.event_busy, title: l10n.errOfferNotOpen)
            : _OneJob(partnerId: partnerId, bookingId: bookingId),
      ),
    );
  }
}

/// On the day of the visit, until it has started, today's selfie is asked first (§6.19). The
/// server checks it again at "On the way" (409 `SELFIE_REQUIRED` opens the selfie then).
bool selfieFirst(PartnerJobOut job) =>
    job.status == 'ACCEPTED' &&
    (job.visit?.done.isEmpty ?? true) &&
    !istDay(job.pickupAt).isAfter(istDay(ServerClock.now()));

class _OneJob extends ConsumerWidget {
  const _OneJob({required this.partnerId, required this.bookingId});

  final String partnerId;
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selfieTakenProvider);
    // known to the server (an app restart doesn't ask again), or taken on this phone just now
    final serverSays = ref.watch(sessionProvider.select((s) => s.me?.selfieToday)) ?? false;
    final selfieToday = serverSays || ref.read(selfieTakenProvider.notifier).today(partnerId);
    // a step kept offline means the visit has started on this phone
    final started = ref.watch(visitControllerProvider.select((s) => s.pending[bookingId]?.isNotEmpty ?? false));
    return JobDetails(
      bookingId: bookingId,
      header: (job) => [
        ..._welcome(context, job),
        // the job stays readable below it: address, health notes, calls
        if (!selfieToday && !started && selfieFirst(job)) ...[
          const _SelfieCard(),
          const SizedBox(height: WWSpacing.lg),
        ],
      ],
    );
  }
}

/// "Your WellWish job", above the job.
List<Widget> _welcome(BuildContext context, PartnerJobOut job) {
  final l10n = WWLocalizations.of(context);
  return [
    Text(l10n.tempHomeTitle, key: const Key('temp-home'), style: WWType.screenTitle),
    const SizedBox(height: WWSpacing.xs),
    Text(l10n.tempHomeBody, style: WWType.caption.copyWith(fontSize: 13)),
    const SizedBox(height: WWSpacing.xs),
    Text(l10n.jobTitle(job.code), style: WWType.caption),
    const SizedBox(height: WWSpacing.lg),
    const RootedWarning(),
  ];
}

/// Today's selfie, first thing on the visit day.
class _SelfieCard extends StatefulWidget {
  const _SelfieCard();

  @override
  State<_SelfieCard> createState() => _SelfieCardState();
}

class _SelfieCardState extends State<_SelfieCard> {
  bool _opening = false;

  /// One selfie screen, however fast the taps.
  Future<void> _open() async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      await context.push<bool>(SelfieScreen.path);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return WWCard(
      key: const Key('temp-selfie-step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: WWColors.tint,
                child: Icon(Icons.face_retouching_natural, color: WWColors.primary),
              ),
              const SizedBox(width: WWSpacing.md),
              Expanded(child: Text(l10n.selfieTitle, style: WWType.section)),
            ],
          ),
          const SizedBox(height: WWSpacing.sm),
          Text(l10n.tempSelfieBody, style: WWType.body),
          const SizedBox(height: WWSpacing.md),
          WWPrimaryButton(
            key: const Key('temp-take-selfie'),
            label: l10n.takeSelfie,
            onPressed: _opening ? null : _open,
          ),
        ],
      ),
    );
  }
}
