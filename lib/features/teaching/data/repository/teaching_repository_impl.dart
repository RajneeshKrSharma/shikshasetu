import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/teaching_assignment.dart';
import '../../domain/repository/teaching_repository.dart';
import '../dto/teaching_dto.dart';
import '../models/teaching_assignment_model.dart';

class TeachingRepositoryImpl implements TeachingRepository {
  TeachingRepositoryImpl(this._database, {String Function()? newId})
    : _newId = newId ?? (() => const Uuid().v4());

  final AppDatabase _database;
  final String Function() _newId;

  Database get _db => _database.db;

  @override
  Future<List<TeachingAssignment>> getAll() async {
    final rows = await _db.query(
      'teacher_subjects',
      orderBy: 'class_name, subject',
    );
    return [
      for (final r in rows)
        TeachingAssignmentModel.fromDto(TeachingDto.fromMap(r)),
    ];
  }

  Future<Map<String, Object?>?> _existing(
    String teacherId,
    String className,
    String subject,
  ) async {
    final rows = await _db.query(
      'teacher_subjects',
      where: 'teacher_id = ? AND class_name = ? AND subject = ?',
      whereArgs: [teacherId, className, subject],
    );
    // The most useful one: allowed first, then waiting.
    rows.sort((a, b) => _rank(a['status']).compareTo(_rank(b['status'])));
    return rows.isEmpty ? null : rows.first;
  }

  int _rank(Object? status) => switch (status) {
    'approved' => 0,
    'pending' => 1,
    _ => 2,
  };

  Future<void> _put({
    required String teacherId,
    required String className,
    required String subject,
    required AssignmentStatus status,
    required String requestedBy,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final have = await _existing(teacherId, className, subject);
    if (have != null && have['status'] == 'approved') return;
    if (have != null &&
        have['status'] == 'pending' &&
        requestedBy == 'teacher') {
      return;
    }
    final dto = TeachingDto(
      id: (have?['id'] as String?) ?? _newId(),
      teacherId: teacherId,
      className: className,
      subject: subject,
      status: status.name,
      requestedBy: requestedBy,
      requestedAt: now,
      decidedAt: status == AssignmentStatus.pending ? null : now,
    );
    await _db.insert(
      'teacher_subjects',
      dto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> request({
    required String teacherId,
    required String className,
    required String subject,
  }) => _put(
    teacherId: teacherId,
    className: className,
    subject: subject,
    status: AssignmentStatus.pending,
    requestedBy: 'teacher',
  );

  @override
  Future<void> allot({
    required String teacherId,
    required String className,
    required String subject,
  }) => _put(
    teacherId: teacherId,
    className: className,
    subject: subject,
    status: AssignmentStatus.approved,
    requestedBy: 'principal',
  );

  @override
  Future<void> decide(String id, AssignmentStatus status) => _db.update(
    'teacher_subjects',
    {
      'status': status.name,
      'decided_at': status == AssignmentStatus.pending
          ? null
          : DateTime.now().millisecondsSinceEpoch,
    },
    where: 'id = ?',
    whereArgs: [id],
  );

  @override
  Future<void> remove(String id) =>
      _db.delete('teacher_subjects', where: 'id = ?', whereArgs: [id]);
}
