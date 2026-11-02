import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';

/// The top of an Overview tab: avatar, name, and a line or two under it.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.lines,
    this.trailing,
  });

  final String name;
  final List<String> lines;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          InitialsAvatar(name, radius: 26),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                for (final line in lines)
                  Text(line, style: context.text.bodyMedium),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// One labelled fact, e.g. "Mobile number  +91 98765 43210". Nothing is shown
/// when [value] is empty, so missing details do not leave gaps.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppIconSize.md, color: AppColors.textMuted),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.text.labelSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(value!, style: context.text.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A card listing [rows], with a divider between those that are shown.
class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.rows});

  final List<InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    final shown = [
      for (final r in rows)
        if (r.value != null && r.value!.trim().isNotEmpty) r,
    ];
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        children: [
          for (var i = 0; i < shown.length; i++) ...[
            shown[i],
            if (i != shown.length - 1)
              Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}
