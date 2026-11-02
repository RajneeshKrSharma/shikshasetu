import 'package:equatable/equatable.dart';

import 'bell_slot.dart';

/// What one class has in one period of one weekday.
class TimetableEntry extends Equatable {
  const TimetableEntry({
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

  @override
  List<Object?> get props => [
    className,
    weekday,
    slotId,
    subject,
    teacherId,
    teacherName,
  ];
}

/// A class's whole week: the school's periods, and what is in each.
class ClassTimetable extends Equatable {
  const ClassTimetable({
    required this.className,
    required this.slots,
    required this.entries,
  });

  final String className;
  final List<BellSlot> slots;
  final List<TimetableEntry> entries;

  TimetableEntry? entryOf(int weekday, String slotId) {
    for (final e in entries) {
      if (e.weekday == weekday && e.slotId == slotId) return e;
    }
    return null;
  }

  @override
  List<Object?> get props => [className, slots, entries];
}

/// Who teaches what in a class, to choose from when filling a period.
class TeachingOption extends Equatable {
  const TeachingOption({
    required this.subject,
    required this.teacherId,
    required this.teacherName,
  });

  final String subject;
  final String teacherId;
  final String teacherName;

  @override
  List<Object?> get props => [subject, teacherId, teacherName];
}

/// The teacher is already teaching another class in that period.
class TimetableConflict implements Exception {
  const TimetableConflict({
    required this.teacherName,
    required this.className,
    required this.weekday,
    required this.slot,
  });

  final String teacherName;
  final String className;
  final int weekday;
  final BellSlot slot;
}

/// How copying one day to others went.
class CopyResult extends Equatable {
  const CopyResult({required this.copied, required this.skipped});

  final int copied;

  /// Periods left out because their teacher was busy elsewhere.
  final int skipped;

  @override
  List<Object?> get props => [copied, skipped];
}

/// One period a teacher teaches on a day.
class TeacherPeriod extends Equatable {
  const TeacherPeriod({
    required this.slot,
    required this.number,
    required this.className,
    required this.subject,
  });

  final BellSlot slot;

  /// Its number among the periods of the day.
  final int number;
  final String className;
  final String subject;

  @override
  List<Object?> get props => [slot, number, className, subject];
}
