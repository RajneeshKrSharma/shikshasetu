import 'package:equatable/equatable.dart';

import '../../../attendance/domain/entities/attendance_status.dart';

/// What is on record for one calendar day. [status] reuses the school-day
/// decision: approved is "school ran", rejected is "school was closed",
/// pending is "nothing recorded".
class SchoolDay extends Equatable {
  const SchoolDay({
    required this.day,
    required this.status,
    this.reason,
    this.decidedBy,
    this.decidedAt,
    this.isHoliday = false,
  });

  final DateTime day;
  final SchoolDayStatus status;

  /// Why the Principal marked it so (required for edits made on the calendar).
  final String? reason;
  final String? decidedBy;
  final DateTime? decidedAt;

  /// A closed day that is on the planned holiday list (as opposed to one
  /// closed for rain, a strike or the like).
  final bool isHoliday;

  bool get isOpen => status == SchoolDayStatus.approved;
  bool get isClosed => status == SchoolDayStatus.rejected;
  bool get hasRecord => status != SchoolDayStatus.pending;

  @override
  List<Object?> get props => [
    day,
    status,
    reason,
    decidedBy,
    decidedAt,
    isHoliday,
  ];
}

/// One edit of a day, kept so changes can be traced.
class SchoolDayChange extends Equatable {
  const SchoolDayChange({
    required this.day,
    required this.from,
    required this.to,
    required this.changedAt,
    this.reason,
    this.changedByName,
  });

  final DateTime day;
  final SchoolDayStatus from;
  final SchoolDayStatus to;
  final DateTime changedAt;
  final String? reason;
  final String? changedByName;

  @override
  List<Object?> get props => [day, from, to, changedAt, reason, changedByName];
}

/// How many days of each kind a stretch of the calendar holds.
class CalendarCounts extends Equatable {
  const CalendarCounts({this.open = 0, this.closed = 0, this.noRecord = 0});

  /// Days school ran.
  final int open;

  /// Days school was marked closed.
  final int closed;

  /// Past working days (Monday to Saturday) with nothing recorded.
  final int noRecord;

  @override
  List<Object?> get props => [open, closed, noRecord];
}

/// A month of the calendar and the totals shown with it.
class CalendarMonth extends Equatable {
  const CalendarMonth({
    required this.month,
    required this.days,
    required this.monthCounts,
    required this.yearCounts,
    required this.yearStart,
    this.schoolStart,
  });

  /// The first day of the month.
  final DateTime month;

  /// Recorded days of the month, by day.
  final Map<DateTime, SchoolDay> days;
  final CalendarCounts monthCounts;

  /// From [yearStart] (the start of the academic year) to today.
  final CalendarCounts yearCounts;
  final DateTime yearStart;

  /// The day the school was registered; nothing before it is on the calendar.
  final DateTime? schoolStart;

  /// Whether the month before this one is within the calendar.
  bool get hasPreviousMonth =>
      schoolStart == null ||
      DateTime(
        month.year,
        month.month,
      ).isAfter(DateTime(schoolStart!.year, schoolStart!.month));

  SchoolDay dayOf(DateTime d) =>
      days[DateTime(d.year, d.month, d.day)] ??
      SchoolDay(
        day: DateTime(d.year, d.month, d.day),
        status: SchoolDayStatus.pending,
      );

  @override
  List<Object?> get props => [
    month,
    days,
    monthCounts,
    yearCounts,
    yearStart,
    schoolStart,
  ];
}

enum CalendarFailure { notAllowed, reasonRequired, invalidDates }

class CalendarException implements Exception {
  const CalendarException(this.failure);

  final CalendarFailure failure;

  @override
  String toString() => 'CalendarException($failure)';
}

/// The academic year the calendar counts over.
///
/// It runs from 1 April to 31 March, the usual Indian school year. This is an
/// assumption, not a school setting; change [startMonth] if yours differs.
class AcademicYear {
  AcademicYear._();

  static const startMonth = 4;

  /// The first day of the academic year that [now] falls in.
  static DateTime startFor(DateTime now) =>
      DateTime(now.month >= startMonth ? now.year : now.year - 1, startMonth);
}

/// One holiday as listed: a run of days with one reason (a single day, or a
/// vacation of several days).
class Holiday extends Equatable {
  const Holiday({required this.start, required this.end, required this.reason});

  final DateTime start;
  final DateTime end;
  final String reason;

  int get days => end.difference(start).inDays + 1;
  bool get isSingleDay => days == 1;

  /// Is [day] one of its days?
  bool covers(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  @override
  List<Object?> get props => [start, end, reason];
}

/// A holiday the Principal is adding: the dates (a single day when [end] is
/// the same as [start]) and why.
class HolidayEntry extends Equatable {
  const HolidayEntry({
    required this.start,
    required this.end,
    required this.reason,
  });

  final DateTime start;
  final DateTime end;
  final String reason;

  /// Every day of the holiday.
  List<DateTime> get days => [
    for (
      var d = DateTime(start.year, start.month, start.day);
      !d.isAfter(end);
      d = DateTime(d.year, d.month, d.day + 1)
    )
      d,
  ];

  @override
  List<Object?> get props => [start, end, reason];
}

/// What adding a list of holidays did.
class AddHolidaysResult extends Equatable {
  const AddHolidaysResult({required this.added, required this.skipped});

  /// Days put on the holiday list.
  final int added;

  /// Days left alone because school was already marked open on them.
  final int skipped;

  @override
  List<Object?> get props => [added, skipped];
}
