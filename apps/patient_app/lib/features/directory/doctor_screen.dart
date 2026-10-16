import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../booking/booking_flow.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import 'directory_providers.dart';
import 'hospital_screen.dart';

/// P09 Doctor profile: photo, speciality, hospitals, OPD days, and "Book a companion for this
/// doctor". Doctors can't be booked themselves (§6.7).
class DoctorScreen extends ConsumerWidget {
  const DoctorScreen({super.key, required this.doctorId});

  static const path = '/doctor/:id';
  static String pathFor(String id) => '/doctor/$id';

  final String doctorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final detail = ref.watch(doctorDetailProvider(doctorId));
    return Scaffold(
      appBar: AppBar(title: Text(detail.value?.fullName ?? '')),
      body: detail.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(doctorDetailProvider(doctorId)),
        ),
        data: (d) => ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Center(
              child: WWAvatar(
                name: d.fullName,
                size: 96,
                image: d.photoUrl == null ? null : NetworkImage(fileUrl(ref.watch(appConfigProvider), d.photoUrl!)),
              ),
            ),
            const SizedBox(height: WWSpacing.md),
            Text(d.fullName, style: WWType.screenTitle, textAlign: TextAlign.center),
            Text(specialityName(context, d.speciality), style: WWType.caption, textAlign: TextAlign.center),
            const SizedBox(height: WWSpacing.lg),
            WWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (d.qualifications.isNotEmpty) _Field(title: l10n.qualifications, text: d.qualifications),
                  if (d.opdInfo.isNotEmpty) _Field(title: l10n.opdDays, text: d.opdInfo),
                  if (d.languages.isNotEmpty)
                    _Field(title: l10n.doctorSpeaks, text: d.languages.map((x) => spokenLanguage(l10n, x)).join(', ')),
                ],
              ),
            ),
            if (d.hospitals.isNotEmpty) ...[
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.doctorHospitals, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              for (final h in d.hospitals)
                WWCard(
                  padding: EdgeInsets.zero,
                  child: WWListTile(
                    icon: Icons.local_hospital_outlined,
                    title: h.name,
                    onTap: () => context.push(HospitalScreen.pathFor(h.id)),
                  ),
                ),
            ],
            const SizedBox(height: WWSpacing.xl),
            if (d.hospitals.isNotEmpty)
              WWPrimaryButton(
                key: const Key('book-for-doctor'),
                label: l10n.bookCompanionForDoctor,
                onPressed: () => startBooking(
                  context,
                  partnerType: 'COMPANION',
                  hospital: BookingPlace(id: d.hospitals.first.id, name: d.hospitals.first.name),
                  doctor: placeOfDoctor(d),
                ),
              ),
            const SizedBox(height: WWSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: WWType.caption),
          Text(text, style: WWType.body),
        ],
      ),
    );
  }
}
