import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/attendance/data/repository/attendance_repository_impl.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';
import 'package:shiksha_setu/features/staff/data/repository/staff_repository_impl.dart';
import 'package:shiksha_setu/features/students/data/repository/students_repository_impl.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late ClassesRepositoryImpl classes;
  late StudentsRepositoryImpl students;

  setUp(() async {
    database = await openTestDatabase();
    classes = ClassesRepositoryImpl(database);
    students = StudentsRepositoryImpl(database);
  });

  tearDown(() => database.close());

  Future<List<String>> names() async => [
    for (final c in await classes.getClasses()) c.name,
  ];

  test('add: classes appear in name order', () async {
    await classes.add('7-A');
    await classes.add('6-A');

    expect(await names(), ['6-A', '7-A']);
  });

  test('add: names are unique ignoring case', () async {
    await classes.add('6-A');

    expect(classes.add('6-a'), throwsA(anything));
  });

  test('getClasses: reports student count and class teacher', () async {
    await classes.add('6-A');
    await insertStudent(database, 's1', '6-A', roll: 1);
    await insertStudent(database, 's2', '6-A', roll: 2);
    await insertTeacher(database, 't1', name: 'Anita');
    await StaffRepositoryImpl(database).assignClass('t1', '6-A');

    final summary = (await classes.getClasses()).single;

    expect(summary.studentCount, 2);
    expect(summary.classTeacherName, 'Anita');
  });

  test('getClasses: a class without a teacher has no teacher name', () async {
    await classes.add('6-A');

    expect((await classes.getClasses()).single.classTeacherName, isNull);
  });

  test('rename: students and their attendance follow the new name', () async {
    await classes.add('6-A');
    await insertStudent(database, 's1', '6-A');
    final attendance = AttendanceRepositoryImpl(database);
    final day = DateTime(2026, 9, 28);
    await attendance.saveClassAttendance('6-A', day, {
      's1': AttendanceStatus.late,
    });

    await classes.rename('6-A', '6-B');

    expect((await students.getByClass('6-B')).map((s) => s.id), ['s1']);
    expect(await attendance.getClassAttendance('6-B', day), {
      's1': AttendanceStatus.late,
    });
  });

  test('delete: removes students and their attendance', () async {
    await classes.add('6-A');
    await insertStudent(database, 's1', '6-A');
    await AttendanceRepositoryImpl(database).saveClassAttendance(
      '6-A',
      DateTime(2026, 9, 28),
      {'s1': AttendanceStatus.present},
    );

    await classes.delete('6-A');

    expect(await names(), isEmpty);
    expect(await database.db.query('student_attendance'), isEmpty);
  });
}
