import '../../../../core/server/json.dart';
import '../../domain/entities/attendance.dart';

class AttendanceModels {
  const AttendanceModels._();

  static RosterLine rosterLine(Json j) => RosterLine(
    studentId: j.string('student_id'),
    name: j.string('name'),
    rollNumber: j.string('roll_number'),
    mark: StudentMark.fromCode(j.stringOrNull('status')),
  );

  static StudentTally tally(Json j) => StudentTally(
    studentId: j.string('student_id'),
    name: j.string('name'),
    rollNumber: j.string('roll_number'),
    present: j.integer('present'),
    late: j.integer('late'),
    absent: j.integer('absent'),
  );

  static WorkRecord record(Json j) => WorkRecord(
    id: j.string('id'),
    personId: j.string('person_id'),
    personName: j.string('person_name'),
    day: j.day('day'),
    checkedInAt: j.minuteOrNull('checked_in_at') ?? 0,
    checkedOutAt: j.minuteOrNull('checked_out_at'),
    late: j.string('status') == 'late',
    corrected: j.stringOrNull('corrected_by_id') != null,
  );

  static DayBoard board(Json j) => DayBoard(
    day: j.day('day'),
    isHoliday: j.flag('is_holiday'),
    people: [
      for (final p in j.list('people'))
        BoardLine(
          personId: p.string('person_id'),
          name: p.string('name'),
          role: p.string('role'),
          status: DayStatus.fromCode(p.stringOrNull('status')),
          checkedInAt: p.minuteOrNull('checked_in_at'),
          checkedOutAt: p.minuteOrNull('checked_out_at'),
        ),
    ],
  );
}
