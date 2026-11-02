import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/students_access.dart';
import '../../domain/usecases/students_usecases.dart';

sealed class StudentDetailEvent extends Equatable {
  const StudentDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentDetailStarted extends StudentDetailEvent {
  const StudentDetailStarted();
}

final class StudentActiveToggled extends StudentDetailEvent {
  const StudentActiveToggled();
}

class StudentDetailState extends Equatable {
  const StudentDetailState({
    this.status = ViewStatus.loading,
    this.failure,
    this.student,
    this.access,
    this.busy = false,
    this.changedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final Student? student;
  final StudentsAccess? access;
  final bool busy;

  /// Goes up when the student was changed here, so lists can reload.
  final int changedCount;

  StudentDetailState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    Student? student,
    StudentsAccess? access,
    bool? busy,
    int? changedCount,
  }) => StudentDetailState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    student: student ?? this.student,
    access: access ?? this.access,
    busy: busy ?? this.busy,
    changedCount: changedCount ?? this.changedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    student,
    access,
    busy,
    changedCount,
  ];
}

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  StudentDetailBloc({
    required String studentId,
    required Account account,
    required GetStudent getStudent,
    required SetStudentActive setStudentActive,
  }) : _id = studentId,
       _account = account,
       _get = getStudent,
       _setActive = setStudentActive,
       super(const StudentDetailState()) {
    on<StudentDetailStarted>(_onStarted);
    on<StudentActiveToggled>(_onToggled);
  }

  final String _id;
  final Account _account;
  final GetStudent _get;
  final SetStudentActive _setActive;

  Future<void> _onStarted(
    StudentDetailStarted e,
    Emitter<StudentDetailState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          student: await _get(_id),
          access: StudentsAccess.of(_account),
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

  Future<void> _onToggled(
    StudentActiveToggled e,
    Emitter<StudentDetailState> emit,
  ) async {
    final student = state.student!;
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      emit(
        state.copyWith(
          busy: false,
          student: await _setActive(
            SetStudentActiveParams(student.id, active: !student.isActive),
          ),
          changedCount: state.changedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
