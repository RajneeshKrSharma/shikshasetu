import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/attendance_usecases.dart';

sealed class MyAttendanceEvent extends Equatable {
  const MyAttendanceEvent();

  @override
  List<Object?> get props => const [];
}

final class MyAttendanceStarted extends MyAttendanceEvent {
  const MyAttendanceStarted();
}

final class CheckedIn extends MyAttendanceEvent {
  const CheckedIn();
}

final class CheckedOut extends MyAttendanceEvent {
  const CheckedOut();
}

class MyAttendanceState extends Equatable {
  const MyAttendanceState({
    this.status = ViewStatus.loading,
    this.failure,
    this.records = const [],
    this.today,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<WorkRecord> records;

  /// Today's record; none until the person has checked in.
  final WorkRecord? today;
  final bool busy;

  bool get canCheckIn => today == null;
  bool get canCheckOut => today != null && today!.checkedOutAt == null;

  MyAttendanceState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<WorkRecord>? records,
    WorkRecord? today,
    bool clearToday = false,
    bool? busy,
  }) => MyAttendanceState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    records: records ?? this.records,
    today: clearToday ? null : (today ?? this.today),
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, records, today, busy];
}

/// A teacher's or staff member's own days, and the check-in and check-out.
class MyAttendanceBloc extends Bloc<MyAttendanceEvent, MyAttendanceState> {
  MyAttendanceBloc({
    required GetMyAttendance getMyAttendance,
    required CheckIn checkIn,
    required CheckOut checkOut,
  }) : _mine = getMyAttendance,
       _checkIn = checkIn,
       _checkOut = checkOut,
       super(const MyAttendanceState()) {
    on<MyAttendanceStarted>((e, emit) async {
      emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
      await _load(emit);
    });
    on<CheckedIn>((e, emit) => _act(emit, () => _checkIn(DateTime.now())));
    on<CheckedOut>((e, emit) => _act(emit, () => _checkOut(DateTime.now())));
  }

  final GetMyAttendance _mine;
  final CheckIn _checkIn;
  final CheckOut _checkOut;

  Future<void> _load(Emitter<MyAttendanceState> emit) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    try {
      final records = await _mine(
        RangeParams(today.subtract(const Duration(days: 30)), today),
      );
      final todays = records.where((r) => r.day == today);
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          records: records,
          today: todays.isEmpty ? null : todays.first,
          clearToday: todays.isEmpty,
          busy: false,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          busy: false,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _act(
    Emitter<MyAttendanceState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      await _load(emit);
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
