import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:shiksha_setu/features/exams/data/repository/pdf_paper_document_repository.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/exams/domain/entities/paper_document.dart';

/// Reads the bundled fonts from disk, as the app does from its assets.
Future<ByteData> _fromDisk(String asset) async {
  final bytes = await File(asset).readAsBytes();
  return ByteData.sublistView(Uint8List.fromList(bytes));
}

PaperLabels _labels() => PaperLabels(
  classLabel: 'Class',
  subjectLabel: 'Subject',
  dateLabel: 'Date',
  timeLabel: 'Time allowed',
  maxMarksLabel: 'Max marks',
  instructionsLabel: 'General instructions',
  studentNameLabel: 'Name',
  rollNoLabel: 'Roll no.',
  answerKeyLabel: 'Answer key',
  columnA: 'Column A',
  columnB: 'Column B',
  trueLabel: 'True',
  falseLabel: 'False',
  endOfPaper: '— End of paper —',
  sectionTitles: {for (final t in QuestionType.values) t: t.name},
  marksText: (m) => '[$m marks]',
  sectionText: (l) => 'Section $l',
);

ExamPaper _paper(List<Question> q, {String instructions = ''}) => ExamPaper(
  id: 'p',
  title: 'Unit Test 1',
  subject: 'Maths',
  classSection: '6-A',
  date: DateTime(2026, 10, 5),
  durationMinutes: 60,
  status: PaperStatus.approved,
  questions: q,
  instructions: instructions,
);

const _rich = [
  Question(
    text: 'Capital of India?',
    marks: 1,
    type: QuestionType.mcq,
    options: ['Mumbai', 'Delhi', 'Pune', 'Goa'],
    correctIndex: 1,
  ),
  Question(
    text: 'The earth is flat.',
    marks: 1,
    type: QuestionType.trueFalse,
    correctIndex: 1,
  ),
  Question(
    text: 'Water boils at _____ degrees.',
    marks: 1,
    type: QuestionType.fillBlank,
    answer: '100',
  ),
  Question(
    text: 'Match the following',
    marks: 3,
    type: QuestionType.matchFollowing,
    pairs: [
      MatchPair('Cat', 'Meow'),
      MatchPair('Dog', 'Bark'),
      MatchPair('Cow', 'Moo'),
    ],
  ),
  Question(text: 'Define force.', marks: 2),
  Question(
    text: 'Explain photosynthesis.',
    marks: 5,
    type: QuestionType.longAnswer,
  ),
];

void main() {
  final repo = PdfPaperDocumentRepository(loadAsset: _fromDisk);

  PaperDocumentRequest request(
    ExamPaper paper, {
    String? logo,
    bool key = false,
    PaperLayout layout = PaperLayout.a4,
  }) => PaperDocumentRequest(
    paper: paper,
    schoolName: 'Sunrise Public School',
    labels: _labels(),
    dateText: '5 Oct 2026',
    durationText: '1 hr',
    logoPath: logo,
    includeAnswerKey: key,
    layout: layout,
  );

  bool isPdf(Uint8List b) =>
      String.fromCharCodes(b.take(5)) == '%PDF-' && b.length > 1000;

  test('an A4 paper with every question type is a PDF', () async {
    expect(isPdf(await repo.build(request(_paper(_rich)))), isTrue);
  });

  test('Hindi text builds without a missing-glyph failure', () async {
    final pdf = await repo.build(
      request(
        _paper(const [
          Question(
            text: 'भारत की राजधानी क्या है?',
            marks: 1,
            type: QuestionType.mcq,
            options: ['मुंबई', 'दिल्ली'],
          ),
          Question(text: 'प्रकाश संश्लेषण समझाइए।', marks: 5),
        ], instructions: 'सभी प्रश्न अनिवार्य हैं।'),
      ),
    );

    expect(isPdf(pdf), isTrue);
  });

  test('the logo is placed when it can be read', () async {
    final dir = await Directory.systemTemp.createTemp('logo');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/logo.png')
      ..writeAsBytesSync(img.encodePng(img.Image(width: 40, height: 40)));

    final without = await repo.build(request(_paper(_rich)));
    final withLogo = await repo.build(request(_paper(_rich), logo: file.path));

    expect(isPdf(withLogo), isTrue);
    // The picture adds bytes to the document.
    expect(withLogo.length, greaterThan(without.length));
  });

  test('a missing or broken logo does not stop the paper', () async {
    expect(
      isPdf(await repo.build(request(_paper(_rich), logo: '/nope.png'))),
      isTrue,
    );

    final dir = await Directory.systemTemp.createTemp('logo');
    addTearDown(() => dir.delete(recursive: true));
    final broken = File('${dir.path}/broken.png')..writeAsBytesSync([1, 2, 3]);
    expect(
      isPdf(await repo.build(request(_paper(_rich), logo: broken.path))),
      isTrue,
    );
  });

  test('the answer key adds a page worth of content', () async {
    final plain = await repo.build(request(_paper(_rich)));
    final keyed = await repo.build(request(_paper(_rich), key: true));

    expect(keyed.length, greaterThan(plain.length));
  });

  test('thermal layouts build for both roll widths', () async {
    for (final layout in [PaperLayout.thermal58, PaperLayout.thermal80]) {
      expect(
        isPdf(await repo.build(request(_paper(_rich), layout: layout))),
        isTrue,
      );
    }
  });

  test('a long paper still builds (it flows onto more pages)', () async {
    final many = [
      for (var i = 0; i < 80; i++)
        Question(text: 'Question number $i about something.', marks: 2),
    ];

    final long = await repo.build(request(_paper(many)));
    final short = await repo.build(request(_paper(_rich.take(1).toList())));

    expect(isPdf(long), isTrue);
    expect(long.length, greaterThan(short.length));
  });

  group('match the following order', () {
    const q = Question(
      text: 'Match the following',
      marks: 4,
      type: QuestionType.matchFollowing,
      pairs: [
        MatchPair('1', 'a'),
        MatchPair('2', 'b'),
        MatchPair('3', 'c'),
        MatchPair('4', 'd'),
      ],
    );

    test('is the same every time for the same question', () {
      expect(
        PdfPaperDocumentRepository.matchOrder(q),
        PdfPaperDocumentRepository.matchOrder(q),
      );
    });

    test('uses every pair exactly once', () {
      expect(PdfPaperDocumentRepository.matchOrder(q).toList()..sort(), [
        0,
        1,
        2,
        3,
      ]);
    });

    test('never prints column B in the same order as column A', () {
      for (var i = 0; i < 50; i++) {
        final varied = Question(
          text: 'Match $i',
          marks: 2,
          type: QuestionType.matchFollowing,
          pairs: q.pairs.take(2 + i % 3).toList(),
        );
        final order = PdfPaperDocumentRepository.matchOrder(varied);

        expect(order, isNot([for (var k = 0; k < order.length; k++) k]));
      }
    });

    test('a single row stays as it is', () {
      const one = Question(
        text: 'x',
        marks: 1,
        type: QuestionType.matchFollowing,
        pairs: [MatchPair('1', 'a')],
      );

      expect(PdfPaperDocumentRepository.matchOrder(one), [0]);
    });
  });
}
