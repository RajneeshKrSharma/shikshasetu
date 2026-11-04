import '../../../../core/server/json.dart';
import '../../../exams/domain/entities/exams.dart';
import '../../domain/entities/timetable.dart';

/// Timetable settings and papers, as the server writes and reads them.
class TimetableModels {
  const TimetableModels._();

  static TimetableSettings settings(Json j) {
    final labels = j.object('type_labels') ?? const <String, dynamic>{};
    return TimetableSettings(
      defaultMaxMarks: j.integer('default_max_marks'),
      defaultDurationMinutes: j.integer('default_duration_minutes'),
      defaultStartMinutes: j.minuteOrNull('default_start_time'),
      showTime: j.flag('show_time', otherwise: true),
      sameDayRule: SameDayRule.fromCode(j.stringOrNull('same_day_rule')),
      minGapDays: j.integer('min_gap_days'),
      offWeekdays: [
        for (final d in (j['off_weekdays'] as List? ?? const []))
          (d as num).toInt(),
      ],
      offDates: [for (final d in j.strings('off_dates')) _day(d)],
      typeLabels: {
        for (final t in ExamType.values) t: '${labels[t.code] ?? t.code}',
      },
    );
  }

  static Map<String, Object?> settingsBody(TimetableSettings s) => {
    'default_max_marks': s.defaultMaxMarks,
    'default_duration_minutes': s.defaultDurationMinutes,
    'default_start_time': s.defaultStartMinutes == null
        ? null
        : WireFormat.minutes(s.defaultStartMinutes!),
    'show_time': s.showTime,
    'same_day_rule': s.sameDayRule.code,
    'min_gap_days': s.minGapDays,
    'off_weekdays': s.offWeekdays,
    'off_dates': [for (final d in s.offDates) WireFormat.day(d)],
    'type_labels': {
      for (final e in s.typeLabels.entries) e.key.code: e.value.trim(),
    },
  };

  static Map<String, Object?> timetableBody(TimetableDraft d) => {
    'exam_type': d.type.code,
    'class_id': d.classId,
    'entries': [
      for (final r in d.scheduled)
        {
          'subject': r.subject,
          'held_on': WireFormat.day(r.heldOn!),
          'max_marks': r.maxMarks,
          'starts_at': r.startsAtMinutes == null
              ? null
              : WireFormat.minutes(r.startsAtMinutes!),
          'duration_minutes': r.durationMinutes,
        },
    ],
  };

  static DateTime _day(String value) {
    final parts = value.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
