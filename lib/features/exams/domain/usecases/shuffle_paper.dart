import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/exam_paper.dart';
import '../repository/exams_repository.dart';
import 'shuffle_questions.dart';

class ShufflePaperParams extends Equatable {
  const ShufflePaperParams(this.paper, {this.options = false});

  final ExamPaper paper;

  /// Also shuffle the options of each MCQ.
  final bool options;

  @override
  List<Object?> get props => [paper, options];
}

/// Reorders a saved paper's questions and saves it.
class ShufflePaper implements UseCase<void, ShufflePaperParams> {
  ShufflePaper(this._repository, {Random? random})
    : _random = random ?? Random();

  final ExamsRepository _repository;
  final Random _random;

  @override
  Future<void> call(ShufflePaperParams p) => _repository.savePaper(
    shufflePaper(p.paper, _random, options: p.options),
    p.paper.createdBy ?? '',
  );
}
