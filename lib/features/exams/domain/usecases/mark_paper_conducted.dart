import '../../../../core/usecase/usecase.dart';
import '../repository/exams_repository.dart';

class MarkPaperConducted implements UseCase<void, String> {
  const MarkPaperConducted(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(String paperId) => _repository.markConducted(paperId);
}
