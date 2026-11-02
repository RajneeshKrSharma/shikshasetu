import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/notice.dart';
import '../bloc/notices_bloc.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.notice,
    required this.canWithdraw,
  });

  final Notice notice;
  final bool canWithdraw;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final announcement = notice.kind == NoticeKind.announcement;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (announcement) ...[
                StatusChip(
                  label: l.noticeAnnouncement,
                  color: context.brand.primary,
                  background: context.brand.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(notice.title, style: context.text.titleSmall),
              ),
              if (canWithdraw)
                IconButton(
                  tooltip: l.noticeWithdraw,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _confirm(context),
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(notice.body, style: context.text.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            [
              if (notice.postedByName.isNotEmpty) notice.postedByName,
              if (notice.postedAt != null)
                formatShortDate(context, notice.postedAt!),
            ].join(' · '),
            style: context.text.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final l = context.l10n;
    final bloc = context.read<NoticesBloc>();
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.noticeWithdrawTitle),
        content: Text(l.noticeWithdrawBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            child: Text(l.noticeWithdraw),
          ),
        ],
      ),
    );
    if (yes ?? false) bloc.add(NoticeWithdrawn(notice.id));
  }
}
