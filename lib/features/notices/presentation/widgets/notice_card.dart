import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/notice.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key, required this.notice});

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notice.title, style: context.text.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.noticePostedBy(
              notice.postedBy,
              formatShortDate(context, notice.postedAt),
            ),
            style: context.text.labelSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(notice.body, style: context.text.bodyMedium),
        ],
      ),
    );
  }
}
