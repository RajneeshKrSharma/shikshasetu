import '../entities/school_class.dart';

abstract interface class ClassesRepository {
  /// Lowest class first.
  Future<List<SchoolClass>> getClasses();

  Future<SchoolClass> add({required ClassLevel level, String section = ''});

  /// An empty [section] takes the section off the class.
  Future<SchoolClass> change(
    String id, {
    required ClassLevel level,
    required String section,
  });

  /// Hides the class; refused while it still has students.
  Future<void> remove(String id);
}
