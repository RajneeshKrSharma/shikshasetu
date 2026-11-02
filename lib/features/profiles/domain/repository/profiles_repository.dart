import '../entities/profile_entities.dart';

abstract interface class ProfilesRepository {
  /// The student with everything on record about them, or null if there is no
  /// such student.
  Future<StudentProfile?> student(String id);

  /// The teacher with everything on record about them, or null.
  Future<TeacherProfile?> teacher(String id);
}
