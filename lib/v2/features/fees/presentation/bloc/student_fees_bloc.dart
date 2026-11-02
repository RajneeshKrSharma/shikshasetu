import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/fees.dart';
import '../../domain/usecases/fees_usecases.dart';

sealed class StudentFeesEvent extends Equatable {
  const StudentFeesEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentFeesStarted extends StudentFeesEvent {
  const StudentFeesStarted();
}

final class FeeReceived extends StudentFeesEvent {
  const FeeReceived(this.params);

  final ReceiveFeeParams params;

  @override
  List<Object?> get props => [params];
}

class StudentFeesState extends Equatable {
  const StudentFeesState({
    this.status = ViewStatus.loading,
    this.failure,
    this.statement,
    this.busy = false,
    this.changedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final FeeStatement? statement;
  final bool busy;

  /// Goes up each time money was received, so the lists can reload.
  final int changedCount;

  StudentFeesState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    FeeStatement? statement,
    bool? busy,
    int? changedCount,
  }) => StudentFeesState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    statement: statement ?? this.statement,
    busy: busy ?? this.busy,
    changedCount: changedCount ?? this.changedCount,
  );

  @override
  List<Object?> get props => [status, failure, statement, busy, changedCount];
}

class StudentFeesBloc extends Bloc<StudentFeesEvent, StudentFeesState> {
  StudentFeesBloc({
    required String studentId,
    required GetStudentFees getStudentFees,
    required ReceiveFee receiveFee,
  }) : _id = studentId,
       _get = getStudentFees,
       _receive = receiveFee,
       super(const StudentFeesState()) {
    on<StudentFeesStarted>(_onStarted);
    on<FeeReceived>(_onReceived);
  }

  final String _id;
  final GetStudentFees _get;
  final ReceiveFee _receive;

  Future<void> _onStarted(
    StudentFeesStarted e,
    Emitter<StudentFeesState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: ViewStatus.ready, statement: await _get(_id)),
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

  Future<void> _onReceived(
    FeeReceived e,
    Emitter<StudentFeesState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _receive(e.params);
      emit(
        state.copyWith(
          busy: false,
          statement: await _get(_id),
          changedCount: state.changedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
