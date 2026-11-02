import '../entities/assembly.dart';
import '../entities/bell_slot.dart';
import '../entities/school_timing.dart';
import '../entities/timetable.dart';

abstract interface class SchoolTimingRepository {
  Future<SchoolTiming> get();

  /// Saves the school's own start, end and working days.
  Future<void> saveBase(SchoolTiming base);
  Future<void> saveRule(TimingRule rule);
  Future<void> deleteRule(String id);
}

abstract interface class AssemblyRepository {
  Future<AssemblySettings> get();
  Future<void> save(AssemblySettings settings);

  /// One duty for each weekday that has one.
  Future<List<AssemblyDuty>> getDuties();
  Future<void> saveDuty(AssemblyDuty duty);
}

abstract interface class TimetableRepository {
  Future<List<BellSlot>> getSlots();
  Future<void> saveSlot(BellSlot slot);
  Future<void> deleteSlot(String id);

  Future<List<TimetableEntry>> getEntries(String className);

  /// Saves (or replaces) an entry. Throws [TimetableConflict] when the teacher
  /// is already teaching another class in that period of that weekday.
  Future<void> saveEntry(TimetableEntry entry);
  Future<void> clearEntry(String className, int weekday, String slotId);

  /// The periods one teacher teaches on [weekday], in order of the day.
  Future<List<TeacherPeriod>> getTeacherPeriods(String teacherId, int weekday);

  /// What each subject of a class is taught by (approved allotments).
  Future<List<TeachingOption>> getOptions(String className);
}
