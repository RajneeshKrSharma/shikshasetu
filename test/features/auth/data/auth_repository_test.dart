import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/auth/domain/repository/auth_repository.dart';
import 'package:shiksha_setu/features/auth/data/repository/auth_repository_impl.dart';
import 'package:shiksha_setu/features/auth/domain/entities/app_user.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late SharedPreferences prefs;
  late AuthRepositoryImpl repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    database = await openTestDatabase();
    repo = AuthRepositoryImpl(database, prefs, hasher: fastHasher);
  });

  tearDown(() => database.close());

  Future<AppUser> setUpSchool() => repo.setUpSchool(
    schoolName: 'Test School',
    name: 'Asha Rao',
    email: 'Asha@School.test',
    phone: '9876543210',
    password: 'correct-horse',
  );

  test('isSchoolSetUp: empty database → false', () async {
    expect(await repo.isSchoolSetUp(), isFalse);
  });

  test(
    'setUpSchool: creates a Principal and marks the school set up',
    () async {
      final user = await setUpSchool();

      expect(user.role, UserRole.principal);
      expect(await repo.isSchoolSetUp(), isTrue);
    },
  );

  test('signIn: email is matched ignoring case', () async {
    await setUpSchool();

    final user = await repo.signIn('  ASHA@school.TEST ', 'correct-horse');

    expect(user.name, 'Asha Rao');
  });

  test('signIn: wrong password → invalid credentials', () async {
    await setUpSchool();

    expect(
      repo.signIn('asha@school.test', 'nope'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.failure,
          'failure',
          AuthFailure.invalidCredentials,
        ),
      ),
    );
  });

  test('signIn: unknown email → invalid credentials', () async {
    expect(
      repo.signIn('nobody@school.test', 'whatever1'),
      throwsA(isA<AuthException>()),
    );
  });

  test('signIn: deactivated teacher → inactive account', () async {
    await setUpSchool();
    await insertTeacher(database, 't1', active: false);
    // Give the teacher a known password.
    final salt = fastHasher.newSalt();
    await database.db.update(
      'users',
      {
        'password_hash': fastHasher.hash('teacher-pass', salt),
        'password_salt': salt,
      },
      where: 'id = ?',
      whereArgs: ['t1'],
    );

    expect(
      repo.signIn('t1@school.test', 'teacher-pass'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.failure,
          'failure',
          AuthFailure.inactiveAccount,
        ),
      ),
    );
  });

  test('restoreSession: returns the user after sign in', () async {
    await setUpSchool();
    await repo.signIn('asha@school.test', 'correct-horse');

    expect((await repo.restoreSession())?.name, 'Asha Rao');
  });

  test('restoreSession: null after sign out', () async {
    await setUpSchool();
    await repo.signOut();

    expect(await repo.restoreSession(), isNull);
  });

  test('restoreSession: a deactivated user is no longer signed in', () async {
    await setUpSchool();
    await insertTeacher(database, 't1');
    await prefs.setString('session_user_id', 't1');
    await database.db.update(
      'users',
      {'active': 0},
      where: 'id = ?',
      whereArgs: ['t1'],
    );

    expect(await repo.restoreSession(), isNull);
  });

  test('changePassword: new password works, old one stops working', () async {
    final user = await setUpSchool();

    await repo.changePassword(
      userId: user.id,
      current: 'correct-horse',
      next: 'battery-staple',
    );

    expect(
      (await repo.signIn('asha@school.test', 'battery-staple')).id,
      user.id,
    );
    expect(
      repo.signIn('asha@school.test', 'correct-horse'),
      throwsA(isA<AuthException>()),
    );
  });

  test('changePassword: wrong current password → rejected', () async {
    final user = await setUpSchool();

    expect(
      repo.changePassword(
        userId: user.id,
        current: 'bad',
        next: 'battery-staple',
      ),
      throwsA(
        isA<AuthException>().having(
          (e) => e.failure,
          'failure',
          AuthFailure.wrongCurrentPassword,
        ),
      ),
    );
  });

  test('updateProfile: name and phone are saved', () async {
    final user = await setUpSchool();

    final updated = await repo.updateProfile(
      userId: user.id,
      name: 'Asha R. Rao',
      phone: '9000000001',
    );

    expect((updated.name, updated.phone), ('Asha R. Rao', '9000000001'));
  });
}
