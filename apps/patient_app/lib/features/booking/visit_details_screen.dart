import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import '../directory/directory_providers.dart';
import '../family/family_controller.dart';
import '../family/member_form_screen.dart';
import 'address_step_screen.dart';
import 'booking_flow.dart';
import 'date_strip.dart';
import 'hospital_picker_screen.dart';

/// P12 Visit details (mockup 5 style): for whom, hospital and doctor (or typed in), the date
/// strip, the appointment and pickup times, notes (§6.17, §6.18).
class VisitDetailsScreen extends ConsumerStatefulWidget {
  const VisitDetailsScreen({super.key});

  static const path = '/book-step/details';

  @override
  ConsumerState<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends ConsumerState<VisitDetailsScreen> {
  late final TextEditingController _hospitalText;
  late final TextEditingController _notes;
  final _strip = ScrollController();
  bool _submitted = false;

  /// The appointment has no free pickup time before it (shown until something changes).
  bool _noPickupFits = false;

  /// The last loaded dates: the strip stays on screen while another date's times load.
  BookingTimesOut? _lastTimes;

  BookingDraftController get _draft => ref.read(bookingDraftProvider.notifier);

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingDraftProvider);
    _hospitalText = TextEditingController(text: draft.hospitalText);
    _notes = TextEditingController(text: draft.notes);
  }

  @override
  void dispose() {
    _hospitalText.dispose();
    _notes.dispose();
    _strip.dispose();
    super.dispose();
  }

  Future<void> _addMember() async {
    final added = await context.push<MemberOut>(MemberFormScreen.addPath);
    if (added != null && mounted) _draft.setMember(added.id);
  }

  Future<void> _pickHospital() async {
    final picked = await context.push<Object>(HospitalPickerScreen.path);
    if (!mounted) return;
    if (picked is PatientHospitalOut) {
      _draft.setHospital(BookingPlace(id: picked.id, name: picked.name, lat: picked.lat, lng: picked.lng));
    } else if (picked == HospitalPickerScreen.notListed) {
      _draft.setNotListed(true);
    }
  }

  /// Another day (the day already shown keeps the chosen time).
  void _chooseDate(DateTime day) {
    setState(() => _noPickupFits = false);
    _draft.setDate(day);
  }

  /// Hospital visits: the doctor's time. Pickup = the latest free time at least the travel
  /// buffer before it (the patient can change it, §6.17). None fits: the pickup stays as it was.
  Future<void> _pickAppointment(BookingTimesOut times) async {
    final draft = ref.read(bookingDraftProvider);
    final current = draft.appointmentAt == null ? null : toIst(draft.appointmentAt!);
    final picked = await showTimePicker(
      context: context,
      initialTime: current == null
          ? const TimeOfDay(hour: 10, minute: 0)
          : TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (picked == null || !mounted) return;
    final appointment = fromIst(times.date, picked.hour, picked.minute);
    _draft.setAppointment(appointment);
    final latest = appointment.subtract(Duration(minutes: times.travelBufferMin));
    final candidates = times.times.where((t) => !t.isAfter(latest)).toList();
    setState(() => _noPickupFits = candidates.isEmpty);
    if (candidates.isNotEmpty) _draft.setPickup(candidates.last);
  }

  void _next() {
    setState(() => _submitted = true);
    _draft
      ..setHospitalText(_hospitalText.text.trim())
      ..setNotes(_notes.text.trim());
    if (_problem(WWLocalizations.of(context), ref.read(bookingDraftProvider)) != null) return;
    pushStep(context, AddressStepScreen.path);
  }

  String? _problem(WWLocalizations l10n, BookingDraft d) {
    if (d.memberId == null) return l10n.chooseMemberRequired;
    if (d.needsHospital && d.hospital == null && (!d.notListed || d.hospitalText.trim().isEmpty)) {
      return l10n.hospitalRequired;
    }
    if (d.pickupAt == null) return _noPickupFits ? l10n.appointmentTooEarly : l10n.timeRequired;
    final appointment = d.appointmentAt;
    if (appointment != null) {
      if (appointment.isBefore(d.pickupAt!)) return l10n.appointmentAfterPickup;
      // The partner's time must cover the appointment (the server checks it too).
      final duration = Duration(minutes: d.service?.durationMin ?? 0);
      if (appointment.difference(d.pickupAt!) > duration) return l10n.pickupTooEarly;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final service = draft.service!; // the route redirects without a service
    final members = ref.watch(membersProvider);
    final memberList = members.unwrapPrevious().value ?? const <MemberOut>[];
    // Yourself unless someone else was chosen (or the booking started from their profile).
    if (draft.memberId == null && memberList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ref.read(bookingDraftProvider).memberId == null) _draft.setMember(memberList.first.id);
      });
    }
    final timesKey = (service.id, draft.date);
    final times = ref.watch(bookingTimesProvider(timesKey));
    if (times.hasValue && !times.isLoading) _lastTimes = times.value;
    final strip = times.value ?? _lastTimes;
    final problem = _submitted
        ? _problem(l10n, draft.copyWith(hospitalText: _hospitalText.text, key: draft.key))
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.visitDetailsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          WWCard(
            child: Row(
              children: [
                Expanded(child: Text(serviceName(context, service), style: WWType.cardTitle)),
                Text(inr(service.pricePaise), style: WWType.cardTitle.copyWith(color: WWColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: WWSpacing.lg),
          WWFieldLabel(l10n.forWhom),
          if (members.hasError && memberList.isEmpty)
            WWErrorState(
              message: patientErrorMessage(l10n, members.error!),
              retryLabel: l10n.tryAgain,
              onRetry: () => ref.read(membersProvider.notifier).reload(),
            )
          else
            Wrap(
              spacing: WWSpacing.sm,
              runSpacing: WWSpacing.sm,
              children: [
                for (final m in memberList)
                  ChoiceChip(
                    key: Key('for-${m.id}'),
                    label: Text(m.isSelf ? l10n.relationSelf : m.fullName.split(' ').first),
                    selected: m.id == draft.memberId,
                    onSelected: (_) => _draft.setMember(m.id),
                  ),
                ActionChip(
                  key: const Key('for-add'),
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(l10n.addMember),
                  onPressed: _addMember,
                ),
              ],
            ),
          if (draft.hasPlace) ...[
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(draft.needsHospital ? l10n.hospitalLabel : l10n.hospitalOptionalLabel),
            if (!draft.notListed)
              WWCard(
                key: const Key('choose-hospital'),
                padding: EdgeInsets.zero,
                // the row is the one button (a second tap area around it had no name for TalkBack)
                child: WWListTile(
                  icon: Icons.local_hospital_outlined,
                  title: draft.hospital?.name ?? l10n.chooseHospital,
                  subtitle: draft.hospital == null ? null : l10n.change,
                  onTap: _pickHospital,
                ),
              )
            else ...[
              WWTextField(
                key: const Key('hospital-text'),
                controller: _hospitalText,
                label: l10n.hospitalTextLabel,
                hint: l10n.hospitalTextHint,
                maxLength: 200,
                onChanged: _draft.setHospitalText,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: _pickHospital, child: Text(l10n.chooseHospital)),
              ),
            ],
            if (draft.needsHospital && draft.hospital != null) ...[
              const SizedBox(height: WWSpacing.md),
              WWFieldLabel(l10n.doctorLabel),
              _DoctorChoice(hospitalId: draft.hospital!.id, selected: draft.doctor, onChanged: _draft.setDoctor),
            ],
          ],
          const SizedBox(height: WWSpacing.lg),
          WWFieldLabel(l10n.dateLabel),
          if (strip == null)
            times.hasError
                ? WWErrorState(
                    message: patientErrorMessage(l10n, times.error!),
                    retryLabel: l10n.tryAgain,
                    onRetry: () => ref.invalidate(bookingTimesProvider(timesKey)),
                  )
                : const Padding(padding: EdgeInsets.all(WWSpacing.lg), child: WWLoading())
          else ...[
            DateStrip(times: strip, controller: _strip, onChosen: _chooseDate),
            if (times.hasError && !times.isLoading)
              WWErrorState(
                message: patientErrorMessage(l10n, times.error!),
                retryLabel: l10n.tryAgain,
                onRetry: () => ref.invalidate(bookingTimesProvider(timesKey)),
              )
            else if (!times.hasValue || times.isLoading)
              const Padding(padding: EdgeInsets.all(WWSpacing.lg), child: WWLoading())
            else
              _TimesSection(
                times: times.value!,
                draft: draft,
                noPickupFits: _noPickupFits,
                onAppointment: () => _pickAppointment(times.value!),
                onPickup: (at) {
                  setState(() => _noPickupFits = false);
                  _draft.setPickup(at);
                },
              ),
          ],
          const SizedBox(height: WWSpacing.lg),
          WWTextField(
            key: const Key('booking-notes'),
            controller: _notes,
            label: l10n.notesLabel,
            hint: l10n.notesHint,
            maxLines: 3,
            maxLength: 500,
            onChanged: _draft.setNotes,
          ),
          if (problem != null) ...[const SizedBox(height: WWSpacing.sm), WWMessageBox(message: problem, isError: true)],
          const SizedBox(height: WWSpacing.lg),
          WWPrimaryButton(key: const Key('details-next'), label: l10n.nextLabel, onPressed: _next),
          const SizedBox(height: WWSpacing.lg),
        ],
      ),
    );
  }
}

class _TimesSection extends StatelessWidget {
  const _TimesSection({
    required this.times,
    required this.draft,
    required this.noPickupFits,
    required this.onAppointment,
    required this.onPickup,
  });

  final BookingTimesOut times;
  final BookingDraft draft;
  final bool noPickupFits;
  final VoidCallback onAppointment;
  final ValueChanged<DateTime> onPickup;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (draft.needsHospital) ...[
          const SizedBox(height: WWSpacing.lg),
          WWFieldLabel(l10n.appointmentTimeLabel),
          WWDateField(
            key: const Key('appointment-time'),
            icon: Icons.schedule,
            text: draft.appointmentAt == null ? null : istTime(context, draft.appointmentAt!),
            placeholder: l10n.appointmentTimeHint,
            onTap: onAppointment,
          ),
          if (draft.appointmentAt != null) ...[
            const SizedBox(height: WWSpacing.xs),
            Text(
              noPickupFits ? l10n.appointmentTooEarly : l10n.pickupSuggested(times.travelBufferMin),
              style: WWType.caption.copyWith(color: noPickupFits ? WWColors.danger : null),
            ),
          ],
        ],
        const SizedBox(height: WWSpacing.lg),
        WWFieldLabel(timeLabelFor(l10n, draft.visitType)),
        TimePills(times: times, selected: draft.pickupAt, onSelected: onPickup),
      ],
    );
  }
}

/// The hospital's doctors, or "Not sure".
class _DoctorChoice extends ConsumerWidget {
  const _DoctorChoice({required this.hospitalId, required this.selected, required this.onChanged});

  final String hospitalId;
  final BookingPlace? selected;
  final ValueChanged<BookingPlace?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final doctors = ref.watch(hospitalDetailProvider(hospitalId)).value?.doctors ?? const <PatientDoctorOut>[];
    final ids = doctors.map((d) => d.id).toSet();
    // A new key when the hospital, the choice or the list changes: the field shows it afresh.
    return KeyedSubtree(
      key: ValueKey('doctors-$hospitalId-${selected?.id}-${doctors.length}'),
      child: DropdownButtonFormField<String?>(
        key: const Key('doctor-choice'),
        initialValue: ids.contains(selected?.id) ? selected!.id : null,
        isExpanded: true,
        style: WWType.body,
        items: [
          DropdownMenuItem<String?>(value: null, child: Text(l10n.doctorNotSure)),
          for (final d in doctors)
            DropdownMenuItem<String?>(
              value: d.id,
              child: Text('${d.fullName} · ${specialityName(context, d.speciality)}', overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (id) {
          final doctor = doctors.where((d) => d.id == id).firstOrNull;
          onChanged(doctor == null ? null : placeOfDoctor(doctor));
        },
      ),
    );
  }
}
