import 'dart:convert';

import '../../domain/entities/assembly.dart';
import '../../domain/entities/bell_slot.dart';
import '../../domain/entities/day_time.dart';
import '../../domain/entities/school_timing.dart';
import '../../domain/entities/timetable.dart';
import '../dto/school_day_dto.dart';

class TimingRuleModel extends TimingRule {
  const TimingRuleModel({
    required super.id,
    required super.start,
    required super.end,
    super.classNames,
    super.fromDate,
  });

  factory TimingRuleModel.fromDto(TimingRuleDto d) => TimingRuleModel(
    id: d.id,
    start: DayTime(d.startMin),
    end: DayTime(d.endMin),
    classNames: d.classNames == null
        ? const []
        : [for (final c in jsonDecode(d.classNames!) as List) '$c'],
    fromDate: d.fromDate == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.fromDate!),
  );

  static TimingRuleDto toDto(TimingRule r) => TimingRuleDto(
    id: r.id,
    startMin: r.start.minutes,
    endMin: r.end.minutes,
    classNames: r.classNames.isEmpty ? null : jsonEncode(r.classNames),
    fromDate: r.fromDate?.millisecondsSinceEpoch,
  );
}

class BellSlotModel extends BellSlot {
  const BellSlotModel({
    required super.id,
    required super.position,
    required super.kind,
    required super.start,
    required super.end,
    super.label,
  });

  factory BellSlotModel.fromDto(BellSlotDto d) => BellSlotModel(
    id: d.id,
    position: d.position,
    kind: d.kind == 'break' ? SlotKind.breakTime : SlotKind.period,
    label: d.label,
    start: DayTime(d.startMin),
    end: DayTime(d.endMin),
  );

  static BellSlotDto toDto(BellSlot s) => BellSlotDto(
    id: s.id,
    position: s.position,
    kind: s.kind == SlotKind.breakTime ? 'break' : 'period',
    label: s.label,
    startMin: s.start.minutes,
    endMin: s.end.minutes,
  );
}

class AssemblyDutyModel extends AssemblyDuty {
  const AssemblyDutyModel({
    required super.weekday,
    super.className,
    super.teacherId,
    super.teacherName,
  });

  factory AssemblyDutyModel.fromDto(AssemblyDutyDto d) => AssemblyDutyModel(
    weekday: d.weekday,
    className: d.className,
    teacherId: d.teacherId,
    teacherName: d.teacherName,
  );

  static AssemblyDutyDto toDto(AssemblyDuty d) => AssemblyDutyDto(
    weekday: d.weekday,
    className: d.className,
    teacherId: d.teacherId,
  );
}

class TimetableEntryModel extends TimetableEntry {
  const TimetableEntryModel({
    required super.className,
    required super.weekday,
    required super.slotId,
    required super.subject,
    super.teacherId,
    super.teacherName,
  });

  factory TimetableEntryModel.fromDto(TimetableEntryDto d) =>
      TimetableEntryModel(
        className: d.className,
        weekday: d.weekday,
        slotId: d.slotId,
        subject: d.subject,
        teacherId: d.teacherId,
        teacherName: d.teacherName,
      );

  static TimetableEntryDto toDto(TimetableEntry e) => TimetableEntryDto(
    className: e.className,
    weekday: e.weekday,
    slotId: e.slotId,
    subject: e.subject,
    teacherId: e.teacherId,
  );
}
