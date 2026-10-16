import 'package:flutter/material.dart';

import '../brand.dart';
import '../tokens.dart';

/// Layout of the login and OTP screens (mockup 2): logo on top, title, subtitle, content.
/// Scrolls when the keyboard is open.
class WWAuthLayout extends StatelessWidget {
  const WWAuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.logoSemanticLabel = 'WellWish',
    this.badge,
    this.onBack,
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final String logoSemanticLabel;

  /// "Partner" in the partner app.
  final String? badge;
  final VoidCallback? onBack;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WWColors.surface,
      appBar: onBack == null
          ? null
          : AppBar(
              backgroundColor: WWColors.surface,
              leading: BackButton(onPressed: onBack),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: WWSpacing.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: onBack == null ? WWSpacing.xxl : WWSpacing.sm),
                    Center(child: WWLogoLockup(width: 190, semanticLabel: logoSemanticLabel)),
                    if (badge != null) ...[const SizedBox(height: WWSpacing.sm), Center(child: WWBadge(label: badge!))],
                    const SizedBox(height: WWSpacing.xl),
                    Text(title, style: WWType.screenTitle),
                    const SizedBox(height: WWSpacing.xs),
                    Text(subtitle, style: WWType.caption.copyWith(fontSize: 13)),
                    const SizedBox(height: WWSpacing.xl),
                    ...children,
                    const Spacer(),
                    if (footer != null) ...[const SizedBox(height: WWSpacing.xl), footer!],
                    const SizedBox(height: WWSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small pill label ("Partner", "Coming soon", "Verified").
class WWBadge extends StatelessWidget {
  const WWBadge({
    super.key,
    required this.label,
    this.color = WWColors.brandBlue,
    this.background = WWColors.tint,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 13, color: color), const SizedBox(width: 4)],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: WWType.caption.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

/// "──── OR ────" between the phone login and Google.
class WWOrDivider extends StatelessWidget {
  const WWOrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: WWSpacing.md),
          child: Text(label, style: WWType.caption),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// White "G Google" button (mockup 2).
class WWGoogleButton extends StatelessWidget {
  const WWGoogleButton({super.key, required this.label, required this.onPressed, this.loading = false});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 160),
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          child: loading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'G',
                      style: TextStyle(
                        fontFamily: WWFont.familyWithPackage,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4285F4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(label, style: WWType.body.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Coloured message box (session ended, errors, hints).
class WWMessageBox extends StatelessWidget {
  const WWMessageBox({super.key, required this.message, this.isError = false, this.icon});

  final String message;
  final bool isError;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = isError ? WWColors.danger : WWColors.brandBlue;
    return Container(
      padding: const EdgeInsets.all(WWSpacing.md),
      decoration: BoxDecoration(
        color: isError ? WWColors.danger.withValues(alpha: 0.08) : WWColors.tint,
        borderRadius: BorderRadius.circular(WWRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? (isError ? Icons.error_outline : Icons.info_outline), color: color, size: 20),
          const SizedBox(width: WWSpacing.sm),
          Expanded(
            child: Text(message, style: WWType.body.copyWith(color: color, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

/// Text-only link button ("Create Account", "Resend code"). Its tap area is at least 48 dp tall
/// (Android's guideline, PHASES 9.8) while the text looks like a link.
class WWLinkButton extends StatelessWidget {
  const WWLinkButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.padded,
        foregroundColor: WWColors.primary,
        textStyle: WWType.body.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}
