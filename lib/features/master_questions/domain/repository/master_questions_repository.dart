import '../entities/master_question.dart';

abstract interface class MasterQuestionsRepository {
  /// Everything in the bank, newest first.
  Future<List<MasterQuestion>> getAll();

  /// Adds the question, or replaces the one with the same id.
  Future<void> save(MasterQuestion question);
  Future<void> delete(String id);
}
