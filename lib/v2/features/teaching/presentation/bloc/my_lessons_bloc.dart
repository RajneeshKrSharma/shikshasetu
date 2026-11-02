import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/teaching.dart';
import '../../domain/usecases/teaching_usecases.dart';

sealed class MyLessonsEvent extends Equatable {
  const MyLessonsEvent();

  @override
  List<Object?> get props => const [];
}

final class MyLessonsStarted extends MyLessonsEvent {
  const MyLessonsStarted();
}

final class LessonSubmitted extends MyLessonsEvent {
  const LessonSubmitted(this.params);

  final RecordLessonParams params;

  @override
  List<Object?> get props => [params];
}

class MyLessonsState extends Equatable {
  const MyLessonsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.allotments = const [],
    this.lessons = const [],
    this.canRecord = false,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Allotment> allotments;
  final List<Lesson> lessons;
  final bool canRecord;
  final bool busy;

  MyLessonsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Allotment>? allotments,
    List<Lesson>? lessons,
    bool? canRecord,
    bool? busy,
  }) => MyLessonsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    allotments: allotments ?? this.allotments,
    lessons: lessons ?? this.lessons,
    canRecord: canRecord ?? this.canRecord,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    allotments,
    lessons,
    canRecord,
    busy,
  ];
}

/// A teacher's own classes and the lessons they recorded lately.
class MyLessonsBloc extends Bloc<MyLessonsEvent, MyLessonsState> {
  MyLessonsBloc({
    required Account account,
    required GetAllotments getAllotments,
    required GetRecentLessons getRecentLessons,
    required RecordLesson recordLesson,
  }) : _account = account,
       _allotments = getAllotments,
       _lessons = getRecentLessons,
       _record = recordLesson,
       super(const MyLessonsState()) {
    on<MyLessonsStarted>(_onStarted);
    on<LessonSubmitted>(_onSubmitted);
  }

  final Account _account;
  final GetAllotments _allotments;
  final GetRecentLessons _lessons;
  final RecordLesson _record;

  DateTime get _since => DateTime.now().subtract(const Duration(days: 30));

  Future<void> _onStarted(
    MyLessonsStarted e,
    Emitter<MyLessonsState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          allotments: await _allotments(null),
          lessons: await _lessons(_since),
          canRecord: TeachingAccess.of(_account).canRecord,
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

  Future<void> _onSubmitted(
    LessonSubmitted e,
    Emitter<MyLessonsState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _record(e.params);
      emit(state.copyWith(busy: false, lessons: await _lessons(_since)));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
