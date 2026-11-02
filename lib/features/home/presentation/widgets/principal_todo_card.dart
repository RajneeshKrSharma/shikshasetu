import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../approvals/presentation/screen/approvals_screen.dart';

/// Tells the Principal, in plain words, whether teachers have sent anything
/// that needs an answer. It only informs: tap it to open Approvals, the one
/// place requests are answered.
class PrincipalTodoCard extends StatelessWidget {
  const PrincipalTodoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<ApprovalsBloc, ApprovalsState>(
      buildWhen: (a, b) => a.pendingCount != b.pendingCount,
      builder: (context, state) {
        final count = state.pendingCount;
        final waiting = count > 0;
        return AppCard(
          onTap: () => ApprovalsScreen.open(context),
          child: Row(
            children: [
              const IconBadge(Icons.fact_check_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.dashRequestsTitle, style: context.text.titleSmall),
                    Text(
                      waiting
                          ? l.dashRequestsWaiting(count)
                          : l.dashRequestsNone,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: StatusChip(
                  key: ValueKey(count),
                  label: waiting
                      ? l.dashRequestsCount(count)
                      : l.dashRequestsClear,
                  color: waiting ? AppColors.late : AppColors.present,
                  background: waiting
                      ? AppColors.lateLight
                      : AppColors.presentLight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
