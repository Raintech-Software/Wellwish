import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import '../family/family_controller.dart';
import '../payments/pay_flow.dart';
import 'address_step_screen.dart';
import 'booking_flow.dart';
import 'documents_step_screen.dart';
import 'visit_details_screen.dart';

/// P15 Review and pay: what was chosen, total / pay now / pay the partner after, the
/// cancellation rule and "Pay ₹X" (§6.6, §6.12). "Pay" saves the booking (Pending payment), then
/// opens Razorpay Checkout; a retry after a failed payment finds the same booking (same key).
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  static const path = '/book-step/review';

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // One key for this screen: a double tap or a retry can't book twice (§6.9).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(bookingDraftProvider.notifier).ensureKey();
    });
  }

  Future<void> _book() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    final controller = ref.read(bookingDraftProvider.notifier);
    final key = controller.ensureKey();
    final d = ref.read(bookingDraftProvider);
    final saved = ref.read(memberDocumentsProvider(d.memberId!)).value;
    final documentIds = saved == null
        ? d.documentIds.toList()
        : saved.map((doc) => doc.id).where(d.documentIds.contains).toList();
    setState(() {
      _busy = true;
      _error = null;
    });
    final container = ProviderScope.containerOf(context, listen: false);
    final router = GoRouter.of(context);
    final description = serviceName(context, d.service!);
    final BookingDetailOut booking;
    try {
      booking =
          (await container
                  .read(patientApiProvider)
                  .patientBook(
                    idempotencyKey: key,
                    bookingIn: BookingIn(
                      serviceId: d.service!.id,
                      memberId: d.memberId!,
                      addressId: d.address!.id,
                      pickupAt: d.pickupAt!.toUtc(),
                      appointmentAt: d.appointmentAt?.toUtc(),
                      hospitalId: d.notListed ? null : d.hospital?.id,
                      hospitalText: d.notListed ? d.hospitalText.trim() : '',
                      doctorId: d.notListed ? null : d.doctor?.id,
                      documentIds: documentIds,
                      notes: d.notes.trim(),
                    ),
                  ))
              .data!;
      bookingsChanged(container, memberId: d.memberId);
    } catch (e) {
      if (!mounted) return;
      final error = toApiException(e);
      final message = error.code == 'IDEMPOTENCY_KEY_REUSED' ? l10n.errBookingChanged : patientErrorMessage(l10n, e);
      // Send the patient back to the step that needs a change (`details.field` says which).
      final step = switch ((error.code, error.details['field'])) {
        ('TIME_NOT_AVAILABLE', _) => VisitDetailsScreen.path,
        ('OUTSIDE_SERVICE_AREA', _) => AddressStepScreen.path,
        ('PRESCRIPTION_REQUIRED', _) => DocumentsStepScreen.path,
        ('INVALID_BOOKING', 'addressId') => AddressStepScreen.path,
        ('INVALID_BOOKING', 'documentIds') => DocumentsStepScreen.path,
        ('INVALID_BOOKING', _) => VisitDetailsScreen.path,
        ('NOT_FOUND', _) => VisitDetailsScreen.path, // something was removed meanwhile
        _ => null,
      };
      setState(() {
        _busy = false;
        _error = message;
      });
      if (step == null) return;
      showSnack(context, message);
      popToStep(router, step);
      // Change the draft after leaving Review (it shows a spinner without a time or address).
      if (error.code == 'TIME_NOT_AVAILABLE') {
        controller.setPickup(null);
        container.invalidate(bookingTimesProvider);
      }
      if (error.code == 'OUTSIDE_SERVICE_AREA') {
        controller.setAddress(null);
        // The server now stores the address as outside: show it so.
        container.invalidate(memberDetailProvider(d.memberId!));
        container.invalidate(allAddressesProvider);
      }
      if (error.code == 'NOT_FOUND') {
        container.invalidate(membersProvider);
        container.invalidate(memberDocumentsProvider(d.memberId!));
      }
      return;
    }
    if (!mounted) return;
    try {
      // Ends on the payment result above Home (also when payment isn't set up yet).
      await payAndShowResult(context, bookingId: booking.id, description: description);
      controller.reset();
    } catch (e) {
      // The booking is saved: "Pay" again finds it and opens Checkout again.
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = patientErrorMessage(l10n, e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final d = ref.watch(bookingDraftProvider);
    final service = d.service;
    if (service == null || d.memberId == null || d.address == null || d.pickupAt == null) {
      return const Scaffold(body: SizedBox.shrink()); // the route redirects to the missing step
    }
    final members = ref.watch(membersProvider).value ?? const <MemberOut>[];
    final member = members.where((m) => m.id == d.memberId).firstOrNull;
    final refund = ref.watch(publicConfigProvider).value?.refundPercent; // shown once loaded
    final isNurse = service.partnerType == 'NURSE';
    final place = d.notListed ? d.hospitalText : d.hospital?.name;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewTitle)),
      body: PopScope(
        canPop: !_busy,
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            WWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReviewLine(label: l10n.serviceLabel, value: serviceName(context, service)),
                  ReviewLine(
                    label: l10n.forWhom,
                    value: member == null
                        ? ''
                        : member.isSelf
                        ? '${member.fullName} (${l10n.relationSelf})'
                        : '${member.fullName} (${relationLabel(l10n, member.relation)})',
                  ),
                  ReviewLine(
                    label: l10n.whenLabel,
                    value: [
                      '${istDay(context, d.pickupAt!)} · ${timeLabelFor(l10n, d.visitType)} ${istTime(context, d.pickupAt!)}',
                      if (d.appointmentAt != null) l10n.appointmentAt(istTime(context, d.appointmentAt!)),
                    ].join('\n'),
                  ),
                  ReviewLine(
                    label: l10n.whereLabel,
                    value: [
                      if (place != null && place.isNotEmpty) place,
                      if (d.doctor != null && !d.notListed) d.doctor!.name,
                      '${d.address!.label}: ${d.address!.line1}',
                    ].join('\n'),
                  ),
                  ReviewLine(label: l10n.documentsLabel, value: l10n.documentsCount(d.documentIds.length)),
                  if (d.notes.trim().isNotEmpty) ReviewLine(label: l10n.notesTitle, value: d.notes.trim()),
                ],
              ),
            ),
            const SizedBox(height: WWSpacing.md),
            PriceBox(
              total: service.pricePaise,
              fee: service.bookingFeePaise,
              balance: service.balancePaise,
              isNurse: isNurse,
            ),
            const SizedBox(height: WWSpacing.md),
            if (refund != null) WWMessageBox(message: l10n.cancellationRule(refund), icon: Icons.info_outline),
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.md),
              WWMessageBox(message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.lg),
            WWPrimaryButton(
              key: const Key('pay-button'),
              label: l10n.payAmount(inr(service.bookingFeePaise)),
              loading: _busy,
              color: WWColors.brandGreen,
              onPressed: _busy ? null : _book,
            ),
            const SizedBox(height: WWSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class ReviewLine extends StatelessWidget {
  const ReviewLine({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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

/// Total · pay now (the booking fee, online) · pay the partner after the visit (§6.6).
class PriceBox extends StatelessWidget {
  const PriceBox({
    super.key,
    required this.total,
    required this.fee,
    required this.balance,
    required this.isNurse,
    this.toPay = true,
  });

  final int total;
  final int fee;
  final int balance;
  final bool isNurse;

  /// The fee is still to pay ("Pay now"); otherwise it is shown as the booking fee.
  final bool toPay;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    Widget row(String label, int paise, {bool strong = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: strong ? WWType.cardTitle : WWType.body)),
          Text(inr(paise), style: (strong ? WWType.cardTitle : WWType.body).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
    return WWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(l10n.priceTotal, total),
          const Divider(),
          row(toPay ? l10n.payNowFee : l10n.bookingFeeOnline, fee, strong: true),
          if (balance > 0) row(isNurse ? l10n.payNurseAfter : l10n.payCompanionAfter, balance),
          const SizedBox(height: WWSpacing.xs),
          // the booking fee may be the whole price (admin's choice per service)
          if (balance == 0) Text(l10n.paidInFullNote, key: const Key('paid-in-full'), style: WWType.caption),
          Text(l10n.extrasNote, style: WWType.caption),
        ],
      ),
    );
  }
}
