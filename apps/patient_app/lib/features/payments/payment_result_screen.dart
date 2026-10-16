import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../booking/booking_flow.dart';
import '../booking/booking_screen.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import '../home/home_screen.dart';
import 'pay_flow.dart';

/// P16 Payment result: confirmed, still being confirmed (asks the server again every few
/// seconds), not paid with "Pay" again while the payment time lasts, or paid too late (refunded).
class PaymentResultScreen extends ConsumerStatefulWidget {
  const PaymentResultScreen({super.key, required this.bookingId, required this.result});

  static const path = '/booking/:id/payment';
  static String pathFor(String id) => '/booking/$id/payment';

  final String bookingId;
  final PayResult result;

  @override
  ConsumerState<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends ConsumerState<PaymentResultScreen> {
  static const _checkEvery = Duration(seconds: 3);
  static const _checks = 20; // about a minute

  late PayOutcome _outcome = widget.result.outcome;
  Timer? _timer;
  int _checked = 0;
  bool _checking = false;
  bool _paying = false;

  @override
  void initState() {
    super.initState();
    if (_outcome == PayOutcome.processing) _next();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// One check at a time: the next is planned when the last one has answered.
  void _next() {
    _checking = true;
    _timer = Timer(_checkEvery, _check);
  }

  Future<void> _check() async {
    _checked++;
    try {
      final booking = await ref.refresh(bookingDetailProvider(widget.bookingId).future);
      if (!mounted) return;
      final outcome = outcomeOf(booking.status);
      if (outcome != PayOutcome.processing) {
        bookingsChanged(ProviderScope.containerOf(context, listen: false));
        setState(() {
          _checking = false;
          _outcome = outcome;
        });
        return;
      }
    } catch (_) {
      // offline for a moment: keep checking
    }
    if (!mounted) return;
    if (_checked >= _checks) {
      setState(() => _checking = false); // shows "we'll send you a message"
    } else {
      _next();
    }
  }

  Future<void> _tryAgain(String description) async {
    if (_paying) return;
    final l10n = WWLocalizations.of(context);
    setState(() => _paying = true);
    try {
      await payAndShowResult(context, bookingId: widget.bookingId, description: description);
    } catch (e) {
      if (mounted) showSnack(context, patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final booking = ref.watch(bookingDetailProvider(widget.bookingId)).value;
    final stillChecking = _outcome == PayOutcome.processing && _checking;
    final (IconData icon, Color color, String title, String body) = switch (_outcome) {
      PayOutcome.confirmed => (
        Icons.check_circle,
        WWColors.brandGreen,
        l10n.paymentConfirmedTitle,
        // a partner may accept while this screen is open: say so (PHASES 9.11)
        booking == null || const ['PENDING_PAYMENT', 'NEW', 'OFFERED'].contains(booking.status)
            ? l10n.paymentConfirmedBody
            : bookingStatusLabel(l10n, booking.status),
      ),
      PayOutcome.processing => (
        Icons.hourglass_top,
        WWColors.warning,
        l10n.paymentProcessingTitle,
        stillChecking ? l10n.paymentProcessingBody : l10n.paymentTakingLong,
      ),
      PayOutcome.cancelled || PayOutcome.failed => (
        Icons.error_outline,
        WWColors.danger,
        _outcome == PayOutcome.cancelled ? l10n.paymentCancelledTitle : l10n.paymentFailedTitle,
        booking?.payBy == null ? '' : l10n.paymentFailedBody(istTime(context, booking!.payBy!)),
      ),
      PayOutcome.notSetUp => (
        Icons.info_outline,
        WWColors.primary,
        l10n.bookingSavedTitle,
        l10n.bookingSavedBody(booking?.code ?? ''),
      ),
      PayOutcome.notPayable => (Icons.timer_off_outlined, WWColors.danger, l10n.paymentFailedTitle, l10n.errNotPayable),
      PayOutcome.notBooked => (
        Icons.currency_exchange,
        WWColors.warning,
        l10n.paymentNotBookedTitle,
        l10n.paymentNotBookedBody,
      ),
    };
    final canRetry =
        (_outcome == PayOutcome.failed || _outcome == PayOutcome.cancelled) &&
        booking != null &&
        booking.status == 'PENDING_PAYMENT' &&
        booking.paymentPending != true &&
        (booking.payBy?.isAfter(DateTime.now()) ?? false);
    return Scaffold(
      appBar: AppBar(title: Text(booking == null ? '' : l10n.bookingCode(booking.code))),
      body: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          const SizedBox(height: WWSpacing.xl),
          Icon(icon, color: color, size: 72, key: Key('pay-result-${_outcome.name}')),
          const SizedBox(height: WWSpacing.lg),
          Text(title, style: WWType.screenTitle, textAlign: TextAlign.center),
          const SizedBox(height: WWSpacing.sm),
          if (body.isNotEmpty) Text(body, style: WWType.body, textAlign: TextAlign.center),
          if (stillChecking) ...[
            const SizedBox(height: WWSpacing.lg),
            const Center(child: CircularProgressIndicator()),
          ],
          if (booking != null) ...[
            const SizedBox(height: WWSpacing.xl),
            WWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookedServiceName(context, booking.service), style: WWType.cardTitle),
                  Text('${booking.memberName} · ${istDateTime(context, booking.pickupAt)}', style: WWType.caption),
                  if (booking.paidPaise > 0) Text(l10n.paidAmount(inr(booking.paidPaise)), style: WWType.caption),
                ],
              ),
            ),
          ],
          const SizedBox(height: WWSpacing.xl),
          if (canRetry)
            WWPrimaryButton(
              key: const Key('pay-again'),
              label: l10n.payAmount(inr(booking.service.bookingFeePaise)),
              color: WWColors.brandGreen,
              loading: _paying,
              onPressed: _paying ? null : () => _tryAgain(bookedServiceName(context, booking.service)),
            ),
          const SizedBox(height: WWSpacing.md),
          WWSecondaryButton(
            key: const Key('view-booking'),
            label: l10n.viewBooking,
            onPressed: () => context.pushReplacement(BookingScreen.pathFor(widget.bookingId)),
          ),
          const SizedBox(height: WWSpacing.sm),
          TextButton(onPressed: () => context.go(HomeScreen.path), child: Text(l10n.backToHome)),
        ],
      ),
    );
  }
}
