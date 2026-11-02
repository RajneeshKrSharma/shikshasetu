import '../entities/exam_paper.dart';

abstract interface class ExamsRepository {
  Future<List<ExamPaper>> getPapers();

  /// Saves a new paper or replaces an existing one. [createdBy] is used only
  /// when the paper has no setter yet.
  Future<void> savePaper(ExamPaper paper, String createdBy);

  /// Moves a paper to [status] (submit, approve, send back). [note] is the
  /// Principal's reason when sending it back.
  Future<void> setStatus(
    String paperId,
    PaperStatus status, {
    String? note,
    DateTime? at,
  });

  Future<void> deletePaper(String paperId);
  Future<void> markConducted(String paperId);

  /// Marks obtained by each student (id → marks) for a conducted paper.
  Future<Map<String, int>> getMarks(String paperId);
  Future<void> saveMarks(String paperId, Map<String, int> marks);
}
