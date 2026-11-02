import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../entities/calendar_entities.dart';
import '../repository/school_calendar_repository.dart';
import 'calendar_usecases.dart';

/// The holiday list: consecutive days with the same reason are one holiday
/// ("5 to 9 November, Diwali vacation"), oldest first.
class GetHolidays implements UseCase<List<Holiday>, NoParams> {
  const GetHolidays(this._repository);

  final SchoolCalendarRepository _repository;

  @override
  Future<List<Holiday>> call(NoParams params) async {
    final days = await _repository.holidayDays();
    final holidays = <Holiday>[];
    DateTime? start;
    DateTime? last;
    String? reason;
    void close() {
      if (start != null) {
        holidays.add(Holiday(start: start, end: last!, reason: reason!));
      }
    }

    for (final d in days) {
      final r = (d.reason ?? '').trim();
      final continues =
          last != null &&
          DateTime(last.year, last.month, last.day + 1) == d.day &&
          r.toLowerCase() == reason!.toLowerCase();
      if (continues) {
        last = d.day;
      } else {
        close();
        start = d.day;
        last = d.day;
        reason = r;
      }
    }
    close();
    return holidays;
  }
}

class AddHolidaysParams extends Equatable {
  const AddHolidaysParams({
    required this.holidays,
    required this.changedBy,
    required this.isPrincipal,
    required this.at,
  });

  final List<HolidayEntry> holidays;
  final String changedBy;
  final bool isPrincipal;
  final DateTime at;

  @override
  List<Object?> get props => [holidays, changedBy, isPrincipal, at];
}

/// The Principal adds a whole list of holidays at once, each with its dates
/// and reason. Throws [CalendarException] for anyone else, for a missing
/// reason, or for dates that make no sense.
class AddHolidays implements UseCase<AddHolidaysResult, AddHolidaysParams> {
  const AddHolidays(this._repository);

  final SchoolCalendarRepository _repository;

  /// The longest a single holiday may run (a vacation is days or weeks).
  static const maxDays = 120;

  @override
  Future<AddHolidaysResult> call(AddHolidaysParams p) {
    if (!p.isPrincipal) {
      throw const CalendarException(CalendarFailure.notAllowed);
    }
    if (p.holidays.isEmpty) {
      throw const CalendarException(CalendarFailure.invalidDates);
    }
    final cleaned = <HolidayEntry>[];
    for (final h in p.holidays) {
      final reason = h.reason.trim();
      if (reason.length < EditSchoolDay.minReasonLength) {
        throw const CalendarException(CalendarFailure.reasonRequired);
      }
      final start = DateTime(h.start.year, h.start.month, h.start.day);
      final end = DateTime(h.end.year, h.end.month, h.end.day);
      if (end.isBefore(start) || end.difference(start).inDays + 1 > maxDays) {
        throw const CalendarException(CalendarFailure.invalidDates);
      }
      cleaned.add(HolidayEntry(start: start, end: end, reason: reason));
    }
    return _repository.addHolidays(
      holidays: cleaned,
      changedBy: p.changedBy,
      at: p.at,
    );
  }
}

class RemoveHolidayParams extends Equatable {
  const RemoveHolidayParams({
    required this.holiday,
    required this.reason,
    required this.changedBy,
    required this.isPrincipal,
    required this.at,
  });

  final Holiday holiday;
  final String reason;
  final String changedBy;
  final bool isPrincipal;
  final DateTime at;

  @override
  List<Object?> get props => [holiday, reason, changedBy, isPrincipal, at];
}

/// The Principal takes a holiday off the list (its days go back to "no
/// record"), giving a reason. Throws [CalendarException].
class RemoveHoliday implements UseCase<void, RemoveHolidayParams> {
  const RemoveHoliday(this._repository);

  final SchoolCalendarRepository _repository;

  @override
  Future<void> call(RemoveHolidayParams p) async {
    if (!p.isPrincipal) {
      throw const CalendarException(CalendarFailure.notAllowed);
    }
    final reason = p.reason.trim();
    if (reason.length < EditSchoolDay.minReasonLength) {
      throw const CalendarException(CalendarFailure.reasonRequired);
    }
    for (
      var d = p.holiday.start;
      !d.isAfter(p.holiday.end);
      d = DateTime(d.year, d.month, d.day + 1)
    ) {
      await _repository.setDay(
        day: d,
        status: SchoolDayStatus.pending,
        reason: reason,
        changedBy: p.changedBy,
        at: p.at,
      );
    }
  }
}
