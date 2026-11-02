import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Single source of truth for fonts and text styles.
///
/// To change the app font: add the font files under `assets/fonts/`,
/// declare them in pubspec.yaml, and set [fontFamily] below.
class AppTypography {
  AppTypography._();

  /// `null` uses the platform default font.
  static String? fontFamily;

  /// The only sizes in the app: 24 big numbers, 20 screen headings, 18 bar
  /// and sheet titles, 16 card titles and field text, 14 body and buttons,
  /// 12 captions and labels.
  static TextTheme get textTheme => _base.apply(fontFamily: fontFamily);

  static const _base = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
    bodySmall: TextStyle(fontSize: 12, color: AppColors.textMuted),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textMuted,
    ),
  );
}
