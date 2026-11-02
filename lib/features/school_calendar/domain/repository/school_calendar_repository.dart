import '../../../attendance/domain/entities/attendance_status.dart';
import '../entities/calendar_entities.dart';

abstract interface class SchoolCalendarRepository {
  /// The day the school was registered in the app, which is where the calendar
  /// starts for the Principal and the teachers; null when not known.
  Future<DateTime?> schoolStart();

  /// What is recorded for the days from [start] to [end], both included.
  Future<List<SchoolDay>> days(DateTime start, DateTime end);

  /// Records [status] for [day] with the Principal's [reason], and logs the
  /// change. [SchoolDayStatus.pending] clears the day.
  Future<void> setDay({
    required DateTime day,
    required SchoolDayStatus status,
    required String reason,
    required String changedBy,
    required DateTime at,
  });

  /// Every closed day, which is the holiday list, oldest first.
  Future<List<SchoolDay>> holidayDays();

  /// Puts the holidays on the list in one go: each day becomes a closed
  /// holiday with its reason, and the change is logged. A day school was
  /// already marked open on is left alone and counted as skipped.
  Future<AddHolidaysResult> addHolidays({
    required List<HolidayEntry> holidays,
    required String changedBy,
    required DateTime at,
  });

  /// The edits made to [day], newest first.
  Future<List<SchoolDayChange>> history(DateTime day);
}
