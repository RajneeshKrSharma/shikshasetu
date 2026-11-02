import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_range.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../domain/entities/profile_entities.dart';
import '../../domain/usecases/get_profiles.dart';

/// How many days of each kind, and how many were recorded in all.
class AttendanceCounts extends Equatable {
  const AttendanceCounts({this.present = 0, this.absent = 0, this.late = 0});

  final int present;
  final int absent;
  final int late;

  int get total => present + absent + late;

  /// Share of recorded days the student was there, on time or late.
  int get attendedPercent =>
      total == 0 ? 0 : ((present + late) * 100 / total).round();

  @override
  List<Object?> get props => [present, absent, late];
}

class StudentProfileState extends Equatable {
  const StudentProfileState({
    this.loading = true,
    this.profile,
    this.range,
    this.statuses = const {},
  });

  final bool loading;

  /// Null while loading, or when there is no such student.
  final StudentProfile? profile;

  /// Only days in this range (a single day is allowed); null means all.
  final DateTimeRange? range;

  /// Only these statuses; empty means all.
  final Set<AttendanceStatus> statuses;

  /// The attendance rows matching the filters, newest first.
  List<StudentAttendanceEntry> get attendance => [
    for (final e in profile?.attendance ?? const <StudentAttendanceEntry>[])
      if ((range == null || DateRanges.contains(range!, e.day)) &&
          (statuses.isEmpty || statuses.contains(e.status)))
        e,
  ];

  /// Counts over the days in the date range (the status filter does not
  /// change them, so they always add up).
  AttendanceCounts get counts {
    var present = 0, absent = 0, late = 0;
    for (final e in profile?.attendance ?? const <StudentAttendanceEntry>[]) {
      if (range != null && !DateRanges.contains(range!, e.day)) continue;
      switch (e.status) {
        case AttendanceStatus.present:
          present++;
        case AttendanceStatus.absent:
          absent++;
        case AttendanceStatus.late:
          late++;
      }
    }
    return AttendanceCounts(present: present, absent: absent, late: late);
  }

  StudentProfileState copyWith({
    bool? loading,
    StudentProfile? profile,
    DateTimeRange? range,
    bool clearRange = false,
    Set<AttendanceStatus>? statuses,
  }) => StudentProfileState(
    loading: loading ?? this.loading,
    profile: profile ?? this.profile,
    range: clearRange ? null : (range ?? this.range),
    statuses: statuses ?? this.statuses,
  );

  @override
  List<Object?> get props => [loading, profile, range, statuses];
}

/// One student's profile, with filters for the attendance history.
class StudentProfileCubit extends Cubit<StudentProfileState> {
  StudentProfileCubit({
    required this.studentId,
    required GetStudentProfile getStudentProfile,
  }) : _get = getStudentProfile,
       super(const StudentProfileState());

  final String studentId;
  final GetStudentProfile _get;

  Future<void> load() async =>
      emit(state.copyWith(loading: false, profile: await _get(studentId)));

  void setRange(DateTimeRange? range) => emit(
    range == null
        ? state.copyWith(clearRange: true)
        : state.copyWith(range: range),
  );

  void toggleStatus(AttendanceStatus s) => emit(
    state.copyWith(
      statuses: state.statuses.contains(s)
          ? ({...state.statuses}..remove(s))
          : {...state.statuses, s},
    ),
  );

  void clearFilters() =>
      emit(state.copyWith(clearRange: true, statuses: const {}));
}

class TeacherProfileState extends Equatable {
  const TeacherProfileState({this.loading = true, this.profile, this.range});

  final bool loading;
  final TeacherProfile? profile;
  final DateTimeRange? range;

  /// The days matching the date range, newest first.
  List<TeacherDayRecord> get attendance => [
    for (final d in profile?.attendance ?? const <TeacherDayRecord>[])
      if (range == null || DateRanges.contains(range!, d.day)) d,
  ];

  /// Days the teacher checked in, within the range.
  int get daysPresent => attendance.where((d) => d.checkIn != null).length;

  TeacherProfileState copyWith({
    bool? loading,
    TeacherProfile? profile,
    DateTimeRange? range,
    bool clearRange = false,
  }) => TeacherProfileState(
    loading: loading ?? this.loading,
    profile: profile ?? this.profile,
    range: clearRange ? null : (range ?? this.range),
  );

  @override
  List<Object?> get props => [loading, profile, range];
}

/// One teacher's profile, with a date filter for the attendance history.
class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  TeacherProfileCubit({
    required this.teacherId,
    required GetTeacherProfile getTeacherProfile,
  }) : _get = getTeacherProfile,
       super(const TeacherProfileState());

  final String teacherId;
  final GetTeacherProfile _get;

  Future<void> load() async =>
      emit(state.copyWith(loading: false, profile: await _get(teacherId)));

  void setRange(DateTimeRange? range) => emit(
    range == null
        ? state.copyWith(clearRange: true)
        : state.copyWith(range: range),
  );
}

/// Search and filters of the student or teacher list.
class PeopleFilterState extends Equatable {
  const PeopleFilterState({
    this.query = '',
    this.classes = const {},
    this.statuses = const {},
  });

  final String query;

  /// Student classes to show; empty shows all.
  final Set<String> classes;

  /// Teacher filters: [PeopleStatus.active], [PeopleStatus.inactive],
  /// [PeopleStatus.classTeacher]. Active and inactive are alternatives; class
  /// teacher narrows further. Empty shows all.
  final Set<PeopleStatus> statuses;

  int get activeCount => classes.length + statuses.length;

  @override
  List<Object?> get props => [query, classes, statuses];
}

enum PeopleStatus { active, inactive, classTeacher }

class PeopleFilterCubit extends Cubit<PeopleFilterState> {
  PeopleFilterCubit() : super(const PeopleFilterState());

  void search(String q) => emit(
    PeopleFilterState(
      query: q,
      classes: state.classes,
      statuses: state.statuses,
    ),
  );

  void toggleClass(String c) => emit(
    PeopleFilterState(
      query: state.query,
      classes: state.classes.contains(c)
          ? ({...state.classes}..remove(c))
          : {...state.classes, c},
      statuses: state.statuses,
    ),
  );

  void toggleStatus(PeopleStatus s) => emit(
    PeopleFilterState(
      query: state.query,
      classes: state.classes,
      statuses: state.statuses.contains(s)
          ? ({...state.statuses}..remove(s))
          : {...state.statuses, s},
    ),
  );

  void clear() => emit(PeopleFilterState(query: state.query));
}
