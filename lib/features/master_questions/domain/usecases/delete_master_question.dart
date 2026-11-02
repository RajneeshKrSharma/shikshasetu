import '../../../../core/usecase/usecase.dart';
import '../repository/master_questions_repository.dart';

class DeleteMasterQuestion implements UseCase<void, String> {
  const DeleteMasterQuestion(this._repository);

  final MasterQuestionsRepository _repository;

  @override
  Future<void> call(String id) => _repository.delete(id);
}
