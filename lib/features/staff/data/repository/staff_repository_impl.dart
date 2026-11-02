import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/repository/staff_repository.dart';
import '../dto/staff_dto.dart';
import '../models/staff_member_model.dart';

class StaffRepositoryImpl implements StaffRepository {
  StaffRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<StaffMember>> getStaff() async {
    final rows = await _db.rawQuery('''
SELECT u.id, u.name, u.subject, u.active, c.name AS class_name
FROM users u
LEFT JOIN classes c ON c.class_teacher_id = u.id
WHERE u.role = 'teacher'
ORDER BY u.name
''');
    return [
      for (final r in rows) StaffMemberModel.fromDto(StaffDto.fromMap(r)),
    ];
  }

  @override
  Future<void> setActive(String staffId, bool active) async {
    await _db.transaction((txn) async {
      await txn.update(
        'users',
        {'active': active ? 1 : 0},
        where: 'id = ?',
        whereArgs: [staffId],
      );
      // An inactive teacher should not keep a class.
      if (!active) {
        await txn.update(
          'classes',
          {'class_teacher_id': null},
          where: 'class_teacher_id = ?',
          whereArgs: [staffId],
        );
      }
    });
  }

  @override
  Future<void> assignClass(String staffId, String? classSection) async {
    await _db.transaction((txn) async {
      await txn.update(
        'classes',
        {'class_teacher_id': null},
        where: 'class_teacher_id = ?',
        whereArgs: [staffId],
      );
      if (classSection != null) {
        await txn.update(
          'classes',
          {'class_teacher_id': staffId},
          where: 'name = ?',
          whereArgs: [classSection],
        );
      }
    });
  }
}
