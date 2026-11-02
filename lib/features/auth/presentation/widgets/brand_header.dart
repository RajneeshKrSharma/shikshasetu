import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';

/// The app's logo mark beside its name, centred.
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.brand.primary,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Icon(
            Icons.auto_stories_rounded,
            size: 24,
            color: context.brand.onPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            context.l10n.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
