import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';
import 'brand_colors.dart';

class AppTheme {
  AppTheme._();

  /// The default, black and white look.
  static ThemeData get light => build(BrandColors.monochrome);

  /// The app theme for the given [brand] colors.
  static ThemeData build(BrandColors brand) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: brand.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: brand.primary,
          onPrimary: brand.onPrimary,
          primaryContainer: brand.primaryLight,
          onPrimaryContainer: brand.primary,
          secondary: brand.accent,
          secondaryContainer: brand.primaryLight,
          onSecondaryContainer: brand.primary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceTint: Colors.transparent,
          error: AppColors.absent,
        );
    final text = AppTypography.textTheme;

    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: c),
    );

    final buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
    const buttonSize = Size.fromHeight(AppSizes.buttonHeight);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      colorScheme: scheme,
      textTheme: text,
      extensions: [brand],
      // One icon size everywhere unless a widget says otherwise.
      iconTheme: const IconThemeData(size: AppIconSize.md),
      listTileTheme: ListTileThemeData(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodySmall,
        iconColor: brand.primary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.background,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        iconTheme: const IconThemeData(size: AppIconSize.lg),
        actionsIconTheme: const IconThemeData(size: AppIconSize.lg),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        // Every field reads the same: 14 label, 16 text, 12 help and errors.
        labelStyle: text.bodyMedium!.copyWith(color: AppColors.textMuted),
        floatingLabelStyle: text.bodySmall,
        hintStyle: text.bodyLarge!.copyWith(color: AppColors.textMuted),
        helperStyle: text.bodySmall,
        errorStyle: text.bodySmall!.copyWith(color: AppColors.absent),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(brand.primary),
        errorBorder: border(AppColors.absent),
        focusedErrorBorder: border(AppColors.absent),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          backgroundColor: brand.primary,
          foregroundColor: brand.onPrimary,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          foregroundColor: brand.primary,
          side: BorderSide(color: AppColors.border),
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brand.primary,
          textStyle: text.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: brand.primary,
        foregroundColor: brand.onPrimary,
        extendedTextStyle: text.labelLarge,
      ),
      chipTheme: ChipThemeData(
        iconTheme: const IconThemeData(size: AppIconSize.sm),
        selectedColor: brand.primaryLight,
        backgroundColor: AppColors.surface,
        side: BorderSide(color: AppColors.border),
        shape: const StadiumBorder(),
        showCheckmark: false,
        labelStyle: text.labelMedium!.copyWith(color: AppColors.textPrimary),
        secondaryLabelStyle: text.labelMedium!.copyWith(color: brand.primary),
        checkmarkColor: brand.primary,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: brand.primaryLight,
          selectedForegroundColor: brand.primary,
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(color: AppColors.border),
          textStyle: text.labelLarge,
          iconSize: AppIconSize.sm,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? brand.onPrimary
              : AppColors.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? brand.primary
              : AppColors.border,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        height: 64,
        indicatorColor: brand.primaryLight,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            size: AppIconSize.lg,
            color: s.contains(WidgetState.selected)
                ? brand.primary
                : AppColors.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => text.labelMedium!.copyWith(
            fontWeight: s.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: s.contains(WidgetState.selected)
                ? brand.primary
                : AppColors.textMuted,
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: brand.primary,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor: brand.primary,
        dividerColor: AppColors.border,
        labelStyle: text.titleSmall,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          brand.primary.withValues(alpha: 0.55),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: brand.primary),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      dividerColor: AppColors.border,
    );
  }
}
