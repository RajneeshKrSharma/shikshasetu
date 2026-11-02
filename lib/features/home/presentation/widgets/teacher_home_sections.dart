import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../l10n/class_label.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_state.dart';
import '../../../attendance/presentation/screen/marking_screen.dart';
import '../../../question_bank/domain/entities/bank_scope.dart';
import '../../../question_bank/presentation/widgets/add_questions_sheet.dart';
import '../../../school_day/presentation/bloc/teacher_day_cubit.dart';
import '../../../school_day/presentation/widgets/school_day_widgets.dart';

/// "Class 4 attendance not marked  [Mark now]", or a calm line once done.
class TeacherClassAlert extends StatelessWidget {
  const TeacherClassAlert({super.key, required this.classSection});

  final String classSection;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        final marks = state.marksOf(classSection);
        final done = marks != null;
        final color = done ? AppColors.present : AppColors.late;
        return Container(
          width: double.infinity,
          padding: AppSpacing.card,
          decoration: BoxDecoration(
            color: done ? AppColors.presentLight : AppColors.lateLight,
            borderRadius: AppRadius.lgAll,
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      done
                          ? l.teacherClassMarked(l.classLabel(classSection))
                          : l.teacherClassNotMarked(l.classLabel(classSection)),
                      style: context.text.titleMedium,
                    ),
                    Text(
                      done
                          ? l.classPresentOfTotal(
                              state.classOf(classSection)?.presentCount ?? 0,
                              marks.length,
                            )
                          : l.teacherClassStudents(
                              state.studentsOf(classSection).length,
                            ),
                      style: context.text.bodySmall!.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!done)
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, AppSizes.buttonCompact),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                  ),
                  onPressed: () => MarkingScreen.open(context, classSection),
                  child: Text(l.teacherMarkNow),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Today's periods of the teacher, each with a shortcut to add a question,
/// and the assembly duty when it is theirs today.
class TeacherDaySection extends StatelessWidget {
  const TeacherDaySection({super.key, required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<TeacherDayCubit, TeacherDayState>(
      builder: (context, state) {
        final day = state.day;
        if (day == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (day.assemblyDuty != null) ...[
              AppCard(
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: context.brand.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.teacherAssemblyDuty(
                              formatWeekdayShort(context, DateTime.now()),
                            ),
                            style: context.text.titleSmall,
                          ),
                          Text(
                            l.teacherAssemblyDutyLine(
                              day.assemblyDuty!.className == null
                                  ? ''
                                  : l.classLabel(day.assemblyDuty!.className!),
                              formatDayTime(context, day.assemblyStart),
                            ),
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            SectionLabel(l.teacherTodayPeriods),
            if (day.periods.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(l.teacherNoPeriods, style: context.text.bodySmall),
              )
            else
              for (final p in day.periods)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${l.classLabel(p.className)} · ${p.subject}'),
                  subtitle: Text(
                    '${formatDayTime(context, p.slot.start)} – '
                    '${formatDayTime(context, p.slot.end)}',
                  ),
                  trailing: TextButton(
                    onPressed: () => AddQuestionsSheet.show(
                      context,
                      BankScope(
                        teacherId: teacherId,
                        classSection: p.className,
                        subject: p.subject,
                      ),
                    ),
                    child: Text(l.teacherAddQuestion),
                  ),
                ),
          ],
        );
      },
    );
  }
}
