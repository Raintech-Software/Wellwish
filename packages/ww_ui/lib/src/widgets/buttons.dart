import 'package:flutter/material.dart';

import '../tokens.dart';

/// Full-width blue button (Send OTP, Confirm Appointment, Subscribe Now).
class WWPrimaryButton extends StatelessWidget {
  const WWPrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false, this.color});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  /// Use `WWColors.brandGreen` for "Book Now" style actions.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: color == null ? null : ElevatedButton.styleFrom(backgroundColor: color),
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
            )
          : Text(label),
    );
  }
}

/// White button with a light border (Google login, Cancel).
class WWSecondaryButton extends StatelessWidget {
  const WWSecondaryButton({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final text = Text(label, style: const TextStyle(color: WWColors.textPrimary));
    if (icon == null) {
      return OutlinedButton(onPressed: onPressed, child: text);
    }
    return OutlinedButton.icon(onPressed: onPressed, icon: icon!, label: text);
  }
}
