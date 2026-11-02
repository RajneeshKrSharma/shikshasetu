import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // The brand colors (primary, accent) are not here: they follow the
  // school's chosen theme and come from `context.brand` (see BrandColors).

  // Neutrals.
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E5E5);

  static const textPrimary = Color(0xFF1A1A1A);
  static const textMuted = Color(0xFF6B6B6B);

  // Status colors keep their meaning whatever the theme is.

  static const present = Color(0xFF2E9E5B);
  static const presentLight = Color(0xFFE2F5EA);
  static const absent = Color(0xFFD64545);
  static const absentLight = Color(0xFFFBE7E7);
  static const late = Color(0xFFE59A14);
  static const lateLight = Color(0xFFFDF1DC);
  static const pending = Color(0xFF8A8A8A);
  static const pendingLight = Color(0xFFEFEFEF);
}
