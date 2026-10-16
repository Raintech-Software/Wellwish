import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../common/patient_ui.dart';
import '../family/family_controller.dart';
import 'booking_flow.dart';
import 'documents_step_screen.dart';

/// P13 Address: the chosen member's saved addresses first, then the account's other ones, and
/// "Add address" with the map pin. Addresses outside a service area can't be booked (§6.18).
class AddressStepScreen extends ConsumerStatefulWidget {
  const AddressStepScreen({super.key});

  static const path = '/book-step/address';

  @override
  ConsumerState<AddressStepScreen> createState() => _AddressStepScreenState();
}

class _AddressStepScreenState extends ConsumerState<AddressStepScreen> {
  bool _submitted = false;

  Future<void> _add(MemberOut member) async {
    final added = await context.push<AddressOut>('/member/${member.id}/address/new', extra: member);
    if (!mounted) return;
    ref.invalidate(allAddressesProvider);
    if (added != null && added.inServiceArea) ref.read(bookingDraftProvider.notifier).setAddress(added);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final memberId = draft.memberId;
    if (memberId == null) return const Scaffold(body: WWLoading());
    final detail = ref.watch(memberDetailProvider(memberId));
    final all = ref.watch(allAddressesProvider);
    final help = switch (draft.visitType) {
      'HOSPITAL_VISIT' => l10n.pickupAddressHelp,
      'HOME_VISIT' => l10n.homeVisitAddressHelp,
      _ => l10n.errandAddressHelp,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addressStepTitle)),
      body: detail.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(memberDetailProvider(memberId)),
        ),
        data: (d) {
          final own = d.addresses;
          final ownIds = own.map((a) => a.id).toSet();
          final others = (all.value ?? const <AddressOut>[]).where((a) => !ownIds.contains(a.id)).toList();
          final title = d.member.isSelf ? l10n.yourAddresses : l10n.addressesOfName(d.member.fullName.split(' ').first);
          // One usable address of theirs: chosen already.
          final usable = own.where((a) => a.inServiceArea).toList();
          if (draft.address == null && usable.length == 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && ref.read(bookingDraftProvider).address == null) {
                ref.read(bookingDraftProvider.notifier).setAddress(usable.single);
              }
            });
          }
          return ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              Text(help, style: WWType.caption),
              const SizedBox(height: WWSpacing.md),
              Text(title, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              if (own.isEmpty) WWCard(child: Text(l10n.noAddresses, style: WWType.caption)),
              for (final a in own) _AddressChoice(address: a, selected: draft.address?.id == a.id),
              const SizedBox(height: WWSpacing.sm),
              WWSecondaryButton(
                key: const Key('booking-add-address'),
                label: l10n.addAddress,
                icon: const Icon(Icons.add_location_alt_outlined, color: WWColors.primary),
                onPressed: () => _add(d.member),
              ),
              if (others.isNotEmpty) ...[
                const SizedBox(height: WWSpacing.lg),
                Text(l10n.otherAddresses, style: WWType.section),
                const SizedBox(height: WWSpacing.sm),
                for (final a in others) _AddressChoice(address: a, selected: draft.address?.id == a.id),
              ],
              if (_submitted && draft.address == null) ...[
                const SizedBox(height: WWSpacing.md),
                WWMessageBox(message: l10n.addressRequiredToBook, isError: true),
              ],
              const SizedBox(height: WWSpacing.lg),
              WWPrimaryButton(
                key: const Key('address-next'),
                label: l10n.nextLabel,
                onPressed: () {
                  setState(() => _submitted = true);
                  if (ref.read(bookingDraftProvider).address != null) {
                    pushStep(context, DocumentsStepScreen.path);
                  }
                },
              ),
              const SizedBox(height: WWSpacing.lg),
            ],
          );
        },
      ),
    );
  }
}

class _AddressChoice extends ConsumerWidget {
  const _AddressChoice({required this.address, required this.selected});

  final AddressOut address;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final ok = address.inServiceArea;
    return Padding(
      padding: const EdgeInsets.only(bottom: WWSpacing.sm),
      child: WWCard(
        key: Key('address-${address.id}'),
        onTap: ok ? () => ref.read(bookingDraftProvider.notifier).setAddress(address) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: ok ? WWColors.primary : WWColors.border,
            ),
            const SizedBox(width: WWSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.label, style: WWType.cardTitle),
                  Text(address.line1, style: WWType.caption),
                  if (address.landmark.isNotEmpty) Text(address.landmark, style: WWType.caption),
                  if (!ok) ...[
                    const SizedBox(height: WWSpacing.xs),
                    Text(l10n.outsideServiceArea, style: WWType.caption.copyWith(color: WWColors.warning)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
