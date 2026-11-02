import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/exam_paper.dart';
import '../repository/exams_repository.dart';

class SavePaperParams extends Equatable {
  const SavePaperParams(this.paper, this.createdBy);

  final ExamPaper paper;
  final String createdBy;

  @override
  List<Object?> get props => [paper, createdBy];
}

class SavePaper implements UseCase<void, SavePaperParams> {
  const SavePaper(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(SavePaperParams p) =>
      _repository.savePaper(p.paper, p.createdBy);
}
