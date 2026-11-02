import '../../../../core/usecase/usecase.dart';
import '../repository/exams_repository.dart';

class DeletePaper implements UseCase<void, String> {
  const DeletePaper(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(String paperId) => _repository.deletePaper(paperId);
}
