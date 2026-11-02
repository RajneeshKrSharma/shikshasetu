import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../approvals/domain/entities/approval_request.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../approvals/presentation/screen/approvals_screen.dart';
import '../../../approvals/presentation/widgets/approval_l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// What is waiting for the Principal, answered on the spot: the next request
/// with its own buttons (Open / Closed for the school day, Approve / Reject
/// for the rest), and an arrow to see them all.
class NeedsYouCard extends StatelessWidget {
  const NeedsYouCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<ApprovalsBloc, ApprovalsState>(
      buildWhen: (a, b) => a.requests != b.requests,
      builder: (context, s) {
        final waiting = [
          for (final r in s.requests)
            if (r.isPending) r,
        ];
        if (waiting.isEmpty) {
          return _Box(
            color: AppColors.present,
            background: AppColors.presentLight,
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.present),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.needsYouNone, style: context.text.titleSmall),
                      Text(l.needsYouNoneHint, style: context.text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        final next = waiting.first;
        final me = context.read<AuthBloc>().state.user?.id ?? '';
        void decide(ApprovalStatus status) {
          HapticFeedback.mediumImpact();
          context.read<ApprovalsBloc>().add(
            ApprovalDecided(request: next, status: status, decidedBy: me),
          );
        }

        return _Box(
          color: AppColors.late,
          background: AppColors.lateLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.needsYouTitle(waiting.length),
                style: context.text.labelMedium!.copyWith(
                  color: AppColors.late,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                next.title ?? next.question(l),
                style: context.text.titleSmall,
              ),
              if (next.title != null && next.detail != null)
                Text(next.detail!, style: context.text.bodySmall),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, AppSizes.buttonCompact),
                      ),
                      onPressed: () => decide(ApprovalStatus.approved),
                      child: Text(next.category.approveLabel(l)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, AppSizes.buttonCompact),
                        backgroundColor: AppColors.surface,
                      ),
                      onPressed: () => decide(ApprovalStatus.rejected),
                      child: Text(next.category.rejectLabel(l)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.outlined(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                    ),
                    tooltip: l.dashWaitingOpen,
                    onPressed: () => ApprovalsScreen.open(context),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.color,
    required this.background,
    required this.child,
  });

  final Color color;
  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: AppSpacing.card,
    decoration: BoxDecoration(
      color: background,
      borderRadius: AppRadius.lgAll,
      border: Border.all(color: color.withValues(alpha: 0.6)),
    ),
    child: child,
  );
}
