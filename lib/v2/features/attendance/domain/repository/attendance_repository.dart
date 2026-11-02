import '../entities/attendance.dart';

abstract interface class AttendanceRepository {
  Future<List<RosterLine>> roster(String classId, DateTime day);

  Future<List<RosterLine>> markRoster(
    String classId,
    DateTime day,
    List<RosterLine> lines,
  );

  Future<List<StudentTally>> report(String classId, DateTime from, DateTime to);

  Future<WorkRecord> checkIn();

  Future<WorkRecord> checkOut();

  Future<List<WorkRecord>> mine(DateTime from, DateTime to);

  Future<DayBoard> board(DateTime day, {String? role});

  Future<void> correct(CorrectionDraft draft);
}
