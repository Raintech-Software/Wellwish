import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import 'booking_flow.dart';
import 'date_strip.dart';

/// P30 Change date or time: the same date strip and times as booking (the booking's own place
/// is free for it), the doctor's time for hospital visits, "Confirm new time" (§6.12). Price and
/// fee stay as booked.
class RescheduleScreen extends ConsumerStatefulWidget {
  const RescheduleScreen({super.key, required this.bookingId});

  static const path = '/booking/:id/reschedule';
  static String pathFor(String id) => '/booking/$id/reschedule';

  final String bookingId;

  @override
  ConsumerState<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends ConsumerState<RescheduleScreen> {
  final _strip = ScrollController();
  DateTime? _date;
  DateTime? _pickup;
  DateTime? _appointment;
  bool _started = false;
  bool _submitted = false;
  bool _noPickupFits = false;
  bool _busy = false;
  String? _error;
  BookingTimesOut? _lastTimes;

  @override
  void dispose() {
    _strip.dispose();
    super.dispose();
  }

  /// Starts on the booking's own day and times.
  void _start(BookingDetailOut b) {
    if (_started) return;
    _started = true;
    final day = toIst(b.pickupAt);
    _date = DateTime(day.year, day.month, day.day);
    _pickup = b.pickupAt;
    _appointment = b.appointmentAt;
  }

  /// Another day: the doctor's time moves with it (same clock time), the pickup is chosen again.
  void _chooseDate(DateTime day) {
    setState(() {
      if (_appointment != null) {
        final at = toIst(_appointment!);
        _appointment = fromIst(day, at.hour, at.minute);
      }
      _date = day;
      _pickup = null;
      _noPickupFits = false;
      _error = null;
    });
  }

  /// The day's times arrived after a date change: suggest the pickup before the appointment.
  void _suggestPickup(BookingTimesOut times) {
    if (_pickup != null || _appointment == null || !sameDay(times.date, _date!)) return;
    final latest = _appointment!.subtract(Duration(minutes: times.travelBufferMin));
    final candidates = times.times.where((t) => !t.isAfter(latest)).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _pickup != null) return;
      setState(() {
        _noPickupFits = candidates.isEmpty;
        if (candidates.isNotEmpty) _pickup = candidates.last;
      });
    });
  }

  Future<void> _pickAppointment(BookingTimesOut times) async {
    final current = _appointment == null ? null : toIst(_appointment!);
    final picked = await showTimePicker(
      context: context,
      initialTime: current == null
          ? const TimeOfDay(hour: 10, minute: 0)
          : TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (picked == null || !mounted) return;
    final appointment = fromIst(times.date, picked.hour, picked.minute);
    final latest = appointment.subtract(Duration(minutes: times.travelBufferMin));
    final candidates = times.times.where((t) => !t.isAfter(latest)).toList();
    setState(() {
      _appointment = appointment;
      _noPickupFits = candidates.isEmpty;
      // No free time fits before the appointment: no pickup until the patient picks one.
      _pickup = candidates.isEmpty ? null : candidates.last;
      _error = null;
    });
  }

  String? _problem(WWLocalizations l10n, BookingDetailOut b) {
    if (_pickup == null) return _noPickupFits ? l10n.appointmentTooEarly : l10n.timeRequired;
    if (_appointment != null) {
      if (_appointment!.isBefore(_pickup!)) return l10n.appointmentAfterPickup;
      if (_appointment!.difference(_pickup!) > Duration(minutes: b.service.durationMin)) return l10n.pickupTooEarly;
    }
    return null;
  }

  bool _changed(BookingDetailOut b) =>
      _pickup != null &&
      (!_pickup!.isAtSameMomentAs(b.pickupAt) ||
          (_appointment == null) != (b.appointmentAt == null) ||
          (_appointment != null && !_appointment!.isAtSameMomentAs(b.appointmentAt!)));

  Future<void> _confirm(BookingDetailOut b) async {
    final l10n = WWLocalizations.of(context);
    setState(() => _submitted = true);
    if (_busy || _problem(l10n, b) != null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container
          .read(patientApiProvider)
          .patientBookingReschedule(
            bookingId: widget.bookingId,
            rescheduleIn: RescheduleIn(pickupAt: _pickup!.toUtc(), appointmentAt: _appointment?.toUtc()),
          );
      bookingsChanged(container, memberId: b.member.id);
      container.invalidate(bookingDetailProvider(widget.bookingId));
      if (!mounted) return;
      showSnack(context, l10n.timeChangedSnack);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      final error = toApiException(e);
      setState(() {
        _busy = false;
        _error = patientErrorMessage(l10n, e);
        if (error.code == 'TIME_NOT_AVAILABLE') _pickup = null;
      });
      if (error.code == 'TIME_NOT_AVAILABLE') ref.invalidate(rescheduleTimesProvider);
      if (error.code == 'RESCHEDULE_NOT_ALLOWED') ref.invalidate(bookingDetailProvider(widget.bookingId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final detail = ref.watch(bookingDetailProvider(widget.bookingId));
    final b = detail.value;
    if (b == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.changeTime)),
        body: detail.hasError
            ? WWErrorState(
                message: patientErrorMessage(l10n, detail.error!),
                retryLabel: l10n.tryAgain,
                onRetry: () => ref.invalidate(bookingDetailProvider(widget.bookingId)),
              )
            : const WWLoading(),
      );
    }
    _start(b);
    final timesKey = (widget.bookingId, _date);
    final times = ref.watch(rescheduleTimesProvider(timesKey));
    if (times.hasValue && !times.isLoading) {
      _lastTimes = times.value;
      _suggestPickup(times.value!);
    }
    final strip = times.value ?? _lastTimes;
    final isHospital = b.service.visitType == 'HOSPITAL_VISIT';
    final problem = _submitted ? _problem(l10n, b) : null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.changeTime)),
      body: PopScope(
        canPop: !_busy,
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            WWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookedServiceName(context, b.service), style: WWType.cardTitle),
                  Text(l10n.currentTime(istDateTime(context, b.pickupAt)), style: WWType.body),
                  Text(l10n.reschedulesLeft(b.reschedulesLeft), style: WWType.caption),
                ],
              ),
            ),
            if (!b.canReschedule) ...[
              const SizedBox(height: WWSpacing.md),
              WWMessageBox(message: rescheduleProblemText(l10n, b.rescheduleProblem), isError: true),
            ] else ...[
              const SizedBox(height: WWSpacing.lg),
              WWFieldLabel(l10n.dateLabel),
              if (strip == null)
                times.hasError
                    ? WWErrorState(
                        message: patientErrorMessage(l10n, times.error!),
                        retryLabel: l10n.tryAgain,
                        onRetry: () => ref.invalidate(rescheduleTimesProvider(timesKey)),
                      )
                    : const Padding(padding: EdgeInsets.all(WWSpacing.lg), child: WWLoading())
              else ...[
                DateStrip(times: strip, controller: _strip, onChosen: _chooseDate),
                if (times.hasError && !times.isLoading)
                  WWErrorState(
                    message: patientErrorMessage(l10n, times.error!),
                    retryLabel: l10n.tryAgain,
                    onRetry: () => ref.invalidate(rescheduleTimesProvider(timesKey)),
                  )
                else if (!times.hasValue || times.isLoading)
                  const Padding(padding: EdgeInsets.all(WWSpacing.lg), child: WWLoading())
                else ...[
                  if (isHospital) ...[
                    const SizedBox(height: WWSpacing.lg),
                    WWFieldLabel(l10n.appointmentTimeLabel),
                    WWDateField(
                      key: const Key('appointment-time'),
                      icon: Icons.schedule,
                      text: _appointment == null ? null : istTime(context, _appointment!),
                      placeholder: l10n.appointmentTimeHint,
                      onTap: () => _pickAppointment(times.value!),
                    ),
                    if (_appointment != null) ...[
                      const SizedBox(height: WWSpacing.xs),
                      Text(
                        _noPickupFits ? l10n.appointmentTooEarly : l10n.pickupSuggested(times.value!.travelBufferMin),
                        style: WWType.caption.copyWith(color: _noPickupFits ? WWColors.danger : null),
                      ),
                    ],
                  ],
                  const SizedBox(height: WWSpacing.lg),
                  WWFieldLabel(timeLabelFor(l10n, b.service.visitType)),
                  TimePills(
                    times: times.value!,
                    selected: _pickup,
                    onSelected: (at) => setState(() {
                      _pickup = at;
                      _noPickupFits = false;
                      _error = null;
                    }),
                  ),
                ],
              ],
              if (b.status == 'OFFERED' || b.status == 'ACCEPTED') ...[
                const SizedBox(height: WWSpacing.md),
                WWMessageBox(message: l10n.partnerWillReconfirm, icon: Icons.info_outline),
              ],
              if (problem != null || _error != null) ...[
                const SizedBox(height: WWSpacing.md),
                WWMessageBox(message: _error ?? problem!, isError: true),
              ],
              const SizedBox(height: WWSpacing.lg),
              WWPrimaryButton(
                key: const Key('confirm-new-time'),
                label: l10n.confirmNewTime,
                loading: _busy,
                onPressed: _busy || !_changed(b) ? null : () => _confirm(b),
              ),
            ],
            const SizedBox(height: WWSpacing.lg),
          ],
        ),
      ),
    );
  }
}

/// Why the time can't be changed in the app (the booking's `rescheduleProblem`).
String rescheduleProblemText(WWLocalizations l10n, String? problem) => switch (problem) {
  'TOO_LATE' => l10n.rescheduleTooLate,
  'LIMIT' => l10n.rescheduleLimit,
  _ => l10n.rescheduleNotAllowed,
};
