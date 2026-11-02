import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../entities/calendar_entities.dart';
import '../repository/school_calendar_repository.dart';

class GetCalendarMonthParams extends Equatable {
  const GetCalendarMonthParams(this.month, this.today);

  /// Any day of the month wanted.
  final DateTime month;
  final DateTime today;

  @override
  List<Object?> get props => [month, today];
}

/// A month of the calendar with its totals, and the totals for the academic
/// year so far.
class GetCalendarMonth
    implements UseCase<CalendarMonth, GetCalendarMonthParams> {
  const GetCalendarMonth(this._repository);

  final SchoolCalendarRepository _repository;

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Future<CalendarMonth> call(GetCalendarMonthParams p) async {
    final first = DateTime(p.month.year, p.month.month);
    final last = DateTime(p.month.year, p.month.month + 1, 0);
    final today = _day(p.today);
    final start = await _repository.schoolStart();
    var yearStart = AcademicYear.startFor(today);
    // Counting begins on the day the school was registered.
    if (start != null && start.isAfter(yearStart)) yearStart = start;

    final monthDays = await _repository.days(first, last);
    final yearDays = await _repository.days(yearStart, today);

    return CalendarMonth(
      month: first,
      days: {for (final d in monthDays) d.day: d},
      monthCounts: _counts(
        monthDays,
        start != null && start.isAfter(first) ? start : first,
        last.isAfter(today) ? today : last,
      ),
      yearCounts: _counts(yearDays, yearStart, today),
      yearStart: yearStart,
      schoolStart: start,
    );
  }

  /// Open and closed days among [records], and the working days from [from]
  /// to [to] that have no record. Sundays are the weekly off and not counted.
  CalendarCounts _counts(List<SchoolDay> records, DateTime from, DateTime to) {
    var open = 0, closed = 0;
    final recorded = <DateTime>{};
    for (final r in records) {
      if (r.isOpen) open++;
      if (r.isClosed) closed++;
      if (r.hasRecord) recorded.add(r.day);
    }
    var noRecord = 0;
    for (
      var d = from;
      !d.isAfter(to);
      d = DateTime(d.year, d.month, d.day + 1)
    ) {
      if (d.weekday != DateTime.sunday && !recorded.contains(d)) noRecord++;
    }
    return CalendarCounts(open: open, closed: closed, noRecord: noRecord);
  }
}

class EditSchoolDayParams extends Equatable {
  const EditSchoolDayParams({
    required this.day,
    required this.status,
    required this.reason,
    required this.changedBy,
    required this.isPrincipal,
    required this.at,
  });

  final DateTime day;
  final SchoolDayStatus status;
  final String reason;
  final String changedBy;

  /// Only the Principal may edit the calendar.
  final bool isPrincipal;
  final DateTime at;

  @override
  List<Object?> get props => [day, status, reason, changedBy, isPrincipal, at];
}

/// The Principal marks a day open, closed, or clears it, giving a reason.
/// Throws [CalendarException] for anyone else, or with no reason.
class EditSchoolDay implements UseCase<void, EditSchoolDayParams> {
  const EditSchoolDay(this._repository);

  final SchoolCalendarRepository _repository;

  /// Shortest reason accepted.
  static const minReasonLength = 3;

  @override
  Future<void> call(EditSchoolDayParams p) {
    if (!p.isPrincipal) {
      throw const CalendarException(CalendarFailure.notAllowed);
    }
    final reason = p.reason.trim();
    if (reason.length < minReasonLength) {
      throw const CalendarException(CalendarFailure.reasonRequired);
    }
    return _repository.setDay(
      day: DateTime(p.day.year, p.day.month, p.day.day),
      status: p.status,
      reason: reason,
      changedBy: p.changedBy,
      at: p.at,
    );
  }
}

class GetSchoolDayHistory implements UseCase<List<SchoolDayChange>, DateTime> {
  const GetSchoolDayHistory(this._repository);

  final SchoolCalendarRepository _repository;

  @override
  Future<List<SchoolDayChange>> call(DateTime day) => _repository.history(day);
}
