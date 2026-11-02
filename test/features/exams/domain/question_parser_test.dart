import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/question_parser.dart';

void main() {
  const parser = QuestionParser();

  test('parse: numbered lines become separate questions', () {
    final result = parser.parse('1. Define force.\n2) State Newton law.');

    expect(result.map((q) => q.text), ['Define force.', 'State Newton law.']);
  });

  test('parse: unmarked lines continue the previous question', () {
    final result = parser.parse(
      'Q1. Find the area of a\nrectangle 4 by 5.\nQ2. Name a prime.',
    );

    expect(result.map((q) => q.text), [
      'Find the area of a rectangle 4 by 5.',
      'Name a prime.',
    ]);
  });

  test('parse: text with no numbering is a single question', () {
    final result = parser.parse('Write an essay\non my school');

    expect(result.map((q) => q.text), ['Write an essay on my school']);
  });

  test('parse: reads marks written as [5]', () {
    final q = parser.parse('1. Explain photosynthesis. [5]').single;

    expect(q.text, 'Explain photosynthesis.');
    expect(q.marks, 5);
  });

  test('parse: reads marks written as (3 marks)', () {
    final q = parser.parse('2. Define an atom (3 marks)').single;

    expect(q.text, 'Define an atom');
    expect(q.marks, 3);
  });

  test('parse: leaves marks empty when none are written', () {
    expect(parser.parse('1. Define force.').single.marks, isNull);
  });

  test('parse: blank input gives no questions', () {
    expect(parser.parse('  \n \n'), isEmpty);
  });

  test('parse: a decimal like 2.5 inside a sentence does not split', () {
    final result = parser.parse('1. Add 2.5 and 3.5.');

    expect(result.map((q) => q.text), ['Add 2.5 and 3.5.']);
  });

  group('MCQ', () {
    test('heading and options on separate lines', () {
      final q = parser
          .parse(
            '1. Capital of India is\n(a) Mumbai\n(b) Delhi\n(c) Pune\n(d) Goa [1]',
          )
          .single;

      expect(q.type, QuestionType.mcq);
      expect(q.text, 'Capital of India is');
      expect(q.options, ['Mumbai', 'Delhi', 'Pune', 'Goa']);
      expect(q.marks, 1);
    });

    test('all options on one line, after the heading', () {
      final q = parser
          .parse(
            'Q1. The sun rises in the (a) East (b) West (c) North (d) South',
          )
          .single;

      expect(q.type, QuestionType.mcq);
      expect(q.text, 'The sun rises in the');
      expect(q.options, ['East', 'West', 'North', 'South']);
    });

    test('options written as A. B. C.', () {
      final q = parser.parse('2. 5 + 3 = ?\nA. 7\nB. 8\nC. 9').single;

      expect(q.options, ['7', '8', '9']);
      expect(q.text, '5 + 3 = ?');
    });

    test('a wrapped option line joins its option', () {
      final q = parser
          .parse('1. Pick one\n(a) a very long\nchoice here\n(b) short')
          .single;

      expect(q.options, ['a very long choice here', 'short']);
    });

    test('Devanagari option markers', () {
      final q = parser
          .parse('1. भारत की राजधानी क्या है?\n(क) मुंबई\n(ख) दिल्ली\n(ग) पुणे')
          .single;

      expect(q.type, QuestionType.mcq);
      expect(q.options, ['मुंबई', 'दिल्ली', 'पुणे']);
    });

    test('numbering continues correctly across several MCQs', () {
      final result = parser.parse(
        '1. First?\n(a) x\n(b) y\n2. Second?\n(a) p\n(b) q',
      );

      expect(result.map((q) => q.text), ['First?', 'Second?']);
      expect(result.map((q) => q.options.length), [2, 2]);
    });

    test('a single "(a)" is not enough to be an MCQ', () {
      final q = parser.parse('1. Name the part (a) of the flower').single;

      expect(q.type, QuestionType.shortAnswer);
      expect(q.options, isEmpty);
    });
  });

  group('other shapes', () {
    test('a blank makes a fill in the blank, normalised to _____', () {
      final q = parser.parse('1. The capital of India is ........ .').single;

      expect(q.type, QuestionType.fillBlank);
      expect(q.text, contains('_____'));
    });

    test('underscores are a blank too', () {
      expect(
        parser.parse('3. Water boils at ____ degrees.').single.type,
        QuestionType.fillBlank,
      );
    });

    test('"state true or false" is a true/false question', () {
      final q = parser
          .parse('4. State true or false: The earth is flat.')
          .single;

      expect(q.type, QuestionType.trueFalse);
    });

    test('plain questions stay short answers', () {
      expect(
        parser.parse('1. Define force.').single.type,
        QuestionType.shortAnswer,
      );
    });
  });

  group('match the following', () {
    test('columns side by side, separated by a tab', () {
      final q = parser
          .parse(
            '5. Match the following [4]\n1. Cat \t a. Meow\n2. Dog \t b. Bark',
          )
          .single;

      expect(q.type, QuestionType.matchFollowing);
      expect(q.marks, 4);
      expect(q.pairs, [
        const MatchPair('Cat', 'Meow'),
        const MatchPair('Dog', 'Bark'),
      ]);
    });

    test('one column after the other', () {
      final result = parser.parse(
        '1. Match the following\n1. Cat\n2. Dog\n3. Cow\na. Moo\nb. Bark\nc. Meow\n2. Define force.',
      );

      expect(result.length, 2);
      expect(result.first.type, QuestionType.matchFollowing);
      expect(result.first.pairs.map((p) => p.left), ['Cat', 'Dog', 'Cow']);
      expect(result.first.pairs.map((p) => p.right), ['Moo', 'Bark', 'Meow']);
      expect(result.last.text, 'Define force.');
    });

    test('items of the match are not mistaken for new questions', () {
      final result = parser.parse(
        '1. Match the following\n1. A \t x\n2. B \t y\n3. C \t z\n4. D \t w\n2. Next question',
      );

      expect(result.length, 2);
      expect(result.first.pairs.length, 4);
    });

    test('two columns it cannot read fall back to plain text', () {
      final q = parser.parse('1. Match the following\nsomething odd').single;

      expect(q.type, QuestionType.shortAnswer);
    });
  });

  group('instruction headings', () {
    test('"Fill in the blanks" is a heading, not a question', () {
      final result = parser.parse(
        'Fill in the blanks:\n1. The sun rises in the ____.\n2. Fish live in ____.',
      );

      expect(result.length, 2);
      expect(result.every((q) => q.type == QuestionType.fillBlank), isTrue);
    });

    test('a numbered heading, then questions that restart at 1', () {
      final result = parser.parse(
        '1. Fill in the blanks:\n1. The sun rises in ____.\n2. Fish live in ____.\n'
        '2. State true or false:\n1. Ice is cold.\n2. Fire is cold.',
      );

      expect(result.map((q) => q.type), [
        QuestionType.fillBlank,
        QuestionType.fillBlank,
        QuestionType.trueFalse,
        QuestionType.trueFalse,
      ]);
    });

    test('"Section B" restarts the numbering', () {
      final result = parser.parse(
        'Section A\n1. One?\n(a) x\n(b) y\n2. Two?\n(a) x\n(b) y\nSection B\n1. Define force.\n2. Define work.',
      );

      expect(result.length, 4);
      expect(result[2].text, 'Define force.');
    });

    test(
      '"Choose the correct answer" does not turn an unfinished question into MCQ',
      () {
        final result = parser.parse(
          'Choose the correct answer:\n1. Define force.',
        );

        expect(result.single.type, QuestionType.shortAnswer);
      },
    );

    test('long answer heading marks the questions that follow', () {
      final result = parser.parse(
        'Long answer questions\n1. Explain photosynthesis. [5]',
      );

      expect(result.single.type, QuestionType.longAnswer);
      expect(result.single.marks, 5);
    });
  });
}
