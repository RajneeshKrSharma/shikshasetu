/// A row of the `school_timings` table. [classNames] is a JSON list, or null
/// for every class.
class TimingRuleDto {
  const TimingRuleDto({
    required this.id,
    required this.startMin,
    required this.endMin,
    this.classNames,
    this.fromDate,
  });

  final String id;
  final int startMin;
  final int endMin;
  final String? classNames;
  final int? fromDate;

  factory TimingRuleDto.fromMap(Map<String, Object?> m) => TimingRuleDto(
    id: m['id']! as String,
    startMin: m['start_min']! as int,
    endMin: m['end_min']! as int,
    classNames: m['class_names'] as String?,
    fromDate: m['from_date'] as int?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'class_names': classNames,
    'start_min': startMin,
    'end_min': endMin,
    'from_date': fromDate,
  };
}

/// A row of the `bell_slots` table.
class BellSlotDto {
  const BellSlotDto({
    required this.id,
    required this.position,
    required this.kind,
    required this.label,
    required this.startMin,
    required this.endMin,
  });

  final String id;
  final int position;
  final String kind;
  final String label;
  final int startMin;
  final int endMin;

  factory BellSlotDto.fromMap(Map<String, Object?> m) => BellSlotDto(
    id: m['id']! as String,
    position: m['position']! as int,
    kind: m['kind']! as String,
    label: m['label']! as String,
    startMin: m['start_min']! as int,
    endMin: m['end_min']! as int,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'position': position,
    'kind': kind,
    'label': label,
    'start_min': startMin,
    'end_min': endMin,
  };
}

/// A row of the `assembly_duty` table, with the teacher's name when joined.
class AssemblyDutyDto {
  const AssemblyDutyDto({
    required this.weekday,
    this.className,
    this.teacherId,
    this.teacherName,
  });

  final int weekday;
  final String? className;
  final String? teacherId;
  final String? teacherName;

  factory AssemblyDutyDto.fromMap(Map<String, Object?> m) => AssemblyDutyDto(
    weekday: m['weekday']! as int,
    className: m['class_name'] as String?,
    teacherId: m['teacher_id'] as String?,
    teacherName: m['teacher_name'] as String?,
  );

  Map<String, Object?> toMap() => {
    'weekday': weekday,
    'class_name': className,
    'teacher_id': teacherId,
  };
}

/// A row of the `timetable_entries` table, with the teacher's name when joined.
class TimetableEntryDto {
  const TimetableEntryDto({
    required this.className,
    required this.weekday,
    required this.slotId,
    required this.subject,
    this.teacherId,
    this.teacherName,
  });

  final String className;
  final int weekday;
  final String slotId;
  final String subject;
  final String? teacherId;
  final String? teacherName;

  factory TimetableEntryDto.fromMap(Map<String, Object?> m) =>
      TimetableEntryDto(
        className: m['class_name']! as String,
        weekday: m['weekday']! as int,
        slotId: m['slot_id']! as String,
        subject: m['subject']! as String,
        teacherId: m['teacher_id'] as String?,
        teacherName: m['teacher_name'] as String?,
      );

  Map<String, Object?> toMap() => {
    'class_name': className,
    'weekday': weekday,
    'slot_id': slotId,
    'subject': subject,
    'teacher_id': teacherId,
  };
}
