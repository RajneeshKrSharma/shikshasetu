import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/utils/context_ext.dart';
import '../view_failure.dart';
import 'failure_text.dart';

/// What a screen shows while its data loads, when loading failed, and when
/// there is nothing to show; [builder] draws the data itself.
class AsyncBody extends StatelessWidget {
  const AsyncBody({
    super.key,
    required this.status,
    required this.builder,
    this.failure,
    this.onRetry,
    this.isEmpty = false,
    this.emptyText,
    this.emptyIcon = Icons.inbox_outlined,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final VoidCallback? onRetry;
  final bool isEmpty;
  final String? emptyText;
  final IconData emptyIcon;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ViewStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewStatus.failed:
        return _Message(
          icon: Icons.cloud_off_outlined,
          text: failure?.text(context.l10n) ?? context.l10n.srvUnavailable,
          action: onRetry == null
              ? null
              : OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.actionRetry),
                ),
        );
      case ViewStatus.ready:
        return isEmpty
            ? _Message(
                icon: emptyIcon,
                text: emptyText ?? context.l10n.emptyNoResults,
              )
            : builder(context);
    }
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: AppSpacing.page,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppIconSize.hero, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            text,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium!.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    ),
  );
}
