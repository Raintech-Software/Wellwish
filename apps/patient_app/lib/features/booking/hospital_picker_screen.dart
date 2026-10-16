import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../directory/hospitals_view.dart';
import '../family/family_controller.dart';
import 'booking_flow.dart';

/// Choosing the hospital in the booking flow: nearby the member's saved address (else the
/// phone's location), with "My hospital isn't listed" at the end (§6.7).
class HospitalPickerScreen extends ConsumerWidget {
  const HospitalPickerScreen({super.key});

  static const path = '/book-step/hospital';

  /// What the screen returns when the patient's hospital isn't in the list.
  static const notListed = 'not-listed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final memberId = ref.watch(bookingDraftProvider.select((d) => d.memberId));
    final detail = memberId == null ? null : ref.watch(memberDetailProvider(memberId));
    final address = detail?.value?.addresses.firstOrNull;
    final waiting = detail != null && detail.isLoading;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chooseHospital)),
      body: waiting
          ? const WWLoading()
          : HospitalsView(
              near: address == null ? null : (double.parse(address.lat), double.parse(address.lng)),
              onOpen: (h) => context.pop(h),
            ),
      // Always there: in the map view and when the list can't load too (§6.7).
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(WWSpacing.screen, WWSpacing.sm, WWSpacing.screen, WWSpacing.sm),
          child: WWSecondaryButton(
            key: const Key('hospital-not-listed'),
            label: l10n.hospitalNotListed,
            icon: const Icon(Icons.edit_outlined, color: WWColors.primary),
            onPressed: () => context.pop(notListed),
          ),
        ),
      ),
    );
  }
}
