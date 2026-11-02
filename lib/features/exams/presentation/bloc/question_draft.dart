import 'package:equatable/equatable.dart';

import '../../domain/entities/exam_paper.dart';
import '../../domain/entities/scanned_question.dart';

/// A pair row being edited.
class PairDraft extends Equatable {
  const PairDraft({this.left = '', this.right = ''});

  final String left;
  final String right;

  bool get isBlank => left.trim().isEmpty && right.trim().isEmpty;

  @override
  List<Object?> get props => [left, right];
}

/// One question being edited. Numbers are kept as typed, so the fields can
/// hold half-finished input.
class QuestionDraft extends Equatable {
  const QuestionDraft({
    required this.id,
    this.type = QuestionType.shortAnswer,
    this.text = '',
    this.marks = '',
    this.options = const [],
    this.correctIndex,
    this.pairs = const [],
    this.answer = '',
    this.needsReview = false,
  });

  /// Starts a new question of [type] with the rows that type needs.
  factory QuestionDraft.blank(int id, QuestionType type) => QuestionDraft(
    id: id,
    type: type,
    options: type == QuestionType.mcq ? const ['', '', '', ''] : const [],
    pairs: type == QuestionType.matchFollowing
        ? const [PairDraft(), PairDraft()]
        : const [],
  );

  factory QuestionDraft.fromQuestion(int id, Question q) => QuestionDraft(
    id: id,
    type: q.type,
    text: q.text,
    marks: q.marks > 0 ? '${q.marks}' : '',
    options: q.options,
    correctIndex: q.correctIndex,
    pairs: [for (final p in q.pairs) PairDraft(left: p.left, right: p.right)],
    answer: q.answer,
  );

  /// A question found by scanning or pasting; the teacher is asked to check it.
  factory QuestionDraft.fromScanned(int id, ScannedQuestion q) => QuestionDraft(
    id: id,
    type: q.type,
    text: q.text,
    marks: q.marks?.toString() ?? '',
    options: q.options,
    pairs: [for (final p in q.pairs) PairDraft(left: p.left, right: p.right)],
    needsReview: true,
  );

  final int id;
  final QuestionType type;
  final String text;
  final String marks;

  /// MCQ choices, including any still empty.
  final List<String> options;
  final int? correctIndex;
  final List<PairDraft> pairs;
  final String answer;

  /// Came from a scan or pasted text and has not been looked at yet.
  final bool needsReview;

  bool get isBlank =>
      text.trim().isEmpty &&
      marks.trim().isEmpty &&
      answer.trim().isEmpty &&
      options.every((o) => o.trim().isEmpty) &&
      pairs.every((p) => p.isBlank);

  QuestionDraft copyWith({
    QuestionType? type,
    String? text,
    String? marks,
    List<String>? options,
    int? correctIndex,
    bool clearCorrect = false,
    List<PairDraft>? pairs,
    String? answer,
    bool? needsReview,
  }) => QuestionDraft(
    id: id,
    type: type ?? this.type,
    text: text ?? this.text,
    marks: marks ?? this.marks,
    options: options ?? this.options,
    correctIndex: clearCorrect ? null : (correctIndex ?? this.correctIndex),
    pairs: pairs ?? this.pairs,
    answer: answer ?? this.answer,
    needsReview: needsReview ?? this.needsReview,
  );

  // Edits. Each returns a new draft; the paper builder and the master-question
  // form share them, so both behave the same.

  QuestionDraft withOptionEdited(int index, String text) {
    if (index >= options.length) return this;
    return copyWith(options: [...options]..[index] = text);
  }

  QuestionDraft withOptionAdded() => copyWith(options: [...options, '']);

  /// Removes an option; the right answer follows its option, and removing the
  /// right one clears the answer.
  QuestionDraft withOptionRemoved(int index) {
    final c = correctIndex;
    final moved = c == null || c == index ? null : (c > index ? c - 1 : c);
    return copyWith(
      options: [...options]..removeAt(index),
      correctIndex: moved,
      clearCorrect: moved == null,
    );
  }

  QuestionDraft withCorrect(int? index) => index == null
      ? copyWith(clearCorrect: true)
      : copyWith(correctIndex: index);

  QuestionDraft withPairEdited(int index, {String? left, String? right}) {
    if (index >= pairs.length) return this;
    return copyWith(
      pairs: [...pairs]
        ..[index] = PairDraft(
          left: left ?? pairs[index].left,
          right: right ?? pairs[index].right,
        ),
    );
  }

  QuestionDraft withPairAdded() =>
      copyWith(pairs: [...pairs, const PairDraft()]);

  QuestionDraft withPairRemoved(int index) =>
      copyWith(pairs: [...pairs]..removeAt(index));

  /// Switches the shape. The text and marks carry over, and so do options or
  /// pairs when the new shape uses them; anything else starts fresh.
  QuestionDraft withType(QuestionType newType) {
    if (newType == type) return this;
    final fresh = QuestionDraft.blank(id, newType);
    return fresh.copyWith(
      text: text,
      marks: marks,
      answer: newType == QuestionType.fillBlank ? answer : '',
      options: newType == QuestionType.mcq && options.length >= 2
          ? options
          : fresh.options,
      pairs: newType == QuestionType.matchFollowing && pairs.length >= 2
          ? pairs
          : fresh.pairs,
    );
  }

  /// The question this draft describes. Empty options and half-filled pairs
  /// are left out, and the right answer keeps pointing at its option.
  Question toQuestion() {
    final kept = <String>[];
    int? correct;
    if (type == QuestionType.mcq) {
      for (var i = 0; i < options.length; i++) {
        if (options[i].trim().isEmpty) continue;
        if (i == correctIndex) correct = kept.length;
        kept.add(options[i].trim());
      }
    } else if (type == QuestionType.trueFalse) {
      correct = correctIndex;
    }
    return Question(
      text: text.trim(),
      marks: int.tryParse(marks.trim()) ?? 0,
      type: type,
      options: kept,
      correctIndex: correct,
      pairs: type == QuestionType.matchFollowing
          ? [
              for (final p in pairs)
                if (p.left.trim().isNotEmpty && p.right.trim().isNotEmpty)
                  MatchPair(p.left.trim(), p.right.trim()),
            ]
          : const [],
      answer: answer.trim(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    text,
    marks,
    options,
    correctIndex,
    pairs,
    answer,
    needsReview,
  ];
}
