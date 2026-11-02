import '../entities/staff_member.dart';

abstract interface class StaffRepository {
  Future<List<StaffMember>> getStaff();
  Future<void> setActive(String staffId, bool active);

  /// Makes [staffId] class teacher of [classSection]; null removes their
  /// current assignment. A class has at most one class teacher.
  Future<void> assignClass(String staffId, String? classSection);
}
