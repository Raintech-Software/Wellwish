import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../booking/my_bookings_screen.dart';
import '../documents/documents_screen.dart';
import '../family/family_controller.dart';
import '../family/family_screen.dart';
import '../family/member_profile_screen.dart';
import '../home/home_shell.dart';
import '../settings/settings_screen.dart';
import '../session/session_controller.dart';

/// P23 Profile (mockup 10): who is logged in, links to your details, documents, family,
/// settings, and logout.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const path = '/profile';

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref, {bool everywhere = false}) async {
    final l10n = WWLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              everywhere ? l10n.logoutEverywhere : l10n.logout,
              style: const TextStyle(color: WWColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(sessionProvider.notifier).logout(everywhere: everywhere);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final me = ref.watch(sessionProvider.select((s) => s.me));
    final self = ref.watch(membersProvider).unwrapPrevious().value?.where((m) => m.isSelf).firstOrNull;
    final config = ref.watch(appConfigProvider);
    final rows = <(IconData, String, VoidCallback)>[
      (
        Icons.person_outline,
        l10n.personalInformation,
        () => me == null ? null : context.push(MemberProfileScreen.pathFor(me.selfMemberId)),
      ),
      (Icons.event_note_outlined, l10n.myBookings, () => context.push(MyBookingsScreen.path)),
      (Icons.description_outlined, l10n.myReports, () => context.go(DocumentsScreen.path)),
      (Icons.family_restroom, l10n.familyMembers, () => context.go(FamilyScreen.path)),
      (Icons.settings_outlined, l10n.settingsTitle, () => context.push(SettingsScreen.path)),
      (Icons.help_outline, l10n.helpSupport, () => showComingSoon(context)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(SettingsScreen.path),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          WWCard(
            child: Row(
              children: [
                WWAvatar(
                  name: me?.fullName ?? '',
                  image: self?.photoUrl == null ? null : NetworkImage(fileUrl(config, self!.photoUrl!)),
                ),
                const SizedBox(width: WWSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(me?.fullName ?? '', style: WWType.section),
                      const SizedBox(height: 2),
                      Text(formatIndianPhone(me?.phone ?? ''), style: WWType.caption),
                      const SizedBox(height: WWSpacing.xs),
                      WWBadge(
                        label: l10n.verified,
                        icon: Icons.check_circle,
                        color: WWColors.brandGreen,
                        background: WWColors.greenTint,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: WWSpacing.lg),
          WWCard(
            padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
            child: Column(
              children: [
                for (final (icon, label, onTap) in rows) WWListTile(icon: icon, title: label, onTap: onTap),
                WWListTile(
                  icon: Icons.devices_other,
                  title: l10n.logoutEverywhere,
                  onTap: () => _confirmLogout(context, ref, everywhere: true),
                ),
                WWListTile(
                  icon: Icons.logout,
                  title: l10n.logout,
                  iconColor: WWColors.danger,
                  titleColor: WWColors.danger,
                  showChevron: false,
                  onTap: () => _confirmLogout(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
