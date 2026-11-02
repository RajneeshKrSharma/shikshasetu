import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';

/// A rule or a hint, in a pale box that is easy to tell from the content.
class SchoolNote extends StatelessWidget {
  const SchoolNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: AppSpacing.card,
    decoration: BoxDecoration(
      color: AppColors.lateLight,
      borderRadius: AppRadius.lgAll,
      border: Border.all(color: AppColors.late.withValues(alpha: 0.6)),
    ),
    child: Text(
      text,
      style: context.text.bodySmall!.copyWith(color: AppColors.textPrimary),
    ),
  );
}
