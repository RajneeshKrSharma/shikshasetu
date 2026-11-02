import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/class_summary.dart';
import '../../domain/repository/classes_repository.dart';
import '../dto/class_summary_dto.dart';
import '../models/class_summary_model.dart';

class ClassesRepositoryImpl implements ClassesRepository {
  ClassesRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<ClassSummary>> getClasses() async {
    final rows = await _database.db.rawQuery('''
SELECT c.name AS name,
       (SELECT COUNT(*) FROM students s WHERE s.class_name = c.name)
         AS student_count,
       u.name AS teacher_name
FROM classes c
LEFT JOIN users u ON u.id = c.class_teacher_id
ORDER BY c.name COLLATE NOCASE
''');
    return [
      for (final r in rows)
        ClassSummaryModel.fromDto(ClassSummaryDto.fromMap(r)),
    ];
  }

  @override
  Future<void> add(String name) =>
      _database.db.insert('classes', {'name': name});

  @override
  Future<void> rename(String oldName, String newName) => _database.db.update(
    'classes',
    {'name': newName},
    where: 'name = ?',
    whereArgs: [oldName],
  );

  @override
  Future<void> delete(String name) =>
      _database.db.delete('classes', where: 'name = ?', whereArgs: [name]);
}
