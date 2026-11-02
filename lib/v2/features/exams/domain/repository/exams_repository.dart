import '../entities/exams.dart';

abstract interface class ExamsRepository {
  Future<List<Exam>> exams({String? classId});

  Future<void> save(ExamDraft draft);

  Future<void> remove(String id);

  Future<ExamResults> results(String examId);

  Future<void> enterMarks(String examId, List<MarkEntry> entries);

  Future<StudentResults> studentResults(String studentId);
}

abstract interface class QuestionBankRepository {
  Future<List<QuestionUnit>> units();

  Future<void> saveUnit(UnitDraft draft);

  Future<void> removeUnit(String id);

  Future<List<Question>> questions(String unitId);

  Future<void> saveQuestion(QuestionDraft draft);

  Future<void> removeQuestion(String id);
}

abstract interface class PaperRepository {
  /// Null while no paper has been started.
  Future<Paper?> paper(String examId);

  Future<Paper> compose(String examId, List<String> questionIds);

  Future<Paper> send(String examId);

  Future<Paper> approve(String examId);

  Future<Paper> reject(String examId, String reason);
}
