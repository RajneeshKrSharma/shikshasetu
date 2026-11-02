import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/exams.dart';
import '../../domain/usecases/exams_usecases.dart';

sealed class UnitQuestionsEvent extends Equatable {
  const UnitQuestionsEvent();

  @override
  List<Object?> get props => const [];
}

final class UnitQuestionsStarted extends UnitQuestionsEvent {
  const UnitQuestionsStarted();
}

final class QuestionSaved extends UnitQuestionsEvent {
  const QuestionSaved(this.draft);

  final QuestionDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class QuestionRemoved extends UnitQuestionsEvent {
  const QuestionRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class UnitQuestionsState extends Equatable {
  const UnitQuestionsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.questions = const [],
    this.canEdit = false,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Question> questions;
  final bool canEdit;
  final bool busy;

  UnitQuestionsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Question>? questions,
    bool? canEdit,
    bool? busy,
  }) => UnitQuestionsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    questions: questions ?? this.questions,
    canEdit: canEdit ?? this.canEdit,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, questions, canEdit, busy];
}

class UnitQuestionsBloc extends Bloc<UnitQuestionsEvent, UnitQuestionsState> {
  UnitQuestionsBloc({
    required String unitId,
    required Account account,
    required GetQuestions getQuestions,
    required SaveQuestion saveQuestion,
    required RemoveQuestion removeQuestion,
  }) : _unitId = unitId,
       _account = account,
       _get = getQuestions,
       _save = saveQuestion,
       _remove = removeQuestion,
       super(const UnitQuestionsState()) {
    on<UnitQuestionsStarted>(_onStarted);
    on<QuestionSaved>((e, emit) => _change(emit, () => _save(e.draft)));
    on<QuestionRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final String _unitId;
  final Account _account;
  final GetQuestions _get;
  final SaveQuestion _save;
  final RemoveQuestion _remove;

  Future<void> _onStarted(
    UnitQuestionsStarted e,
    Emitter<UnitQuestionsState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          questions: await _get(_unitId),
          canEdit: ExamsAccess.of(_account).canPrepare,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _change(
    Emitter<UnitQuestionsState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(state.copyWith(busy: false, questions: await _get(_unitId)));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
