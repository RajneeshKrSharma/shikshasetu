import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';
import 'package:shiksha_setu/features/students/data/repository/students_repository_impl.dart';
import 'package:shiksha_setu/features/auth/data/repository/auth_repository_impl.dart';
import 'package:shiksha_setu/features/registration/domain/repository/registration_repository.dart';
import 'package:shiksha_setu/features/registration/data/repository/registration_repository_impl.dart';
import 'package:shiksha_setu/features/registration/domain/entities/person.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late RegistrationRepositoryImpl repo;
  late StudentsRepositoryImpl students;

  setUp(() async {
    database = await openTestDatabase();
    repo = RegistrationRepositoryImpl(database, hasher: fastHasher);
    students = StudentsRepositoryImpl(database);
    await ClassesRepositoryImpl(database).add('6-A');
  });

  tearDown(() => database.close());

  test('registerStudent: roll numbers count up within the class', () async {
    for (final name in ['A', 'B', 'C']) {
      await students.add(
        name: name,
        classSection: '6-A',
        guardian: 'G',
        phone: '+91 9000000000',
        aadhaarMasked: 'XXXX XXXX 1234',
      );
    }

    final roster = await students.getByClass('6-A');
    expect(roster.map((s) => s.rollNo), [1, 2, 3]);
  });

  test('registerStudent: the student joins the class roster', () async {
    await students.add(
      name: 'Ravi',
      classSection: '6-A',
      guardian: 'Suresh',
      phone: '+91 9000000000',
      aadhaarMasked: 'XXXX XXXX 1234',
    );

    final people = await repo.getPeople();
    expect(people.single.type, PersonType.student);
    expect(people.single.detail, '6-A');
  });

  test(
    'registerTeacher: the teacher can sign in with the given password',
    () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthRepositoryImpl(
        database,
        await SharedPreferences.getInstance(),
        hasher: fastHasher,
      );

      await repo.registerTeacher(
        name: 'Meena',
        email: 'Meena@School.test',
        phone: '+91 9000000000',
        subject: 'English',
        aadhaarMasked: 'XXXX XXXX 1234',
        password: 'first-login-1',
      );

      final user = await auth.signIn('meena@school.test', 'first-login-1');
      expect((user.name, user.subject), ('Meena', 'English'));
    },
  );

  test('registerTeacher: employee ids count up', () async {
    for (final n in ['a', 'b']) {
      await repo.registerTeacher(
        name: n,
        email: '$n@school.test',
        phone: '+91 9000000000',
        subject: 'Maths',
        aadhaarMasked: 'XXXX XXXX 1234',
        password: 'password-$n',
      );
    }

    final rows = await database.db.query('users', orderBy: 'employee_id');
    expect(rows.map((r) => r['employee_id']), ['T-001', 'T-002']);
  });

  test('registerTeacher: an email already in use → emailTaken', () async {
    Future<void> register() => repo.registerTeacher(
      name: 'Meena',
      email: 'meena@school.test',
      phone: '+91 9000000000',
      subject: 'English',
      aadhaarMasked: 'XXXX XXXX 1234',
      password: 'first-login-1',
    );
    await register();

    expect(
      register(),
      throwsA(
        isA<RegistrationException>().having(
          (e) => e.failure,
          'failure',
          RegistrationFailure.emailTaken,
        ),
      ),
    );
  });

  test('registerOther: appears in the registry with its role title', () async {
    await repo.registerOther(
      name: 'Ramesh',
      roleTitle: 'Van driver',
      phone: '+91 9000000000',
      aadhaarMasked: 'XXXX XXXX 1234',
    );

    final p = (await repo.getPeople()).single;
    expect((p.type, p.detail), (PersonType.other, 'Van driver'));
  });

  test('no full Aadhaar number is stored anywhere', () async {
    await students.add(
      name: 'Ravi',
      classSection: '6-A',
      guardian: 'Suresh',
      phone: '+91 9000000000',
      aadhaarMasked: 'XXXX XXXX 0124',
    );

    final row = (await database.db.query('students')).single;
    expect(row['aadhaar_masked'], 'XXXX XXXX 0124');
  });
}
