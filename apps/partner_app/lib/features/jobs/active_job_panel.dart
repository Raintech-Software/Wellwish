import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../home/selfie_screen.dart';
import '../registration/partner_errors.dart';
import '../session/session_controller.dart';
import 'care_note_screen.dart';
import 'collect_balance_screen.dart';
import 'job_format.dart';
import 'visit_controller.dart';

/// R12 Active job (ARCHITECTURE §6.11): the next step as one big button (the OTP step asks for
/// the family's code; "Care done" opens the care note), "sharing your location", the 15-minute
/// wait after arriving with "Patient not available", and SOS (WellWish + 112 / 108).
class ActiveJobPanel extends ConsumerStatefulWidget {
  const ActiveJobPanel({super.key, required this.job});

  final PartnerJobOut job;

  @override
  ConsumerState<ActiveJobPanel> createState() => _ActiveJobPanelState();
}

class _ActiveJobPanelState extends ConsumerState<ActiveJobPanel> {
  bool _busy = false;
  bool _noShowBusy = false;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    // the wait timers count down on screen (patient not available, wrong-code wait)
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      final visit = widget.job.visit;
      if (mounted && (visit?.noShowReadyAt != null || visit?.otpRetryAt != null)) setState(() {});
    });
    // after the app was closed mid-job: share the location again (never switches jobs)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.jobLoaded(widget.job.id, widget.job);
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  VisitController get _controller {
    final l10n = WWLocalizations.of(context);
    return ref.read(visitControllerProvider.notifier)
      ..notificationTitle = l10n.fgsTitle
      ..notificationText = l10n.fgsText;
  }

  /// The next step after the ones already done and those waiting for the network.
  String? _next(VisitOut visit, List<String> pending) {
    if (pending.isEmpty) return visit.nextStep;
    final index = visit.steps.indexOf(pending.last);
    return index >= 0 && index < visit.steps.length - 1 ? visit.steps[index + 1] : null;
  }

  Future<void> _tap(String step) async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    final job = widget.job;
    final visit = job.visit!;
    if (step == visit.otpStep) {
      final done = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _OtpSheet(job: job, step: step, controller: _controller),
      );
      if (done == true && mounted) showSnack(context, l10n.stepName(step));
      return;
    }
    if (step == 'CARE_DONE') {
      await context.push(CareNoteScreen.pathFor(job.id));
      return;
    }
    if (step == 'ON_THE_WAY') {
      // busy already while the permission question is open: a second tap sends nothing twice
      setState(() => _busy = true);
      // Android 13+: the location notification needs this (the job still works without it)
      await ref.read(notificationPermissionProvider)();
      if (!mounted) return;
    }
    setState(() => _busy = true);
    try {
      final outcome = await _controller.doStep(job, step);
      if (!mounted) return;
      if (outcome == StepOutcome.queued) showSnack(context, l10n.stepQueued);
      if (step == 'COMPLETED') {
        showSnack(context, l10n.jobFinished);
        // only once the server has it (kept offline, the balance would be refused): until then
        // the job screen's balance card comes once the job shows Completed
        if (outcome == StepOutcome.sent && job.balancePaise > 0) {
          unawaited(context.push(CollectBalanceScreen.pathFor(job.id)));
        }
      }
    } catch (e) {
      if (!mounted) return;
      final error = toApiException(e);
      if (error.code == 'SELFIE_REQUIRED') {
        // §6.19: a temporary partner without today's selfie: take it, then back to the job
        setState(() => _busy = false);
        await context.push<bool>(SelfieScreen.path);
        return;
      }
      final from = DateTime.tryParse('${error.details['from'] ?? ''}');
      showSnack(
        context,
        error.code == 'TOO_EARLY_TO_START' && from != null
            ? l10n.tooEarlyToStart(istDateTime(context, from))
            : partnerErrorMessage(l10n, e),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _noShow() async {
    final l10n = WWLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        content: Text(l10n.noShowConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(dialog, true), child: Text(l10n.patientNotAvailable)),
        ],
      ),
    );
    if (ok != true || !mounted || _noShowBusy) return;
    setState(() => _noShowBusy = true);
    try {
      await _controller.patientNotAvailable(widget.job.id);
      if (mounted) showSnack(context, l10n.noShowDone);
    } catch (e) {
      if (!mounted) return;
      final error = toApiException(e);
      final called = error.details['called'];
      showSnack(context, error.code == 'TOO_EARLY' && called == false ? l10n.callFirst : partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _noShowBusy = false);
    }
  }

  Future<void> _sos() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _SosSheet(bookingId: widget.job.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final job = widget.job;
    final visit = job.visit;
    if (visit == null) return const SizedBox.shrink();
    final state = ref.watch(visitControllerProvider);
    final pending = state.pending[job.id] ?? const [];
    final next = _next(visit, pending);
    final current = pending.isNotEmpty ? pending.last : visit.currentStep;
    final sharing = state.sharingBookingId == job.id;
    final support = ref.watch(sessionProvider.select((s) => s.supportPhone));
    final ready = visit.noShowReadyAt;
    final waitLeft = ready?.difference(ServerClock.now()).inSeconds;
    final waiting = ['REACHED_PATIENT', 'REACHED_HOME'].contains(current) && pending.isEmpty;
    final retryAt = visit.otpRetryAt;
    final codeWait = next == visit.otpStep && retryAt != null && retryAt.isAfter(ServerClock.now());
    return WWCard(
      key: const Key('active-job'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.activeJobTitle, style: WWType.section)),
              if (job.status == 'IN_PROGRESS')
                TextButton.icon(
                  key: const Key('sos'),
                  onPressed: _sos,
                  style: TextButton.styleFrom(foregroundColor: WWColors.danger),
                  icon: const Icon(Icons.sos),
                  label: Text(l10n.sos),
                ),
            ],
          ),
          if (current.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: WWSpacing.sm),
              child: WWBadge(
                label: l10n.stepName(current),
                icon: Icons.check_circle,
                color: WWColors.brandGreen,
                background: WWColors.greenTint,
              ),
            ),
          if (sharing)
            Row(
              children: [
                const Icon(Icons.my_location, size: 16, color: WWColors.brandGreen),
                const SizedBox(width: WWSpacing.xs),
                Expanded(child: Text(l10n.sharingLocation, style: WWType.caption)),
              ],
            ),
          if (state.locationProblem && sharing) ...[
            const SizedBox(height: WWSpacing.xs),
            WWMessageBox(message: l10n.locationOffHelp, isError: true),
            TextButton.icon(
              key: const Key('share-again'),
              onPressed: () => _controller.startSharing(job.id),
              icon: const Icon(Icons.my_location),
              label: Text(l10n.shareAgain),
            ),
          ],
          if (state.stepsRefused) ...[
            const SizedBox(height: WWSpacing.xs),
            WWMessageBox(key: const Key('steps-refused'), message: l10n.stepsRefused, isError: true),
          ],
          if (pending.isNotEmpty) ...[
            const SizedBox(height: WWSpacing.xs),
            WWMessageBox(
              key: const Key('pending-steps'),
              message: l10n.pendingSteps(pending.length),
              icon: Icons.cloud_off,
            ),
          ],
          if (codeWait) ...[
            const SizedBox(height: WWSpacing.sm),
            WWMessageBox(
              key: const Key('otp-wait'),
              message: l10n.otpWaitUntil(istTime(context, retryAt)),
              isError: true,
            ),
            if (support != null && support.isNotEmpty)
              TextButton.icon(
                onPressed: () => launchUrl(Uri(scheme: 'tel', path: support)),
                icon: const Icon(Icons.support_agent),
                label: Text(l10n.callWellWish),
              ),
          ] else if (next != null) ...[
            const SizedBox(height: WWSpacing.md),
            WWPrimaryButton(
              key: const Key('next-step'),
              label: l10n.stepName(next),
              color: next == 'COMPLETED' ? WWColors.brandGreen : null,
              loading: _busy,
              onPressed: _busy ? null : () => _tap(next),
            ),
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.tapWhenDone, style: WWType.caption, textAlign: TextAlign.center),
          ],
          if (waiting && waitLeft != null) ...[
            const SizedBox(height: WWSpacing.md),
            if (waitLeft > 0)
              Text(
                l10n.waitTimer(clock(waitLeft)),
                key: const Key('wait-timer'),
                style: WWType.caption,
                textAlign: TextAlign.center,
              )
            else
              WWSecondaryButton(
                key: const Key('patient-not-available'),
                icon: _noShowBusy
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.person_off_outlined),
                label: l10n.patientNotAvailable,
                onPressed: _noShowBusy ? null : _noShow,
              ),
          ],
        ],
      ),
    );
  }
}

/// The OTP step: the family's 4-digit code.
class _OtpSheet extends ConsumerStatefulWidget {
  const _OtpSheet({required this.job, required this.step, required this.controller});

  final PartnerJobOut job;
  final String step;
  final VisitController controller;

  @override
  ConsumerState<_OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends ConsumerState<_OtpSheet> {
  final _code = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = WWLocalizations.of(context);
    if (_busy || _code.text.trim().length != 4) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.controller.doStep(widget.job, widget.step, otp: _code.text.trim());
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final error = toApiException(e);
      setState(() {
        _busy = false;
        final retryAt = DateTime.tryParse('${error.details['retryAt'] ?? ''}');
        final left = (error.details['triesLeft'] as num?)?.toInt() ?? 0;
        _error = switch (error.code) {
          // after 4 wrong codes: a wait (5, 10, 20 min…), never a hard lock
          'WRONG_OTP' || 'OTP_WAIT' when retryAt != null => l10n.otpWaitUntil(istTime(context, retryAt)),
          'WRONG_OTP' when left == 1 => l10n.jobOtpLastTry,
          'WRONG_OTP' => l10n.jobOtpWrong(left),
          _ => error.isConnectivity ? l10n.noNetworkOtp : partnerErrorMessage(l10n, e),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return SingleChildScrollView(
      // large text (9.8)
      child: Padding(
        padding: EdgeInsets.only(
          left: WWSpacing.screen,
          right: WWSpacing.screen,
          bottom: MediaQuery.viewInsetsOf(context).bottom + WWSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.enterOtpTitle, style: WWType.screenTitle),
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.enterOtpBody, style: WWType.body),
            const SizedBox(height: WWSpacing.md),
            TextField(
              key: const Key('otp-input'),
              controller: _code,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: WWType.screenTitle.copyWith(letterSpacing: 12),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: (_) => _submit(),
            ),
            if (_error != null) WWMessageBox(key: const Key('otp-error'), message: _error!, isError: true),
            const SizedBox(height: WWSpacing.md),
            WWPrimaryButton(
              key: const Key('confirm-otp'),
              label: l10n.stepName(widget.step),
              loading: _busy,
              onPressed: _busy ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// SOS: WellWish (with the location) and the emergency numbers.
class _SosSheet extends ConsumerStatefulWidget {
  const _SosSheet({required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<_SosSheet> createState() => _SosSheetState();
}

class _SosSheetState extends ConsumerState<_SosSheet> {
  bool _busy = false;
  bool _sent = false;
  String? _error;

  Future<void> _send() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // the point just shared for this job if there is one (indoors a fresh fix often takes
      // longer than an SOS should wait), else a fresh one; a fake one still goes, flagged
      final place = await ref.read(visitControllerProvider.notifier).sosPlace(widget.bookingId);
      await ref
          .read(partnerApiProvider)
          .partnerSos(
            bookingId: widget.bookingId,
            sosIn: SosIn(
              lat: place?.lat.toStringAsFixed(6),
              lng: place?.lng.toStringAsFixed(6),
              mock: place?.mock ?? false,
            ),
          );
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) setState(() => _error = partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return SingleChildScrollView(
      // large text (9.8)
      child: Padding(
        padding: const EdgeInsets.fromLTRB(WWSpacing.screen, 0, WWSpacing.screen, WWSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.sosTitle, style: WWType.screenTitle.copyWith(color: WWColors.danger)),
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.sosBody, style: WWType.body),
            const SizedBox(height: WWSpacing.md),
            if (_sent)
              WWMessageBox(key: const Key('sos-sent'), message: l10n.sosSent, icon: Icons.check_circle)
            else
              WWPrimaryButton(
                key: const Key('send-sos'),
                label: l10n.sendSos,
                color: WWColors.danger,
                loading: _busy,
                onPressed: _busy ? null : _send,
              ),
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.sm),
              WWMessageBox(key: const Key('sos-error'), message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.sm),
            WWSecondaryButton(
              icon: const Icon(Icons.local_police_outlined),
              label: l10n.call112,
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: '112')),
            ),
            const SizedBox(height: WWSpacing.sm),
            WWSecondaryButton(
              icon: const Icon(Icons.emergency_outlined),
              label: l10n.call108,
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: '108')),
            ),
          ],
        ),
      ),
    );
  }
}
