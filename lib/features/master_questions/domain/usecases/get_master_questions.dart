import '../../../../core/usecase/usecase.dart';
import '../entities/master_question.dart';
import '../repository/master_questions_repository.dart';

class GetMasterQuestions implements UseCase<List<MasterQuestion>, NoParams> {
  const GetMasterQuestions(this._repository);

  final MasterQuestionsRepository _repository;

  @override
  Future<List<MasterQuestion>> call(NoParams params) => _repository.getAll();
}
