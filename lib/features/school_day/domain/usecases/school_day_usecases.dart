import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/assembly.dart';
import '../entities/bell_slot.dart';
import '../entities/day_time.dart';
import '../entities/school_timing.dart';
import '../entities/timetable.dart';
import '../repository/school_day_repositories.dart';

// ---- school timing

class GetSchoolTiming implements UseCase<SchoolTiming, NoParams> {
  const GetSchoolTiming(this._repository);

  final SchoolTimingRepository _repository;

  @override
  Future<SchoolTiming> call(NoParams params) => _repository.get();
}

class SaveSchoolTiming implements UseCase<void, SchoolTiming> {
  const SaveSchoolTiming(this._repository);

  final SchoolTimingRepository _repository;

  @override
  Future<void> call(SchoolTiming base) => _repository.saveBase(base);
}

/// Saves a timing for some classes or from a date. A new one gets an id.
class SaveTimingRule implements UseCase<void, TimingRule> {
  const SaveTimingRule(this._repository);

  final SchoolTimingRepository _repository;

  @override
  Future<void> call(TimingRule rule) => _repository.saveRule(
    rule.id.isEmpty
        ? TimingRule(
            id: const Uuid().v4(),
            start: rule.start,
            end: rule.end,
            classNames: rule.classNames,
            fromDate: rule.fromDate,
          )
        : rule,
  );
}

class DeleteTimingRule implements UseCase<void, String> {
  const DeleteTimingRule(this._repository);

  final SchoolTimingRepository _repository;

  @override
  Future<void> call(String id) => _repository.deleteRule(id);
}

// ---- assembly

/// The assembly with its duty for each weekday.
class AssemblyOverview extends Equatable {
  const AssemblyOverview(this.settings, this.duties);

  final AssemblySettings settings;
  final List<AssemblyDuty> duties;

  AssemblyDuty dutyOf(int weekday) => duties.firstWhere(
    (d) => d.weekday == weekday,
    orElse: () => AssemblyDuty(weekday: weekday),
  );

  @override
  List<Object?> get props => [settings, duties];
}

class GetAssembly implements UseCase<AssemblyOverview, NoParams> {
  const GetAssembly(this._repository);

  final AssemblyRepository _repository;

  @override
  Future<AssemblyOverview> call(NoParams params) async =>
      AssemblyOverview(await _repository.get(), await _repository.getDuties());
}

class SaveAssembly implements UseCase<void, AssemblySettings> {
  const SaveAssembly(this._repository);

  final AssemblyRepository _repository;

  @override
  Future<void> call(AssemblySettings settings) => _repository.save(settings);
}

class SaveAssemblyDuty implements UseCase<void, AssemblyDuty> {
  const SaveAssemblyDuty(this._repository);

  final AssemblyRepository _repository;

  @override
  Future<void> call(AssemblyDuty duty) => _repository.saveDuty(duty);
}

// ---- bell and timetable

class GetBellSlots implements UseCase<List<BellSlot>, NoParams> {
  const GetBellSlots(this._repository);

  final TimetableRepository _repository;

  @override
  Future<List<BellSlot>> call(NoParams params) => _repository.getSlots();
}

/// Saves a period or break. A new one (empty id) goes at the end of the day.
class SaveBellSlot implements UseCase<void, BellSlot> {
  const SaveBellSlot(this._repository);

  final TimetableRepository _repository;

  @override
  Future<void> call(BellSlot slot) async {
    if (slot.id.isNotEmpty) return _repository.saveSlot(slot);
    final slots = await _repository.getSlots();
    return _repository.saveSlot(
      BellSlot(
        id: const Uuid().v4(),
        position: slots.length,
        kind: slot.kind,
        label: slot.label,
        start: slot.start,
        end: slot.end,
      ),
    );
  }
}

class DeleteBellSlot implements UseCase<void, String> {
  const DeleteBellSlot(this._repository);

  final TimetableRepository _repository;

  @override
  Future<void> call(String id) => _repository.deleteSlot(id);
}

class GetClassTimetable implements UseCase<ClassTimetable, String> {
  const GetClassTimetable(this._repository);

  final TimetableRepository _repository;

  @override
  Future<ClassTimetable> call(String className) async => ClassTimetable(
    className: className,
    slots: await _repository.getSlots(),
    entries: await _repository.getEntries(className),
  );
}

class GetTeachingOptions implements UseCase<List<TeachingOption>, String> {
  const GetTeachingOptions(this._repository);

  final TimetableRepository _repository;

  @override
  Future<List<TeachingOption>> call(String className) =>
      _repository.getOptions(className);
}

/// Puts a subject and its teacher in a period. Throws [TimetableConflict] if
/// the teacher is busy with another class then.
class SaveTimetableEntry implements UseCase<void, TimetableEntry> {
  const SaveTimetableEntry(this._repository);

  final TimetableRepository _repository;

  @override
  Future<void> call(TimetableEntry entry) => _repository.saveEntry(entry);
}

class ClearTimetableEntryParams extends Equatable {
  const ClearTimetableEntryParams(this.className, this.weekday, this.slotId);

  final String className;
  final int weekday;
  final String slotId;

  @override
  List<Object?> get props => [className, weekday, slotId];
}

class ClearTimetableEntry implements UseCase<void, ClearTimetableEntryParams> {
  const ClearTimetableEntry(this._repository);

  final TimetableRepository _repository;

  @override
  Future<void> call(ClearTimetableEntryParams p) =>
      _repository.clearEntry(p.className, p.weekday, p.slotId);
}

class CopyTimetableDayParams extends Equatable {
  const CopyTimetableDayParams({
    required this.className,
    required this.fromWeekday,
    required this.toWeekdays,
  });

  final String className;
  final int fromWeekday;
  final List<int> toWeekdays;

  @override
  List<Object?> get props => [className, fromWeekday, toWeekdays];
}

/// Copies one day of a class's timetable to other days. A period whose
/// teacher is busy elsewhere then is left out, and counted.
class CopyTimetableDay implements UseCase<CopyResult, CopyTimetableDayParams> {
  const CopyTimetableDay(this._repository);

  final TimetableRepository _repository;

  @override
  Future<CopyResult> call(CopyTimetableDayParams p) async {
    final from = [
      for (final e in await _repository.getEntries(p.className))
        if (e.weekday == p.fromWeekday) e,
    ];
    var copied = 0, skipped = 0;
    for (final day in p.toWeekdays) {
      for (final e in from) {
        try {
          await _repository.saveEntry(
            TimetableEntry(
              className: e.className,
              weekday: day,
              slotId: e.slotId,
              subject: e.subject,
              teacherId: e.teacherId,
              teacherName: e.teacherName,
            ),
          );
          copied++;
        } on TimetableConflict {
          skipped++;
        }
      }
    }
    return CopyResult(copied: copied, skipped: skipped);
  }
}

/// A teacher's day: the periods they teach, and whether they lead the
/// assembly that day.
class TeacherDay extends Equatable {
  const TeacherDay({
    required this.periods,
    this.assemblyDuty,
    this.assemblyStart,
  });

  final List<TeacherPeriod> periods;

  /// Their duty this weekday, if they have one.
  final AssemblyDuty? assemblyDuty;
  final DayTime? assemblyStart;

  @override
  List<Object?> get props => [periods, assemblyDuty, assemblyStart];
}

class TeacherDayQuery extends Equatable {
  const TeacherDayQuery(this.teacherId, this.day);

  final String teacherId;
  final DateTime day;

  @override
  List<Object?> get props => [teacherId, day];
}

class GetTeacherDay implements UseCase<TeacherDay, TeacherDayQuery> {
  const GetTeacherDay(this._timetable, this._assembly);

  final TimetableRepository _timetable;
  final AssemblyRepository _assembly;

  @override
  Future<TeacherDay> call(TeacherDayQuery q) async {
    final duties = await _assembly.getDuties();
    final mine = duties
        .where((d) => d.weekday == q.day.weekday && d.teacherId == q.teacherId)
        .firstOrNull;
    return TeacherDay(
      periods: await _timetable.getTeacherPeriods(q.teacherId, q.day.weekday),
      assemblyDuty: mine,
      assemblyStart: mine == null ? null : (await _assembly.get()).start,
    );
  }
}
