import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../session/session_controller.dart';

/// Asks the system for location permission (W-P1: consent → location permission → Home).
/// Location is used to sort nearby hospitals (Phase 5). Saying no is fine.
typedef LocationPermissionRequest = Future<void> Function();

final locationPermissionProvider = Provider<LocationPermissionRequest>(
  (ref) => () async {
    try {
      await Geolocator.requestPermission();
    } catch (_) {
      // No location services on this device: the app works without them.
    }
  },
);

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  static const path = '/setup/location';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    void done() => ref.read(sessionProvider.notifier).locationStepDone();
    return Scaffold(
      backgroundColor: WWColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(WWSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(color: WWColors.tint, shape: BoxShape.circle),
                child: const Icon(Icons.location_on_outlined, size: 60, color: WWColors.primary),
              ),
              const SizedBox(height: WWSpacing.xl),
              Text(l10n.locationTitle, style: WWType.screenTitle, textAlign: TextAlign.center),
              const SizedBox(height: WWSpacing.sm),
              Text(l10n.locationBody, style: WWType.body, textAlign: TextAlign.center),
              const Spacer(),
              WWPrimaryButton(
                label: l10n.allowLocation,
                onPressed: () async {
                  await ref.read(locationPermissionProvider)();
                  done();
                },
              ),
              const SizedBox(height: WWSpacing.sm),
              WWSecondaryButton(label: l10n.notNow, onPressed: done),
            ],
          ),
        ),
      ),
    );
  }
}
