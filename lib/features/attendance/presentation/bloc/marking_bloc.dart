import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../students/domain/entities/student.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/usecases/save_class_attendance.dart';

sealed class MarkingEvent extends Equatable {
  const MarkingEvent();

  @override
  List<Object?> get props => const [];
}

final class MarkChanged extends MarkingEvent {
  const MarkChanged(this.studentId, this.status);

  final String studentId;
  final AttendanceStatus status;

  @override
  List<Object?> get props => [studentId, status];
}

final class AllMarkedPresent extends MarkingEvent {
  const AllMarkedPresent();
}

final class MarksSaveRequested extends MarkingEvent {
  const MarksSaveRequested();
}

class MarkingState extends Equatable {
  const MarkingState({
    required this.marks,
    this.dirty = false,
    this.saving = false,
    this.saved = false,
  });

  final Map<String, AttendanceStatus> marks;

  /// There are changes that have not been saved yet.
  final bool dirty;
  final bool saving;
  final bool saved;

  int count(AttendanceStatus s) => marks.values.where((v) => v == s).length;

  MarkingState copyWith({
    Map<String, AttendanceStatus>? marks,
    bool? dirty,
    bool? saving,
    bool? saved,
  }) => MarkingState(
    marks: marks ?? this.marks,
    dirty: dirty ?? this.dirty,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
  );

  @override
  List<Object?> get props => [marks, dirty, saving, saved];
}

/// What a [MarkingBloc] needs to start (passed through the service locator).
class MarkingArgs {
  const MarkingArgs({
    required this.classSection,
    required this.students,
    this.saved,
  });

  final String classSection;
  final List<Student> students;
  final Map<String, AttendanceStatus>? saved;
}

/// Marking one class's students as present / absent / late for today.
class MarkingBloc extends Bloc<MarkingEvent, MarkingState> {
  MarkingBloc({
    required this.classSection,
    required List<Student> students,
    Map<String, AttendanceStatus>? saved,
    required SaveClassAttendance saveClassAttendance,
    DateTime Function()? now,
  }) : _students = students,
       _save = saveClassAttendance,
       _now = now ?? DateTime.now,
       super(
         MarkingState(
           // Students not marked yet default to present.
           marks: {
             for (final s in students)
               s.id: saved?[s.id] ?? AttendanceStatus.present,
           },
         ),
       ) {
    on<MarkChanged>(
      (e, emit) => emit(
        state.copyWith(
          marks: {...state.marks, e.studentId: e.status},
          dirty: true,
        ),
      ),
    );
    on<AllMarkedPresent>(
      (e, emit) => emit(
        state.copyWith(
          marks: {for (final s in _students) s.id: AttendanceStatus.present},
          dirty: true,
        ),
      ),
    );
    on<MarksSaveRequested>(_onSave);
  }

  final String classSection;
  final List<Student> _students;
  final SaveClassAttendance _save;
  final DateTime Function() _now;

  Future<void> _onSave(MarksSaveRequested e, Emitter<MarkingState> emit) async {
    emit(state.copyWith(saving: true));
    await _save(
      SaveClassAttendanceParams(
        classSection: classSection,
        day: _now(),
        marks: state.marks,
      ),
    );
    emit(state.copyWith(saving: false, dirty: false, saved: true));
  }
}
