import '../../../exams/domain/entities/exam_paper.dart';
import '../entities/bank_scope.dart';
import '../entities/bank_unit.dart';

abstract interface class QuestionBankRepository {
  /// The banks the teacher has started.
  Future<List<BankScope>> getStartedScopes(String teacherId);

  Future<List<BankUnit>> getUnits(BankScope scope);

  /// Every question in the units of [scope].
  Future<List<BankQuestion>> getQuestions(BankScope scope);

  Future<BankUnit> addUnit(BankScope scope, String name);

  Future<void> saveQuestions(
    BankScope scope,
    String unitId,
    List<Question> questions,
  );

  Future<void> updateQuestion(BankQuestion question, BankScope scope);
  Future<void> deleteQuestion(String id);
}
