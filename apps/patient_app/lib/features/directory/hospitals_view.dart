import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../addresses/address_form_screen.dart' show mapTilesEnabledProvider;
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import 'directory_providers.dart';

/// P06 Nearby hospitals: search, speciality filter, list or map (§6.7). Used by the Doctors
/// tab and by the booking flow's hospital picker ([near] = the member's address there).
class HospitalsView extends ConsumerStatefulWidget {
  const HospitalsView({super.key, required this.onOpen, this.near, this.trailing});

  final ValueChanged<PatientHospitalOut> onOpen;

  /// Search around this point instead of the phone's location.
  final (double, double)? near;

  /// Extra widget under the list (the picker's "My hospital isn't listed").
  final Widget? trailing;

  @override
  ConsumerState<HospitalsView> createState() => _HospitalsViewState();
}

class _HospitalsViewState extends ConsumerState<HospitalsView> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _q = '';
  String? _specialityId;
  bool _map = false;

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
    final position = widget.near != null ? AsyncData<(double, double)?>(widget.near) : ref.watch(phonePositionProvider);
    if (position.isLoading) return const WWLoading();
    final near = position.value;
    final query = (near: near, q: _q, specialityId: _specialityId);
    final hospitals = ref.watch(nearbyHospitalsProvider(query));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(WWSpacing.screen, WWSpacing.sm, WWSpacing.screen, 0),
          child: Row(
            children: [
              Expanded(
                child: WWSearchField(
                  key: const Key('hospital-search'),
                  controller: _search,
                  hint: l10n.searchHospitalsHint,
                  onChanged: _onSearch,
                ),
              ),
              const SizedBox(width: WWSpacing.sm),
              IconButton.filledTonal(
                key: const Key('hospital-map-toggle'),
                tooltip: _map ? l10n.showList : l10n.showMap,
                icon: Icon(_map ? Icons.view_list_outlined : Icons.map_outlined),
                onPressed: () => setState(() => _map = !_map),
              ),
            ],
          ),
        ),
        SpecialityChips(selected: _specialityId, onSelected: (id) => setState(() => _specialityId = id)),
        Expanded(
          child: hospitals.unwrapPrevious().when(
            loading: () => const WWLoading(),
            error: (e, _) => WWErrorState(
              message: patientErrorMessage(l10n, e),
              retryLabel: l10n.tryAgain,
              onRetry: () => ref.invalidate(nearbyHospitalsProvider(query)),
            ),
            data: (data) => _map
                ? _HospitalsMap(hospitals: data.items, near: near, onOpen: widget.onOpen)
                : _HospitalsList(
                    data: data,
                    hasLocation: near != null,
                    onOpen: widget.onOpen,
                    trailing: widget.trailing,
                    onRefresh: () async {
                      if (widget.near == null) ref.invalidate(phonePositionProvider);
                      ref.invalidate(nearbyHospitalsProvider(query));
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _HospitalsList extends StatelessWidget {
  const _HospitalsList({
    required this.data,
    required this.hasLocation,
    required this.onOpen,
    required this.onRefresh,
    this.trailing,
  });

  final NearbyHospitalsOut data;
  final bool hasLocation;
  final ValueChanged<PatientHospitalOut> onOpen;
  final Future<void> Function() onRefresh;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final radius = data.radiusKm;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          Text(radius != null ? l10n.hospitalsWithin(radius.round()) : l10n.hospitalsAll, style: WWType.section),
          if (!hasLocation) ...[
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.hospitalsNoLocation, style: WWType.caption),
          ],
          const SizedBox(height: WWSpacing.md),
          if (data.items.isEmpty)
            WWEmptyState(
              icon: Icons.local_hospital_outlined,
              title: l10n.noHospitalsFound,
              message: l10n.tryAnotherSearch,
            ),
          for (final h in data.items) ...[
            HospitalCard(hospital: h, onTap: () => onOpen(h)),
            const SizedBox(height: WWSpacing.sm),
          ],
          ?trailing,
        ],
      ),
    );
  }
}

/// A hospital in a list: type, address, distance, doctors.
class HospitalCard extends StatelessWidget {
  const HospitalCard({super.key, required this.hospital, required this.onTap});

  final PatientHospitalOut hospital;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final distance = hospital.distanceKm;
    return WWCard(
      key: Key('hospital-${hospital.id}'),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: WWColors.tint, borderRadius: BorderRadius.circular(WWRadius.card)),
            child: const Icon(Icons.local_hospital_outlined, color: WWColors.primary),
          ),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hospital.name, style: WWType.cardTitle),
                const SizedBox(height: 2),
                Text(
                  [hospitalTypeLabel(l10n, hospital.type), if (hospital.city.isNotEmpty) hospital.city].join(' · '),
                  style: WWType.caption,
                ),
                const SizedBox(height: 2),
                Text(hospital.address, style: WWType.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: WWSpacing.xs),
                Text(
                  [
                    if (distance != null) l10n.kmAway(distance.toStringAsFixed(1)),
                    l10n.doctorCount(hospital.doctorCount),
                  ].join(' · '),
                  style: WWType.caption.copyWith(color: WWColors.brandGreen, fontWeight: FontWeight.w500),
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

LatLng latLngOf(String lat, String lng) => LatLng(double.parse(lat), double.parse(lng));

/// Bhubaneswar: where the map opens when nothing else is known.
const defaultMapCentre = LatLng(20.2961, 85.8245);

class _HospitalsMap extends ConsumerWidget {
  const _HospitalsMap({required this.hospitals, required this.near, required this.onOpen});

  final List<PatientHospitalOut> hospitals;
  final (double, double)? near;
  final ValueChanged<PatientHospitalOut> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final centre = near != null
        ? LatLng(near!.$1, near!.$2)
        : hospitals.isNotEmpty
        ? latLngOf(hospitals.first.lat, hospitals.first.lng)
        : defaultMapCentre;
    return FlutterMap(
      options: MapOptions(initialCenter: centre, initialZoom: 12),
      children: [
        if (ref.watch(mapTilesEnabledProvider))
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'in.wellwish.patient',
          ),
        MarkerLayer(
          markers: [
            if (near != null)
              Marker(
                point: LatLng(near!.$1, near!.$2),
                child: const Icon(Icons.my_location, color: WWColors.brandBlue),
              ),
            for (final h in hospitals)
              Marker(
                point: latLngOf(h.lat, h.lng),
                width: 44,
                height: 44,
                child: Tooltip(
                  message: h.name,
                  child: GestureDetector(
                    key: Key('hospital-pin-${h.id}'),
                    onTap: () => onOpen(h),
                    child: const Icon(Icons.location_on, color: WWColors.danger, size: 40),
                  ),
                ),
              ),
          ],
        ),
        RichAttributionWidget(attributions: [TextSourceAttribution(l10n.mapAttribution)]),
      ],
    );
  }
}

/// "All" + every speciality, one line that scrolls sideways (mockup 4 filter).
class SpecialityChips extends ConsumerWidget {
  const SpecialityChips({super.key, required this.selected, required this.onSelected});

  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final specialities = ref.watch(specialitiesProvider).value ?? const <SpecialityOut>[];
    final chips = [
      (id: null as String?, label: l10n.allSpecialities),
      for (final s in specialities.where((s) => (s.doctorCount ?? 0) > 0 || s.id == selected))
        (id: s.id as String?, label: specialityName(context, s)),
    ];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: WWSpacing.screen, vertical: WWSpacing.sm),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: WWSpacing.sm),
        itemBuilder: (context, i) => ChoiceChip(
          label: Text(chips[i].label),
          selected: chips[i].id == selected,
          onSelected: (_) => onSelected(chips[i].id),
        ),
      ),
    );
  }
}
