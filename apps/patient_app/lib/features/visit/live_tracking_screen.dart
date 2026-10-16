import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../addresses/address_form_screen.dart';
import '../booking/booking_flow.dart';
import '../booking/booking_screen.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import '../directory/hospitals_view.dart';
import 'visit_widgets.dart';

/// "About 12 min away", or in hours from 60 minutes ("About 2 h 5 min away").
String etaText(WWLocalizations l10n, int minutes) =>
    minutes < 60 ? l10n.etaMinutes(minutes) : l10n.etaHours(minutes ~/ 60, minutes % 60);

/// `booking.location` messages from the live socket; the session controller adds them here.
final bookingLocationsProvider = Provider<StreamController<LiveLocationOut>>((ref) {
  final controller = StreamController<LiveLocationOut>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});

/// The partner's latest point and ETA for one booking: loaded once, then moved by the live
/// socket. Asks again every 30 s in case a socket message was missed.
class LiveLocationController extends AsyncNotifier<LiveLocationOut> {
  LiveLocationController(this.bookingId);

  final String bookingId;

  @override
  Future<LiveLocationOut> build() async {
    final sub = ref.watch(bookingLocationsProvider).stream.where((l) => l.bookingId == bookingId).listen(_moved);
    final timer = Timer.periodic(const Duration(seconds: 30), (_) => _refresh());
    ref.onDispose(() {
      sub.cancel();
      timer.cancel();
    });
    return _fetch();
  }

  Future<LiveLocationOut> _fetch() async =>
      (await ref.read(patientApiProvider).patientBookingLive(bookingId: bookingId)).data!;

  void _moved(LiveLocationOut point) {
    final current = state.value?.at;
    if (current != null && point.at != null && point.at!.isBefore(current)) return; // an older one
    state = AsyncData(point);
  }

  Future<void> _refresh() async {
    try {
      final point = await _fetch();
      if (ref.mounted) _moved(point);
    } catch (_) {
      // keep showing the last point
    }
  }
}

final liveLocationProvider = AsyncNotifierProvider.autoDispose.family<LiveLocationController, LiveLocationOut, String>(
  LiveLocationController.new,
);

/// P19 Live tracking (§6.11): the map with the partner and the home, the ETA, the current step,
/// the visit code, call, share the trip and SOS. Stops at "Completed".
class LiveTrackingScreen extends ConsumerStatefulWidget {
  const LiveTrackingScreen({super.key, required this.bookingId});

  static const path = '/booking/:id/live';
  static String pathFor(String id) => '/booking/$id/live';

  final String bookingId;

  @override
  ConsumerState<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends ConsumerState<LiveTrackingScreen> {
  final _map = MapController();
  bool _ready = false;

  /// The map follows the partner until the user moves it.
  bool _follow = true;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final detail = ref.watch(bookingDetailProvider(widget.bookingId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.liveTitle)),
      body: detail.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(bookingDetailProvider(widget.bookingId)),
        ),
        data: (b) {
          if (b.status != 'IN_PROGRESS' && b.status != 'ACCEPTED') return _Ended(booking: b);
          ref.listen(liveLocationProvider(widget.bookingId), (_, next) {
            final p = next.value;
            if (_follow && _ready && p?.lat != null && p?.lng != null) {
              _map.move(latLngOf(p!.lat!, p.lng!), _map.camera.zoom);
            }
          });
          final location = ref.watch(liveLocationProvider(widget.bookingId)).value;
          return Column(
            children: [
              Expanded(flex: 5, child: _buildMap(b, location)),
              Expanded(
                flex: 4,
                child: _Panel(booking: b, location: location),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(BookingDetailOut b, LiveLocationOut? location) {
    final l10n = WWLocalizations.of(context);
    final home = b.address.lat.isNotEmpty ? latLngOf(b.address.lat, b.address.lng) : null;
    final partner = location?.lat != null && location?.lng != null ? latLngOf(location!.lat!, location.lng!) : null;
    return FlutterMap(
      key: const Key('live-map'),
      mapController: _map,
      options: MapOptions(
        initialCenter: partner ?? home ?? defaultMapCentre,
        initialZoom: 15,
        onMapReady: () => _ready = true,
        onPositionChanged: (_, hasGesture) {
          if (hasGesture) _follow = false;
        },
      ),
      children: [
        if (ref.watch(mapTilesEnabledProvider))
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'in.wellwish.patient',
          ),
        MarkerLayer(
          markers: [
            if (home != null)
              Marker(
                point: home,
                width: 40,
                height: 40,
                child: const Icon(Icons.home, color: WWColors.brandNavy, size: 34),
              ),
            if (partner != null)
              Marker(
                point: partner,
                width: 48,
                height: 48,
                child: Container(
                  key: const Key('partner-marker'),
                  decoration: BoxDecoration(
                    color: WWColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: WWColors.primary, width: 3),
                  ),
                  child: const Icon(Icons.person, color: WWColors.primary),
                ),
              ),
          ],
        ),
        if (partner != null)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(WWSpacing.md),
              child: FloatingActionButton.small(
                heroTag: null,
                backgroundColor: WWColors.surface,
                onPressed: () {
                  _follow = true;
                  _map.move(partner, _map.camera.zoom);
                },
                child: const Icon(Icons.my_location, color: WWColors.primary),
              ),
            ),
          ),
        RichAttributionWidget(attributions: [TextSourceAttribution(l10n.mapAttribution)]),
      ],
    );
  }
}

class _Panel extends ConsumerStatefulWidget {
  const _Panel({required this.booking, required this.location});

  final BookingDetailOut booking;
  final LiveLocationOut? location;

  @override
  ConsumerState<_Panel> createState() => _PanelState();
}

class _PanelState extends ConsumerState<_Panel> {
  bool _sharing = false;

  Future<void> _share() async {
    if (_sharing) return;
    final l10n = WWLocalizations.of(context);
    setState(() => _sharing = true);
    try {
      final link = (await ref.read(patientApiProvider).patientShareLink(bookingId: widget.booking.id)).data!;
      await Clipboard.setData(ClipboardData(text: link.url));
      if (mounted) showSnack(context, l10n.linkCopied);
    } catch (e) {
      if (mounted) showSnack(context, patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final b = widget.booking;
    final loc = widget.location;
    final partner = b.partner;
    final name = partner?.fullName.split(' ').first ?? '';
    final step = b.visit?.currentStep ?? '';
    return ListView(
      padding: const EdgeInsets.all(WWSpacing.screen),
      children: [
        Text(
          step.isEmpty ? bookingStatusLabel(l10n, b.status) : l10n.nowStep(l10n.stepName(step)),
          key: const Key('live-step'),
          style: WWType.section,
        ),
        const SizedBox(height: WWSpacing.xs),
        if (loc?.lat == null)
          Text(l10n.waitingForLocation(name), style: WWType.caption)
        else
          Text(
            [
              if (loc!.etaMin != null) etaText(l10n, loc.etaMin!),
              if (loc.at != null) l10n.updatedAt(istTime(context, loc.at!)),
            ].join(' · '),
            key: const Key('live-eta'),
            style: WWType.body,
          ),
        if (b.jobOtp != null) ...[
          const SizedBox(height: WWSpacing.md),
          VisitCodeCard(code: b.jobOtp!, partnerName: name),
        ],
        const SizedBox(height: WWSpacing.md),
        Row(
          children: [
            if (partner != null && partner.phone.isNotEmpty) ...[
              Expanded(
                child: WWSecondaryButton(
                  key: const Key('live-call'),
                  icon: const Icon(Icons.call_outlined),
                  label: l10n.callName(name),
                  onPressed: () => launchUrl(Uri(scheme: 'tel', path: partner.phone.replaceAll(' ', ''))),
                ),
              ),
              const SizedBox(width: WWSpacing.sm),
            ],
            Expanded(
              child: WWSecondaryButton(
                key: const Key('share-trip'),
                icon: const Icon(Icons.share_outlined),
                label: l10n.shareTrip,
                onPressed: _sharing ? null : _share,
              ),
            ),
          ],
        ),
        if (b.status == 'IN_PROGRESS') ...[
          const SizedBox(height: WWSpacing.md),
          OutlinedButton.icon(
            key: const Key('sos'),
            style: OutlinedButton.styleFrom(
              foregroundColor: WWColors.danger,
              side: const BorderSide(color: WWColors.danger),
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.sos),
            label: Text(l10n.sos),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => SosSheet(bookingId: b.id),
            ),
          ),
        ],
      ],
    );
  }
}

/// The visit ended (or was cancelled): no more live location.
class _Ended extends StatelessWidget {
  const _Ended({required this.booking});

  final BookingDetailOut booking;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return WWEmptyState(
      key: const Key('live-ended'),
      icon: booking.status == 'COMPLETED' ? Icons.check_circle_outline : Icons.location_off_outlined,
      title: booking.status == 'COMPLETED' ? l10n.visitCompleted : bookingStatusLabel(l10n, booking.status),
      message: l10n.liveEnded,
      actionLabel: l10n.backToBooking,
      onAction: () => context.canPop() ? context.pop() : context.go(BookingScreen.pathFor(booking.id)),
    );
  }
}

/// SOS (§6.15): the admins' alarm and an SMS to the emergency contacts, with the phone's
/// location; and 112 / 108.
class SosSheet extends ConsumerStatefulWidget {
  const SosSheet({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<SosSheet> createState() => _SosSheetState();
}

class _SosSheetState extends ConsumerState<SosSheet> {
  bool _busy = false;
  bool _sent = false;
  String? _error;

  Future<void> _send() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final here = await ref
          .read(locationServiceProvider)
          .current()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => (position: null, problem: LocationProblem.unavailable, mock: false),
          );
      final position = here.position;
      await ref
          .read(patientApiProvider)
          .patientSos(
            bookingId: widget.bookingId,
            sosIn: SosIn(
              lat: position?.$1.toStringAsFixed(6),
              lng: position?.$2.toStringAsFixed(6),
              mock: here.mock, // a fake one still goes, flagged for WellWish
            ),
          );
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) setState(() => _error = patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return SingleChildScrollView(
      // large text (9.8)
      child: Padding(
        padding: const EdgeInsets.fromLTRB(WWSpacing.screen, 0, WWSpacing.screen, WWSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.sosTitle, style: WWType.screenTitle.copyWith(color: WWColors.danger)),
            const SizedBox(height: WWSpacing.sm),
            Text(l10n.sosBody, style: WWType.body),
            const SizedBox(height: WWSpacing.lg),
            if (_sent)
              WWMessageBox(key: const Key('sos-sent'), message: l10n.sosSent, icon: Icons.check_circle_outline)
            else
              WWPrimaryButton(
                key: const Key('send-sos'),
                label: l10n.sendSos,
                color: WWColors.danger,
                loading: _busy,
                onPressed: _busy ? null : _send,
              ),
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.sm),
              WWMessageBox(message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.md),
            WWSecondaryButton(
              icon: const Icon(Icons.local_police_outlined),
              label: l10n.call112,
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: '112')),
            ),
            const SizedBox(height: WWSpacing.sm),
            WWSecondaryButton(
              icon: const Icon(Icons.emergency_outlined),
              label: l10n.call108,
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: '108')),
            ),
          ],
        ),
      ),
    );
  }
}
