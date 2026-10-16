import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../addresses/address_form_screen.dart' show mapTilesEnabledProvider;
import '../booking/booking_flow.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import 'directory_providers.dart';
import 'doctors_screen.dart';
import 'hospitals_view.dart';

/// P07 Hospital detail: address, map, OPD hours, departments, doctors, and "Book a companion to
/// this hospital".
class HospitalScreen extends ConsumerWidget {
  const HospitalScreen({super.key, required this.hospitalId});

  static const path = '/hospital/:id';
  static String pathFor(String id) => '/hospital/$id';

  final String hospitalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final detail = ref.watch(hospitalDetailProvider(hospitalId));
    return Scaffold(
      appBar: AppBar(title: Text(detail.value?.name ?? '')),
      body: detail.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(hospitalDetailProvider(hospitalId)),
        ),
        data: (h) => ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Text(h.name, style: WWType.screenTitle),
            const SizedBox(height: 2),
            Text(hospitalTypeLabel(l10n, h.type), style: WWType.caption),
            const SizedBox(height: WWSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(WWRadius.card),
              child: SizedBox(
                height: 160,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: latLngOf(h.lat, h.lng),
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                  ),
                  children: [
                    if (ref.watch(mapTilesEnabledProvider))
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'in.wellwish.patient',
                      ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: latLngOf(h.lat, h.lng),
                          width: 44,
                          height: 44,
                          child: const Icon(Icons.location_on, color: WWColors.danger, size: 40),
                        ),
                      ],
                    ),
                    RichAttributionWidget(attributions: [TextSourceAttribution(l10n.mapAttribution)]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: WWSpacing.md),
            WWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Line(icon: Icons.place_outlined, text: h.address),
                  if (h.opdHours.isNotEmpty) _Line(icon: Icons.schedule, title: l10n.opdHours, text: h.opdHours),
                  if (h.phone.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: _Line(icon: Icons.call_outlined, text: h.phone),
                        ),
                        TextButton.icon(
                          onPressed: () => launchUrl(Uri(scheme: 'tel', path: h.phone)),
                          icon: const Icon(Icons.call),
                          label: Text(l10n.callLabel),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (h.departments.isNotEmpty) ...[
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.departments, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              Wrap(
                spacing: WWSpacing.sm,
                runSpacing: WWSpacing.sm,
                children: [for (final d in h.departments) Chip(label: Text(d))],
              ),
            ],
            const SizedBox(height: WWSpacing.lg),
            Text(l10n.doctorsHere, style: WWType.section),
            const SizedBox(height: WWSpacing.sm),
            if (h.doctors.isEmpty) WWCard(child: Text(l10n.doctorCount(0), style: WWType.caption)),
            for (final d in h.doctors) ...[DoctorCard(doctor: d), const SizedBox(height: WWSpacing.sm)],
            const SizedBox(height: WWSpacing.lg),
            WWPrimaryButton(
              key: const Key('book-at-hospital'),
              label: l10n.bookCompanionHere,
              onPressed: () => startBooking(
                context,
                partnerType: 'COMPANION',
                hospital: BookingPlace(id: h.id, name: h.name, lat: h.lat, lng: h.lng),
              ),
            ),
            const SizedBox(height: WWSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text, this.title});

  final IconData icon;
  final String text;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: WWColors.primary),
          const SizedBox(width: WWSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title!, style: WWType.caption),
                Text(text, style: WWType.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
