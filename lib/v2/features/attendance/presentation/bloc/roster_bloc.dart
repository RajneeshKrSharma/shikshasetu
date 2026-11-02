import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/attendance_usecases.dart';

sealed class RosterEvent extends Equatable {
  const RosterEvent();

  @override
  List<Object?> get props => const [];
}

final class RosterStarted extends RosterEvent {
  const RosterStarted();
}

final class RosterClassChosen extends RosterEvent {
  const RosterClassChosen(this.classId);

  final String classId;

  @override
  List<Object?> get props => [classId];
}

final class RosterDayChosen extends RosterEvent {
  const RosterDayChosen(this.day);

  final DateTime day;

  @override
  List<Object?> get props => [day];
}

final class StudentMarked extends RosterEvent {
  const StudentMarked(this.studentId, this.mark);

  final String studentId;
  final StudentMark mark;

  @override
  List<Object?> get props => [studentId, mark];
}

final class AllMarkedPresent extends RosterEvent {
  const AllMarkedPresent();
}

final class RosterSaved extends RosterEvent {
  const RosterSaved();
}

class RosterState extends Equatable {
  const RosterState({
    this.status = ViewStatus.loading,
    this.failure,
    this.classes = const [],
    this.classId,
    required this.day,
    this.lines = const [],
    this.canMark = false,
    this.busy = false,
    this.savedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<SchoolClass> classes;
  final String? classId;
  final DateTime day;
  final List<RosterLine> lines;
  final bool canMark;
  final bool busy;

  /// Goes up each time the marks were saved, so the screen can say so.
  final int savedCount;

  RosterState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<SchoolClass>? classes,
    String? classId,
    DateTime? day,
    List<RosterLine>? lines,
    bool? canMark,
    bool? busy,
    int? savedCount,
  }) => RosterState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    classes: classes ?? this.classes,
    classId: classId ?? this.classId,
    day: day ?? this.day,
    lines: lines ?? this.lines,
    canMark: canMark ?? this.canMark,
    busy: busy ?? this.busy,
    savedCount: savedCount ?? this.savedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    classes,
    classId,
    day,
    lines,
    canMark,
    busy,
    savedCount,
  ];
}

/// Marking a class's attendance for a day.
class RosterBloc extends Bloc<RosterEvent, RosterState> {
  RosterBloc({
    required Account account,
    required GetClasses getClasses,
    required GetRoster getRoster,
    required MarkRoster markRoster,
  }) : _account = account,
       _classes = getClasses,
       _roster = getRoster,
       _mark = markRoster,
       super(RosterState(day: _today())) {
    on<RosterStarted>(_onStarted);
    on<RosterClassChosen>((e, emit) => _show(emit, e.classId, state.day));
    on<RosterDayChosen>((e, emit) {
      final id = state.classId;
      return id == null ? Future.value() : _show(emit, id, e.day);
    });
    on<StudentMarked>(
      (e, emit) => emit(
        state.copyWith(
          lines: [
            for (final l in state.lines)
              l.studentId == e.studentId ? l.marked(e.mark) : l,
          ],
        ),
      ),
    );
    on<AllMarkedPresent>(
      (e, emit) => emit(
        state.copyWith(
          lines: [for (final l in state.lines) l.marked(StudentMark.present)],
        ),
      ),
    );
    on<RosterSaved>(_onSaved);
  }

  final Account _account;
  final GetClasses _classes;
  final GetRoster _roster;
  final MarkRoster _mark;

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<void> _onStarted(RosterStarted e, Emitter<RosterState> emit) async {
    try {
      final classes = await _classes(const NoParams());
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          classes: classes,
          canMark: AttendanceAccess.of(_account).canMarkStudents,
        ),
      );
      if (classes.isNotEmpty) await _show(emit, classes.first.id, state.day);
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _show(
    Emitter<RosterState> emit,
    String classId,
    DateTime day,
  ) async {
    emit(
      state.copyWith(
        classId: classId,
        day: day,
        busy: true,
        clearFailure: true,
      ),
    );
    try {
      emit(
        state.copyWith(
          lines: await _roster(RosterParams(classId, day)),
          busy: false,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  Future<void> _onSaved(RosterSaved e, Emitter<RosterState> emit) async {
    final classId = state.classId;
    if (classId == null) return;
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      emit(
        state.copyWith(
          busy: false,
          lines: await _mark(MarkRosterParams(classId, state.day, state.lines)),
          savedCount: state.savedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
