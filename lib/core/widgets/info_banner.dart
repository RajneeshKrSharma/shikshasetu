import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// How serious a [InfoBanner] is.
enum BannerKind { info, warning, error }

/// The one box for a note, a warning or an error on any screen: a small icon,
/// an optional bold title, the message, and optionally a button.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.title,
    this.kind = BannerKind.info,
    this.icon,
    this.action,
  });

  final String message;
  final String? title;
  final BannerKind kind;

  /// Defaults to one that suits [kind].
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final (color, tint, defaultIcon) = switch (kind) {
      BannerKind.info => (
        context.brand.primary,
        context.brand.primaryLight,
        Icons.info_outline,
      ),
      BannerKind.warning => (
        AppColors.late,
        AppColors.lateLight,
        Icons.warning_amber_rounded,
      ),
      BannerKind.error => (
        AppColors.absent,
        AppColors.absentLight,
        Icons.error_outline,
      ),
    };
    return Container(
      width: double.infinity,
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title!, style: context.text.titleSmall),
                Text(message, style: context.text.bodyMedium),
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The one small round-cornered square that holds an icon in a list or card.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key, this.color, this.background});

  final IconData icon;
  final Color? color;
  final Color? background;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? context.brand.primaryLight,
        borderRadius: AppRadius.lgAll,
      ),
      child: Icon(
        icon,
        size: AppIconSize.lg,
        color: color ?? context.brand.primary,
      ),
    );
  }
}
