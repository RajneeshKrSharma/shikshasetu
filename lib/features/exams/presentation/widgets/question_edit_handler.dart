import '../../domain/entities/exam_paper.dart';

/// What the question editor can ask for. The paper builder and the
/// master-question form each fulfil it in their own way (an event for the
/// bloc, a method on the cubit), so one editor card serves both.
abstract interface class QuestionEditHandler {
  void text(String value);
  void marks(String value);
  void answer(String value);
  void type(QuestionType type);
  void optionEdited(int index, String value);
  void optionAdded();
  void optionRemoved(int index);
  void correct(int? index);
  void pairEdited(int index, {String? left, String? right});
  void pairAdded();
  void pairRemoved(int index);
}
