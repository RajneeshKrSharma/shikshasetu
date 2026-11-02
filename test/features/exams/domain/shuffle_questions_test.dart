import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/shuffle_questions.dart';

void main() {
  Question mcq(String t, {List<String>? options, int? correct}) => Question(
    text: t,
    marks: 1,
    type: QuestionType.mcq,
    options: options ?? const ['a', 'b', 'c', 'd'],
    correctIndex: correct,
  );
  Question short(String t) => Question(text: t, marks: 2);

  final questions = [
    mcq('m1'),
    mcq('m2'),
    mcq('m3'),
    mcq('m4'),
    short('s1'),
    short('s2'),
    short('s3'),
  ];

  test(
    'questions stay inside their own type, and sections keep their order',
    () {
      for (var seed = 0; seed < 20; seed++) {
        final out = shuffleWithinSections(
          questions,
          (q) => q.type,
          Random(seed),
        );

        expect(out.length, 7);
        expect(out.take(4).every((q) => q.type == QuestionType.mcq), isTrue);
        expect(
          out.skip(4).every((q) => q.type == QuestionType.shortAnswer),
          isTrue,
        );
        expect(
          {for (final q in out) q.text},
          {for (final q in questions) q.text},
        );
      }
    },
  );

  test('a shuffle really changes the order for at least some seeds', () {
    final orders = {
      for (var seed = 0; seed < 20; seed++)
        shuffleWithinSections(
          questions,
          (q) => q.type,
          Random(seed),
        ).map((q) => q.text).join(),
    };
    expect(orders.length, greaterThan(1));
  });

  test('sections stay in the order the types first appear', () {
    final mixed = [short('s1'), mcq('m1'), short('s2'), mcq('m2')];

    final out = shuffleWithinSections(mixed, (q) => q.type, Random(1));

    expect(
      out.take(2).every((q) => q.type == QuestionType.shortAnswer),
      isTrue,
    );
    expect(out.skip(2).every((q) => q.type == QuestionType.mcq), isTrue);
  });

  test('shuffling options keeps the right answer on its option', () {
    for (var seed = 0; seed < 30; seed++) {
      final q = mcq('Q', options: ['one', 'two', 'three', 'four'], correct: 2);

      final s = shuffleOptions(q, Random(seed));

      expect(s.options..sort(), ['four', 'one', 'three', 'two']);
      expect(s.options[s.correctIndex!], isNotNull);
    }
    final shuffled = shuffleOptions(
      mcq('Q', options: ['one', 'two', 'three', 'four'], correct: 2),
      Random(5),
    );
    expect(shuffled.options[shuffled.correctIndex!], 'three');
  });

  test('other types are not touched by an options shuffle', () {
    final q = short('s');
    expect(shuffleOptions(q, Random(1)), q);
  });

  test('shufflePaper can include the options', () {
    final paper = ExamPaper(
      id: 'p',
      title: 't',
      subject: 's',
      classSection: '6-A',
      date: DateTime(2026),
      durationMinutes: 30,
      status: PaperStatus.draft,
      questions: [mcq('m1', correct: 0), mcq('m2', correct: 1)],
    );

    final out = shufflePaper(paper, Random(3), options: true);

    for (final q in out.questions) {
      final original = paper.questions.firstWhere((o) => o.text == q.text);
      expect(
        q.options[q.correctIndex!],
        original.options[original.correctIndex!],
      );
    }
  });
}
