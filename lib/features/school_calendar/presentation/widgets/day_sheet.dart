import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../domain/entities/calendar_entities.dart';
import '../bloc/day_detail_cubit.dart';

/// What the Principal chose to do with a day.
enum DayAction { open, closed, clear }

extension SchoolDayStatusText on SchoolDayStatus {
  String label(AppLocalizations l) => switch (this) {
    SchoolDayStatus.approved => l.calendarOpen,
    SchoolDayStatus.rejected => l.calendarClosed,
    SchoolDayStatus.pending => l.calendarNoRecord,
  };

  Color get color => switch (this) {
    SchoolDayStatus.approved => AppColors.present,
    SchoolDayStatus.rejected => AppColors.absent,
    SchoolDayStatus.pending => AppColors.pending,
  };

  Color get background => switch (this) {
    SchoolDayStatus.approved => AppColors.presentLight,
    SchoolDayStatus.rejected => AppColors.absentLight,
    SchoolDayStatus.pending => AppColors.pendingLight,
  };
}

/// One day's details: whether school ran, why, who marked it and when, and the
/// history of edits. The Principal also gets the buttons to change it.
class DaySheet extends StatelessWidget {
  const DaySheet({super.key, required this.record, required this.canEdit});

  final SchoolDay record;
  final bool canEdit;

  /// Shows the sheet; pops with the action chosen, if any.
  static Future<DayAction?> show(
    BuildContext context, {
    required SchoolDay record,
    required bool canEdit,
  }) => showModalBottomSheet<DayAction>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => BlocProvider(
      create: (_) => sl<DayDetailCubit>(param1: record.day)..load(),
      child: DaySheet(record: record, canEdit: canEdit),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sunday = record.day.weekday == DateTime.sunday;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatLongDate(context, record.day),
                    style: context.text.titleMedium,
                  ),
                ),
                StatusChip(
                  label: record.isHoliday
                      ? l.calendarHoliday
                      : record.status.label(l),
                  color: record.isHoliday
                      ? context.brand.primary
                      : record.status.color,
                  background: record.isHoliday
                      ? context.brand.primaryLight
                      : record.status.background,
                ),
              ],
            ),
            if (sunday && !record.hasRecord) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l.calendarWeeklyOff, style: context.text.bodySmall),
            ],
            BlocBuilder<DayDetailCubit, DayDetailState>(
              buildWhen: (a, b) => a.holiday != b.holiday,
              builder: (context, s) {
                final h = s.holiday;
                if (h == null || h.isSingleDay) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Text(
                    '${formatDateRange(context, DateTimeRange(start: h.start, end: h.end))}'
                    '  ·  ${l.holidayDays(h.days)}',
                    style: context.text.titleSmall!.copyWith(
                      color: context.brand.primary,
                    ),
                  ),
                );
              },
            ),
            if (record.hasRecord) ...[
              const SizedBox(height: AppSpacing.lg),
              if (record.isHoliday && (record.reason ?? '').isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xl,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lateLight,
                    borderRadius: AppRadius.mdAll,
                    border: Border.all(
                      color: AppColors.late.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.celebration,
                        size: AppIconSize.xl,
                        color: AppColors.late,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          record.reason!,
                          style: context.text.headlineSmall!.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  (record.reason ?? '').isEmpty
                      ? l.calendarNoReason
                      : l.calendarReason(record.reason!),
                  style: context.text.bodyLarge,
                ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ListHeader(
              title: l.calendarHistory,
              count: context.select(
                (DayDetailCubit c) => c.state.history.length,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            BlocBuilder<DayDetailCubit, DayDetailState>(
              builder: (context, s) {
                if (s.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (s.history.isEmpty) {
                  return Text(
                    l.calendarNoHistory,
                    style: context.text.bodySmall,
                  );
                }
                return Column(
                  children: [
                    for (final c in s.history)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.history,
                              size: AppIconSize.md,
                              color: c.to.color,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${c.from.label(l)} → ${c.to.label(l)}',
                                    style: context.text.titleSmall,
                                  ),
                                  if ((c.reason ?? '').isNotEmpty)
                                    Text(
                                      l.calendarReason(c.reason!),
                                      style: context.text.bodyMedium,
                                    ),
                                  Text(
                                    l.calendarMarkedBy(
                                      c.changedByName ?? '–',
                                      '${formatShortDate(context, c.changedAt)}, '
                                      '${formatTime(context, c.changedAt)}',
                                    ),
                                    style: context.text.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            if (canEdit) ...[
              const SizedBox(height: AppSpacing.md),
              if (!record.isOpen)
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(DayAction.open),
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(l.calendarMarkOpen),
                ),
              if (!record.isOpen && !record.isClosed)
                const SizedBox(height: AppSpacing.md),
              if (!record.isClosed)
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(DayAction.closed),
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text(l.calendarMarkClosed),
                ),
              if (record.hasRecord) ...[
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(DayAction.clear),
                  child: Text(l.calendarClearDay),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
