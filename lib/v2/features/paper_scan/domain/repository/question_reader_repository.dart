import '../../../../../features/exams/domain/entities/scanned_question.dart';

abstract interface class QuestionReaderRepository {
  /// Reads photos of a handwritten paper, in order, into questions.
  /// Throws a [PaperReadException] when it cannot.
  Future<List<ScannedQuestion>> read(List<String> imagePaths);
}
