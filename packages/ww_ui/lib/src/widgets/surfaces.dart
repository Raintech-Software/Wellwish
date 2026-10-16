import 'package:flutter/material.dart';

import '../tokens.dart';

/// White rounded card with a light border.
class WWCard extends StatelessWidget {
  const WWCard({super.key, required this.child, this.padding = const EdgeInsets.all(WWSpacing.lg), this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Icon in a tinted circle + title + subtitle + chevron (Profile, Family Updates rows).
class WWListTile extends StatelessWidget {
  const WWListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor = WWColors.primary,
    this.titleColor,
    this.showChevron = true,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color? titleColor;
  final bool showChevron;

  /// Shown instead of the chevron (e.g. a small spinner while something opens).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(WWRadius.card),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: WWSpacing.md, vertical: WWSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: WWSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: WWType.cardTitle.copyWith(color: titleColor)),
                  if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: WWType.caption)],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showChevron)
              const Icon(Icons.chevron_right, color: WWColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class WWNavItem {
  const WWNavItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// 5-tab bottom navigation as in the mockup (Home · Doctors · Reports · Family · Profile).
class WWBottomNav extends StatelessWidget {
  const WWBottomNav({super.key, required this.items, required this.currentIndex, required this.onTap});

  final List<WWNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: WWColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        elevation: 0,
        items: [
          for (final item in items)
            BottomNavigationBarItem(icon: Icon(item.icon), activeIcon: Icon(item.activeIcon), label: item.label),
        ],
      ),
    );
  }
}
