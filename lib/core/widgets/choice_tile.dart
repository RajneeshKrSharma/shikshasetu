import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// One choice on a feature's first screen: a large tile with what it is and a
/// line saying what it is for.
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  /// The main choice (adding something) is tinted.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Material(
      color: highlight ? brand.primaryLight : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(
          color: highlight
              ? brand.primary.withValues(alpha: 0.5)
              : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: highlight ? brand.primary : brand.primaryLight,
                child: Icon(
                  icon,
                  color: highlight ? AppColors.surface : brand.primary,
                ),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "What do you need?" with the choices of a feature, two to a row.
class ChoiceScreenBody extends StatelessWidget {
  const ChoiceScreenBody({
    super.key,
    required this.question,
    required this.tiles,
  });

  final String question;
  final List<ChoiceTile> tiles;

  @override
  Widget build(BuildContext context) => ListView(
    padding: AppSpacing.pageOf(context),
    children: [
      Text(question, style: context.text.headlineSmall),
      const SizedBox(height: AppSpacing.lg),
      LayoutBuilder(
        builder: (context, box) {
          const gap = AppSpacing.md;
          final width = (box.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final t in tiles)
                SizedBox(width: width, height: 168, child: t),
            ],
          );
        },
      ),
    ],
  );
}
