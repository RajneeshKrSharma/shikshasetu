import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/teaching.dart';
import '../../domain/usecases/teaching_usecases.dart';

sealed class LessonBoardEvent extends Equatable {
  const LessonBoardEvent();

  @override
  List<Object?> get props => const [];
}

final class LessonBoardStarted extends LessonBoardEvent {
  const LessonBoardStarted();
}

final class LessonBoardDayChosen extends LessonBoardEvent {
  const LessonBoardDayChosen(this.day);

  final DateTime day;

  @override
  List<Object?> get props => [day];
}

class LessonBoardState extends Equatable {
  const LessonBoardState({
    this.status = ViewStatus.loading,
    this.failure,
    this.day,
    this.rows = const [],
  });

  final ViewStatus status;
  final ViewFailure? failure;

  /// Null means today.
  final DateTime? day;
  final List<LessonStatus> rows;

  @override
  List<Object?> get props => [status, failure, day, rows];
}

class LessonBoardBloc extends Bloc<LessonBoardEvent, LessonBoardState> {
  LessonBoardBloc({required GetLessonBoard getLessonBoard})
    : _board = getLessonBoard,
      super(const LessonBoardState()) {
    on<LessonBoardStarted>((e, emit) => _load(emit, state.day));
    on<LessonBoardDayChosen>((e, emit) => _load(emit, e.day));
  }

  final GetLessonBoard _board;

  Future<void> _load(Emitter<LessonBoardState> emit, DateTime? day) async {
    emit(LessonBoardState(day: day));
    final shown = day ?? DateTime.now();
    try {
      emit(
        LessonBoardState(
          status: ViewStatus.ready,
          day: day,
          rows: await _board(shown),
        ),
      );
    } on ServerException catch (error) {
      emit(
        LessonBoardState(
          status: ViewStatus.failed,
          day: day,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }
}
