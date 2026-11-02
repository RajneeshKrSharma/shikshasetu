import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/domain/repository/exams_repository.dart';
import '../entities/bank_scope.dart';
import '../entities/bank_unit.dart';
import '../entities/paper_plan.dart';
import '../repository/question_bank_repository.dart';

class AvailabilityParams extends Equatable {
  const AvailabilityParams(this.scope, this.unitIds);

  final BankScope scope;
  final Set<String> unitIds;

  @override
  List<Object?> get props => [scope, unitIds];
}

/// The types of question that exist in the chosen units, and how many of each
/// there are in every unit. Types with none are left out.
class GetTypeAvailability
    implements UseCase<List<TypeAvailability>, AvailabilityParams> {
  const GetTypeAvailability(this._bank);

  final QuestionBankRepository _bank;

  @override
  Future<List<TypeAvailability>> call(AvailabilityParams p) async {
    final questions = [
      for (final q in await _bank.getQuestions(p.scope))
        if (p.unitIds.contains(q.unitId)) q,
    ];
    return [
      for (final t in QuestionType.values)
        if (questions.any((q) => q.question.type == t))
          TypeAvailability(
            type: t,
            perUnit: {
              for (final u in p.unitIds)
                u: questions
                    .where((q) => q.unitId == u && q.question.type == t)
                    .length,
            },
          ),
    ];
  }
}

/// Picks the questions for a plan from the bank, mixing the chosen units.
class MakePaperSet implements UseCase<PaperSet, PaperPlan> {
  const MakePaperSet(this._bank, this._random);

  final QuestionBankRepository _bank;
  final Random _random;

  @override
  Future<PaperSet> call(PaperPlan plan) async {
    final all = await _bank.getQuestions(plan.scope);
    final picked = <PlannedQuestion>[];
    final short = <QuestionType, int>{};
    for (final t in plan.types) {
      // One shuffled list per unit, then one from each unit in turn, so the
      // set is spread over the units asked for.
      final perUnit = [
        for (final u in t.unitIds)
          [
            for (final q in all)
              if (q.unitId == u && q.question.type == t.type) q,
          ]..shuffle(_random),
      ]..shuffle(_random);
      final chosen = <BankQuestion>[];
      var round = 0;
      while (chosen.length < t.count &&
          perUnit.any((list) => round < list.length)) {
        for (final list in perUnit) {
          if (round < list.length && chosen.length < t.count) {
            chosen.add(list[round]);
          }
        }
        round++;
      }
      picked.addAll([
        for (final q in chosen) PlannedQuestion(bank: q, marks: t.marksEach),
      ]);
      if (chosen.length < t.count) short[t.type] = t.count - chosen.length;
    }
    return PaperSet(questions: picked, shortBy: short);
  }
}

class ReplacementsParams extends Equatable {
  const ReplacementsParams({
    required this.scope,
    required this.type,
    required this.unitIds,
    required this.taken,
  });

  final BankScope scope;
  final QuestionType type;
  final Set<String> unitIds;

  /// Ids of the questions already in the paper.
  final Set<String> taken;

  @override
  List<Object?> get props => [scope, type, unitIds, taken];
}

/// The questions that could take another's place: the same type, from the
/// chosen units, not already in the paper.
class GetReplacements
    implements UseCase<List<BankQuestion>, ReplacementsParams> {
  const GetReplacements(this._bank);

  final QuestionBankRepository _bank;

  @override
  Future<List<BankQuestion>> call(ReplacementsParams p) async => [
    for (final q in await _bank.getQuestions(p.scope))
      if (q.question.type == p.type &&
          p.unitIds.contains(q.unitId) &&
          !p.taken.contains(q.id))
        q,
  ];
}

class SendPaperParams extends Equatable {
  const SendPaperParams({
    required this.plan,
    required this.set,
    required this.title,
    required this.send,
  });

  final PaperPlan plan;
  final PaperSet set;
  final String title;

  /// Send to the Principal now, or keep as a draft.
  final bool send;

  @override
  List<Object?> get props => [plan, set, title, send];
}

/// Makes the paper from the set and either keeps it as a draft or sends it
/// to the Principal.
class SavePlannedPaper implements UseCase<ExamPaper, SendPaperParams> {
  const SavePlannedPaper(this._exams, this._newId, this._now);

  final ExamsRepository _exams;
  final String Function() _newId;
  final DateTime Function() _now;

  @override
  Future<ExamPaper> call(SendPaperParams p) async {
    final plan = p.plan;
    final paper = ExamPaper(
      id: _newId(),
      title: p.title,
      subject: plan.scope.subject,
      classSection: plan.scope.classSection,
      date: plan.date,
      durationMinutes: plan.minutes,
      status: p.send ? PaperStatus.submitted : PaperStatus.draft,
      createdBy: plan.scope.teacherId,
      submittedAt: p.send ? _now() : null,
      kind: plan.kind,
      questions: [
        for (final q in p.set.questions)
          Question(
            text: q.bank.question.text,
            marks: q.marks,
            type: q.bank.question.type,
            options: q.bank.question.options,
            correctIndex: q.bank.question.correctIndex,
            pairs: q.bank.question.pairs,
            answer: q.bank.question.answer,
          ),
      ],
    );
    await _exams.savePaper(paper, plan.scope.teacherId);
    return paper;
  }
}
