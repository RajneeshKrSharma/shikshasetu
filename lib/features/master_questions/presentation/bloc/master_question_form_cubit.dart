import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/presentation/bloc/question_draft.dart';
import '../../../exams/presentation/widgets/question_edit_handler.dart';
import '../../domain/entities/master_question.dart';

class MasterFormState extends Equatable {
  const MasterFormState({required this.draft, this.subject});

  final QuestionDraft draft;
  final String? subject;

  @override
  List<Object?> get props => [draft, subject];
}

/// One master question being written. It is also the editor's handler: the
/// card calls these methods and the draft updates.
class MasterQuestionFormCubit extends Cubit<MasterFormState>
    implements QuestionEditHandler {
  MasterQuestionFormCubit({MasterQuestion? initial, QuestionType? type})
    : id = initial?.id,
      super(
        MasterFormState(
          draft: initial == null
              ? QuestionDraft.blank(0, type ?? QuestionType.mcq)
              : QuestionDraft.fromQuestion(0, initial.question),
          subject: initial?.subject,
        ),
      );

  /// Set when editing an existing master question.
  final String? id;

  void _edit(QuestionDraft Function(QuestionDraft) change) =>
      emit(MasterFormState(draft: change(state.draft), subject: state.subject));

  void subjectChosen(String? subject) =>
      emit(MasterFormState(draft: state.draft, subject: subject));

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
