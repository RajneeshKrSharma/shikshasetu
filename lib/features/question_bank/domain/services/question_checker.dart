import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../entities/review.dart';

/// Decides what is still unsure about a question read from a photo.
class QuestionChecker {
  const QuestionChecker();

  static final _headingStart = RegExp(
    r'^(page|exercise|chapter|unit|lesson|section|worksheet|name|date|class|'
    r'पृष्ठ|अभ्यास|पाठ|इकाई)\b',
    caseSensitive: false,
  );

  /// A line that looks like a heading or a page mark, not a question.
  bool looksLikeHeading(ScannedQuestion q) {
    if (q.type != QuestionType.shortAnswer) return false;
    final text = q.text.trim();
    if (text.endsWith('?') || text.contains('__')) return false;
    final words = text.split(RegExp(r'\s+')).length;
    return _headingStart.hasMatch(text) || words <= 2;
  }

  /// What is unsure about [q]. [checked] is true once the teacher has looked
  /// at it, which settles "match" questions.
  ReviewFlag flagOf(Question q, {required bool checked}) => switch (q.type) {
    QuestionType.mcq || QuestionType.trueFalse =>
      q.correctIndex == null ? ReviewFlag.answerMissing : ReviewFlag.ready,
    QuestionType.fillBlank =>
      q.answer.trim().isEmpty ? ReviewFlag.answerMissing : ReviewFlag.ready,
    QuestionType.matchFollowing =>
      q.pairs.length < 2 || !checked ? ReviewFlag.checkPairs : ReviewFlag.ready,
    QuestionType.shortAnswer || QuestionType.longAnswer => ReviewFlag.ready,
  };
}
