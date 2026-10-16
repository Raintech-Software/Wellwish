import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/patient_ui.dart';
import 'family_controller.dart';
import 'member_form_screen.dart';
import 'member_profile_screen.dart';

/// P22 Family (mockup 8): you and your family members, + Add member.
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  static const path = '/family';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final members = ref.watch(membersProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.familyTitle)),
      body: members.unwrapPrevious().when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(membersProvider),
        ),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.read(membersProvider.notifier).reload(),
          child: ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              const _IntroCard(),
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.familyMembers, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              for (final member in list) ...[MemberCard(member: member), const SizedBox(height: WWSpacing.sm)],
              if (list.length <= 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: WWSpacing.md),
                  child: Text(l10n.noFamilyYet, style: WWType.caption, textAlign: TextAlign.center),
                ),
              const SizedBox(height: WWSpacing.md),
              WWPrimaryButton(
                key: const Key('add-member'),
                label: l10n.addMember,
                onPressed: () => context.push(MemberFormScreen.addPath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(WWSpacing.lg),
      decoration: BoxDecoration(color: WWColors.tint, borderRadius: BorderRadius.circular(WWRadius.card)),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: WWColors.surface, shape: BoxShape.circle),
            child: const Icon(Icons.groups, color: WWColors.primary, size: 32),
          ),
          const SizedBox(width: WWSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.familyIntroTitle, style: WWType.cardTitle),
                const SizedBox(height: WWSpacing.xs),
                Text(l10n.familyIntroBody, style: WWType.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One member row: photo or initials, name, relation and age.
class MemberCard extends ConsumerWidget {
  const MemberCard({super.key, required this.member});

  final MemberOut member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    return WWCard(
      key: Key('member-${member.id}'),
      onTap: () => context.push(MemberProfileScreen.pathFor(member.id)),
      child: Row(
        children: [
          WWAvatar(
            name: member.fullName,
            size: 52,
            image: member.photoUrl == null ? null : NetworkImage(fileUrl(config, member.photoUrl!)),
          ),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.fullName.isEmpty ? l10n.relationSelf : member.fullName, style: WWType.cardTitle),
                const SizedBox(height: 2),
                Text(memberSubtitle(l10n, member), style: WWType.caption),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: WWColors.textSecondary),
        ],
      ),
    );
  }
}
