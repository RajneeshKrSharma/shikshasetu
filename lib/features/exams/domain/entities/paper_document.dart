import 'exam_paper.dart';

/// How the paper is laid out: a full A4 sheet, or a narrow strip for a
/// 58 mm or 80 mm thermal roll.
enum PaperLayout {
  a4,
  thermal58,
  thermal80;

  bool get isThermal => this != a4;
}

/// The words printed on the paper, in the language of the app. Passed in so
/// the PDF code does not depend on the localization system.
class PaperLabels {
  const PaperLabels({
    required this.classLabel,
    required this.subjectLabel,
    required this.dateLabel,
    required this.timeLabel,
    required this.maxMarksLabel,
    required this.instructionsLabel,
    required this.studentNameLabel,
    required this.rollNoLabel,
    required this.answerKeyLabel,
    required this.columnA,
    required this.columnB,
    required this.trueLabel,
    required this.falseLabel,
    required this.endOfPaper,
    required this.sectionTitles,
    required this.marksText,
    required this.sectionText,
  });

  final String classLabel;
  final String subjectLabel;
  final String dateLabel;
  final String timeLabel;
  final String maxMarksLabel;
  final String instructionsLabel;
  final String studentNameLabel;
  final String rollNoLabel;
  final String answerKeyLabel;
  final String columnA;
  final String columnB;
  final String trueLabel;
  final String falseLabel;
  final String endOfPaper;

  /// Heading of the section for each question type.
  final Map<QuestionType, String> sectionTitles;

  /// "[2 marks]" for a number of marks.
  final String Function(int marks) marksText;

  /// "Section A" for a letter.
  final String Function(String letter) sectionText;
}

/// Everything needed to print one paper.
class PaperDocumentRequest {
  const PaperDocumentRequest({
    required this.paper,
    required this.schoolName,
    required this.labels,
    required this.dateText,
    required this.durationText,
    this.logoPath,
    this.includeAnswerKey = false,
    this.layout = PaperLayout.a4,
  });

  final ExamPaper paper;
  final String schoolName;

  /// Where the school logo is kept, if one was set.
  final String? logoPath;
  final PaperLabels labels;

  /// The exam date and the time allowed, already written for the reader.
  final String dateText;
  final String durationText;
  final bool includeAnswerKey;
  final PaperLayout layout;
}
