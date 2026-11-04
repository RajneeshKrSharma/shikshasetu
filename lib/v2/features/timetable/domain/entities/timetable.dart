import 'package:equatable/equatable.dart';

import '../../../exams/domain/entities/exams.dart';

/// What to do when a class would sit two papers on one day.
enum SameDayRule {
  allow('allow'),
  warn('warn'),
  block('block');

  const SameDayRule(this.code);

  final String code;

  static SameDayRule fromCode(String? code) {
    for (final r in values) {
      if (r.code == code) return r;
    }
    return SameDayRule.warn;
  }
}

/// How the Principal wants exam timetables made; one set for the school.
class TimetableSettings extends Equatable {
  const TimetableSettings({
    required this.defaultMaxMarks,
    required this.defaultDurationMinutes,
    required this.defaultStartMinutes,
    required this.showTime,
    required this.sameDayRule,
    required this.minGapDays,
    required this.offWeekdays,
    required this.offDates,
    required this.typeLabels,
  });

  final int defaultMaxMarks;
  final int defaultDurationMinutes;

  /// Minutes since midnight; null until the Principal sets one.
  final int? defaultStartMinutes;
  final bool showTime;
  final SameDayRule sameDayRule;
  final int minGapDays;

  /// Weekly holidays, Monday as 0 up to Sunday as 6 (the server's numbering).
  final List<int> offWeekdays;
  final List<DateTime> offDates;
  final Map<ExamType, String> typeLabels;

  /// What the school calls [type], such as "Half Yearly".
  String labelOf(ExamType type) => typeLabels[type] ?? type.code;

  bool isOffDay(DateTime day) =>
      offWeekdays.contains(day.weekday - 1) ||
      offDates.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      );

  /// [from], or the first day after it that is not a holiday.
  DateTime firstOpenDay(DateTime from) {
    var day = DateTime(from.year, from.month, from.day);
    for (var i = 0; i < 400 && isOffDay(day); i++) {
      day = DateTime(day.year, day.month, day.day + 1);
    }
    return day;
  }

  TimetableSettings copyWith({
    int? defaultMaxMarks,
    int? defaultDurationMinutes,
    int? defaultStartMinutes,
    bool clearDefaultStart = false,
    bool? showTime,
    SameDayRule? sameDayRule,
    int? minGapDays,
    List<int>? offWeekdays,
    List<DateTime>? offDates,
    Map<ExamType, String>? typeLabels,
  }) => TimetableSettings(
    defaultMaxMarks: defaultMaxMarks ?? this.defaultMaxMarks,
    defaultDurationMinutes:
        defaultDurationMinutes ?? this.defaultDurationMinutes,
    defaultStartMinutes: clearDefaultStart
        ? null
        : (defaultStartMinutes ?? this.defaultStartMinutes),
    showTime: showTime ?? this.showTime,
    sameDayRule: sameDayRule ?? this.sameDayRule,
    minGapDays: minGapDays ?? this.minGapDays,
    offWeekdays: offWeekdays ?? this.offWeekdays,
    offDates: offDates ?? this.offDates,
    typeLabels: typeLabels ?? this.typeLabels,
  );

  @override
  List<Object?> get props => [
    defaultMaxMarks,
    defaultDurationMinutes,
    defaultStartMinutes,
    showTime,
    sameDayRule,
    minGapDays,
    offWeekdays,
    offDates,
    typeLabels,
  ];
}

/// One subject's line in a timetable being made. A line without a date is
/// skipped; what is left empty falls back to the settings on the server.
class TimetableRow extends Equatable {
  const TimetableRow({
    required this.subject,
    this.heldOn,
    this.maxMarks,
    this.startsAtMinutes,
    this.durationMinutes,
  });

  final String subject;
  final DateTime? heldOn;
  final int? maxMarks;
  final int? startsAtMinutes;
  final int? durationMinutes;

  bool get isScheduled => heldOn != null;

  TimetableRow copyWith({
    DateTime? heldOn,
    bool clearDate = false,
    int? maxMarks,
    bool clearMarks = false,
    int? startsAtMinutes,
    bool clearStart = false,
    int? durationMinutes,
    bool clearDuration = false,
  }) => TimetableRow(
    subject: subject,
    heldOn: clearDate ? null : (heldOn ?? this.heldOn),
    maxMarks: clearMarks ? null : (maxMarks ?? this.maxMarks),
    startsAtMinutes: clearStart
        ? null
        : (startsAtMinutes ?? this.startsAtMinutes),
    durationMinutes: clearDuration
        ? null
        : (durationMinutes ?? this.durationMinutes),
  );

  @override
  List<Object?> get props => [
    subject,
    heldOn,
    maxMarks,
    startsAtMinutes,
    durationMinutes,
  ];
}

/// A class's whole timetable for one exam, as the Principal fills it.
class TimetableDraft extends Equatable {
  const TimetableDraft({
    required this.type,
    required this.classId,
    required this.rows,
  });

  final ExamType type;
  final String classId;
  final List<TimetableRow> rows;

  /// Only the lines that were given a date.
  List<TimetableRow> get scheduled => [
    for (final r in rows)
      if (r.isScheduled) r,
  ];

  @override
  List<Object?> get props => [type, classId, rows];
}
