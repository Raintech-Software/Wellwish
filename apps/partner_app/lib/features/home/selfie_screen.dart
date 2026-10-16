import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../jobs/job_format.dart';
import '../jobs/jobs_providers.dart';
import '../registration/device_tools.dart';
import '../registration/partner_errors.dart';
import '../session/session_controller.dart';
import '../temporary/temporary_home.dart';

/// The India day each partner took a selfie on this phone (partner id → day). A temporary
/// partner can't ask the server (§6.19: only their job is open), so their home uses this to show
/// the selfie step first. Forgotten when the app closes: a second selfie that day is harmless
/// (the newest is their photo), and a missing one is caught by "On the way" (409
/// `SELFIE_REQUIRED`).
class SelfieTaken extends Notifier<Map<String, DateTime>> {
  @override
  Map<String, DateTime> build() => const {};

  void taken(String partnerId) => state = {...state, partnerId: istDay(ServerClock.now())};

  bool today(String partnerId) => state[partnerId] == istDay(ServerClock.now());
}

final selfieTakenProvider = NotifierProvider<SelfieTaken, Map<String, DateTime>>(SelfieTaken.new);

/// The once-a-day selfie before "Available today" (§6.15, §8.3): front camera, uploaded, then
/// the switch goes on. The admin spot-checks it against the approved photo. Pops true when the
/// partner is available.
///
/// A temporary partner (§6.19) takes it before "On the way" of their one job: no "Available
/// today" for them; it pops true once the selfie is saved (it's their photo for the visit).
class SelfieScreen extends ConsumerStatefulWidget {
  const SelfieScreen({super.key});

  static const path = '/selfie';

  @override
  ConsumerState<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends ConsumerState<SelfieScreen> {
  bool _busy = false;
  bool _saved = false; // today's selfie is in: a retry only switches "available" on
  String? _error;

  Future<void> _take() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final container = ProviderScope.containerOf(context, listen: false);
    final me = ref.read(sessionProvider).me;
    final temporary = isTemporary(me?.partnerStatus);
    if (!_saved) {
      final file = await ref.read(filePickerProvider).pick(PickSource.frontCamera);
      if (file == null || !mounted) return;
      setState(() {
        _busy = true;
        _error = null;
      });
      try {
        final key = await ref.read(uploaderProvider).upload(PartnerUploadUrlInPurposeEnum.partnerSelfie, file);
        await container.read(partnerApiProvider).partnerSelfieAdd(selfieIn: SelfieIn(fileKey: key));
        _saved = true;
        if (me != null) container.read(selfieTakenProvider.notifier).taken(me.id);
      } catch (e) {
        if (mounted) {
          setState(() {
            _busy = false;
            _error = partnerErrorMessage(l10n, e);
          });
        }
        return;
      }
    } else {
      setState(() {
        _busy = true;
        _error = null;
      });
    }
    if (temporary) {
      // §6.19: no "Available today" (closed to them): back to their job
      messenger.showSnackBar(SnackBar(content: Text(l10n.tempSelfieSaved)));
      if (!mounted) return;
      setState(() => _busy = false);
      if (router.canPop()) {
        router.pop(true);
      } else {
        router.go(TemporaryHome.path);
      }
      return;
    }
    try {
      await container
          .read(partnerApiProvider)
          .partnerAvailabilitySet(availabilityIn: AvailabilityIn(availableToday: true));
      jobsChanged(container.invalidate);
      messenger.showSnackBar(SnackBar(content: Text(l10n.selfieSaved)));
      if (mounted) router.pop(true);
    } catch (e) {
      jobsChanged(container.invalidate);
      if (mounted) {
        setState(() {
          _busy = false;
          _error = partnerErrorMessage(l10n, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final temporary = ref.watch(sessionProvider.select((s) => isTemporary(s.me?.partnerStatus)));
    return PopScope(
      canPop: !_busy, // not while the selfie is being sent
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.selfieTitle)),
        body: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            const SizedBox(height: WWSpacing.xl),
            const Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: WWColors.tint,
                child: Icon(Icons.face_retouching_natural, size: 56, color: WWColors.primary),
              ),
            ),
            const SizedBox(height: WWSpacing.lg),
            Text(temporary ? l10n.tempSelfieBody : l10n.selfieBody, style: WWType.body, textAlign: TextAlign.center),
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.md),
              WWMessageBox(message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.xl),
            WWPrimaryButton(
              key: const Key('take-selfie'),
              label: _saved ? l10n.tryAgain : l10n.takeSelfie,
              loading: _busy,
              onPressed: _busy ? null : _take,
            ),
          ],
        ),
      ),
    );
  }
}
