import 'dart:math';

import '../entities/exam_paper.dart';

/// Shuffles questions without breaking the paper's sections: a paper lists
/// all MCQs, then all fill-in-the-blanks, and so on, so questions are only
/// mixed within their own type and the sections keep their order.
List<T> shuffleWithinSections<T>(
  List<T> items,
  QuestionType Function(T) typeOf,
  Random random,
) {
  final order = <QuestionType>[];
  final groups = <QuestionType, List<T>>{};
  for (final item in items) {
    final t = typeOf(item);
    if (!groups.containsKey(t)) order.add(t);
    groups.putIfAbsent(t, () => []).add(item);
  }
  // A paper is printed section by section in a fixed type order, so keep the
  // order the types first appeared in rather than regrouping them.
  return [for (final t in order) ...(groups[t]!..shuffle(random))];
}

/// The same MCQ with its options in a new order; the right answer moves with
/// its option.
Question shuffleOptions(Question q, Random random) {
  if (q.type != QuestionType.mcq || q.options.length < 2) return q;
  final order = List<int>.generate(q.options.length, (i) => i)..shuffle(random);
  return Question(
    text: q.text,
    marks: q.marks,
    type: q.type,
    options: [for (final i in order) q.options[i]],
    correctIndex: q.correctIndex == null
        ? null
        : order.indexOf(q.correctIndex!),
    pairs: q.pairs,
    answer: q.answer,
  );
}

/// A paper with its questions shuffled (and, if asked, MCQ options too).
ExamPaper shufflePaper(ExamPaper paper, Random random, {bool options = false}) {
  final questions = shuffleWithinSections(
    paper.questions,
    (q) => q.type,
    random,
  );
  return paper.copyWith(
    questions: options
        ? [for (final q in questions) shuffleOptions(q, random)]
        : questions,
  );
}
