import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/presentation/bloc/question_draft.dart';
import '../../../exams/presentation/widgets/question_edit_handler.dart';
import '../../domain/entities/bank_scope.dart';
import '../../domain/entities/bank_unit.dart';
import '../../domain/usecases/bank_usecases.dart';

class AddQuestionState extends Equatable {
  const AddQuestionState({
    required this.draft,
    this.units = const [],
    this.unitId,
    this.saves = 0,
    this.closeAfterSave = false,
    this.unitMissing = false,
  });

  final QuestionDraft draft;
  final List<BankUnit> units;
  final String? unitId;

  /// How many questions were saved in this session (to show a message).
  final int saves;

  /// The last save was "Save", not "Save and add another".
  final bool closeAfterSave;
  final bool unitMissing;

  AddQuestionState copyWith({
    QuestionDraft? draft,
    List<BankUnit>? units,
    String? unitId,
    int? saves,
    bool? closeAfterSave,
    bool? unitMissing,
  }) => AddQuestionState(
    draft: draft ?? this.draft,
    units: units ?? this.units,
    unitId: unitId ?? this.unitId,
    saves: saves ?? this.saves,
    closeAfterSave: closeAfterSave ?? this.closeAfterSave,
    unitMissing: unitMissing ?? this.unitMissing,
  );

  @override
  List<Object?> get props => [
    draft,
    units,
    unitId,
    saves,
    closeAfterSave,
    unitMissing,
  ];
}

/// One question being typed into a unit. It is also the editor's handler.
class AddQuestionCubit extends Cubit<AddQuestionState>
    implements QuestionEditHandler {
  AddQuestionCubit({
    required this.scope,
    required GetBankOverview getOverview,
    required AddBankUnit addUnit,
    required SaveBankQuestions save,
    this.initialUnitId,
  }) : _getOverview = getOverview,
       _addUnit = addUnit,
       _save = save,
       super(
         AddQuestionState(
           draft: QuestionDraft.blank(0, QuestionType.fillBlank),
           unitId: initialUnitId,
         ),
       );

  final BankScope scope;
  final String? initialUnitId;
  final GetBankOverview _getOverview;
  final AddBankUnit _addUnit;
  final SaveBankQuestions _save;

  Future<void> load() async {
    final overview = await _getOverview(scope);
    final units = [for (final u in overview.units) u.unit];
    if (isClosed) return;
    emit(state.copyWith(units: units));
  }

  void unitChosen(String id) =>
      emit(state.copyWith(unitId: id, unitMissing: false));

  Future<void> unitAdded(String name) async {
    final unit = await _addUnit(AddUnitParams(scope, name));
    if (isClosed) return;
    emit(
      state.copyWith(
        units: [...state.units, unit],
        unitId: unit.id,
        unitMissing: false,
      ),
    );
  }

  /// Saves the question. With [again] the form is cleared for the next one.
  Future<void> save({required bool again}) async {
    final unitId = state.unitId;
    if (unitId == null) {
      emit(state.copyWith(unitMissing: true));
      return;
    }
    await _save(SaveQuestionsParams(scope, unitId, [state.draft.toQuestion()]));
    if (isClosed) return;
    emit(
      state.copyWith(
        draft: QuestionDraft.blank(state.saves + 1, state.draft.type),
        saves: state.saves + 1,
        closeAfterSave: !again,
      ),
    );
  }

  void _edit(QuestionDraft Function(QuestionDraft) change) =>
      emit(state.copyWith(draft: change(state.draft)));

  @override
  void text(String value) => _edit((d) => d.copyWith(text: value));
  @override
  void marks(String value) => _edit((d) => d.copyWith(marks: value));
  @override
  void answer(String value) => _edit((d) => d.copyWith(answer: value));
  @override
  void type(QuestionType type) => _edit((d) => d.withType(type));
  @override
  void optionEdited(int index, String value) =>
      _edit((d) => d.withOptionEdited(index, value));
  @override
  void optionAdded() => _edit((d) => d.withOptionAdded());
  @override
  void optionRemoved(int index) => _edit((d) => d.withOptionRemoved(index));
  @override
  void correct(int? index) => _edit((d) => d.withCorrect(index));
  @override
  void pairEdited(int index, {String? left, String? right}) =>
      _edit((d) => d.withPairEdited(index, left: left, right: right));
  @override
  void pairAdded() => _edit((d) => d.withPairAdded());
  @override
  void pairRemoved(int index) => _edit((d) => d.withPairRemoved(index));
}
