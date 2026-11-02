import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/attendance_status.dart';
import '../../domain/entities/other_staff_mark.dart';
import '../../domain/usecases/other_staff_attendance_usecases.dart';

sealed class StaffMarkingEvent extends Equatable {
  const StaffMarkingEvent();

  @override
  List<Object?> get props => const [];
}

final class StaffMarkingStarted extends StaffMarkingEvent {
  const StaffMarkingStarted();
}

final class StaffMarkChanged extends StaffMarkingEvent {
  const StaffMarkChanged(this.staffId, this.status);

  final String staffId;
  final AttendanceStatus status;

  @override
  List<Object?> get props => [staffId, status];
}

final class AllStaffMarkedPresent extends StaffMarkingEvent {
  const AllStaffMarkedPresent();
}

final class StaffMarksSaveRequested extends StaffMarkingEvent {
  const StaffMarksSaveRequested();
}

class StaffMarkingState extends Equatable {
  const StaffMarkingState({
    this.loading = true,
    this.staff = const [],
    this.marks = const {},
    this.dirty = false,
    this.saving = false,
    this.saved = false,
  });

  final bool loading;
  final List<OtherStaffMark> staff;
  final Map<String, AttendanceStatus> marks;

  /// There are changes that have not been saved yet.
  final bool dirty;
  final bool saving;
  final bool saved;

  int count(AttendanceStatus s) => marks.values.where((v) => v == s).length;

  StaffMarkingState copyWith({
    bool? loading,
    List<OtherStaffMark>? staff,
    Map<String, AttendanceStatus>? marks,
    bool? dirty,
    bool? saving,
    bool? saved,
  }) => StaffMarkingState(
    loading: loading ?? this.loading,
    staff: staff ?? this.staff,
    marks: marks ?? this.marks,
    dirty: dirty ?? this.dirty,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
  );

  @override
  List<Object?> get props => [loading, staff, marks, dirty, saving, saved];
}

/// The Principal marking other staff present, absent or late for a day.
class StaffMarkingBloc extends Bloc<StaffMarkingEvent, StaffMarkingState> {
  StaffMarkingBloc({
    required this.day,
    required GetOtherStaffAttendance getStaff,
    required SaveOtherStaffAttendance saveStaff,
  }) : _get = getStaff,
       _save = saveStaff,
       super(const StaffMarkingState()) {
    on<StaffMarkingStarted>(_onStarted);
    on<StaffMarkChanged>(
      (e, emit) => emit(
        state.copyWith(
          marks: {...state.marks, e.staffId: e.status},
          dirty: true,
        ),
      ),
    );
    on<AllStaffMarkedPresent>(
      (e, emit) => emit(
        state.copyWith(
          marks: {
            for (final s in state.staff) s.staffId: AttendanceStatus.present,
          },
          dirty: true,
        ),
      ),
    );
    on<StaffMarksSaveRequested>(_onSave);
  }

  final DateTime day;
  final GetOtherStaffAttendance _get;
  final SaveOtherStaffAttendance _save;

  Future<void> _onStarted(
    StaffMarkingStarted e,
    Emitter<StaffMarkingState> emit,
  ) async {
    final staff = await _get(day);
    emit(
      state.copyWith(
        loading: false,
        staff: staff,
        // Staff not marked yet start as present.
        marks: {
          for (final s in staff)
            s.staffId: s.status ?? AttendanceStatus.present,
        },
      ),
    );
  }

  Future<void> _onSave(
    StaffMarksSaveRequested e,
    Emitter<StaffMarkingState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    await _save(SaveOtherStaffAttendanceParams(day: day, marks: state.marks));
    emit(state.copyWith(saving: false, dirty: false, saved: true));
  }
}
