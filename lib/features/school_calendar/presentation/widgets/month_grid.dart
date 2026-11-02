import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../domain/entities/calendar_entities.dart';

/// A month as a grid of days, Sunday first. School days are green, closed
/// days red, working days with nothing recorded plain, Sundays muted; today is
/// ringed, and a dot marks a day that has a reason noted.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.data,
    required this.today,
    required this.onDayTap,
  });

  final CalendarMonth data;
  final DateTime today;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final first = data.month;
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    // Sunday is column 0: DateTime.sunday is 7, so 7 % 7 = 0.
    final lead = first.weekday % 7;
    final cells = lead + daysInMonth;
    final rows = (cells / 7).ceil();
    final locale = Localizations.localeOf(context).toString();
    // Any week's days in order, only to read the localized short names.
    final weekdayNames = DateFormat.E(locale);
    final sunday = DateTime(2024, 1, 7);

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: Text(
                    weekdayNames
                        .format(sunday.add(Duration(days: i)))
                        .toUpperCase(),
                    style: context.text.labelSmall!.copyWith(
                      color: i == 0 ? AppColors.absent : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (var r = 0; r < rows; r++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                for (var c = 0; c < 7; c++)
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final n = r * 7 + c - lead + 1;
                        if (n < 1 || n > daysInMonth) {
                          return const AspectRatio(aspectRatio: 1);
                        }
                        final date = DateTime(first.year, first.month, n);
                        // Holidays side by side in a week are one band.
                        bool holiday(int day, int col) =>
                            col >= 0 &&
                            col < 7 &&
                            day >= 1 &&
                            day <= daysInMonth &&
                            _isHoliday(
                              data.dayOf(
                                DateTime(first.year, first.month, day),
                              ),
                            );
                        final record = data.dayOf(date);
                        final isHoliday = _isHoliday(record);
                        return _DayCell(
                          date: date,
                          record: record,
                          joinLeft: isHoliday && holiday(n - 1, c - 1),
                          joinRight: isHoliday && holiday(n + 1, c + 1),
                          isToday:
                              date.year == today.year &&
                              date.month == today.month &&
                              date.day == today.day,
                          onTap: () => onDayTap(date),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

bool _isHoliday(SchoolDay d) =>
    d.status == SchoolDayStatus.rejected && d.isHoliday;

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.record,
    required this.joinLeft,
    required this.joinRight,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final SchoolDay record;

  /// The neighbouring day in the same week is also a holiday, so this cell
  /// continues the band instead of ending it.
  final bool joinLeft;
  final bool joinRight;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sunday = date.weekday == DateTime.sunday;
    final (bg, fg) = switch (record.status) {
      SchoolDayStatus.approved => (AppColors.presentLight, AppColors.present),
      // A day on the holiday list is told apart from one closed for another
      // reason.
      SchoolDayStatus.rejected when record.isHoliday => (
        context.brand.primaryLight,
        context.brand.primary,
      ),
      SchoolDayStatus.rejected => (AppColors.absentLight, AppColors.absent),
      SchoolDayStatus.pending => (
        sunday ? AppColors.pendingLight : AppColors.surface,
        sunday ? AppColors.textMuted : AppColors.textPrimary,
      ),
    };
    final holiday = _isHoliday(record);
    const radius = Radius.circular(12);
    final shape = holiday
        ? BorderRadius.horizontal(
            left: joinLeft ? Radius.zero : radius,
            right: joinRight ? Radius.zero : radius,
          )
        : AppRadius.mdAll;
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(joinLeft ? 0 : 2, 2, joinRight ? 0 : 2, 2),
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: shape,
            side: isToday
                ? BorderSide(color: context.brand.primary, width: 2)
                : holiday
                ? BorderSide.none
                : BorderSide(
                    color: record.hasRecord
                        ? fg.withValues(alpha: 0.35)
                        : AppColors.border,
                  ),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(borderRadius: shape),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: context.text.titleSmall!.copyWith(
                    color: fg,
                    fontWeight: isToday ? FontWeight.bold : null,
                  ),
                ),
                if (record.hasRecord &&
                    (record.reason ?? '').isNotEmpty &&
                    !joinLeft)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: fg,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
