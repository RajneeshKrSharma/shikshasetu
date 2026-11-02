import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.onTap,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Replaces the neutral outline, e.g. with a soft tint of the card's color.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: borderColor == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: AppRadius.lgAll,
              side: BorderSide(color: borderColor!),
            ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(text, style: context.text.titleSmall)),
          ?trailing,
        ],
      ),
    );
  }
}

/// A number with a short label and a small icon: a figure on a card, no
/// colored boxes. [background] is kept for callers but no longer used.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.background,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: context.text.headlineSmall),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: context.text.bodySmall),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        style: context.text.labelMedium!.copyWith(color: color),
      ),
    );
  }
}

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.name, {super.key, this.radius = 22});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts.length > 1
        ? '${parts.first[0]}${parts.last[0]}'
        : parts.first[0];
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.brand.primaryLight,
      child: Text(
        initials.toUpperCase(),
        style: context.text.titleMedium!.copyWith(
          color: context.brand.primary,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppIconSize.hero, color: AppColors.border),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
