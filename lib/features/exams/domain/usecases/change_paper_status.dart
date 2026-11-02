import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/exam_paper.dart';
import '../repository/exams_repository.dart';

class ChangePaperStatusParams extends Equatable {
  const ChangePaperStatusParams(
    this.paperId,
    this.status, {
    this.note,
    this.at,
  });

  final String paperId;
  final PaperStatus status;

  /// The reason, when the Principal sends a paper back.
  final String? note;
  final DateTime? at;

  @override
  List<Object?> get props => [paperId, status, note, at];
}

/// Submit for approval, approve, or send back with a note.
class ChangePaperStatus implements UseCase<void, ChangePaperStatusParams> {
  const ChangePaperStatus(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(ChangePaperStatusParams p) =>
      _repository.setStatus(p.paperId, p.status, note: p.note, at: p.at);
}
