import 'package:flutter/material.dart';

import '../tokens.dart';
import 'buttons.dart';

/// Centered spinner for whole-screen loading.
class WWLoading extends StatelessWidget {
  const WWLoading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[const SizedBox(height: WWSpacing.md), Text(message!, style: WWType.caption)],
        ],
      ),
    );
  }
}

/// "Nothing here yet" screen with an optional action.
class WWEmptyState extends StatelessWidget {
  const WWEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WWSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: WWColors.tint, shape: BoxShape.circle),
              child: Icon(icon, size: 34, color: WWColors.primary),
            ),
            const SizedBox(height: WWSpacing.lg),
            Text(title, style: WWType.section, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: WWSpacing.sm),
              Text(message!, style: WWType.caption, textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: WWSpacing.lg),
              WWPrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error screen with a retry button. Texts come from ww_l10n (no hard-coded strings).
class WWErrorState extends StatelessWidget {
  const WWErrorState({super.key, required this.message, required this.retryLabel, required this.onRetry});

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WWSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: WWColors.danger),
            const SizedBox(height: WWSpacing.md),
            Text(message, style: WWType.body, textAlign: TextAlign.center),
            const SizedBox(height: WWSpacing.lg),
            WWSecondaryButton(label: retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
