import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/exam_paper.dart';
import '../../domain/entities/paper_document.dart';

/// The words printed on a paper, in the app's current language.
PaperLabels paperLabelsOf(AppLocalizations l) => PaperLabels(
  classLabel: l.fieldClass,
  subjectLabel: l.fieldSubject,
  dateLabel: l.fieldDate,
  timeLabel: l.printTimeAllowed,
  maxMarksLabel: l.printMaxMarks,
  instructionsLabel: l.paperInstructions,
  studentNameLabel: l.printName,
  rollNoLabel: l.printRollNo,
  answerKeyLabel: l.printAnswerKey,
  columnA: l.qColumnA,
  columnB: l.qColumnB,
  trueLabel: l.qTrue,
  falseLabel: l.qFalse,
  endOfPaper: l.printEndOfPaper,
  sectionTitles: {
    QuestionType.mcq: l.printSecMcq,
    QuestionType.trueFalse: l.printSecTrueFalse,
    QuestionType.fillBlank: l.printSecFill,
    QuestionType.matchFollowing: l.printSecMatch,
    QuestionType.shortAnswer: l.printSecShort,
    QuestionType.longAnswer: l.printSecLong,
  },
  marksText: l.printMarks,
  sectionText: l.printSection,
);
