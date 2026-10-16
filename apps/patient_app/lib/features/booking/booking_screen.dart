import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import '../payments/pay_flow.dart';
import '../visit/live_tracking_screen.dart';
import '../visit/visit_widgets.dart';
import 'booking_flow.dart';
import 'reschedule_screen.dart';
import 'review_screen.dart';

/// P18 Booking detail: status, what, when, where, documents, price, refunds and timeline, with
/// "Pay" while unpaid, "Change date or time" and "Cancel booking" (§6.12). Opened from My
/// bookings, the Home card, the member's profile and the payment result. During the visit: the
/// visit code and "Track live" (P19); after it, P20: pay the partner, rate, report a problem.
class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key, required this.bookingId});

  static const path = '/booking/:id';
  static String pathFor(String id) => '/booking/$id';

  final String bookingId;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  bool _paying = false;

  Future<void> _pay(BookingDetailOut b) async {
    if (_paying) return;
    final l10n = WWLocalizations.of(context);
    setState(() => _paying = true);
    try {
      await payAndShowResult(context, bookingId: b.id, description: bookedServiceName(context, b.service));
    } catch (e) {
      if (mounted) showSnack(context, patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  Future<void> _cancel(BookingDetailOut b) async {
    final cancelled = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CancelSheet(booking: b),
    );
    if (cancelled == true && mounted) showSnack(context, WWLocalizations.of(context).bookingCancelledSnack);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final detail = ref.watch(bookingDetailProvider(widget.bookingId));
    return Scaffold(
      appBar: AppBar(title: Text(detail.value == null ? '' : l10n.bookingCode(detail.value!.code))),
      body: detail.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(bookingDetailProvider(widget.bookingId)),
        ),
        data: (b) {
          // A payment Razorpay is still confirming: no second "Pay" (it could charge twice).
          final confirming = b.status == 'PENDING_PAYMENT' && b.paymentPending == true;
          final canPay = b.status == 'PENDING_PAYMENT' && !confirming && (b.payBy?.isAfter(DateTime.now()) ?? false);
          // Before "on the way" the time can be changed; otherwise say why not.
          final reschedulable = const {'NEW', 'OFFERED', 'ACCEPTED'}.contains(b.status);
          final partnerName = b.partner?.fullName.split(' ').first ?? '';
          return RefreshIndicator(
            onRefresh: () => ref.refresh(bookingDetailProvider(widget.bookingId).future),
            child: ListView(
              padding: const EdgeInsets.all(WWSpacing.screen),
              children: [
                _StatusCard(booking: b),
                if (b.status == 'COMPLETED') ...[const SizedBox(height: WWSpacing.md), CompletedCard(booking: b)],
                if (b.status == 'PATIENT_NO_SHOW') ...[
                  const SizedBox(height: WWSpacing.md),
                  WWMessageBox(message: l10n.noShowShown(partnerName), icon: Icons.info_outline),
                ],
                if (b.partner != null) ...[const SizedBox(height: WWSpacing.md), _PartnerCard(partner: b.partner!)],
                if (b.jobOtp != null) ...[
                  const SizedBox(height: WWSpacing.md),
                  VisitCodeCard(code: b.jobOtp!, partnerName: partnerName),
                ],
                if (b.status == 'IN_PROGRESS') ...[
                  const SizedBox(height: WWSpacing.md),
                  WWPrimaryButton(
                    key: const Key('track-live'),
                    label: l10n.trackLive,
                    onPressed: () => context.push(LiveTrackingScreen.pathFor(b.id)),
                  ),
                ],
                if (b.canReview == true) ...[
                  const SizedBox(height: WWSpacing.md),
                  RatingCard(bookingId: b.id),
                ] else if (b.review != null) ...[
                  const SizedBox(height: WWSpacing.md),
                  YourReviewCard(review: b.review!),
                ],
                if (b.reconfirmNeeded) ...[
                  const SizedBox(height: WWSpacing.sm),
                  WWMessageBox(message: l10n.partnerWillReconfirm, icon: Icons.info_outline),
                ],
                if (confirming) ...[
                  const SizedBox(height: WWSpacing.md),
                  WWMessageBox(
                    key: const Key('payment-confirming'),
                    message: l10n.paymentTakingLong,
                    icon: Icons.hourglass_top,
                  ),
                ],
                if (canPay) ...[
                  const SizedBox(height: WWSpacing.md),
                  WWPrimaryButton(
                    key: const Key('booking-pay'),
                    label: l10n.payAmount(inr(b.service.bookingFeePaise)),
                    color: WWColors.brandGreen,
                    loading: _paying,
                    onPressed: _paying ? null : () => _pay(b),
                  ),
                ],
                const SizedBox(height: WWSpacing.md),
                WWCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReviewLine(label: l10n.serviceLabel, value: bookedServiceName(context, b.service)),
                      ReviewLine(label: l10n.forWhom, value: b.member.fullName),
                      ReviewLine(
                        label: l10n.whenLabel,
                        value: [
                          '${istDay(context, b.pickupAt)} · ${timeLabelFor(l10n, b.service.visitType)} ${istTime(context, b.pickupAt)}',
                          if (b.appointmentAt != null) l10n.appointmentAt(istTime(context, b.appointmentAt!)),
                        ].join('\n'),
                      ),
                      ReviewLine(
                        label: l10n.whereLabel,
                        value: [
                          if (b.hospitalName.isNotEmpty) b.hospitalName,
                          if (b.doctorName.isNotEmpty) b.doctorName,
                          if (b.address.line1.isNotEmpty) '${b.address.label}: ${b.address.line1}',
                        ].join('\n'),
                      ),
                      if (b.notes.isNotEmpty) ReviewLine(label: l10n.notesTitle, value: b.notes),
                    ],
                  ),
                ),
                if (reschedulable) ...[
                  const SizedBox(height: WWSpacing.md),
                  WWSecondaryButton(
                    key: const Key('change-time'),
                    icon: const Icon(Icons.edit_calendar_outlined),
                    label: l10n.changeTime,
                    onPressed: b.canReschedule ? () => context.push(RescheduleScreen.pathFor(b.id)) : null,
                  ),
                  const SizedBox(height: WWSpacing.xs),
                  Text(
                    b.canReschedule
                        ? l10n.reschedulesLeft(b.reschedulesLeft)
                        : rescheduleProblemText(l10n, b.rescheduleProblem),
                    style: WWType.caption,
                  ),
                ],
                if (b.documents.isNotEmpty) ...[
                  const SizedBox(height: WWSpacing.lg),
                  Text(l10n.documentsLabel, style: WWType.section),
                  const SizedBox(height: WWSpacing.sm),
                  for (final doc in b.documents)
                    WWCard(
                      padding: EdgeInsets.zero,
                      child: WWListTile(
                        icon: doc.removed ? Icons.block : Icons.description_outlined,
                        iconColor: doc.removed ? WWColors.textSecondary : WWColors.primary,
                        title: doc.removed ? l10n.documentRemoved : doc.title,
                        subtitle: documentTypeLabel(l10n, doc.type),
                        showChevron: false,
                      ),
                    ),
                ],
                const SizedBox(height: WWSpacing.lg),
                PriceBox(
                  total: b.service.pricePaise,
                  fee: b.service.bookingFeePaise,
                  balance: b.service.balancePaise,
                  isNurse: b.service.partnerType == 'NURSE',
                  toPay: b.status == 'PENDING_PAYMENT',
                ),
                if (b.refunds.isNotEmpty) ...[
                  const SizedBox(height: WWSpacing.lg),
                  Text(l10n.refundsTitle, style: WWType.section),
                  const SizedBox(height: WWSpacing.sm),
                  for (final r in b.refunds) _RefundTile(refund: r),
                ],
                const SizedBox(height: WWSpacing.lg),
                Text(l10n.timelineTitle, style: WWType.section),
                const SizedBox(height: WWSpacing.sm),
                WWCard(
                  child: Column(
                    children: [
                      for (final t in b.timeline)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Icon(Icons.circle, size: 10, color: WWColors.primary),
                              ),
                              const SizedBox(width: WWSpacing.sm),
                              // the time goes under the event when both don't fit (large text)
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: WWSpacing.sm,
                                  children: [
                                    Text(switch (t.event) {
                                      'CREATE' => l10n.eventCreate,
                                      'PAY' => l10n.eventPaid,
                                      'RESCHEDULE' => l10n.eventRescheduled,
                                      _ when (t.step ?? '').isNotEmpty => l10n.stepName(t.step!),
                                      _ => bookingStatusLabel(l10n, t.status),
                                    }, style: WWType.body),
                                    Text(istDateTime(context, t.at), style: WWType.caption),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (b.tickets?.isNotEmpty ?? false) ...[
                  const SizedBox(height: WWSpacing.lg),
                  TicketsSection(tickets: b.tickets!),
                ],
                if (b.canReport == true) ...[
                  const SizedBox(height: WWSpacing.md),
                  ReportProblemButton(bookingId: b.id),
                ],
                if (b.canCancel) ...[
                  const SizedBox(height: WWSpacing.xl),
                  Center(
                    child: TextButton.icon(
                      key: const Key('cancel-booking'),
                      onPressed: () => _cancel(b),
                      icon: const Icon(Icons.cancel_outlined, color: WWColors.danger),
                      label: Text(l10n.cancelBooking, style: const TextStyle(color: WWColors.danger)),
                    ),
                  ),
                ],
                const SizedBox(height: WWSpacing.lg),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.booking});

  final BookingDetailOut booking;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final waiting = booking.status == 'PENDING_PAYMENT';
    final color = switch (booking.status) {
      'CANCELLED' || 'EXPIRED' || 'PATIENT_NO_SHOW' => WWColors.textSecondary,
      'PENDING_PAYMENT' => WWColors.warning,
      _ => WWColors.brandGreen,
    };
    return WWCard(
      child: Row(
        children: [
          Icon(switch (booking.status) {
            'PENDING_PAYMENT' => Icons.hourglass_top,
            'CANCELLED' || 'EXPIRED' || 'PATIENT_NO_SHOW' => Icons.event_busy,
            _ => Icons.event_available,
          }, color: color),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bookingStatusLabel(l10n, booking.status), style: WWType.cardTitle.copyWith(color: color)),
                Text(booking.code, style: WWType.caption),
                if (booking.status == 'IN_PROGRESS' && (booking.visit?.currentStep.isNotEmpty ?? false))
                  Text(l10n.nowStep(l10n.stepName(booking.visit!.currentStep)), style: WWType.body),
                if (waiting && booking.payBy != null)
                  Text(l10n.payBy(istTime(context, booking.payBy!)), style: WWType.caption),
                if (booking.paidPaise > 0) Text(l10n.paidAmount(inr(booking.paidPaise)), style: WWType.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// §6.15: once a partner accepts, the patient sees their photo, name, role, rating and a Call
/// button (the phone is hidden again after the job).
class _PartnerCard extends ConsumerWidget {
  const _PartnerCard({required this.partner});

  final AssignedPartnerOut partner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final role = partner.role == 'NURSE' ? l10n.roleNurse : l10n.roleCompanion;
    final rating = partner.ratingCount > 0 && partner.ratingAvg != null
        ? l10n.ratingCount(
            double.tryParse(partner.ratingAvg!)?.toStringAsFixed(1) ?? partner.ratingAvg!, // "4.80" → "4.8"
            partner.ratingCount,
          )
        : l10n.newPartner;
    return WWCard(
      key: const Key('your-partner'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.yourPartner, style: WWType.caption),
          const SizedBox(height: WWSpacing.sm),
          Row(
            children: [
              WWAvatar(
                name: partner.fullName,
                size: 56,
                image: partner.photoUrl == null
                    ? null
                    : NetworkImage(fileUrl(ref.watch(appConfigProvider), partner.photoUrl!)),
              ),
              const SizedBox(width: WWSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(partner.fullName, style: WWType.cardTitle),
                    Text(role, style: WWType.caption),
                    Row(
                      children: [
                        if (partner.ratingCount > 0) ...[
                          const Icon(Icons.star, size: 16, color: WWColors.warning),
                          const SizedBox(width: 2),
                        ],
                        Flexible(child: Text(rating, style: WWType.caption)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (partner.phone.isNotEmpty) ...[
            const SizedBox(height: WWSpacing.md),
            WWSecondaryButton(
              key: const Key('call-partner'),
              icon: const Icon(Icons.call_outlined),
              label: l10n.callName(partner.fullName.split(' ').first),
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: partner.phone.replaceAll(' ', ''))),
            ),
          ],
        ],
      ),
    );
  }
}

class _RefundTile extends StatelessWidget {
  const _RefundTile({required this.refund});

  final BookingRefundOut refund;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final (String label, Color color) = switch (refund.status) {
      'AWAITING_APPROVAL' => (l10n.refundAwaiting, WWColors.warning),
      'PENDING' => (l10n.refundPending, WWColors.warning),
      'PROCESSED' => (l10n.refundProcessed, WWColors.brandGreen),
      'REJECTED' => (l10n.refundRejected, WWColors.textSecondary),
      _ => (l10n.refundFailed, WWColors.danger),
    };
    return WWCard(
      child: Row(
        children: [
          Icon(Icons.currency_rupee, color: color),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inr(refund.amountPaise), style: WWType.cardTitle),
                Text(istDateTime(context, refund.processedAt ?? refund.createdAt), style: WWType.caption),
              ],
            ),
          ),
          Text(
            label,
            style: WWType.caption.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// W-P4 Cancel: what comes back (from the server's preview), why, "Yes, cancel". Pops true once
/// cancelled.
class CancelSheet extends ConsumerStatefulWidget {
  const CancelSheet({super.key, required this.booking});

  final BookingDetailOut booking;

  @override
  ConsumerState<CancelSheet> createState() => _CancelSheetState();
}

class _CancelSheetState extends ConsumerState<CancelSheet> {
  final _more = TextEditingController();
  late Future<CancelPreviewOut> _preview;
  String _reason = 'PLANS_CHANGED';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _preview = _loadPreview();
  }

  Future<CancelPreviewOut> _loadPreview() =>
      ref.read(patientApiProvider).patientBookingCancelPreview(bookingId: widget.booking.id).then((r) => r.data!);

  @override
  void dispose() {
    _more.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    final more = _more.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container
          .read(patientApiProvider)
          .patientBookingCancel(
            bookingId: widget.booking.id,
            cancelIn: CancelIn(reason: more.isEmpty ? _reason : '$_reason: $more'),
          );
      bookingsChanged(container, memberId: widget.booking.member.id);
      container.invalidate(bookingDetailProvider(widget.booking.id));
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = patientErrorMessage(l10n, e);
      });
      if (toApiException(e).code == 'CANCEL_NOT_ALLOWED') {
        container.invalidate(bookingDetailProvider(widget.booking.id));
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
            Text(l10n.cancelTitle, style: WWType.screenTitle),
            const SizedBox(height: WWSpacing.md),
            FutureBuilder<CancelPreviewOut>(
              future: _preview,
              builder: (context, snap) {
                if (snap.hasError) {
                  return WWErrorState(
                    message: patientErrorMessage(l10n, snap.error!),
                    retryLabel: l10n.tryAgain,
                    onRetry: () => setState(() => _preview = _loadPreview()),
                  );
                }
                final p = snap.data;
                if (p == null) return const Padding(padding: EdgeInsets.all(WWSpacing.md), child: WWLoading());
                if (!p.allowed) return WWMessageBox(message: l10n.cancelNotAllowed, isError: true);
                return WWMessageBox(
                  key: const Key('cancel-refund'),
                  icon: Icons.info_outline,
                  message: p.refundPaise > 0
                      ? l10n.cancelRefund(inr(p.refundPaise), p.refundPercent)
                      : l10n.cancelNoRefund,
                );
              },
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.cancelReasonLabel),
            WWChoicePills<String>(
              choices: [
                WWChoice(key: const Key('reason-plans'), value: 'PLANS_CHANGED', label: l10n.cancelReasonPlans),
                WWChoice(key: const Key('reason-mistake'), value: 'BOOKED_BY_MISTAKE', label: l10n.cancelReasonMistake),
                WWChoice(key: const Key('reason-other'), value: 'OTHER', label: l10n.cancelReasonOther),
              ],
              selected: _reason,
              onSelected: (r) => setState(() => _reason = r),
            ),
            const SizedBox(height: WWSpacing.md),
            WWTextField(
              key: const Key('cancel-more'),
              controller: _more,
              label: l10n.cancelReasonHint,
              maxLines: 2,
              maxLength: 200,
            ),
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.sm),
              WWMessageBox(message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.md),
            FutureBuilder<CancelPreviewOut>(
              future: _preview,
              builder: (context, snap) => WWPrimaryButton(
                key: const Key('confirm-cancel'),
                label: l10n.confirmCancel,
                color: WWColors.danger,
                loading: _busy,
                onPressed: _busy || snap.data?.allowed != true ? null : _confirm,
              ),
            ),
            const SizedBox(height: WWSpacing.sm),
            TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(false), child: Text(l10n.keepBooking)),
          ],
        ),
      ),
    );
  }
}
