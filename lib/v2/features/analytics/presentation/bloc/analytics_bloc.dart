import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../../core/utils/date_range.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/usecases/analytics_usecases.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => const [];
}

final class AnalyticsStarted extends AnalyticsEvent {
  const AnalyticsStarted();
}

final class GraphChosen extends AnalyticsEvent {
  const GraphChosen(this.kind);

  final GraphKind kind;

  @override
  List<Object?> get props => [kind];
}

final class AnalyticsRangeChosen extends AnalyticsEvent {
  const AnalyticsRangeChosen(this.range);

  final DateTimeRange range;

  @override
  List<Object?> get props => [range];
}

final class AnalyticsClassChosen extends AnalyticsEvent {
  const AnalyticsClassChosen(this.classId);

  /// Null for the whole school.
  final String? classId;

  @override
  List<Object?> get props => [classId];
}

class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.kind = GraphKind.studentAttendance,
    required this.range,
    this.classId,
    this.classes = const [],
    this.data,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final GraphKind kind;
  final DateTimeRange range;
  final String? classId;
  final List<SchoolClass> classes;
  final GraphData? data;
  final bool busy;

  AnalyticsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    GraphKind? kind,
    DateTimeRange? range,
    String? classId,
    bool clearClass = false,
    List<SchoolClass>? classes,
    GraphData? data,
    bool? busy,
  }) => AnalyticsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    kind: kind ?? this.kind,
    range: range ?? this.range,
    classId: clearClass ? null : (classId ?? this.classId),
    classes: classes ?? this.classes,
    data: data ?? this.data,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    kind,
    range,
    classId,
    classes,
    data,
    busy,
  ];
}

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({required GetGraph getGraph, required GetClasses getClasses})
    : _graph = getGraph,
      _classes = getClasses,
      super(AnalyticsState(range: DateRanges.thisMonth(DateTime.now()))) {
    on<AnalyticsStarted>((e, emit) async {
      try {
        final classes = await _classes(const NoParams());
        await _load(emit, state.copyWith(classes: classes));
      } on ServerException catch (error) {
        emit(
          state.copyWith(
            status: ViewStatus.failed,
            failure: ViewFailure.from(error),
          ),
        );
      }
    });
    on<GraphChosen>((e, emit) => _load(emit, state.copyWith(kind: e.kind)));
    on<AnalyticsRangeChosen>(
      (e, emit) => _load(emit, state.copyWith(range: e.range)),
    );
    on<AnalyticsClassChosen>(
      (e, emit) => _load(
        emit,
        state.copyWith(classId: e.classId, clearClass: e.classId == null),
      ),
    );
  }

  final GetGraph _graph;
  final GetClasses _classes;

  Future<void> _load(Emitter<AnalyticsState> emit, AnalyticsState next) async {
    emit(next.copyWith(busy: true, clearFailure: true));
    try {
      emit(
        next.copyWith(
          status: ViewStatus.ready,
          busy: false,
          data: await _graph(
            GetGraphParams(
              next.kind,
              next.range.start,
              next.range.end,
              classId: next.classId,
            ),
          ),
        ),
      );
    } on ServerException catch (error) {
      emit(
        next.copyWith(
          status: ViewStatus.failed,
          busy: false,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }
}
