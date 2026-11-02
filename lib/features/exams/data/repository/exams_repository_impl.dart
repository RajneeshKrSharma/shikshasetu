import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/exam_paper.dart';
import '../../domain/repository/exams_repository.dart';
import '../dto/exam_dto.dart';
import '../models/exam_paper_model.dart';

class ExamsRepositoryImpl implements ExamsRepository {
  ExamsRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<ExamPaper>> getPapers() async {
    final papers = await _db.query('exam_papers');
    final questions = await _db.query(
      'exam_questions',
      orderBy: 'paper_id, position',
    );
    final byPaper = <String, List<ExamQuestionDto>>{};
    for (final q in questions.map(ExamQuestionDto.fromMap)) {
      byPaper.putIfAbsent(q.paperId, () => []).add(q);
    }
    return [
      for (final r in papers.map(ExamPaperDto.fromMap))
        ExamPaperModel.fromDto(r, byPaper[r.id] ?? const []),
    ];
  }

  @override
  Future<void> savePaper(ExamPaper paper, String createdBy) =>
      _db.transaction((txn) async {
        await txn.insert(
          'exam_papers',
          ExamPaperModel.toDto(paper, createdBy).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await txn.delete(
          'exam_questions',
          where: 'paper_id = ?',
          whereArgs: [paper.id],
        );
        for (final q in ExamPaperModel.questionDtos(paper)) {
          await txn.insert('exam_questions', q.toMap());
        }
      });

  @override
  Future<void> setStatus(
    String paperId,
    PaperStatus status, {
    String? note,
    DateTime? at,
  }) => _db.update(
    'exam_papers',
    {
      'status': status.name,
      // A new note only comes with sending a paper back; any other move
      // clears the old one.
      'review_note': note,
      if (status == PaperStatus.submitted)
        'submitted_at': (at ?? DateTime.now()).millisecondsSinceEpoch,
    },
    where: 'id = ?',
    whereArgs: [paperId],
  );

  @override
  Future<void> deletePaper(String paperId) =>
      _db.delete('exam_papers', where: 'id = ?', whereArgs: [paperId]);

  @override
  Future<void> markConducted(String paperId) => _db.update(
    'exam_papers',
    {'status': PaperStatus.conducted.name},
    where: 'id = ?',
    whereArgs: [paperId],
  );

  @override
  Future<Map<String, int>> getMarks(String paperId) async {
    final rows = await _db.query(
      'exam_marks',
      where: 'paper_id = ?',
      whereArgs: [paperId],
    );
    return {
      for (final m in rows.map(ExamMarkDto.fromMap))
        m.studentId: m.marksObtained,
    };
  }

  @override
  Future<void> saveMarks(String paperId, Map<String, int> marks) async {
    final batch = _db.batch();
    for (final e in marks.entries) {
      batch.insert(
        'exam_marks',
        ExamMarkDto(
          paperId: paperId,
          studentId: e.key,
          marksObtained: e.value,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
