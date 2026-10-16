import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/patient_ui.dart';
import '../family/family_controller.dart';

/// Whether the map loads its tiles. OpenStreetMap until the Google Maps key arrives
/// (ARCHITECTURE v2.11 §3.2); its free tile server is for light use only (development and
/// testing). Tests turn it off. The layer itself is built fresh on every visit: a TileLayer
/// closes its downloader when the screen closes, so a kept one shows a blank map next time.
final mapTilesEnabledProvider = Provider<bool>((ref) => true);

/// What the edit route carries: whose address, and the address.
typedef AddressEditArgs = ({MemberOut member, AddressOut address});

/// Where the map starts when there's no address yet: Bhubaneswar.
const _defaultCenter = LatLng(20.2961, 85.8245);

/// P24 Add / edit an address for a family member: move the map so the pin sits on the house
/// (or "use my current location"), then the address in words.
class AddressFormScreen extends ConsumerStatefulWidget {
  const AddressFormScreen({super.key, required this.member, this.address});

  static String addPathFor(String memberId) => '/member/$memberId/address/new';
  static String editPathFor(String addressId) => '/address/$addressId/edit';

  final MemberOut member;

  /// The address being edited; null = a new one.
  final AddressOut? address;

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _map = MapController();
  final _label = TextEditingController();
  final _line1 = TextEditingController();
  final _landmark = TextEditingController();
  final _notes = TextEditingController();
  late LatLng _pin;

  /// A new address must be placed by hand (moving the map) or by "use my current location":
  /// the starting point is just the middle of Bhubaneswar.
  late bool _pinPlaced = widget.address != null;
  bool _locating = false;
  bool _saving = false;
  bool _submitted = false;
  String? _error;
  String? _locationError;

  bool get _isEdit => widget.address != null;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _pin = a == null ? _defaultCenter : LatLng(double.parse(a.lat), double.parse(a.lng));
    if (a != null) {
      _label.text = a.label;
      _line1.text = a.line1;
      _landmark.text = a.landmark;
      _notes.text = a.notes;
    }
  }

  @override
  void dispose() {
    _map.dispose();
    for (final c in [_label, _line1, _landmark, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    final l10n = WWLocalizations.of(context);
    setState(() {
      _locating = true;
      _locationError = null;
    });
    final result = await ref.read(locationServiceProvider).current();
    if (!mounted) return;
    setState(() {
      _locating = false;
      final position = result.position;
      if (position == null) {
        _locationError = switch (result.problem) {
          LocationProblem.denied => l10n.locationDenied,
          LocationProblem.off => l10n.locationOff,
          _ => l10n.somethingWentWrong,
        };
      } else {
        _pin = LatLng(position.$1, position.$2);
        _pinPlaced = true;
        _map.move(_pin, 17);
      }
    });
  }

  bool get _valid => _pinPlaced && _label.text.trim().isNotEmpty && _line1.text.trim().length >= 5;

  Future<void> _save() async {
    final l10n = WWLocalizations.of(context);
    setState(() => _submitted = true);
    if (!_valid) {
      showSnack(context, l10n.fixMarkedFields);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = AddressIn(
      memberId: widget.member.id,
      label: _label.text.trim(),
      line1: _line1.text.trim(),
      landmark: _landmark.text.trim(),
      notes: _notes.text.trim(),
      lat: _pin.latitude.toStringAsFixed(6),
      lng: _pin.longitude.toStringAsFixed(6),
    );
    // The container, not `ref`: it still works if the screen is closed during the save.
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      final api = container.read(patientApiProvider);
      final saved = _isEdit
          ? (await api.patientAddressUpdate(addressId: widget.address!.id, addressIn: body)).data!
          : (await api.patientAddressAdd(addressIn: body)).data!;
      container.invalidate(memberDetailProvider(widget.member.id));
      await container.read(membersProvider.notifier).reload();
      if (!mounted) return;
      if (!saved.inServiceArea) showSnack(context, l10n.savedOutsideArea);
      // The booking flow picks the new address straight away.
      if (context.canPop()) context.pop(saved);
    } catch (e) {
      if (mounted) setState(() => _error = patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _remove() async {
    final l10n = WWLocalizations.of(context);
    final ok = await confirmDanger(context, title: l10n.remove, body: widget.address!.line1, action: l10n.remove);
    if (!ok || !mounted) return;
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container.read(patientApiProvider).patientAddressRemove(addressId: widget.address!.id);
      container.invalidate(memberDetailProvider(widget.member.id));
      await container.read(membersProvider.notifier).reload();
      if (mounted && context.canPop()) context.pop();
    } catch (e) {
      if (mounted) setState(() => _error = patientErrorMessage(l10n, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final showTiles = ref.watch(mapTilesEnabledProvider);
    final name = widget.member.isSelf ? l10n.relationSelf : widget.member.fullName;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editAddressTitle : l10n.addAddressTitle),
        actions: [
          if (_isEdit)
            IconButton(
              key: const Key('address-remove'),
              tooltip: l10n.remove,
              icon: const Icon(Icons.delete_outline, color: WWColors.danger),
              onPressed: _remove,
            ),
        ],
      ),
      // The map sits above the scrolling form, so dragging the map never scrolls the page.
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(WWSpacing.screen, WWSpacing.sm, WWSpacing.screen, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.addressForName(name), style: WWType.caption),
                  const SizedBox(height: WWSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(WWRadius.card),
                    child: SizedBox(
                      height: 220,
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _map,
                            options: MapOptions(
                              initialCenter: _pin,
                              initialZoom: widget.address == null ? 13 : 17,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                              ),
                              onPositionChanged: (camera, hasGesture) {
                                _pin = camera.center;
                                if (hasGesture && !_pinPlaced) setState(() => _pinPlaced = true);
                              },
                            ),
                            children: [
                              if (showTiles)
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'in.wellwish.patient',
                                ),
                            ],
                          ),
                          // The pin stays in the middle; the map moves under it.
                          const IgnorePointer(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 36),
                                child: Icon(Icons.location_on, size: 44, color: WWColors.danger),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 6,
                            bottom: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              color: Colors.white70,
                              child: Text(l10n.mapAttribution, style: WWType.caption.copyWith(fontSize: 10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: WWSpacing.xs),
                  Text(
                    _submitted && !_pinPlaced ? l10n.pinRequired : l10n.mapHelp,
                    style: _submitted && !_pinPlaced ? WWType.caption.copyWith(color: WWColors.danger) : WWType.caption,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(WWSpacing.screen),
                children: [
                  WWSecondaryButton(
                    key: const Key('use-location'),
                    label: l10n.useCurrentLocation,
                    icon: _locating
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location, color: WWColors.primary),
                    onPressed: _locating ? null : _useCurrentLocation,
                  ),
                  if (_locationError != null) ...[
                    const SizedBox(height: WWSpacing.sm),
                    WWMessageBox(message: _locationError!, isError: true),
                  ],
                  const SizedBox(height: WWSpacing.lg),
                  WWFieldLabel(l10n.addressLabel),
                  WWTextField(
                    key: const Key('address-label'),
                    controller: _label,
                    hint: l10n.addressLabelHint,
                    maxLength: 40,
                    errorText: _submitted && _label.text.trim().isEmpty ? l10n.labelRequired : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: WWSpacing.sm),
                  Wrap(
                    spacing: WWSpacing.sm,
                    children: [
                      for (final quick in [l10n.labelHome, l10n.labelWork])
                        ActionChip(label: Text(quick), onPressed: () => setState(() => _label.text = quick)),
                    ],
                  ),
                  const SizedBox(height: WWSpacing.lg),
                  WWFieldLabel(l10n.addressLine),
                  WWTextField(
                    key: const Key('address-line'),
                    controller: _line1,
                    hint: l10n.homeAddressHint,
                    maxLines: 3,
                    maxLength: 200,
                    errorText: _submitted && _line1.text.trim().length < 5 ? l10n.addressLineRequired : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: WWSpacing.sm),
                  WWFieldLabel(l10n.landmark),
                  WWTextField(controller: _landmark, maxLength: 120),
                  const SizedBox(height: WWSpacing.sm),
                  WWFieldLabel(l10n.addressNotes),
                  WWTextField(controller: _notes, hint: l10n.addressNotesHint, maxLines: 2, maxLength: 300),
                  if (_error != null) ...[
                    const SizedBox(height: WWSpacing.lg),
                    WWMessageBox(message: _error!, isError: true),
                  ],
                  const SizedBox(height: WWSpacing.xl),
                  WWPrimaryButton(key: const Key('address-save'), label: l10n.save, loading: _saving, onPressed: _save),
                  const SizedBox(height: WWSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
