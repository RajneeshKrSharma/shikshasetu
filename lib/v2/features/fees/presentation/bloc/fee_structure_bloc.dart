import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../../../core/money.dart';
import '../../domain/entities/fees.dart';
import '../../domain/usecases/fees_usecases.dart';

sealed class FeeStructureEvent extends Equatable {
  const FeeStructureEvent();

  @override
  List<Object?> get props => const [];
}

final class FeeStructureStarted extends FeeStructureEvent {
  const FeeStructureStarted();
}

final class FeeClassChosen extends FeeStructureEvent {
  const FeeClassChosen(this.classId);

  final String classId;

  @override
  List<Object?> get props => [classId];
}

final class FeeAmountChanged extends FeeStructureEvent {
  const FeeAmountChanged(this.head, this.amount);

  final FeeHead head;
  final Money amount;

  @override
  List<Object?> get props => [head, amount];
}

class FeeStructureState extends Equatable {
  const FeeStructureState({
    this.status = ViewStatus.loading,
    this.failure,
    this.classes = const [],
    this.classId,
    this.lines = const [],
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<SchoolClass> classes;
  final String? classId;
  final List<FeeStructureLine> lines;
  final bool busy;

  FeeStructureState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<SchoolClass>? classes,
    String? classId,
    List<FeeStructureLine>? lines,
    bool? busy,
  }) => FeeStructureState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    classes: classes ?? this.classes,
    classId: classId ?? this.classId,
    lines: lines ?? this.lines,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, classes, classId, lines, busy];
}

class FeeStructureBloc extends Bloc<FeeStructureEvent, FeeStructureState> {
  FeeStructureBloc({
    required GetClasses getClasses,
    required GetFeeStructure getFeeStructure,
    required SetFeeAmount setFeeAmount,
  }) : _classes = getClasses,
       _structure = getFeeStructure,
       _set = setFeeAmount,
       super(const FeeStructureState()) {
    on<FeeStructureStarted>(_onStarted);
    on<FeeClassChosen>((e, emit) => _show(emit, e.classId));
    on<FeeAmountChanged>(_onChanged);
  }

  final GetClasses _classes;
  final GetFeeStructure _structure;
  final SetFeeAmount _set;

  Future<void> _onStarted(
    FeeStructureStarted e,
    Emitter<FeeStructureState> emit,
  ) async {
    try {
      final classes = await _classes(const NoParams());
      emit(state.copyWith(classes: classes, status: ViewStatus.ready));
      if (classes.isNotEmpty) await _show(emit, classes.first.id);
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _show(Emitter<FeeStructureState> emit, String classId) async {
    emit(state.copyWith(classId: classId, busy: true, clearFailure: true));
    try {
      emit(state.copyWith(lines: await _structure(classId), busy: false));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  Future<void> _onChanged(
    FeeAmountChanged e,
    Emitter<FeeStructureState> emit,
  ) async {
    final classId = state.classId;
    if (classId == null) return;
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _set(SetFeeAmountParams(classId, e.head, e.amount));
      emit(state.copyWith(lines: await _structure(classId), busy: false));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
