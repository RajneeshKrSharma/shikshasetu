import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecases/name_school.dart';
import '../../domain/usecases/needs_school_setup.dart';
import '../../domain/usecases/restore_session.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sync_verified_email.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Owns who is signed in for the whole app.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RestoreSession restoreSession,
    required NameSchool nameSchool,
    required NeedsSchoolSetup needsSchoolSetup,
    required SignIn signIn,
    required SignOut signOut,
    required SyncVerifiedEmail syncVerifiedEmail,
  }) : _restoreSession = restoreSession,
       _nameSchool = nameSchool,
       _needsSchoolSetup = needsSchoolSetup,
       _signIn = signIn,
       _signOut = signOut,
       _syncVerifiedEmail = syncVerifiedEmail,
       super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthSchoolNamed>(_onSchoolNamed);
    on<AuthLoginSubmitted>(
      (e, emit) =>
          _authenticate(emit, () => _signIn(SignInParams(e.email, e.password))),
    );
    on<AuthLogoutRequested>(_onLogout);
    on<AuthEmailSyncRequested>(_onEmailSync);
    on<AuthUserChanged>((e, emit) => emit(state.copyWith(user: e.user)));
  }

  final RestoreSession _restoreSession;
  final NameSchool _nameSchool;
  final NeedsSchoolSetup _needsSchoolSetup;
  final SignIn _signIn;
  final SignOut _signOut;
  final SyncVerifiedEmail _syncVerifiedEmail;

  Future<void> _onStarted(AuthStarted e, Emitter<AuthState> emit) async {
    final user = await _restoreSession(const NoParams());
    if (user == null) {
      emit(const AuthState(status: AuthStatus.signedOut));
      return;
    }
    await _enter(user, emit);
    if (state.status == AuthStatus.signedIn) {
      add(const AuthEmailSyncRequested());
    }
  }

  Future<void> _onSchoolNamed(
    AuthSchoolNamed e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _nameSchool(e.name);
      emit(AuthState(status: AuthStatus.signedIn, user: state.user));
    } on AuthException catch (err) {
      emit(
        state.copyWith(
          busy: false,
          failure: err.failure,
          failureMessage: err.message,
        ),
      );
    }
  }

  Future<void> _authenticate(
    Emitter<AuthState> emit,
    Future<AppUser> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _enter(await action(), emit);
    } on AuthException catch (err) {
      emit(
        state.copyWith(
          busy: false,
          failure: err.failure,
          failureMessage: err.message,
        ),
      );
    }
  }

  /// A signed-in person opens the app, unless the school still needs a name.
  Future<void> _enter(AppUser user, Emitter<AuthState> emit) async {
    final naming = await _needsSchoolSetup(user);
    emit(
      AuthState(
        status: naming ? AuthStatus.namingSchool : AuthStatus.signedIn,
        user: user,
      ),
    );
  }

  Future<void> _onEmailSync(
    AuthEmailSyncRequested e,
    Emitter<AuthState> emit,
  ) async {
    if (state.status != AuthStatus.signedIn) return;
    final user = await _syncVerifiedEmail(const NoParams());
    if (user != null) emit(state.copyWith(user: user));
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await _signOut(const NoParams());
    emit(const AuthState(status: AuthStatus.signedOut));
  }
}
