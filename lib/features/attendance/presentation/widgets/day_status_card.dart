import '../../../../core/widgets/info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/attendance_status.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

/// Daily "is school open today" approval. Principal can decide, others see it.
class DayStatusCard extends StatelessWidget {
  const DayStatusCard({super.key, required this.canDecide});

  final bool canDecide;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = context.read<AuthBloc>().state.user!.id;
    void decide(SchoolDayStatus s) => context.read<AttendanceBloc>().add(
      SchoolDayDecided(status: s, decidedBy: me),
    );

    return BlocBuilder<AttendanceBloc, AttendanceState>(
      buildWhen: (a, b) => a.dayStatus != b.dayStatus,
      builder: (context, state) {
        final status = state.dayStatus;
        final (label, color, bg, icon) = switch (status) {
          SchoolDayStatus.approved => (
            l.dayOpen,
            AppColors.present,
            AppColors.presentLight,
            Icons.check_circle_rounded,
          ),
          SchoolDayStatus.rejected => (
            l.dayClosed,
            AppColors.absent,
            AppColors.absentLight,
            Icons.cancel_rounded,
          ),
          SchoolDayStatus.pending => (
            l.dayPending,
            AppColors.late,
            AppColors.lateLight,
            Icons.hourglass_top_rounded,
          ),
        };

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(icon, color: color, background: bg),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: context.text.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          formatLongDate(context, DateTime.now()),
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (canDecide && status == SchoolDayStatus.pending) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => decide(SchoolDayStatus.rejected),
                        child: Text(l.actionKeepClosed),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => decide(SchoolDayStatus.approved),
                        child: Text(l.actionApprove),
                      ),
                    ),
                  ],
                ),
              ],
              if (canDecide && status != SchoolDayStatus.pending) ...[
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () => decide(SchoolDayStatus.pending),
                    child: Text(l.actionChangeDecision),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
