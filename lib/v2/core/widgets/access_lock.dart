import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/utils/context_ext.dart';

/// Covers all of [child] with a centred "access restricted" label and blocks
/// every tap, so nobody can use the app underneath.
class AccessLock extends StatelessWidget {
  const AccessLock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExcludeSemantics(child: AbsorbPointer(child: child)),
        Positioned.fill(
          child: Material(
            color: AppColors.background,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  context.l10n.accessRestrictedLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
