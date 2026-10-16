import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import 'directory_providers.dart';
import 'doctor_screen.dart';
import 'hospital_screen.dart';
import 'hospitals_view.dart';

/// The Doctors tab: P08 doctor directory (mockup 4) and P06 nearby hospitals.
class DoctorsTab extends StatefulWidget {
  const DoctorsTab({super.key});

  static const path = '/doctors';

  @override
  State<DoctorsTab> createState() => _DoctorsTabState();
}

class _DoctorsTabState extends State<DoctorsTab> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDoctors)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: WWSpacing.screen),
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: 0, label: Text(l10n.tabDoctors), icon: const Icon(Icons.person_search_outlined)),
                ButtonSegment(
                  value: 1,
                  label: Text(l10n.tabHospitals),
                  icon: const Icon(Icons.local_hospital_outlined),
                ),
              ],
              selected: {_segment},
              onSelectionChanged: (s) => setState(() => _segment = s.first),
            ),
          ),
          Expanded(
            child: _segment == 0
                ? const DoctorsList()
                : HospitalsView(onOpen: (h) => context.push(HospitalScreen.pathFor(h.id))),
          ),
        ],
      ),
    );
  }
}

class DoctorsList extends ConsumerStatefulWidget {
  const DoctorsList({super.key});

  @override
  ConsumerState<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends ConsumerState<DoctorsList> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _q = '';
  String? _specialityId;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _q = text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final query = (q: _q, specialityId: _specialityId);
    final doctors = ref.watch(doctorsProvider(query));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(WWSpacing.screen, WWSpacing.sm, WWSpacing.screen, 0),
          child: WWSearchField(
            key: const Key('doctor-search'),
            controller: _search,
            hint: l10n.searchDoctorsHint,
            onChanged: _onSearch,
          ),
        ),
        SpecialityChips(selected: _specialityId, onSelected: (id) => setState(() => _specialityId = id)),
        Expanded(
          child: doctors.unwrapPrevious().when(
            loading: () => const WWLoading(),
            error: (e, _) => WWErrorState(
              message: patientErrorMessage(l10n, e),
              retryLabel: l10n.tryAgain,
              onRetry: () => ref.invalidate(doctorsProvider(query)),
            ),
            data: (page) => page.items.isEmpty
                ? WWEmptyState(
                    icon: Icons.person_search_outlined,
                    title: l10n.noDoctorsFound,
                    message: l10n.tryAnotherSearch,
                  )
                : RefreshIndicator(
                    onRefresh: () => ref.refresh(doctorsProvider(query).future),
                    child: ListView(
                      padding: const EdgeInsets.all(WWSpacing.screen),
                      children: [
                        for (final d in page.items) ...[DoctorCard(doctor: d), const SizedBox(height: WWSpacing.sm)],
                        if (page.hasMore)
                          TextButton(
                            onPressed: () async {
                              try {
                                await ref.read(doctorsProvider(query).notifier).loadMore();
                              } catch (e) {
                                if (context.mounted) showSnack(context, patientErrorMessage(l10n, e));
                              }
                            },
                            child: Text(l10n.loadMore),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// A doctor card as in mockup 4: photo, name, speciality, hospital, "View Profile".
class DoctorCard extends ConsumerWidget {
  const DoctorCard({super.key, required this.doctor, this.onTap});

  final PatientDoctorOut doctor;

  /// Default: open the doctor's profile.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final open = onTap ?? () => context.push(DoctorScreen.pathFor(doctor.id));
    return WWCard(
      key: Key('doctor-${doctor.id}'),
      onTap: open,
      child: Row(
        children: [
          WWAvatar(
            name: doctor.fullName,
            size: 56,
            image: doctor.photoUrl == null
                ? null
                : NetworkImage(fileUrl(ref.watch(appConfigProvider), doctor.photoUrl!)),
          ),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.fullName, style: WWType.cardTitle),
                Text(specialityName(context, doctor.speciality), style: WWType.caption),
                if (doctor.hospitals.isNotEmpty)
                  Text(
                    doctor.hospitals.map((h) => h.name).join(', '),
                    style: WWType.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: WWSpacing.xs),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.zero, // grows with the phone's text size
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: WWSpacing.md, vertical: 6),
                    textStyle: WWType.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                  onPressed: open,
                  child: Text(l10n.viewProfile),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: WWColors.textSecondary),
        ],
      ),
    );
  }
}
