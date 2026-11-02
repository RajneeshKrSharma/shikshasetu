import '../../../../core/usecase/usecase.dart';
import '../entities/master_question.dart';
import '../repository/master_questions_repository.dart';

class SaveMasterQuestion implements UseCase<void, MasterQuestion> {
  const SaveMasterQuestion(this._repository);

  final MasterQuestionsRepository _repository;

  @override
  Future<void> call(MasterQuestion q) => _repository.save(q);
}
