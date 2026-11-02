import 'package:equatable/equatable.dart';

import 'exam_paper.dart';

/// A question detected in scanned or pasted text, before the teacher reviews
/// it. Besides the text it carries what the parser recognised about its shape.
class ScannedQuestion extends Equatable {
  const ScannedQuestion({
    required this.text,
    this.marks,
    this.type = QuestionType.shortAnswer,
    this.options = const [],
    this.pairs = const [],
  });

  /// The question, or its heading for MCQ and "match" questions.
  final String text;

  /// Marks read from the text (e.g. "[5]" or "5 marks"), if any.
  final int? marks;
  final QuestionType type;

  /// MCQ choices, in the order printed.
  final List<String> options;

  /// Rows of a "match the following", paired in the order printed. The real
  /// pairing is not in the photo, so the teacher checks it.
  final List<MatchPair> pairs;

  @override
  List<Object?> get props => [text, marks, type, options, pairs];
}

/// Which writing system to expect in the photo.
enum ScanScript { latin, devanagari }

enum PhotoSource { camera, gallery }
