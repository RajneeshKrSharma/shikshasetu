import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';
import 'package:shiksha_setu/features/staff/data/repository/staff_repository_impl.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late StaffRepositoryImpl staff;

  setUp(() async {
    database = await openTestDatabase();
    staff = StaffRepositoryImpl(database);
    final classes = ClassesRepositoryImpl(database);
    await classes.add('6-A');
    await classes.add('7-A');
    await insertTeacher(database, 't1', name: 'Anita');
    await insertTeacher(database, 't2', name: 'Bela');
  });

  tearDown(() => database.close());

  Future<Map<String, String?>> assignments() async => {
    for (final m in await staff.getStaff()) m.id: m.classSection,
  };

  test('assignClass: teacher becomes class teacher of that class', () async {
    await staff.assignClass('t1', '6-A');

    expect(await assignments(), {'t1': '6-A', 't2': null});
  });

  test('assignClass: moving to another class frees the first one', () async {
    await staff.assignClass('t1', '6-A');

    await staff.assignClass('t1', '7-A');

    expect(await assignments(), {'t1': '7-A', 't2': null});
  });

  test('assignClass: a class has one class teacher', () async {
    await staff.assignClass('t1', '6-A');

    // The database refuses a second teacher on the same class row.
    await staff.assignClass('t2', '6-A');

    expect((await assignments())['t2'], '6-A');
    expect((await assignments())['t1'], isNull, reason: 'replaced, not shared');
  });

  test('assignClass: null removes the assignment', () async {
    await staff.assignClass('t1', '6-A');

    await staff.assignClass('t1', null);

    expect((await assignments())['t1'], isNull);
  });

  test('setActive: deactivating a teacher also frees their class', () async {
    await staff.assignClass('t1', '6-A');

    await staff.setActive('t1', false);

    final m = (await staff.getStaff()).firstWhere((m) => m.id == 't1');
    expect(m.active, isFalse);
    expect(m.classSection, isNull);
  });

  test('renaming a class keeps its class teacher', () async {
    await staff.assignClass('t1', '6-A');

    await ClassesRepositoryImpl(database).rename('6-A', '6-B');

    expect((await assignments())['t1'], '6-B');
  });

  test('deleting a class leaves its teacher without a class', () async {
    await staff.assignClass('t1', '6-A');

    await ClassesRepositoryImpl(database).delete('6-A');

    expect((await assignments())['t1'], isNull);
  });
}
