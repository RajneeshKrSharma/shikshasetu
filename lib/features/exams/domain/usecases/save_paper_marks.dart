import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/exams_repository.dart';

class SavePaperMarksParams extends Equatable {
  const SavePaperMarksParams(this.paperId, this.marks);

  final String paperId;
  final Map<String, int> marks;

  @override
  List<Object?> get props => [paperId, marks];
}

class SavePaperMarks implements UseCase<void, SavePaperMarksParams> {
  const SavePaperMarks(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(SavePaperMarksParams p) =>
      _repository.saveMarks(p.paperId, p.marks);
}
