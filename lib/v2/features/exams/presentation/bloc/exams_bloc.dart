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

sealed class ExamsEvent extends Equatable {
  const ExamsEvent();

  @override
  List<Object?> get props => const [];
}

final class ExamsStarted extends ExamsEvent {
  const ExamsStarted();
}

final class ExamsFiltered extends ExamsEvent {
  const ExamsFiltered({this.classId, this.awaitingApproval = false});

  final String? classId;
  final bool awaitingApproval;

  @override
  List<Object?> get props => [classId, awaitingApproval];
}

final class ExamSaved extends ExamsEvent {
  const ExamSaved(this.draft);

  final ExamDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class ExamRemoved extends ExamsEvent {
  const ExamRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class ExamsState extends Equatable {
  const ExamsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.exams = const [],
    this.classes = const [],
    this.classId,
    this.awaitingApproval = false,
    this.access,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Exam> exams;
  final List<SchoolClass> classes;
  final String? classId;
  final bool awaitingApproval;
  final ExamsAccess? access;
  final bool busy;

  bool get canSchedule => access?.canSchedule ?? false;

  /// What the list shows: all exams, or only those whose paper waits.
  List<Exam> get shown => awaitingApproval
      ? [
          for (final e in exams)
            if (e.paperStatus == PaperStatus.sent) e,
        ]
      : exams;

  ExamsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Exam>? exams,
    List<SchoolClass>? classes,
    String? classId,
    bool clearClass = false,
    bool? awaitingApproval,
    ExamsAccess? access,
    bool? busy,
  }) => ExamsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    exams: exams ?? this.exams,
    classes: classes ?? this.classes,
    classId: clearClass ? null : (classId ?? this.classId),
    awaitingApproval: awaitingApproval ?? this.awaitingApproval,
    access: access ?? this.access,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    exams,
    classes,
    classId,
    awaitingApproval,
    busy,
  ];
}

class ExamsBloc extends Bloc<ExamsEvent, ExamsState> {
  ExamsBloc({
    required Account account,
    required GetExams getExams,
    required SaveExam saveExam,
    required RemoveExam removeExam,
    required GetClasses getClasses,
  }) : _account = account,
       _get = getExams,
       _save = saveExam,
       _remove = removeExam,
       _classes = getClasses,
       super(const ExamsState()) {
    on<ExamsStarted>(_onStarted);
    on<ExamsFiltered>(
      (e, emit) => _load(
        emit,
        state.copyWith(
          classId: e.classId,
          clearClass: e.classId == null,
          awaitingApproval: e.awaitingApproval,
        ),
      ),
    );
    on<ExamSaved>((e, emit) => _change(emit, () => _save(e.draft)));
    on<ExamRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final Account _account;
  final GetExams _get;
  final SaveExam _save;
  final RemoveExam _remove;
  final GetClasses _classes;

  Future<void> _onStarted(ExamsStarted e, Emitter<ExamsState> emit) async {
    try {
      final classes = await _classes(const NoParams());
      await _load(
        emit,
        state.copyWith(classes: classes, access: ExamsAccess.of(_account)),
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

  Future<void> _load(Emitter<ExamsState> emit, ExamsState next) async {
    emit(next.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        next.copyWith(
          status: ViewStatus.ready,
          exams: await _get(next.classId),
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

  Future<void> _change(
    Emitter<ExamsState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(state.copyWith(busy: false, exams: await _get(state.classId)));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
