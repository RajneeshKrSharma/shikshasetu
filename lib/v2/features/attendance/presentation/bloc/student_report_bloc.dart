import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../../core/utils/date_range.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/attendance_usecases.dart';

sealed class StudentReportEvent extends Equatable {
  const StudentReportEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentReportStarted extends StudentReportEvent {
  const StudentReportStarted();
}

final class ReportClassChosen extends StudentReportEvent {
  const ReportClassChosen(this.classId);

  final String classId;

  @override
  List<Object?> get props => [classId];
}

final class ReportRangeChosen extends StudentReportEvent {
  const ReportRangeChosen(this.range);

  final DateTimeRange range;

  @override
  List<Object?> get props => [range];
}

class StudentReportState extends Equatable {
  const StudentReportState({
    this.status = ViewStatus.loading,
    this.failure,
    this.classes = const [],
    this.classId,
    this.range,
    this.tallies = const [],
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<SchoolClass> classes;
  final String? classId;
  final DateTimeRange? range;
  final List<StudentTally> tallies;
  final bool busy;

  StudentReportState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<SchoolClass>? classes,
    String? classId,
    DateTimeRange? range,
    List<StudentTally>? tallies,
    bool? busy,
  }) => StudentReportState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    classes: classes ?? this.classes,
    classId: classId ?? this.classId,
    range: range ?? this.range,
    tallies: tallies ?? this.tallies,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    classes,
    classId,
    range,
    tallies,
    busy,
  ];
}

/// A class's attendance over a period, student by student.
class StudentReportBloc extends Bloc<StudentReportEvent, StudentReportState> {
  StudentReportBloc({
    required GetClasses getClasses,
    required GetStudentReport getStudentReport,
  }) : _classes = getClasses,
       _report = getStudentReport,
       super(const StudentReportState()) {
    on<StudentReportStarted>(_onStarted);
    on<ReportClassChosen>(
      (e, emit) => _load(emit, state.copyWith(classId: e.classId)),
    );
    on<ReportRangeChosen>(
      (e, emit) => _load(emit, state.copyWith(range: e.range)),
    );
  }

  final GetClasses _classes;
  final GetStudentReport _report;

  Future<void> _onStarted(
    StudentReportStarted e,
    Emitter<StudentReportState> emit,
  ) async {
    try {
      final classes = await _classes(const NoParams());
      final base = state.copyWith(
        status: ViewStatus.ready,
        classes: classes,
        range: DateRanges.thisMonth(DateTime.now()),
      );
      await _load(
        emit,
        classes.isEmpty ? base : base.copyWith(classId: classes.first.id),
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

  Future<void> _load(
    Emitter<StudentReportState> emit,
    StudentReportState next,
  ) async {
    final classId = next.classId;
    final range = next.range;
    if (classId == null || range == null) {
      emit(next);
      return;
    }
    emit(next.copyWith(busy: true, clearFailure: true));
    try {
      emit(
        next.copyWith(
          busy: false,
          tallies: await _report(ReportParams(classId, range.start, range.end)),
        ),
      );
    } on ServerException catch (error) {
      emit(next.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
