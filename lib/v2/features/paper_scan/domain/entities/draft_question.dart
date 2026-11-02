import 'package:equatable/equatable.dart';

import '../../../../../features/exams/domain/entities/exam_paper.dart';
import '../../../../../features/exams/domain/entities/scanned_question.dart';

/// A question the teacher is still checking. Unlike a scanned question it has
/// an id, so the screen can tell rows apart while they are added and removed.
class DraftQuestion extends Equatable {
  const DraftQuestion({
    required this.id,
    this.text = '',
    this.marks = 0,
    this.type = QuestionType.shortAnswer,
    this.options = const [],
    this.pairs = const [],
  });

  factory DraftQuestion.fromScanned(int id, ScannedQuestion q) => DraftQuestion(
    id: id,
    text: q.text,
    marks: q.marks ?? 0,
    type: q.type,
    options: q.options,
    pairs: q.pairs,
  );

  final int id;
  final String text;
  final int marks;
  final QuestionType type;
  final List<String> options;
  final List<MatchPair> pairs;

  DraftQuestion copyWith({String? text, int? marks, List<String>? options}) =>
      DraftQuestion(
        id: id,
        text: text ?? this.text,
        marks: marks ?? this.marks,
        type: type,
        options: options ?? this.options,
        pairs: pairs,
      );

  bool get isBlank => text.trim().isEmpty;

  Question toQuestion() => Question(
    text: text.trim(),
    marks: marks,
    type: type,
    options: [
      for (final o in options)
        if (o.trim().isNotEmpty) o.trim(),
    ],
    pairs: pairs,
  );

  @override
  List<Object?> get props => [id, text, marks, type, options, pairs];
}
