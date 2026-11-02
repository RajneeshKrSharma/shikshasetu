import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/auth/domain/entities/app_user.dart';
import 'package:shiksha_setu/features/auth/domain/repository/auth_repository.dart';
import 'package:shiksha_setu/features/auth/domain/usecases/is_school_set_up.dart';
import 'package:shiksha_setu/features/auth/domain/usecases/restore_session.dart';
import 'package:shiksha_setu/features/auth/domain/usecases/set_up_school.dart';
import 'package:shiksha_setu/features/auth/domain/usecases/sign_in.dart';
import 'package:shiksha_setu/features/auth/domain/usecases/sign_out.dart';
import 'package:shiksha_setu/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shiksha_setu/features/auth/presentation/bloc/auth_event.dart';
import 'package:shiksha_setu/features/auth/presentation/bloc/auth_state.dart';

final _asha = AppUser(
  id: 'u1',
  name: 'Asha',
  email: 'asha@school.test',
  role: UserRole.principal,
  phone: '9',
  employeeId: 'P-001',
  joinedOn: DateTime(2026),
);

class FakeAuthRepository implements AuthRepository {
  bool setUp = false;
  AppUser? session;
  AuthFailure? signInFails;
  bool signedOut = false;

  @override
  Future<bool> isSchoolSetUp() async => setUp;

  @override
  Future<AppUser?> restoreSession() async => session;

  @override
  Future<AppUser> signIn(String email, String password) async {
    if (signInFails != null) throw AuthException(signInFails!);
    return _asha;
  }

  @override
  Future<AppUser> setUpSchool({
    required String schoolName,
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async => _asha;

  @override
  Future<void> signOut() async => signedOut = true;

  @override
  Future<void> changePassword({
    required String userId,
    required String current,
    required String next,
  }) async {}

  @override
  Future<AppUser> updateProfile({
    required String userId,
    required String name,
    required String phone,
  }) async => _asha;
}

void main() {
  late FakeAuthRepository repo;

  AuthBloc build() => AuthBloc(
    isSchoolSetUp: IsSchoolSetUp(repo),
    restoreSession: RestoreSession(repo),
    setUpSchool: SetUpSchool(repo),
    signIn: SignIn(repo),
    signOut: SignOut(repo),
  );

  setUp(() => repo = FakeAuthRepository());

  blocTest<AuthBloc, AuthState>(
    'AuthStarted: saved session → signedIn with that user',
    setUp: () => repo.session = _asha,
    build: build,
    act: (b) => b.add(const AuthStarted()),
    expect: () => [AuthState(status: AuthStatus.signedIn, user: _asha)],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthStarted: no session and no school yet → needsSetup',
    build: build,
    act: (b) => b.add(const AuthStarted()),
    expect: () => [const AuthState(status: AuthStatus.needsSetup)],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthStarted: no session but school exists → signedOut',
    setUp: () => repo.setUp = true,
    build: build,
    act: (b) => b.add(const AuthStarted()),
    expect: () => [const AuthState(status: AuthStatus.signedOut)],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthSetUpSubmitted: school created → busy then choosingTheme, '
    'and AuthThemeConfirmed then enters the app',
    build: build,
    act: (b) async {
      b.add(
        const AuthSetUpSubmitted(
          SetUpSchoolParams(
            schoolName: 'S',
            name: 'Asha',
            email: 'asha@school.test',
            phone: '9',
            password: 'password1',
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      b.add(const AuthThemeConfirmed());
    },
    expect: () => [
      const AuthState(busy: true),
      AuthState(status: AuthStatus.choosingTheme, user: _asha),
      AuthState(status: AuthStatus.signedIn, user: _asha),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthLoginSubmitted: correct credentials → busy then signedIn',
    build: build,
    act: (b) => b.add(const AuthLoginSubmitted('a@b.c', 'pw')),
    expect: () => [
      const AuthState(busy: true),
      AuthState(status: AuthStatus.signedIn, user: _asha),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthLoginSubmitted: wrong credentials → failure is kept, not signed in',
    setUp: () => repo.signInFails = AuthFailure.invalidCredentials,
    build: build,
    act: (b) => b.add(const AuthLoginSubmitted('a@b.c', 'bad')),
    expect: () => [
      const AuthState(busy: true),
      const AuthState(failure: AuthFailure.invalidCredentials),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthLogoutRequested: clears the user and forgets the session',
    seed: () => AuthState(status: AuthStatus.signedIn, user: _asha),
    build: build,
    act: (b) => b.add(const AuthLogoutRequested()),
    expect: () => [const AuthState(status: AuthStatus.signedOut)],
    verify: (_) => expect(repo.signedOut, isTrue),
  );

  blocTest<AuthBloc, AuthState>(
    'AuthUserChanged: replaces the signed-in user',
    seed: () => AuthState(status: AuthStatus.signedIn, user: _asha),
    build: build,
    act: (b) => b.add(
      AuthUserChanged(
        AppUser(
          id: 'u1',
          name: 'Asha R.',
          email: _asha.email,
          role: _asha.role,
          phone: '9',
          employeeId: 'P-001',
          joinedOn: _asha.joinedOn,
        ),
      ),
    ),
    verify: (b) => expect(b.state.user?.name, 'Asha R.'),
  );
}
