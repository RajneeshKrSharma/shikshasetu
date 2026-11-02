import '../entities/class_summary.dart';

abstract interface class ClassesRepository {
  Future<List<ClassSummary>> getClasses();
  Future<void> add(String name);
  Future<void> rename(String oldName, String newName);

  /// Removes the class together with its students and their attendance.
  Future<void> delete(String name);
}
