import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/utils/context_ext.dart';

/// Puts a bold "this is a beta" strip above every screen of [child]. It uses
/// the app's own brand color so it reads as part of the app, with a bright
/// BETA pill to catch the eye.
class BetaBanner extends StatelessWidget {
  const BetaBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final onBrand = context.brand.onPrimary;
    return Column(
      children: [
        Material(
          color: context.brand.primary,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.late,
                      borderRadius: AppRadius.pillAll,
                    ),
                    child: Text(
                      context.l10n.betaBadge,
                      style: context.text.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      context.l10n.betaNotice,
                      textAlign: TextAlign.center,
                      style: context.text.labelLarge?.copyWith(
                        color: onBrand,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // The strip already sits under the status bar; screens below it must
        // not add that gap a second time.
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
