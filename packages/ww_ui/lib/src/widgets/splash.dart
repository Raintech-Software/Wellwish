import 'package:flutter/material.dart';

import '../brand.dart';
import '../tokens.dart';

/// Splash screen from mockup 1, shared by both apps, showing the official logo lockup
/// (mark + WellWish + Hindi tagline). The Partner app passes [badge] ("Partner").
class WWSplash extends StatelessWidget {
  const WWSplash({super.key, required this.semanticLabel, this.badge});

  /// Read by screen readers for the logo, e.g. "WellWish. आपकी सेहत, हमारी ज़िम्मेदारी".
  final String semanticLabel;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WWColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _SplashWavesPainter())),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WWLogoLockup(width: 280, semanticLabel: semanticLabel),
                  if (badge != null) ...[
                    const SizedBox(height: WWSpacing.lg),
                    Container(
                      key: const Key('ww-splash-badge'),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(color: WWColors.tint, borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        badge!,
                        style: WWType.cardTitle.copyWith(
                          color: WWColors.brandBlue,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Positioned(left: 0, right: 0, bottom: 96, child: Center(child: _SplashProgress())),
        ],
      ),
    );
  }
}

class _SplashProgress extends StatelessWidget {
  const _SplashProgress();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: const SizedBox(
        width: 120,
        height: 4,
        child: LinearProgressIndicator(color: WWColors.primary, backgroundColor: WWColors.greenTint),
      ),
    );
  }
}

/// Soft blue wave top-left and blue/green wave bottom-right, as in mockup 1.
class _SplashWavesPainter extends CustomPainter {
  const _SplashWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Top: a pale wide band, with a smaller, stronger blue sweep in the top-left corner.
    final topOuter = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.04)
      ..cubicTo(w * 0.7, h * 0.10, w * 0.35, h * 0.07, 0, h * 0.20)
      ..close();
    _fill(
      canvas,
      topOuter,
      [WWColors.tint, WWColors.greenTint.withValues(alpha: 0.5)],
      Alignment.topLeft,
      Alignment.topRight,
      Rect.fromLTWH(0, 0, w, h * 0.2),
    );

    final topInner = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.62, 0)
      ..cubicTo(w * 0.42, h * 0.035, w * 0.18, h * 0.05, 0, h * 0.13)
      ..close();
    _fill(
      canvas,
      topInner,
      [WWColors.primary.withValues(alpha: 0.85), WWColors.primary.withValues(alpha: 0.25)],
      Alignment.topLeft,
      Alignment.bottomRight,
      Rect.fromLTWH(0, 0, w * 0.62, h * 0.13),
    );

    // Bottom: pale green band across, stronger blue in the bottom-right corner.
    final bottomOuter = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.95)
      ..cubicTo(w * 0.35, h * 0.89, w * 0.7, h * 0.93, w, h * 0.82)
      ..lineTo(w, h)
      ..close();
    _fill(
      canvas,
      bottomOuter,
      [WWColors.greenTint, WWColors.tint],
      Alignment.bottomLeft,
      Alignment.topRight,
      Rect.fromLTWH(0, h * 0.82, w, h * 0.18),
    );

    final bottomInner = Path()
      ..moveTo(w * 0.35, h)
      ..cubicTo(w * 0.6, h * 0.97, w * 0.85, h * 0.95, w, h * 0.88)
      ..lineTo(w, h)
      ..close();
    _fill(
      canvas,
      bottomInner,
      [WWColors.primary.withValues(alpha: 0.25), WWColors.primary.withValues(alpha: 0.8)],
      Alignment.bottomLeft,
      Alignment.topRight,
      Rect.fromLTWH(w * 0.35, h * 0.88, w * 0.65, h * 0.12),
    );
  }

  void _fill(Canvas canvas, Path path, List<Color> colors, Alignment begin, Alignment end, Rect bounds) {
    canvas.drawPath(
      path,
      Paint()..shader = LinearGradient(colors: colors, begin: begin, end: end).createShader(bounds),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
