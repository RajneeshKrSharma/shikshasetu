import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/student.dart';
import '../../domain/repository/students_repository.dart';
import '../dto/student_dto.dart';
import '../models/student_model.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  StudentsRepositoryImpl(this._database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _database;
  final DateTime Function() _clock;

  @override
  Future<List<Student>> getByClass(String classSection) async {
    final rows = await _database.db.query(
      'students',
      where: 'class_name = ? AND active = 1',
      whereArgs: [classSection],
      orderBy: 'roll_no',
    );
    return [for (final r in rows) StudentModel.fromDto(StudentDto.fromMap(r))];
  }

  @override
  Future<List<String>> getVehicleNumbers() async {
    final rows = await _database.db.rawQuery(
      "SELECT DISTINCT vehicle_number AS v FROM other_staff "
      "WHERE active = 1 AND vehicle_number IS NOT NULL AND vehicle_number != '' "
      "ORDER BY vehicle_number",
    );
    return [for (final r in rows) r['v']! as String];
  }

  @override
  Future<Student?> get(String id) async {
    final rows = await _database.db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty
        ? null
        : StudentModel.fromDto(StudentDto.fromMap(rows.first));
  }

  @override
  Future<Student> add(Student draft) => _database.db.transaction((txn) async {
    final max = await txn.rawQuery(
      'SELECT COALESCE(MAX(roll_no), 0) AS m FROM students '
      'WHERE class_name = ?',
      [draft.classSection],
    );
    final dto = StudentModel.toDto(
      draft,
      id: const Uuid().v4(),
      rollNo: (max.first['m']! as int) + 1,
      registeredOn: _clock(),
    );
    await txn.insert('students', dto.toMap());
    return StudentModel.fromDto(dto);
  });

  @override
  Future<void> update(Student member) => _database.db.transaction((txn) async {
    final map = StudentModel.toDto(
      member,
      id: member.id,
      rollNo: member.rollNo,
      registeredOn: member.registeredOn ?? _clock(),
    ).toMap();
    // The registration day, Aadhaar and active flag are not edited here.
    map
      ..remove('id')
      ..remove('registered_on')
      ..remove('aadhaar_masked')
      ..remove('aadhaar_reason')
      ..remove('active')
      ..remove('dress_size');
    final before = await txn.query(
      'students',
      columns: ['class_name'],
      where: 'id = ?',
      whereArgs: [member.id],
    );
    // Moving to another class gives the next roll number of that class.
    if (before.isNotEmpty &&
        before.first['class_name'] != member.classSection) {
      final max = await txn.rawQuery(
        'SELECT COALESCE(MAX(roll_no), 0) AS m FROM students '
        'WHERE class_name = ?',
        [member.classSection],
      );
      map['roll_no'] = (max.first['m']! as int) + 1;
    } else {
      map.remove('roll_no');
    }
    await txn.update('students', map, where: 'id = ?', whereArgs: [member.id]);
  });
}
