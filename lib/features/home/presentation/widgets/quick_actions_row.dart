import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../notices/presentation/screen/notices_screen.dart';

/// The one thing that is not a tab: posting a notice for everyone. (Students,
/// attendance and fees are reached from the tabs.)
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const NoticesScreen())),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: context.brand.primaryLight,
            child: Icon(Icons.campaign_outlined, color: context.brand.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.quickNotice, style: context.text.titleSmall),
                Text(l.quickNoticeHint, style: context.text.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
