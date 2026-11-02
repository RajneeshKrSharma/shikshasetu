import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/attendance_usecases.dart';

sealed class PeopleBoardEvent extends Equatable {
  const PeopleBoardEvent();

  @override
  List<Object?> get props => const [];
}

final class PeopleBoardStarted extends PeopleBoardEvent {
  const PeopleBoardStarted();
}

final class PeopleBoardFiltered extends PeopleBoardEvent {
  const PeopleBoardFiltered({required this.day, this.role});

  final DateTime day;

  /// `teacher`, `staff`, or null for everyone.
  final String? role;

  @override
  List<Object?> get props => [day, role];
}

final class AttendanceCorrected extends PeopleBoardEvent {
  const AttendanceCorrected(this.draft);

  final CorrectionDraft draft;

  @override
  List<Object?> get props => [draft];
}

class PeopleBoardState extends Equatable {
  const PeopleBoardState({
    this.status = ViewStatus.loading,
    this.failure,
    required this.day,
    this.role,
    this.board,
    this.canCorrect = false,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final DateTime day;
  final String? role;
  final DayBoard? board;
  final bool canCorrect;
  final bool busy;

  PeopleBoardState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    DateTime? day,
    String? role,
    bool clearRole = false,
    DayBoard? board,
    bool? canCorrect,
    bool? busy,
  }) => PeopleBoardState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    day: day ?? this.day,
    role: clearRole ? null : (role ?? this.role),
    board: board ?? this.board,
    canCorrect: canCorrect ?? this.canCorrect,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    day,
    role,
    board,
    canCorrect,
    busy,
  ];
}

/// The Principal's view of how teachers and staff came in on a day.
class PeopleBoardBloc extends Bloc<PeopleBoardEvent, PeopleBoardState> {
  PeopleBoardBloc({
    required Account account,
    required GetDayBoard getDayBoard,
    required CorrectAttendance correctAttendance,
  }) : _account = account,
       _board = getDayBoard,
       _correct = correctAttendance,
       super(PeopleBoardState(day: _today())) {
    on<PeopleBoardStarted>(
      (e, emit) => _load(
        emit,
        state.copyWith(canCorrect: AttendanceAccess.of(_account).canCorrect),
      ),
    );
    on<PeopleBoardFiltered>(
      (e, emit) => _load(
        emit,
        state.copyWith(day: e.day, role: e.role, clearRole: e.role == null),
      ),
    );
    on<AttendanceCorrected>(_onCorrected);
  }

  final Account _account;
  final GetDayBoard _board;
  final CorrectAttendance _correct;

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<void> _load(
    Emitter<PeopleBoardState> emit,
    PeopleBoardState next,
  ) async {
    emit(next.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        next.copyWith(
          status: ViewStatus.ready,
          board: await _board(BoardParams(next.day, role: next.role)),
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

  Future<void> _onCorrected(
    AttendanceCorrected e,
    Emitter<PeopleBoardState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _correct(e.draft);
      emit(
        state.copyWith(
          busy: false,
          board: await _board(BoardParams(state.day, role: state.role)),
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
