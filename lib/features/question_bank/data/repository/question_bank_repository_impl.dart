import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../master_questions/data/dto/master_question_dto.dart';
import '../../../master_questions/data/models/master_question_model.dart';
import '../../../master_questions/domain/entities/master_question.dart';
import '../../domain/entities/bank_scope.dart';
import '../../domain/entities/bank_unit.dart';
import '../../domain/repository/question_bank_repository.dart';

/// Keeps a teacher's bank in `question_units` and `master_questions` (a
/// question with a unit belongs to that teacher's bank).
class QuestionBankRepositoryImpl implements QuestionBankRepository {
  QuestionBankRepositoryImpl(this._database, this._newId, this._now);

  final AppDatabase _database;
  final String Function() _newId;
  final DateTime Function() _now;

  Database get _db => _database.db;

  BankUnit _unit(Map<String, Object?> r, BankScope scope) => BankUnit(
    id: r['id']! as String,
    scope: scope,
    name: r['name']! as String,
    position: r['position']! as int,
  );

  @override
  Future<List<BankScope>> getStartedScopes(String teacherId) async {
    final rows = await _db.query(
      'question_units',
      where: 'teacher_id = ?',
      whereArgs: [teacherId],
    );
    return [
      for (final key in {
        for (final r in rows) '${r['class_name']}\u0000${r['subject']}',
      })
        BankScope(
          teacherId: teacherId,
          classSection: key.split('\u0000')[0],
          subject: key.split('\u0000')[1],
        ),
    ];
  }

  @override
  Future<List<BankUnit>> getUnits(BankScope scope) async {
    final rows = await _db.query(
      'question_units',
      where: 'teacher_id = ? AND class_name = ? AND subject = ?',
      whereArgs: [scope.teacherId, scope.classSection, scope.subject],
      orderBy: 'position, created_at',
    );
    return [for (final r in rows) _unit(r, scope)];
  }

  @override
  Future<List<BankQuestion>> getQuestions(BankScope scope) async {
    final rows = await _db.rawQuery(
      'SELECT q.* FROM master_questions q '
      'JOIN question_units u ON u.id = q.unit_id '
      'WHERE u.teacher_id = ? AND u.class_name = ? AND u.subject = ? '
      'ORDER BY q.created_at, q.id',
      [scope.teacherId, scope.classSection, scope.subject],
    );
    return [
      for (final r in rows)
        _question(MasterQuestionModel.fromDto(MasterQuestionDto.fromMap(r))),
    ];
  }

  BankQuestion _question(MasterQuestion m) => BankQuestion(
    id: m.id,
    unitId: m.unitId!,
    question: m.question,
    createdAt: m.createdAt,
  );

  @override
  Future<BankUnit> addUnit(BankScope scope, String name) async {
    final position = Sqflite.firstIntValue(
      await _db.rawQuery(
        'SELECT COUNT(*) FROM question_units '
        'WHERE teacher_id = ? AND class_name = ? AND subject = ?',
        [scope.teacherId, scope.classSection, scope.subject],
      ),
    )!;
    final unit = BankUnit(
      id: _newId(),
      scope: scope,
      name: name,
      position: position,
    );
    await _db.insert('question_units', {
      'id': unit.id,
      'teacher_id': scope.teacherId,
      'class_name': scope.classSection,
      'subject': scope.subject,
      'name': name,
      'position': position,
      'created_at': _now().millisecondsSinceEpoch,
    });
    return unit;
  }

  MasterQuestion _master(
    String id,
    Question q,
    BankScope scope,
    String unitId,
    DateTime at,
  ) => MasterQuestion(
    id: id,
    question: q,
    createdAt: at,
    subject: scope.subject,
    classSection: scope.classSection,
    createdBy: scope.teacherId,
    unitId: unitId,
  );

  @override
  Future<void> saveQuestions(
    BankScope scope,
    String unitId,
    List<Question> questions,
  ) => _db.transaction((txn) async {
    final base = _now();
    for (var i = 0; i < questions.length; i++) {
      await txn.insert(
        'master_questions',
        MasterQuestionModel.toDto(
          _master(
            _newId(),
            questions[i],
            scope,
            unitId,
            base.add(Duration(milliseconds: i)),
          ),
        ).toMap(),
      );
    }
  });

  @override
  Future<void> updateQuestion(BankQuestion q, BankScope scope) => _db.insert(
    'master_questions',
    MasterQuestionModel.toDto(
      _master(q.id, q.question, scope, q.unitId, q.createdAt),
    ).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  @override
  Future<void> deleteQuestion(String id) =>
      _db.delete('master_questions', where: 'id = ?', whereArgs: [id]);
}
