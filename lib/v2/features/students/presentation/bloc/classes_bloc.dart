import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/entities/students_access.dart';
import '../../domain/usecases/classes_usecases.dart';

sealed class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object?> get props => const [];
}

final class ClassesStarted extends ClassesEvent {
  const ClassesStarted();
}

final class ClassSaved extends ClassesEvent {
  const ClassSaved(this.params);

  final SaveClassParams params;

  @override
  List<Object?> get props => [params];
}

final class ClassRemoved extends ClassesEvent {
  const ClassRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class ClassesState extends Equatable {
  const ClassesState({
    this.status = ViewStatus.loading,
    this.failure,
    this.classes = const [],
    this.canManage = false,
    this.busy = false,
    this.savedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<SchoolClass> classes;
  final bool canManage;
  final bool busy;
  final int savedCount;

  ClassesState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<SchoolClass>? classes,
    bool? canManage,
    bool? busy,
    int? savedCount,
  }) => ClassesState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    classes: classes ?? this.classes,
    canManage: canManage ?? this.canManage,
    busy: busy ?? this.busy,
    savedCount: savedCount ?? this.savedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    classes,
    canManage,
    busy,
    savedCount,
  ];
}

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  ClassesBloc({
    required Account account,
    required GetClasses getClasses,
    required SaveClass saveClass,
    required RemoveClass removeClass,
  }) : _account = account,
       _get = getClasses,
       _save = saveClass,
       _remove = removeClass,
       super(const ClassesState()) {
    on<ClassesStarted>(_onStarted);
    on<ClassSaved>((e, emit) => _change(emit, () => _save(e.params)));
    on<ClassRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final Account _account;
  final GetClasses _get;
  final SaveClass _save;
  final RemoveClass _remove;

  Future<void> _onStarted(ClassesStarted e, Emitter<ClassesState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          classes: await _get(const NoParams()),
          canManage: StudentsAccess.of(_account).canManageClasses,
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
    Emitter<ClassesState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(
        state.copyWith(
          busy: false,
          classes: await _get(const NoParams()),
          savedCount: state.savedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
