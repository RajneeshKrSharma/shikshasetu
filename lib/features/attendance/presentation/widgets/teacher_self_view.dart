import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../face_id/presentation/bloc/face_id_cubit.dart';
import '../../../face_id/presentation/screen/face_id_screen.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import 'check_failure_l10n.dart';
import 'day_status_card.dart';

/// Teacher's own check-in / check-out and class-marking entry point.
class TeacherSelfView extends StatelessWidget {
  const TeacherSelfView({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return BlocListener<AttendanceBloc, AttendanceState>(
      listenWhen: (a, b) => b.problem != null && a.problem != b.problem,
      listener: (context, state) {
        final p = state.problem!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(p.failure.message(l, p.distance))),
        );
      },
      child: ListView(
        padding: AppSpacing.pageOf(context),
        children: [
          const DayStatusCard(canDecide: false),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                final record = state.recordOf(user.id);
                final open = state.isSchoolOpen;
                final worked = record?.workedAt(DateTime.now());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(l.sectionMyAttendanceToday),
                    Row(
                      children: [
                        _TimeBlock(
                          label: l.labelCheckIn,
                          value: formatTime(context, record?.checkIn),
                        ),
                        _TimeBlock(
                          label: l.labelCheckOut,
                          value: formatTime(context, record?.checkOut),
                        ),
                        _TimeBlock(
                          label: l.labelWorked,
                          value: worked == null
                              ? '--'
                              : formatDuration(l, worked),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (!open)
                      _Notice(l.noticeCheckInLocked)
                    else if (record?.checkOut != null)
                      _Notice(l.noticeCheckedOut)
                    else if (record?.isCheckedIn == true)
                      FilledButton.icon(
                        onPressed: state.checking
                            ? null
                            : () => context.read<AttendanceBloc>().add(
                                CheckOutRequested(
                                  user.id,
                                  teacherName: user.name,
                                ),
                              ),
                        icon: const Icon(Icons.logout),
                        label: Text(l.actionCheckOut),
                      )
                    else
                      FilledButton.icon(
                        onPressed: state.checking
                            ? null
                            : () => context.read<AttendanceBloc>().add(
                                CheckInRequested(
                                  user.id,
                                  teacherName: user.name,
                                ),
                              ),
                        icon: const Icon(Icons.login),
                        label: Text(l.actionCheckIn),
                      ),
                    if (state.checking) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const LinearProgressIndicator(),
                    ],
                    if (open && record?.checkOut == null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(l.checkInHint, style: context.text.labelSmall),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _FaceIdTile(user: user),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.text.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: context.text.titleMedium),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.pendingLight,
        borderRadius: AppRadius.mdAll,
      ),
      child: Text(text, style: context.text.bodySmall),
    );
  }
}

/// Shows whether Face ID is set up, and nudges the teacher to set it up.
class _FaceIdTile extends StatelessWidget {
  const _FaceIdTile({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<FaceIdCubit>(
        param1: FaceIdArgs(
          teacherId: user.id,
          teacherName: user.name,
          enrolledBy: user.id,
        ),
      )..load(),
      child: BlocBuilder<FaceIdCubit, FaceIdState>(
        builder: (context, s) {
          if (s.loading) return const SizedBox.shrink();
          return AppCard(
            onTap: () async {
              final cubit = context.read<FaceIdCubit>();
              await FaceIdScreen.open(
                context,
                teacherId: user.id,
                teacherName: user.name,
                canManage: false,
              );
              await cubit.load();
            },
            child: Row(
              children: [
                Icon(
                  s.isEnrolled
                      ? Icons.verified_user_outlined
                      : Icons.face_retouching_natural,
                  color: s.isEnrolled ? AppColors.present : AppColors.late,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.faceTitle, style: context.text.titleSmall),
                      Text(
                        s.isEnrolled ? l.faceStatusOn : l.faceNudgeSetUpPrompt,
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          );
        },
      ),
    );
  }
}
