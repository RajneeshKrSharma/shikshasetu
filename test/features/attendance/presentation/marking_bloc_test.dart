import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/check_point.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/teacher_attendance.dart';
import 'package:shiksha_setu/features/attendance/domain/repository/attendance_repository.dart';
import 'package:shiksha_setu/features/attendance/domain/usecases/save_class_attendance.dart';
import 'package:shiksha_setu/features/attendance/presentation/bloc/marking_bloc.dart';
import 'package:shiksha_setu/features/students/domain/entities/student.dart';

class RecordingAttendanceRepository implements AttendanceRepository {
  String? savedClass;
  DateTime? savedDay;
  Map<String, AttendanceStatus>? savedMarks;

  @override
  Future<void> saveClassAttendance(
    String classSection,
    DateTime day,
    Map<String, AttendanceStatus> marks,
  ) async {
    savedClass = classSection;
    savedDay = day;
    savedMarks = marks;
  }

  @override
  Future<SchoolDayStatus> getDayStatus(DateTime day) async =>
      SchoolDayStatus.pending;
  @override
  Future<void> setDayStatus(DateTime d, SchoolDayStatus s, String by) async {}
  @override
  Future<List<TeacherAttendance>> getTeacherRecords(DateTime day) async =>
      const [];
  @override
  Future<void> checkIn(String id, DateTime at, CheckPoint p) async {}
  @override
  Future<void> checkOut(String id, DateTime at, CheckPoint p) async {}
  @override
  Future<Map<String, AttendanceStatus>?> getClassAttendance(
    String c,
    DateTime d,
  ) async => null;
}

void main() {
  const students = [
    Student(id: 's1', name: 'A', rollNo: 1, classSection: '6-A'),
    Student(id: 's2', name: 'B', rollNo: 2, classSection: '6-A'),
  ];
  final today = DateTime(2026, 9, 30);
  late RecordingAttendanceRepository repo;

  MarkingBloc build({Map<String, AttendanceStatus>? saved}) => MarkingBloc(
    classSection: '6-A',
    students: students,
    saved: saved,
    saveClassAttendance: SaveClassAttendance(repo),
    now: () => today,
  );

  setUp(() => repo = RecordingAttendanceRepository());

  test('initial state: unmarked students default to present, not dirty', () {
    final bloc = build();

    expect(bloc.state.marks, {
      's1': AttendanceStatus.present,
      's2': AttendanceStatus.present,
    });
    expect(bloc.state.dirty, isFalse);
  });

  test('initial state: saved marks are shown', () {
    final bloc = build(saved: {'s2': AttendanceStatus.absent});

    expect(bloc.state.marks['s2'], AttendanceStatus.absent);
    expect(bloc.state.marks['s1'], AttendanceStatus.present);
  });

  blocTest<MarkingBloc, MarkingState>(
    'MarkChanged: updates that student and marks the form dirty',
    build: build,
    act: (b) => b.add(const MarkChanged('s1', AttendanceStatus.late)),
    verify: (b) {
      expect(b.state.marks['s1'], AttendanceStatus.late);
      expect(b.state.dirty, isTrue);
      expect(b.state.count(AttendanceStatus.late), 1);
    },
  );

  blocTest<MarkingBloc, MarkingState>(
    'AllMarkedPresent: resets everyone to present',
    build: () => build(saved: {'s1': AttendanceStatus.absent}),
    act: (b) => b.add(const AllMarkedPresent()),
    verify: (b) => expect(b.state.count(AttendanceStatus.present), 2),
  );

  blocTest<MarkingBloc, MarkingState>(
    'MarksSaveRequested: saves for the class and day, then is no longer dirty',
    build: build,
    act: (b) => b
      ..add(const MarkChanged('s1', AttendanceStatus.absent))
      ..add(const MarksSaveRequested()),
    verify: (b) {
      expect(repo.savedClass, '6-A');
      expect(repo.savedDay, today);
      expect(repo.savedMarks!['s1'], AttendanceStatus.absent);
      expect(b.state.saved, isTrue);
      expect(b.state.dirty, isFalse, reason: 'nothing left to lose');
    },
  );
}
