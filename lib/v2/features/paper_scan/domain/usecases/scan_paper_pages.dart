import '../../../../../core/usecase/usecase.dart';
import '../../../../../features/exams/domain/entities/scanned_question.dart';
import '../entities/paper_read_failure.dart';
import '../repository/question_reader_repository.dart';

/// Reads photos of a handwritten paper, in order, and finds the questions.
class ScanPaperPages implements UseCase<List<ScannedQuestion>, List<String>> {
  const ScanPaperPages(this._reader);

  final QuestionReaderRepository _reader;

  @override
  Future<List<ScannedQuestion>> call(List<String> imagePaths) async {
    final questions = await _reader.read(imagePaths);
    if (questions.isEmpty) {
      throw const PaperReadException(PaperReadFailure.noQuestions);
    }
    return questions;
  }
}
