import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/face_entities.dart';
import '../../domain/repository/face_repositories.dart';

/// Keeps face templates in the phone's database. They are never backed up or
/// sent to the cloud: a face is not something to copy around.
class SqliteFaceTemplateRepository implements FaceTemplateRepository {
  SqliteFaceTemplateRepository(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<FaceTemplate?> get(String teacherId) async {
    final rows = await _db.query(
      'face_templates',
      where: 'teacher_id = ?',
      whereArgs: [teacherId],
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return FaceTemplate(
      teacherId: teacherId,
      embeddings: [
        for (final e in jsonDecode(r['embeddings']! as String) as List)
          [for (final v in e as List) (v as num).toDouble()],
      ],
      enrolledAt: DateTime.fromMillisecondsSinceEpoch(r['enrolled_at']! as int),
      enrolledBy: r['enrolled_by'] as String?,
    );
  }

  @override
  Future<void> save(FaceTemplate t) => _db.insert('face_templates', {
    'teacher_id': t.teacherId,
    'embeddings': jsonEncode(t.embeddings),
    'enrolled_at': t.enrolledAt.millisecondsSinceEpoch,
    'enrolled_by': t.enrolledBy,
  }, conflictAlgorithm: ConflictAlgorithm.replace);

  @override
  Future<void> delete(String teacherId) => _db.delete(
    'face_templates',
    where: 'teacher_id = ?',
    whereArgs: [teacherId],
  );

  @override
  Future<Set<String>> enrolledIds() async => {
    for (final r in await _db.query('face_templates', columns: ['teacher_id']))
      r['teacher_id']! as String,
  };
}
