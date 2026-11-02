import '../../../../core/usecase/usecase.dart';
import '../entities/scanned_question.dart';
import 'question_parser.dart';

/// Finds the questions in typed or pasted text (from a message, a Word file,
/// or anywhere else), the same way a scanned photo is read.
class ParseQuestionText implements UseCase<List<ScannedQuestion>, String> {
  const ParseQuestionText(this._parser);

  final QuestionParser _parser;

  @override
  Future<List<ScannedQuestion>> call(String text) async => _parser.parse(text);
}
