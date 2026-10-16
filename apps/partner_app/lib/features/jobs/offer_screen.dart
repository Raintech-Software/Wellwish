import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../registration/partner_errors.dart';
import 'job_format.dart';
import 'job_screen.dart';
import 'jobs_providers.dart';
import 'offer_card.dart';

/// R09 Assignment offer (§6.10): the summary only (area, distance, time, hospital, needs, the
/// balance to collect). The full address, phones, health notes and documents open after
/// accepting. Decline needs a reason.
class OfferScreen extends ConsumerStatefulWidget {
  const OfferScreen({super.key, required this.assignmentId});

  static const path = '/offer/:id';
  static String pathFor(String id) => '/offer/$id';

  final String assignmentId;

  @override
  ConsumerState<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends ConsumerState<OfferScreen> {
  bool _busy = false;

  Future<void> _accept(OfferSummaryOut offer) async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    setState(() => _busy = true);
    final container = ProviderScope.containerOf(context, listen: false);
    final router = GoRouter.of(context);
    try {
      await ref.read(partnerApiProvider).partnerOfferAccept(assignmentId: offer.assignmentId);
      jobsChanged(ref.invalidate);
      container.invalidate(jobProvider(offer.bookingId));
      router.pushReplacement(JobScreen.pathFor(offer.bookingId));
    } catch (e) {
      if (!mounted) return;
      if (toApiException(e).code == 'OFFER_NOT_OPEN') {
        jobsChanged(ref.invalidate);
        // Maybe it's theirs already (accepted by phone with the admin, or a double tap).
        try {
          await ref.read(partnerApiProvider).partnerJobGet(bookingId: offer.bookingId);
          router.pushReplacement(JobScreen.pathFor(offer.bookingId));
          return;
        } catch (_) {
          // not theirs: say so and go back
        }
        if (!mounted) return;
        showSnack(context, partnerErrorMessage(l10n, e));
        router.pop();
        return;
      }
      showSnack(context, partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _decline(OfferSummaryOut offer) async {
    if (_busy) return;
    final declined = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _DeclineSheet(assignmentId: offer.assignmentId),
    );
    if (declined == true && mounted) {
      showSnack(context, WWLocalizations.of(context).offerDeclined);
      jobsChanged(ref.invalidate);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final offer = ref.watch(offerProvider(widget.assignmentId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.offerTitle)),
      body: offer.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: partnerErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(offerProvider(widget.assignmentId)),
        ),
        data: (o) {
          final reconfirm = o.kind == 'RECONFIRM';
          final open = o.response == 'OPEN';
          final theirs = o.response == 'ACCEPTED' || o.response == 'ACCEPTED_BY_PHONE';
          final needs = [
            mobilityLabel(l10n, o.mobility),
            if (o.language.isNotEmpty) spokenLanguage(l10n, o.language),
          ].where((s) => s.isNotEmpty).join(' · ');
          return ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              if (reconfirm) ...[
                WWMessageBox(message: l10n.offerReconfirm, icon: Icons.update),
                const SizedBox(height: WWSpacing.md),
              ],
              WWCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(serviceName(context, o.service), style: WWType.section),
                    const SizedBox(height: WWSpacing.xs),
                    Text(o.code, style: WWType.caption),
                    if (open) ...[const SizedBox(height: WWSpacing.sm), OfferCountdown(timeoutAt: o.timeoutAt)],
                  ],
                ),
              ),
              const SizedBox(height: WWSpacing.md),
              WWCard(
                child: Column(
                  children: [
                    _Line(
                      label: l10n.whenLabel,
                      value: [
                        istDateTime(context, o.pickupAt),
                        if (o.appointmentAt != null) l10n.appointmentAt(istTime(context, o.appointmentAt!)),
                      ].join('\n'),
                    ),
                    _Line(
                      label: l10n.offerArea,
                      value: [
                        if (o.area.isNotEmpty) o.area,
                        if (o.distanceKm != null) l10n.offerDistance(o.distanceKm!.toStringAsFixed(1)),
                      ].join('\n'),
                    ),
                    if (o.hospitalName.isNotEmpty) _Line(label: l10n.hospitalLabel, value: o.hospitalName),
                    _Line(label: l10n.offerPatient, value: personLine(l10n, o.memberGender, o.memberAge)),
                    if (needs.isNotEmpty) _Line(label: l10n.offerNeeds, value: needs),
                    _Line(
                      label: l10n.documentsLabel,
                      value: [
                        l10n.offerDocuments(o.documentsAttached),
                        if (o.hasPrescription) l10n.offerPrescription,
                      ].join('\n'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: WWSpacing.md),
              if (o.balancePaise > 0) ...[
                WWMessageBox(message: l10n.offerBalance(inr(o.balancePaise)), icon: Icons.currency_rupee),
                const SizedBox(height: WWSpacing.sm),
              ],
              Text(l10n.offerDetailsLater, style: WWType.caption),
              const SizedBox(height: WWSpacing.xl),
              if (open) ...[
                WWPrimaryButton(
                  key: const Key('accept-offer'),
                  label: reconfirm ? l10n.acceptNewTime : l10n.acceptOffer,
                  color: WWColors.brandGreen,
                  loading: _busy,
                  onPressed: _busy ? null : () => _accept(o),
                ),
                const SizedBox(height: WWSpacing.sm),
                WWSecondaryButton(
                  key: const Key('decline-offer'),
                  label: l10n.declineOffer,
                  onPressed: _busy ? null : () => _decline(o),
                ),
              ] else if (theirs) ...[
                WWMessageBox(
                  key: const Key('offer-theirs'),
                  message: l10n.offerAccepted,
                  icon: Icons.check_circle_outline,
                ),
                const SizedBox(height: WWSpacing.sm),
                WWPrimaryButton(
                  key: const Key('open-job'),
                  label: l10n.openJob,
                  onPressed: () => context.pushReplacement(JobScreen.pathFor(o.bookingId)),
                ),
              ] else
                WWMessageBox(key: const Key('offer-closed'), message: l10n.errOfferNotOpen, icon: Icons.info_outline),
              const SizedBox(height: WWSpacing.lg),
            ],
          );
        },
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 96, child: Text(label, style: WWType.caption)),
          Expanded(child: Text(value, style: WWType.body)),
        ],
      ),
    );
  }
}

/// Decline with a reason (not available, too far, other) and an optional note.
class _DeclineSheet extends ConsumerStatefulWidget {
  const _DeclineSheet({required this.assignmentId});

  final String assignmentId;

  @override
  ConsumerState<_DeclineSheet> createState() => _DeclineSheetState();
}

class _DeclineSheetState extends ConsumerState<_DeclineSheet> {
  final _note = TextEditingController();
  DeclineInReasonEnum _reason = DeclineInReasonEnum.NOT_AVAILABLE;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(partnerApiProvider)
          .partnerOfferDecline(
            assignmentId: widget.assignmentId,
            declineIn: DeclineIn(reason: _reason, note: _note.text.trim()),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
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
    return Padding(
      padding: EdgeInsets.only(
        left: WWSpacing.screen,
        right: WWSpacing.screen,
        bottom: MediaQuery.viewInsetsOf(context).bottom + WWSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.declineTitle, style: WWType.screenTitle),
            const SizedBox(height: WWSpacing.md),
            WWChoicePills<DeclineInReasonEnum>(
              choices: [
                WWChoice(
                  key: const Key('decline-not-available'),
                  value: DeclineInReasonEnum.NOT_AVAILABLE,
                  label: l10n.declineNotAvailable,
                ),
                WWChoice(
                  key: const Key('decline-too-far'),
                  value: DeclineInReasonEnum.TOO_FAR,
                  label: l10n.declineTooFar,
                ),
                WWChoice(key: const Key('decline-other'), value: DeclineInReasonEnum.OTHER, label: l10n.declineOther),
              ],
              selected: _reason,
              onSelected: (r) => setState(() => _reason = r),
            ),
            const SizedBox(height: WWSpacing.md),
            WWTextField(controller: _note, label: l10n.declineNoteHint, maxLines: 2, maxLength: 200),
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.sm),
              WWMessageBox(message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.md),
            WWPrimaryButton(
              key: const Key('confirm-decline'),
              label: l10n.declineOffer,
              color: WWColors.danger,
              loading: _busy,
              onPressed: _busy ? null : _confirm,
            ),
          ],
        ),
      ),
    );
  }
}
