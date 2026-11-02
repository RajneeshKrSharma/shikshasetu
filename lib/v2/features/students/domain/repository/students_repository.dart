import '../entities/student.dart';

abstract interface class StudentsRepository {
  /// By class, then roll number.
  Future<List<Student>> getStudents({
    String? classId,
    String query = '',
    bool onlyActive = true,
  });

  Future<Student> getStudent(String id);

  Future<Student> save(StudentDraft draft);

  /// Makes the student inactive (or active again). Nothing is deleted.
  Future<Student> setActive(String id, {required bool active});
}
