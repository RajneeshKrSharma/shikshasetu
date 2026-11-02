import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exams/domain/entities/exam_paper.dart';
import '../../domain/entities/bank_scope.dart';
import '../../domain/entities/bank_unit.dart';
import '../../domain/entities/paper_plan.dart';
import '../../domain/usecases/bank_usecases.dart';
import '../../domain/usecases/paper_maker_usecases.dart';

enum MakerProblem { needTotals, needUnits, needTypes, mismatch }

enum MakerResult { sent, draft }

class PaperMakerState extends Equatable {
  const PaperMakerState({
    required this.date,
    this.step = 1,
    this.scopes = const [],
    this.scope,
    this.kind = ExamKind.unitTest,
    this.totalMarks = '',
    this.minutes = '',
    this.units = const [],
    this.unitIds = const {},
    this.availability = const [],
    this.plans = const {},
    this.set = const PaperSet(),
    this.replaced = 0,
    this.replaceIndex,
    this.candidates = const [],
    this.problem,
    this.saving = false,
    this.result,
  });

  final DateTime date;
  final int step;
  final List<BankScope> scopes;
  final BankScope? scope;
  final ExamKind kind;
  final String totalMarks;
  final String minutes;
  final List<UnitSummary> units;
  final Set<String> unitIds;
  final List<TypeAvailability> availability;
  final Map<QuestionType, TypePlan> plans;
  final PaperSet set;

  /// Questions the teacher swapped for another by hand.
  final int replaced;
  final int? replaceIndex;
  final List<BankQuestion> candidates;
  final MakerProblem? problem;
  final bool saving;
  final MakerResult? result;

  int get totalMarksValue => int.tryParse(totalMarks.trim()) ?? 0;
  int get minutesValue => int.tryParse(minutes.trim()) ?? 0;

  /// The plan in the order the types are listed.
  List<TypePlan> get typePlans => [
    for (final a in availability)
      if (plans[a.type] != null) plans[a.type]!,
  ];

  int get plannedMarks => typePlans.fold(0, (a, t) => a + t.marks);

  PaperPlan? get plan => scope == null
      ? null
      : PaperPlan(
          kind: kind,
          scope: scope!,
          totalMarks: totalMarksValue,
          minutes: minutesValue,
          date: date,
          unitIds: unitIds,
          types: [
            for (final t in typePlans)
              if (t.count > 0) t,
          ],
        );

  PaperMakerState copyWith({
    int? step,
    List<BankScope>? scopes,
    BankScope? scope,
    ExamKind? kind,
    String? totalMarks,
    String? minutes,
    DateTime? date,
    List<UnitSummary>? units,
    Set<String>? unitIds,
    List<TypeAvailability>? availability,
    Map<QuestionType, TypePlan>? plans,
    PaperSet? set,
    int? replaced,
    int? replaceIndex,
    List<BankQuestion>? candidates,
    MakerProblem? problem,
    bool clearProblem = false,
    bool? saving,
    MakerResult? result,
  }) => PaperMakerState(
    date: date ?? this.date,
    step: step ?? this.step,
    scopes: scopes ?? this.scopes,
    scope: scope ?? this.scope,
    kind: kind ?? this.kind,
    totalMarks: totalMarks ?? this.totalMarks,
    minutes: minutes ?? this.minutes,
    units: units ?? this.units,
    unitIds: unitIds ?? this.unitIds,
    availability: availability ?? this.availability,
    plans: plans ?? this.plans,
    set: set ?? this.set,
    replaced: replaced ?? this.replaced,
    replaceIndex: replaceIndex ?? this.replaceIndex,
    candidates: candidates ?? this.candidates,
    problem: clearProblem ? null : (problem ?? this.problem),
    saving: saving ?? this.saving,
    result: result ?? this.result,
  );

  @override
  List<Object?> get props => [
    date,
    step,
    scopes,
    scope,
    kind,
    totalMarks,
    minutes,
    units,
    unitIds,
    availability,
    plans,
    set,
    replaced,
    replaceIndex,
    candidates,
    problem,
    saving,
    result,
  ];
}

/// Making a paper from the bank in five steps: the kind of exam, the units,
/// the question types, the set (with Replace), and sending it.
class PaperMakerCubit extends Cubit<PaperMakerState> {
  PaperMakerCubit({
    required this.teacherId,
    required GetBankScopes getScopes,
    required GetBankOverview getOverview,
    required GetTypeAvailability getAvailability,
    required MakePaperSet makeSet,
    required GetReplacements getReplacements,
    required SavePlannedPaper savePaper,
    BankScope? initial,
    DateTime? today,
  }) : _getScopes = getScopes,
       _getOverview = getOverview,
       _getAvailability = getAvailability,
       _makeSet = makeSet,
       _getReplacements = getReplacements,
       _savePaper = savePaper,
       _initial = initial,
       super(PaperMakerState(date: today ?? DateTime.now()));

  final String teacherId;
  final GetBankScopes _getScopes;
  final GetBankOverview _getOverview;
  final GetTypeAvailability _getAvailability;
  final MakePaperSet _makeSet;
  final GetReplacements _getReplacements;
  final SavePlannedPaper _savePaper;
  final BankScope? _initial;

  Future<void> load() async {
    final scopes = await _getScopes(teacherId);
    final scope = scopes.contains(_initial)
        ? _initial
        : (scopes.isEmpty ? null : scopes.first);
    if (isClosed) return;
    emit(state.copyWith(scopes: scopes, scope: scope));
    if (scope != null) await _loadUnits(scope);
  }

  Future<void> scopeChosen(BankScope scope) async {
    emit(state.copyWith(scope: scope, unitIds: const {}));
    await _loadUnits(scope);
  }

  Future<void> _loadUnits(BankScope scope) async {
    final overview = await _getOverview(scope);
    if (isClosed) return;
    emit(state.copyWith(units: overview.units));
  }

  void kindChosen(ExamKind k) => emit(state.copyWith(kind: k));
  void totalMarksChanged(String v) => emit(state.copyWith(totalMarks: v));
  void minutesChanged(String v) => emit(state.copyWith(minutes: v));
  void dateChosen(DateTime d) => emit(state.copyWith(date: d));

  void toUnits() {
    if (state.totalMarksValue <= 0 || state.minutesValue <= 0) {
      emit(state.copyWith(problem: MakerProblem.needTotals));
      return;
    }
    emit(state.copyWith(step: 2, clearProblem: true));
  }

  void unitToggled(String id) {
    final summary = state.units.firstWhere((u) => u.unit.id == id);
    if (summary.total == 0) return;
    final ids = {...state.unitIds};
    if (!ids.remove(id)) ids.add(id);
    emit(state.copyWith(unitIds: ids, clearProblem: true));
  }

  Future<void> toTypes() async {
    final scope = state.scope;
    if (scope == null || state.unitIds.isEmpty) {
      emit(state.copyWith(problem: MakerProblem.needUnits));
      return;
    }
    final availability = await _getAvailability(
      AvailabilityParams(scope, state.unitIds),
    );
    if (isClosed) return;
    emit(
      state.copyWith(
        step: 3,
        availability: availability,
        clearProblem: true,
        plans: {
          for (final a in availability)
            a.type:
                state.plans[a.type]?.copyWith(
                  unitIds: state.plans[a.type]!.unitIds.intersection({
                    for (final e in a.perUnit.entries)
                      if (e.value > 0) e.key,
                  }),
                ) ??
                TypePlan(
                  type: a.type,
                  unitIds: {
                    for (final e in a.perUnit.entries)
                      if (e.value > 0) e.key,
                  },
                  count: 0,
                  marksEach: 1,
                ),
        },
      ),
    );
  }

  void _plan(QuestionType type, TypePlan Function(TypePlan) change) {
    final current = state.plans[type];
    if (current == null) return;
    emit(
      state.copyWith(
        plans: {...state.plans, type: change(current)},
        clearProblem: true,
      ),
    );
  }

  void planUnitToggled(QuestionType type, String unitId) => _plan(type, (p) {
    final ids = {...p.unitIds};
    if (!ids.remove(unitId)) ids.add(unitId);
    return p.copyWith(unitIds: ids);
  });

  void planCountChanged(QuestionType type, int count) =>
      _plan(type, (p) => p.copyWith(count: count < 0 ? 0 : count));

  void planMarksChanged(QuestionType type, int marks) =>
      _plan(type, (p) => p.copyWith(marksEach: marks < 1 ? 1 : marks));

  Future<void> makeSet() async {
    final plan = state.plan;
    if (plan == null || plan.types.isEmpty) {
      emit(state.copyWith(problem: MakerProblem.needTypes));
      return;
    }
    final set = await _makeSet(plan);
    if (isClosed) return;
    emit(state.copyWith(step: 4, set: set, replaced: 0, clearProblem: true));
  }

  /// Loads what could take the place of question [index] of the set.
  Future<void> openReplace(int index) async {
    final scope = state.scope;
    final plan = state.plan;
    if (scope == null || plan == null) return;
    final target = state.set.questions[index];
    final unitIds = plan.types.firstWhere((t) => t.type == target.type).unitIds;
    final candidates = await _getReplacements(
      ReplacementsParams(
        scope: scope,
        type: target.type,
        unitIds: unitIds,
        taken: {for (final q in state.set.questions) q.bank.id},
      ),
    );
    if (isClosed) return;
    emit(state.copyWith(replaceIndex: index, candidates: candidates));
  }

  void replaced(BankQuestion q) {
    final i = state.replaceIndex;
    if (i == null) return;
    final old = state.set.questions[i];
    final questions = [...state.set.questions]
      ..[i] = PlannedQuestion(bank: q, marks: old.marks);
    emit(
      state.copyWith(
        set: PaperSet(questions: questions, shortBy: state.set.shortBy),
        replaced: state.replaced + 1,
        candidates: const [],
      ),
    );
  }

  void toSend() {
    if (state.set.marks != state.totalMarksValue) {
      emit(state.copyWith(problem: MakerProblem.mismatch));
      return;
    }
    emit(state.copyWith(step: 5, clearProblem: true));
  }

  void back() {
    if (state.step > 1) {
      emit(state.copyWith(step: state.step - 1, clearProblem: true));
    }
  }

  /// Saves the paper as a draft, or sends it to the Principal.
  Future<void> finish({required String title, required bool send}) async {
    final plan = state.plan;
    if (plan == null) return;
    emit(state.copyWith(saving: true));
    await _savePaper(
      SendPaperParams(plan: plan, set: state.set, title: title, send: send),
    );
    if (isClosed) return;
    emit(
      state.copyWith(
        saving: false,
        result: send ? MakerResult.sent : MakerResult.draft,
      ),
    );
  }
}
