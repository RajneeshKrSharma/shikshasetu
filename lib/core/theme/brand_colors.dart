import 'package:flutter/material.dart';

/// The app's main colors (buttons, highlights): black and white. Everything
/// else (status greens/reds, neutrals) is fixed in [AppColors].
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryLight,
    required this.accent,
    required this.accentLight,
  });

  /// The default look: black and white.
  static const monochrome = BrandColors(
    primary: Color(0xFF111111),
    onPrimary: Colors.white,
    primaryLight: Color(0xFFEDEDED),
    accent: Color(0xFF4A4A4A),
    accentLight: Color(0xFFF0F0F0),
  );

  final Color primary;
  final Color onPrimary;
  final Color primaryLight;
  final Color accent;
  final Color accentLight;

  @override
  BrandColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryLight,
    Color? accent,
    Color? accentLight,
  }) => BrandColors(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    primaryLight: primaryLight ?? this.primaryLight,
    accent: accent ?? this.accent,
    accentLight: accentLight ?? this.accentLight,
  );

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
    );
  }
}
