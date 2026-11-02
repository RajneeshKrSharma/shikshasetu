import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../attendance/presentation/bloc/attendance_state.dart';
import '../../../attendance/presentation/widgets/check_failure_l10n.dart';
import '../../../auth/domain/entities/app_user.dart';

/// A teacher's whole day in one card: is school open, and the one button they
/// need now (Check In or Check Out). It changes by itself when the Principal
/// opens school.
class TeacherTodayCard extends StatelessWidget {
  const TeacherTodayCard({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listenWhen: (a, b) => b.problem != null && a.problem != b.problem,
      listener: (context, state) {
        final p = state.problem!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(p.failure.message(l, p.distance))),
        );
      },
      builder: (context, state) {
        final record = state.recordOf(user.id);
        final checkedIn = record?.isCheckedIn == true;
        final done = record?.checkOut != null;
        final bloc = context.read<AttendanceBloc>();

        final (color, _, icon, title, body) = switch (state.dayStatus) {
          _ when done => (
            AppColors.present,
            AppColors.presentLight,
            Icons.task_alt_rounded,
            l.dashTeacherOutTitle,
            l.noticeCheckedOut,
          ),
          _ when checkedIn => (
            AppColors.present,
            AppColors.presentLight,
            Icons.check_circle_rounded,
            l.dashTeacherInTitle,
            l.dashTeacherInBody(formatTime(context, record?.checkIn)),
          ),
          SchoolDayStatus.approved => (
            AppColors.present,
            AppColors.presentLight,
            Icons.wb_sunny_rounded,
            l.dashTeacherOpenTitle,
            l.dashTeacherOpenBody,
          ),
          SchoolDayStatus.rejected => (
            AppColors.absent,
            AppColors.absentLight,
            Icons.event_busy_rounded,
            l.dashTeacherClosedTitle,
            l.dashTeacherClosedBody,
          ),
          SchoolDayStatus.pending => (
            AppColors.late,
            AppColors.lateLight,
            Icons.hourglass_top_rounded,
            l.dashTeacherWaitTitle,
            l.dashTeacherWaitBody,
          ),
        };

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: AppIconSize.lg),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.text.titleSmall),
                        Text(body, style: context.text.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              if (state.isSchoolOpen && !done) ...[
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: state.checking
                      ? null
                      : () => checkedIn
                            ? bloc.add(
                                CheckOutRequested(
                                  user.id,
                                  teacherName: user.name,
                                ),
                              )
                            : bloc.add(
                                CheckInRequested(
                                  user.id,
                                  teacherName: user.name,
                                ),
                              ),
                  icon: Icon(
                    checkedIn ? Icons.logout : Icons.login,
                    size: AppIconSize.sm,
                  ),
                  label: Text(checkedIn ? l.actionCheckOut : l.actionCheckIn),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
                  ),
                ),
                if (state.checking) ...[
                  const SizedBox(height: AppSpacing.md),
                  const LinearProgressIndicator(),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
