import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/exams.dart';
import '../../domain/usecases/exams_usecases.dart';

sealed class QuestionBankEvent extends Equatable {
  const QuestionBankEvent();

  @override
  List<Object?> get props => const [];
}

final class QuestionBankStarted extends QuestionBankEvent {
  const QuestionBankStarted();
}

final class UnitSaved extends QuestionBankEvent {
  const UnitSaved(this.draft);

  final UnitDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class UnitRemoved extends QuestionBankEvent {
  const UnitRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class QuestionBankState extends Equatable {
  const QuestionBankState({
    this.status = ViewStatus.loading,
    this.failure,
    this.units = const [],
    this.classes = const [],
    this.canManage = false,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<QuestionUnit> units;
  final List<SchoolClass> classes;
  final bool canManage;
  final bool busy;

  QuestionBankState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<QuestionUnit>? units,
    List<SchoolClass>? classes,
    bool? canManage,
    bool? busy,
  }) => QuestionBankState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    units: units ?? this.units,
    classes: classes ?? this.classes,
    canManage: canManage ?? this.canManage,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, units, classes, canManage, busy];
}

class QuestionBankBloc extends Bloc<QuestionBankEvent, QuestionBankState> {
  QuestionBankBloc({
    required Account account,
    required GetUnits getUnits,
    required SaveUnit saveUnit,
    required RemoveUnit removeUnit,
    required GetClasses getClasses,
  }) : _account = account,
       _get = getUnits,
       _save = saveUnit,
       _remove = removeUnit,
       _classes = getClasses,
       super(const QuestionBankState()) {
    on<QuestionBankStarted>(_onStarted);
    on<UnitSaved>((e, emit) => _change(emit, () => _save(e.draft)));
    on<UnitRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final Account _account;
  final GetUnits _get;
  final SaveUnit _save;
  final RemoveUnit _remove;
  final GetClasses _classes;

  Future<void> _onStarted(
    QuestionBankStarted e,
    Emitter<QuestionBankState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          units: await _get(const NoUnitsParams()),
          classes: await _classes(const NoParams()),
          canManage: ExamsAccess.of(_account).canManageBank,
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
    Emitter<QuestionBankState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(
        state.copyWith(busy: false, units: await _get(const NoUnitsParams())),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
