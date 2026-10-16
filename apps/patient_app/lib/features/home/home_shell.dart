import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

/// Bottom navigation as in the mockup: Home · Doctors · Reports · Family · Profile (§7.1).
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: WWBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        items: [
          WWNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: l10n.navHome),
          WWNavItem(icon: Icons.medical_services_outlined, activeIcon: Icons.medical_services, label: l10n.navDoctors),
          WWNavItem(icon: Icons.description_outlined, activeIcon: Icons.description, label: l10n.navReports),
          WWNavItem(icon: Icons.groups_outlined, activeIcon: Icons.groups, label: l10n.navFamily),
          WWNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: l10n.navProfile),
        ],
      ),
    );
  }
}

/// A tab whose feature arrives in a later phase (behind a feature flag).
class ComingSoonTab extends StatelessWidget {
  const ComingSoonTab({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: WWEmptyState(icon: icon, title: l10n.comingSoon, message: l10n.comingSoonBody),
    );
  }
}

void showComingSoon(BuildContext context) {
  final l10n = WWLocalizations.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(l10n.comingSoonBody)));
}
