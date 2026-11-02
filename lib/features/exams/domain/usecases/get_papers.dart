import '../../../../core/usecase/usecase.dart';
import '../entities/exam_paper.dart';
import '../repository/exams_repository.dart';

class GetPapers implements UseCase<List<ExamPaper>, NoParams> {
  const GetPapers(this._repository);

  final ExamsRepository _repository;

  @override
  Future<List<ExamPaper>> call(NoParams params) => _repository.getPapers();
}
