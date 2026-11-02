import '../../../../core/usecase/usecase.dart';
import '../repository/exams_repository.dart';

class GetPaperMarks implements UseCase<Map<String, int>, String> {
  const GetPaperMarks(this._repository);

  final ExamsRepository _repository;

  @override
  Future<Map<String, int>> call(String paperId) =>
      _repository.getMarks(paperId);
}
