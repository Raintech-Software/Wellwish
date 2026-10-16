import 'package:flutter/material.dart';

import '../brand.dart';
import '../tokens.dart';
import 'auth.dart';

/// Home tile (mockup 3): picture in a tinted circle, label, optional badge.
class WWFeatureTile extends StatelessWidget {
  const WWFeatureTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = WWColors.primary,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  /// e.g. "Coming soon" while a feature is behind a flag.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WWColors.surface,
      borderRadius: BorderRadius.circular(WWRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(WWRadius.card),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: WWSpacing.sm, vertical: WWSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WWRadius.card),
            border: Border.all(color: WWColors.border),
          ),
          // Shrinks the content a little instead of overflowing when a translation is long.
          child: LayoutBuilder(
            builder: (context, constraints) => Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                        child: Icon(icon, color: color, size: 30),
                      ),
                      const SizedBox(height: WWSpacing.sm),
                      Text(
                        label,
                        style: WWType.cardTitle.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (badge != null) ...[
                        const SizedBox(height: 6),
                        WWBadge(label: badge!, color: WWColors.textSecondary, background: WWColors.background),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The blue hero card on Home (mockup 3), with the logo mark instead of a stock photo.
class WWHeroCard extends StatelessWidget {
  const WWHeroCard({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(WWSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WWRadius.card),
        gradient: const LinearGradient(
          colors: [WWColors.tint, WWColors.greenTint],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: WWType.section.copyWith(color: WWColors.brandNavy, fontSize: 17)),
                const SizedBox(height: WWSpacing.xs),
                Text(subtitle, style: WWType.caption),
              ],
            ),
          ),
          const SizedBox(width: WWSpacing.md),
          const WWLogo(width: 76),
        ],
      ),
    );
  }
}

/// Round avatar: the photo when there is one, else the initials.
class WWAvatar extends StatelessWidget {
  const WWAvatar({super.key, required this.name, this.size = 64, this.image});

  final String name;
  final double size;
  final ImageProvider? image;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initials;
    final fallback = _initialsCircle(initials);
    if (image != null) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image(image: image!, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback),
        ),
      );
    }
    return fallback;
  }

  Widget _initialsCircle(String initials) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: WWColors.tint, shape: BoxShape.circle),
      child: initials.isEmpty
          ? Icon(Icons.person, size: size * 0.55, color: WWColors.primary)
          : Text(
              initials,
              style: WWType.section.copyWith(color: WWColors.primary, fontSize: size * 0.34),
            ),
    );
  }
}
