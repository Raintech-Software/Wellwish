import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../addresses/address_form_screen.dart';
import '../booking/booking_flow.dart';
import '../booking/booking_screen.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import '../documents/documents_controller.dart';
import '../documents/documents_screen.dart';
import 'family_controller.dart';
import 'member_form_screen.dart';

/// P29 Family member profile: details, health notes, addresses, documents, bookings,
/// "Book for them", edit and remove.
class MemberProfileScreen extends ConsumerWidget {
  const MemberProfileScreen({super.key, required this.memberId});

  static const path = '/member/:id';
  static String pathFor(String id) => '/member/$id';

  final String memberId;

  Future<void> _remove(BuildContext context, WidgetRef ref, MemberOut member) async {
    final l10n = WWLocalizations.of(context);
    final deleteDocuments = await showDialog<bool>(
      context: context,
      builder: (_) => _RemoveMemberDialog(member: member),
    );
    if (deleteDocuments == null || !context.mounted) return;
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container.read(membersProvider.notifier).remove(member.id, deleteDocuments: deleteDocuments);
      documentsChanged(container);
      if (context.mounted) context.pop();
    } catch (e) {
      if (context.mounted) showSnack(context, patientErrorMessage(l10n, e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final detail = ref.watch(memberDetailProvider(memberId));
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.value?.member.fullName ?? ''),
        actions: [
          if (detail.value != null)
            IconButton(
              key: const Key('member-edit'),
              tooltip: l10n.edit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(MemberFormScreen.editPathFor(memberId), extra: detail.value!.member),
            ),
        ],
      ),
      body: detail.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(memberDetailProvider(memberId)),
        ),
        data: (d) => RefreshIndicator(
          onRefresh: () => ref.refresh(memberDetailProvider(memberId).future),
          child: ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              _Header(member: d.member),
              const SizedBox(height: WWSpacing.lg),
              _DetailsCard(member: d.member),
              const SizedBox(height: WWSpacing.lg),
              _HealthCard(member: d.member),
              const SizedBox(height: WWSpacing.lg),
              _AddressesSection(member: d.member, addresses: d.addresses),
              const SizedBox(height: WWSpacing.lg),
              _DocumentsSection(member: d.member, documents: d.documents),
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.bookingsTitle, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              if (d.bookings.isEmpty) WWCard(child: Text(l10n.noBookingsYet, style: WWType.caption)),
              for (final b in d.bookings)
                WWCard(
                  padding: EdgeInsets.zero,
                  child: WWListTile(
                    icon: Icons.event_note_outlined,
                    title: bookedServiceName(context, b.service),
                    subtitle: '${istDateTime(context, b.pickupAt)} · ${bookingStatusLabel(l10n, b.status)}',
                    onTap: () => context.push(BookingScreen.pathFor(b.id)),
                  ),
                ),
              const SizedBox(height: WWSpacing.xl),
              WWPrimaryButton(
                key: const Key('member-book'),
                label: l10n.bookForName(d.member.isSelf ? l10n.relationSelf : d.member.fullName.split(' ').first),
                onPressed: () => _chooseBooking(context, d.member.id),
              ),
              if (!d.member.isSelf) ...[
                const SizedBox(height: WWSpacing.md),
                WWSecondaryButton(
                  key: const Key('member-remove'),
                  label: l10n.removeMember,
                  icon: const Icon(Icons.person_remove_outlined, color: WWColors.danger),
                  onPressed: () => _remove(context, ref, d.member),
                ),
              ],
              const SizedBox(height: WWSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Book for them": a companion or a nurse, with this member already chosen.
Future<void> _chooseBooking(BuildContext context, String memberId) async {
  final l10n = WWLocalizations.of(context);
  final type = await showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    builder: (context) => SingleChildScrollView(
      // large text (9.8)
      child: Padding(
        padding: const EdgeInsets.all(WWSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.chooseBookingType, style: WWType.section),
            const SizedBox(height: WWSpacing.md),
            WWListTile(
              key: const Key('book-type-companion'),
              icon: Icons.groups_2_outlined,
              iconColor: WWColors.brandGreen,
              title: l10n.tileBookCompanion,
              onTap: () => Navigator.pop(context, 'COMPANION'),
            ),
            WWListTile(
              key: const Key('book-type-nurse'),
              icon: Icons.vaccines_outlined,
              iconColor: WWColors.brandNavy,
              title: l10n.tileBookNurse,
              onTap: () => Navigator.pop(context, 'NURSE'),
            ),
          ],
        ),
      ),
    ),
  );
  if (type != null && context.mounted) startBooking(context, partnerType: type, memberId: memberId);
}

class _Header extends ConsumerWidget {
  const _Header({required this.member});

  final MemberOut member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    return WWCard(
      child: Row(
        children: [
          WWAvatar(
            name: member.fullName,
            size: 72,
            image: member.photoUrl == null ? null : NetworkImage(fileUrl(config, member.photoUrl!)),
          ),
          const SizedBox(width: WWSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.fullName, style: WWType.section),
                const SizedBox(height: 2),
                Text(memberSubtitle(l10n, member), style: WWType.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: WWType.caption)),
          Expanded(child: Text(value, style: WWType.body)),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.member});

  final MemberOut member;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final gender = switch (member.gender) {
      'FEMALE' => l10n.genderFemale,
      'MALE' => l10n.genderMale,
      'OTHER' => l10n.genderOther,
      _ => l10n.notGiven,
    };
    final emergency = member.emergencyName.isEmpty
        ? l10n.relationSelf
        : '${member.emergencyName} · ${formatIndianPhone(member.emergencyPhone)}';
    return WWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.detailsTitle, style: WWType.cardTitle),
          const SizedBox(height: WWSpacing.sm),
          _Row(l10n.dateOfBirth, member.dob == null ? l10n.notGiven : formatDate(context, member.dob!)),
          _Row(l10n.gender, gender),
          if (!member.isSelf)
            _Row(l10n.mobileLabel, member.phone.isEmpty ? l10n.notGiven : formatIndianPhone(member.phone)),
          _Row(l10n.language, memberLanguageLabel(l10n, member.language)),
          _Row(l10n.emergencyContact, emergency),
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  const _HealthCard({required this.member});

  final MemberOut member;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    String or(String v) => v.isEmpty ? l10n.notGiven : v;
    return WWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_border, color: WWColors.danger, size: 20),
              const SizedBox(width: WWSpacing.sm),
              Text(l10n.healthNotes, style: WWType.cardTitle),
            ],
          ),
          const SizedBox(height: WWSpacing.xs),
          Text(l10n.healthNotesHelp, style: WWType.caption),
          const SizedBox(height: WWSpacing.sm),
          _Row(l10n.conditions, or(member.conditions)),
          _Row(l10n.allergies, or(member.allergies)),
          _Row(l10n.mobility, mobilityLabel(l10n, member.mobility)),
          _Row(l10n.sensoryNotes, or(member.sensoryNotes)),
        ],
      ),
    );
  }
}

class _AddressesSection extends StatelessWidget {
  const _AddressesSection({required this.member, required this.addresses});

  final MemberOut member;
  final List<AddressOut> addresses;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.addressesTitle, style: WWType.section)),
            WWLinkButton(
              key: const Key('address-add'),
              label: l10n.addAddress,
              onPressed: () => context.push(AddressFormScreen.addPathFor(member.id), extra: member),
            ),
          ],
        ),
        const SizedBox(height: WWSpacing.sm),
        if (addresses.isEmpty) WWCard(child: Text(l10n.noAddresses, style: WWType.caption)),
        for (final address in addresses) ...[
          WWCard(
            key: Key('address-${address.id}'),
            onTap: () =>
                context.push(AddressFormScreen.editPathFor(address.id), extra: (member: member, address: address)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, color: WWColors.primary),
                const SizedBox(width: WWSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.label, style: WWType.cardTitle),
                      const SizedBox(height: 2),
                      Text(address.line1, style: WWType.caption),
                      if (!address.inServiceArea) ...[
                        const SizedBox(height: WWSpacing.xs),
                        WWBadge(
                          label: l10n.outsideServiceArea,
                          icon: Icons.warning_amber_rounded,
                          color: WWColors.warning,
                          background: WWColors.warningTint,
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: WWColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: WWSpacing.sm),
        ],
      ],
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({required this.member, required this.documents});

  final MemberOut member;
  final List<PatientDocumentOut> documents;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.stepDocuments, style: WWType.section)),
            WWLinkButton(
              label: l10n.uploadDocument,
              onPressed: () => showUploadDocumentSheet(context, memberId: member.id),
            ),
          ],
        ),
        const SizedBox(height: WWSpacing.sm),
        if (documents.isEmpty) WWCard(child: Text(l10n.noDocumentsYet, style: WWType.caption)),
        for (final document in documents.take(3)) ...[
          DocumentCard(document: document, showMember: false),
          const SizedBox(height: WWSpacing.sm),
        ],
        if (documents.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: WWLinkButton(
              label: l10n.seeAll,
              onPressed: () => context.push(DocumentsScreen.memberPathFor(member.id)),
            ),
          ),
      ],
    );
  }
}

/// "Remove Sabitri?" with "Also delete their medical documents". Returns null when cancelled,
/// else whether to delete the documents too.
class _RemoveMemberDialog extends StatefulWidget {
  const _RemoveMemberDialog({required this.member});

  final MemberOut member;

  @override
  State<_RemoveMemberDialog> createState() => _RemoveMemberDialogState();
}

class _RemoveMemberDialogState extends State<_RemoveMemberDialog> {
  bool _deleteDocuments = false;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.removeMemberTitle(widget.member.fullName)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.removeMemberBody),
          if (widget.member.documentCount > 0) ...[
            const SizedBox(height: WWSpacing.md),
            CheckboxListTile(
              key: const Key('remove-delete-documents'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _deleteDocuments,
              onChanged: (v) => setState(() => _deleteDocuments = v ?? false),
              title: Text(l10n.alsoDeleteDocuments, style: WWType.body),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        TextButton(
          onPressed: () => Navigator.pop(context, _deleteDocuments),
          child: Text(l10n.remove, style: const TextStyle(color: WWColors.danger)),
        ),
      ],
    );
  }
}
