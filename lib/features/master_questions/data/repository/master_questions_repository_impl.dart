import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/master_question.dart';
import '../../domain/repository/master_questions_repository.dart';
import '../dto/master_question_dto.dart';
import '../models/master_question_model.dart';

class MasterQuestionsRepositoryImpl implements MasterQuestionsRepository {
  MasterQuestionsRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<MasterQuestion>> getAll() async {
    final rows = await _db.query(
      'master_questions',
      where: 'unit_id IS NULL',
      orderBy: 'created_at DESC',
    );
    return [
      for (final r in rows)
        MasterQuestionModel.fromDto(MasterQuestionDto.fromMap(r)),
    ];
  }

  @override
  Future<void> save(MasterQuestion question) => _db.insert(
    'master_questions',
    MasterQuestionModel.toDto(question).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  @override
  Future<void> delete(String id) =>
      _db.delete('master_questions', where: 'id = ?', whereArgs: [id]);
}
