import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// A square button with a tinted icon, its name, and a small line under it
/// (a count, a short status). The same tile is used on the Home screen, on a
/// group's workspace and on a person's profile.
class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.caption,
  });

  final IconData icon;
  final String label;
  final String? caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.brand.primaryLight,
                  borderRadius: AppRadius.lgAll,
                ),
                child: Icon(
                  icon,
                  size: AppIconSize.md,
                  color: context.brand.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelMedium,
              ),
              if (caption != null)
                Text(
                  caption!,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tiles in rows of [columns], all the same size, the last row left-aligned.
class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key, required this.tiles, this.columns = 3});

  final List<Widget> tiles;
  final int columns;

  /// Height of every tile.
  static const double tileHeight = 104;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        const gap = AppSpacing.sm;
        final width = (box.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final t in tiles)
              SizedBox(width: width, height: tileHeight, child: t),
          ],
        );
      },
    );
  }
}
