import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/exams.dart';
import '../repository/exams_repository.dart';

class GetExams implements UseCase<List<Exam>, String?> {
  const GetExams(this._repository);

  final ExamsRepository _repository;

  @override
  Future<List<Exam>> call(String? classId) =>
      _repository.exams(classId: classId);
}

class SaveExam implements UseCase<void, ExamDraft> {
  const SaveExam(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(ExamDraft draft) => _repository.save(draft);
}

class RemoveExam implements UseCase<void, String> {
  const RemoveExam(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(String id) => _repository.remove(id);
}

class GetExamResults implements UseCase<ExamResults, String> {
  const GetExamResults(this._repository);

  final ExamsRepository _repository;

  @override
  Future<ExamResults> call(String examId) => _repository.results(examId);
}

class EnterMarksParams extends Equatable {
  const EnterMarksParams(this.examId, this.entries);

  final String examId;
  final List<MarkEntry> entries;

  @override
  List<Object?> get props => [examId, entries];
}

class EnterMarks implements UseCase<void, EnterMarksParams> {
  const EnterMarks(this._repository);

  final ExamsRepository _repository;

  @override
  Future<void> call(EnterMarksParams p) =>
      _repository.enterMarks(p.examId, p.entries);
}

class GetStudentResults implements UseCase<StudentResults, String> {
  const GetStudentResults(this._repository);

  final ExamsRepository _repository;

  @override
  Future<StudentResults> call(String studentId) =>
      _repository.studentResults(studentId);
}

// ------------------------------------------------------------ question bank
class NoUnitsParams extends Equatable {
  const NoUnitsParams();

  @override
  List<Object?> get props => const [];
}

class GetUnits implements UseCase<List<QuestionUnit>, NoUnitsParams> {
  const GetUnits(this._repository);

  final QuestionBankRepository _repository;

  @override
  Future<List<QuestionUnit>> call(NoUnitsParams params) => _repository.units();
}

class SaveUnit implements UseCase<void, UnitDraft> {
  const SaveUnit(this._repository);

  final QuestionBankRepository _repository;

  @override
  Future<void> call(UnitDraft draft) => _repository.saveUnit(draft);
}

class RemoveUnit implements UseCase<void, String> {
  const RemoveUnit(this._repository);

  final QuestionBankRepository _repository;

  @override
  Future<void> call(String id) => _repository.removeUnit(id);
}

class GetQuestions implements UseCase<List<Question>, String> {
  const GetQuestions(this._repository);

  final QuestionBankRepository _repository;

  @override
  Future<List<Question>> call(String unitId) => _repository.questions(unitId);
}

class SaveQuestion implements UseCase<void, QuestionDraft> {
  const SaveQuestion(this._repository);

  final QuestionBankRepository _repository;

  @override
  Future<void> call(QuestionDraft draft) => _repository.saveQuestion(draft);
}

class RemoveQuestion implements UseCase<void, String> {
  const RemoveQuestion(this._repository);

  final QuestionBankRepository _repository;

  @override
  Future<void> call(String id) => _repository.removeQuestion(id);
}

// -------------------------------------------------------------------- paper
class GetPaper implements UseCase<Paper?, String> {
  const GetPaper(this._repository);

  final PaperRepository _repository;

  @override
  Future<Paper?> call(String examId) => _repository.paper(examId);
}

class ComposePaperParams extends Equatable {
  const ComposePaperParams(this.examId, this.questionIds);

  final String examId;
  final List<String> questionIds;

  @override
  List<Object?> get props => [examId, questionIds];
}

class ComposePaper implements UseCase<Paper, ComposePaperParams> {
  const ComposePaper(this._repository);

  final PaperRepository _repository;

  @override
  Future<Paper> call(ComposePaperParams p) =>
      _repository.compose(p.examId, p.questionIds);
}

class SendPaper implements UseCase<Paper, String> {
  const SendPaper(this._repository);

  final PaperRepository _repository;

  @override
  Future<Paper> call(String examId) => _repository.send(examId);
}

class ApprovePaper implements UseCase<Paper, String> {
  const ApprovePaper(this._repository);

  final PaperRepository _repository;

  @override
  Future<Paper> call(String examId) => _repository.approve(examId);
}

class RejectPaperParams extends Equatable {
  const RejectPaperParams(this.examId, this.reason);

  final String examId;
  final String reason;

  @override
  List<Object?> get props => [examId, reason];
}

class RejectPaper implements UseCase<Paper, RejectPaperParams> {
  const RejectPaper(this._repository);

  final PaperRepository _repository;

  @override
  Future<Paper> call(RejectPaperParams p) =>
      _repository.reject(p.examId, p.reason.trim());
}
