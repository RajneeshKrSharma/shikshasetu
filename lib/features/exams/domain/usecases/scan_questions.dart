import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/scanned_question.dart';
import '../repository/question_scanner_repository.dart';
import 'question_parser.dart';

class ScanQuestionsParams extends Equatable {
  const ScanQuestionsParams(this.imagePath, this.script);

  final String imagePath;
  final ScanScript script;

  @override
  List<Object?> get props => [imagePath, script];
}

/// Reads a photo of a question paper and splits it into questions.
class ScanQuestions
    implements UseCase<List<ScannedQuestion>, ScanQuestionsParams> {
  const ScanQuestions(this._scanner, this._parser);

  final QuestionScannerRepository _scanner;
  final QuestionParser _parser;

  @override
  Future<List<ScannedQuestion>> call(ScanQuestionsParams p) async {
    final text = await _scanner.recognize(p.imagePath, script: p.script);
    return _parser.parse(text);
  }
}
