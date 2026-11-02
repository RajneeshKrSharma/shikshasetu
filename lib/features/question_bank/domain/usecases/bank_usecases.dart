import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../../../teaching/domain/repository/teaching_repository.dart';
import '../entities/bank_scope.dart';
import '../entities/bank_unit.dart';
import '../entities/review.dart';
import '../repository/question_bank_repository.dart';
import '../services/question_checker.dart';

/// The class-and-subject banks a teacher can use: what they are allowed to
/// teach, and what they have already started.
class GetBankScopes implements UseCase<List<BankScope>, String> {
  const GetBankScopes(this._bank, this._teaching);

  final QuestionBankRepository _bank;
  final TeachingRepository _teaching;

  @override
  Future<List<BankScope>> call(String teacherId) async {
    final started = await _bank.getStartedScopes(teacherId);
    final allowed = [
      for (final a in await _teaching.getAll())
        if (a.teacherId == teacherId && a.isApproved)
          BankScope(
            teacherId: teacherId,
            classSection: a.className,
            subject: a.subject,
          ),
    ];
    final seen = <BankScope>{};
    return [
      for (final s in [...allowed, ...started])
        if (seen.add(s)) s,
    ]..sort((a, b) {
      final c = a.classSection.compareTo(b.classSection);
      return c != 0 ? c : a.subject.compareTo(b.subject);
    });
  }
}

class GetBankOverview implements UseCase<BankOverview, BankScope> {
  const GetBankOverview(this._bank);

  final QuestionBankRepository _bank;

  @override
  Future<BankOverview> call(BankScope scope) async {
    final units = await _bank.getUnits(scope);
    final questions = await _bank.getQuestions(scope);
    return BankOverview(
      scope: scope,
      units: [
        for (final u in units)
          UnitSummary(
            unit: u,
            counts: {
              for (final t in QuestionType.values)
                t: questions
                    .where((q) => q.unitId == u.id && q.question.type == t)
                    .length,
            },
          ),
      ],
    );
  }
}

class UnitQuestionsParams extends Equatable {
  const UnitQuestionsParams(this.scope, this.unitId);

  final BankScope scope;
  final String unitId;

  @override
  List<Object?> get props => [scope, unitId];
}

class GetUnitQuestions
    implements UseCase<List<BankQuestion>, UnitQuestionsParams> {
  const GetUnitQuestions(this._bank);

  final QuestionBankRepository _bank;

  @override
  Future<List<BankQuestion>> call(UnitQuestionsParams p) async => [
    for (final q in await _bank.getQuestions(p.scope))
      if (q.unitId == p.unitId) q,
  ];
}

class AddUnitParams extends Equatable {
  const AddUnitParams(this.scope, this.name);

  final BankScope scope;
  final String name;

  @override
  List<Object?> get props => [scope, name];
}

class AddBankUnit implements UseCase<BankUnit, AddUnitParams> {
  const AddBankUnit(this._bank);

  final QuestionBankRepository _bank;

  @override
  Future<BankUnit> call(AddUnitParams p) =>
      _bank.addUnit(p.scope, p.name.trim());
}

class SaveQuestionsParams extends Equatable {
  const SaveQuestionsParams(this.scope, this.unitId, this.questions);

  final BankScope scope;
  final String unitId;
  final List<Question> questions;

  @override
  List<Object?> get props => [scope, unitId, questions];
}

class SaveBankQuestions implements UseCase<void, SaveQuestionsParams> {
  const SaveBankQuestions(this._bank);

  final QuestionBankRepository _bank;

  @override
  Future<void> call(SaveQuestionsParams p) =>
      _bank.saveQuestions(p.scope, p.unitId, p.questions);
}

class DeleteBankQuestion implements UseCase<void, String> {
  const DeleteBankQuestion(this._bank);

  final QuestionBankRepository _bank;

  @override
  Future<void> call(String id) => _bank.deleteQuestion(id);
}

/// A question found in a photo, with what to check and whether it is kept.
class ScannedReview extends Equatable {
  const ScannedReview({
    required this.question,
    required this.flag,
    required this.included,
  });

  final ScannedQuestion question;
  final ReviewFlag flag;
  final bool included;

  @override
  List<Object?> get props => [question, flag, included];
}

/// Sorts the questions read from a photo: which are ready, which need an
/// answer, and which are left out because they look like headings.
class ReviewScanned
    implements UseCase<List<ScannedReview>, List<ScannedQuestion>> {
  const ReviewScanned(this._checker);

  final QuestionChecker _checker;

  @override
  Future<List<ScannedReview>> call(List<ScannedQuestion> found) async => [
    for (final q in found)
      if (_checker.looksLikeHeading(q))
        ScannedReview(question: q, flag: ReviewFlag.leftOut, included: false)
      else
        ScannedReview(
          question: q,
          flag: _checker.flagOf(
            Question(
              text: q.text,
              marks: q.marks ?? 0,
              type: q.type,
              options: q.options,
              pairs: q.pairs,
            ),
            checked: false,
          ),
          included: true,
        ),
  ];
}

class CheckParams extends Equatable {
  const CheckParams(this.question, {required this.checked});

  final Question question;
  final bool checked;

  @override
  List<Object?> get props => [question, checked];
}

/// What is still unsure about one question (used as the teacher fixes it).
class CheckQuestion implements UseCase<ReviewFlag, CheckParams> {
  const CheckQuestion(this._checker);

  final QuestionChecker _checker;

  @override
  Future<ReviewFlag> call(CheckParams p) async =>
      _checker.flagOf(p.question, checked: p.checked);
}
