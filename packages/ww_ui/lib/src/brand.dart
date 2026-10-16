import 'package:flutter/material.dart';

import 'tokens.dart';

/// The heart mark (blue hand, green hand, family, cross) from the official logo
/// (docs/ui-reference/wellwish-logo.jpg). Use where space is small: app bars, cards.
class WWLogo extends StatelessWidget {
  const WWLogo({super.key, this.width = 140});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_mark.png',
      package: WWFont.package,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      semanticLabel: 'WellWish',
    );
  }
}

/// The full official logo: mark + "WellWish" + Hindi tagline. Use on the splash and login.
class WWLogoLockup extends StatelessWidget {
  const WWLogoLockup({super.key, this.width = 270, this.semanticLabel = 'WellWish'});

  final double width;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_full.png',
      package: WWFont.package,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      semanticLabel: semanticLabel,
    );
  }
}

/// "Well" in brand blue + "Wish" in brand green, as text (for headers where the image
/// lockup would be too big).
class WWWordmark extends StatelessWidget {
  const WWWordmark({super.key, this.fontSize = 44});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: WWFont.familyWithPackage,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.5,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Well',
            style: base.copyWith(color: WWColors.brandBlue),
          ),
          TextSpan(
            text: 'Wish',
            style: base.copyWith(color: WWColors.brandGreen),
          ),
        ],
      ),
      semanticsLabel: 'WellWish',
    );
  }
}
