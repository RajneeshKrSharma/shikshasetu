import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/students_access.dart';
import '../../domain/usecases/classes_usecases.dart';
import '../../domain/usecases/students_usecases.dart';

sealed class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentsStarted extends StudentsEvent {
  const StudentsStarted();
}

final class StudentsFiltered extends StudentsEvent {
  const StudentsFiltered({this.classId, this.query});

  /// null for "all classes".
  final String? classId;
  final String? query;

  @override
  List<Object?> get props => [classId, query];
}

final class StudentsFilterCleared extends StudentsEvent {
  const StudentsFilterCleared();
}

class StudentsState extends Equatable {
  const StudentsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.students = const [],
    this.classes = const [],
    this.classId,
    this.query = '',
    this.canManage = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Student> students;
  final List<SchoolClass> classes;
  final String? classId;
  final String query;
  final bool canManage;

  StudentsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Student>? students,
    List<SchoolClass>? classes,
    String? classId,
    bool clearClass = false,
    String? query,
    bool? canManage,
  }) => StudentsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    students: students ?? this.students,
    classes: classes ?? this.classes,
    classId: clearClass ? null : (classId ?? this.classId),
    query: query ?? this.query,
    canManage: canManage ?? this.canManage,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    students,
    classes,
    classId,
    query,
    canManage,
  ];
}

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc({
    required Account account,
    required GetStudents getStudents,
    required GetClasses getClasses,
  }) : _account = account,
       _students = getStudents,
       _classes = getClasses,
       super(const StudentsState()) {
    on<StudentsStarted>(_onStarted);
    on<StudentsFiltered>(_onFiltered);
    on<StudentsFilterCleared>(
      (e, emit) => _load(emit, state.copyWith(clearClass: true, query: '')),
    );
  }

  final Account _account;
  final GetStudents _students;
  final GetClasses _classes;

  Future<void> _onStarted(
    StudentsStarted e,
    Emitter<StudentsState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          classes: await _classes(const NoParams()),
          canManage: StudentsAccess.of(_account).canManageStudents,
        ),
      );
      await _load(emit, state);
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _onFiltered(StudentsFiltered e, Emitter<StudentsState> emit) =>
      _load(
        emit,
        state.copyWith(
          classId: e.classId,
          clearClass: e.classId == null && e.query == null,
          query: e.query,
        ),
      );

  Future<void> _load(Emitter<StudentsState> emit, StudentsState next) async {
    emit(next.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        next.copyWith(
          status: ViewStatus.ready,
          students: await _students(
            GetStudentsParams(classId: next.classId, query: next.query),
          ),
        ),
      );
    } on ServerException catch (error) {
      emit(
        next.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }
}
