import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/check_result.dart';
import '../../domain/usecases/get_attendance_overview.dart';
import '../../domain/usecases/record_teacher_check.dart';
import '../../domain/usecases/set_school_day_status.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

/// Today's attendance for the whole signed-in app: school day approval,
/// teacher check-ins and every class's marks.
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc({
    required GetAttendanceOverview getOverview,
    required SetSchoolDayStatus setDayStatus,
    required CheckInTeacher checkIn,
    required CheckOutTeacher checkOut,
    DateTime Function()? now,
  }) : _getOverview = getOverview,
       _setDayStatus = setDayStatus,
       _checkIn = checkIn,
       _checkOut = checkOut,
       _now = now ?? DateTime.now,
       super(const AttendanceState()) {
    on<AttendanceStarted>(_onLoad);
    on<AttendanceRefreshed>(_onLoad);
    on<SchoolDayDecided>(_onDayDecided);
    on<CheckInRequested>(
      (e, emit) => _record(emit, e.teacherId, e.teacherName, checkOut: false),
    );
    on<CheckOutRequested>(
      (e, emit) => _record(emit, e.teacherId, e.teacherName, checkOut: true),
    );
  }

  final GetAttendanceOverview _getOverview;
  final SetSchoolDayStatus _setDayStatus;
  final CheckInTeacher _checkIn;
  final CheckOutTeacher _checkOut;
  final DateTime Function() _now;

  int _problemId = 0;

  Future<void> _onLoad(AttendanceEvent e, Emitter<AttendanceState> emit) async {
    final overview = await _getOverview(_now());
    emit(state.copyWith(loading: false, overview: overview));
  }

  Future<void> _onDayDecided(
    SchoolDayDecided e,
    Emitter<AttendanceState> emit,
  ) async {
    await _setDayStatus(
      SetSchoolDayStatusParams(
        day: _now(),
        status: e.status,
        decidedBy: e.decidedBy,
      ),
    );
    emit(state.copyWith(overview: await _getOverview(_now())));
  }

  Future<void> _record(
    Emitter<AttendanceState> emit,
    String teacherId,
    String teacherName, {
    required bool checkOut,
  }) async {
    emit(state.copyWith(checking: true, clearProblem: true));
    final params = TeacherCheckParams(
      teacherId: teacherId,
      at: _now(),
      teacherName: teacherName,
    );
    final CheckResult result = await (checkOut
        ? _checkOut(params)
        : _checkIn(params));

    if (result.ok) {
      emit(
        state.copyWith(checking: false, overview: await _getOverview(_now())),
      );
    } else {
      emit(
        state.copyWith(
          checking: false,
          problem: CheckProblem(
            failure: result.failure!,
            distance: result.distance,
            id: ++_problemId,
          ),
        ),
      );
    }
  }
}
