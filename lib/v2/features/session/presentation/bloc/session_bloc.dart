import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/account.dart';
import '../../domain/navigation/navigation_policy.dart';
import '../../domain/usecases/build_navigation.dart';
import '../../domain/usecases/session_usecases.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => const [];
}

final class SessionStarted extends SessionEvent {
  const SessionStarted();
}

final class SignInSubmitted extends SessionEvent {
  const SignInSubmitted(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object?> get props => [email];
}

final class SignOutRequested extends SessionEvent {
  const SignOutRequested();
}

final class SessionEnded extends SessionEvent {
  const SessionEnded();
}

final class NameChanged extends SessionEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class PasswordChangeRequested extends SessionEvent {
  const PasswordChangeRequested({required this.current, required this.next});

  final String current;
  final String next;

  @override
  List<Object?> get props => [current];
}

enum SessionStatus { checking, signedOut, signedIn }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.checking,
    this.account,
    this.navigation,
    this.busy = false,
    this.failure,
    this.savedCount = 0,
    this.offline = false,
  });

  final SessionStatus status;
  final Account? account;
  final AppNavigation? navigation;
  final bool busy;
  final ViewFailure? failure;

  /// Goes up each time a change to the person's own details was saved.
  final int savedCount;

  /// The app could not reach the server while opening, and may try again.
  final bool offline;

  SessionState copyWith({
    SessionStatus? status,
    Account? account,
    AppNavigation? navigation,
    bool? busy,
    ViewFailure? failure,
    bool clearFailure = false,
    int? savedCount,
    bool? offline,
  }) => SessionState(
    status: status ?? this.status,
    account: account ?? this.account,
    navigation: navigation ?? this.navigation,
    busy: busy ?? this.busy,
    failure: clearFailure ? null : (failure ?? this.failure),
    savedCount: savedCount ?? this.savedCount,
    offline: offline ?? this.offline,
  );

  @override
  List<Object?> get props => [
    status,
    account,
    navigation,
    busy,
    failure,
    savedCount,
    offline,
  ];
}

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required SignIn signIn,
    required RestoreSession restoreSession,
    required SignOut signOut,
    required RenameMe renameMe,
    required ChangePassword changePassword,
    required WatchSessionEnd watchSessionEnd,
    required BuildNavigation buildNavigation,
  }) : _signIn = signIn,
       _restore = restoreSession,
       _signOut = signOut,
       _rename = renameMe,
       _changePassword = changePassword,
       _build = buildNavigation,
       super(const SessionState()) {
    on<SessionStarted>(_onStarted);
    on<SignInSubmitted>(_onSignIn);
    on<SignOutRequested>(_onSignOut);
    on<SessionEnded>(_onEnded);
    on<NameChanged>(_onName);
    on<PasswordChangeRequested>(_onPassword);
    _ended = watchSessionEnd(
      const NoParams(),
    ).listen((_) => add(const SessionEnded()));
  }

  final SignIn _signIn;
  final RestoreSession _restore;
  final SignOut _signOut;
  final RenameMe _rename;
  final ChangePassword _changePassword;
  final BuildNavigation _build;
  late final StreamSubscription<void> _ended;

  Future<void> _onStarted(SessionStarted e, Emitter<SessionState> emit) async {
    emit(state.copyWith(status: SessionStatus.checking, offline: false));
    try {
      final account = await _restore(const NoParams());
      if (account == null) {
        emit(const SessionState(status: SessionStatus.signedOut));
      } else {
        await _enter(account, emit);
      }
    } on ServerException catch (error) {
      // Not signed out: the phone just cannot reach the server right now.
      emit(
        SessionState(
          status: SessionStatus.signedOut,
          failure: ViewFailure.from(error),
          offline: error.failure == ServerFailure.offline,
        ),
      );
    }
  }

  Future<void> _onSignIn(SignInSubmitted e, Emitter<SessionState> emit) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _enter(await _signIn(SignInParams(e.email, e.password)), emit);
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  Future<void> _enter(Account account, Emitter<SessionState> emit) async {
    emit(
      SessionState(
        status: SessionStatus.signedIn,
        account: account,
        navigation: await _build(account),
      ),
    );
  }

  Future<void> _onSignOut(
    SignOutRequested e,
    Emitter<SessionState> emit,
  ) async {
    await _signOut(const NoParams());
    emit(const SessionState(status: SessionStatus.signedOut));
  }

  Future<void> _onEnded(SessionEnded e, Emitter<SessionState> emit) async {
    if (state.status != SessionStatus.signedIn) return;
    await _signOut(const NoParams());
    emit(
      const SessionState(
        status: SessionStatus.signedOut,
        failure: ViewFailure(ServerFailure.sessionExpired),
      ),
    );
  }

  Future<void> _onName(NameChanged e, Emitter<SessionState> emit) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      final account = await _rename(e.name);
      emit(
        state.copyWith(
          busy: false,
          account: account,
          savedCount: state.savedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  Future<void> _onPassword(
    PasswordChangeRequested e,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _changePassword(
        ChangePasswordParams(current: e.current, next: e.next),
      );
      emit(state.copyWith(busy: false, savedCount: state.savedCount + 1));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  @override
  Future<void> close() {
    _ended.cancel();
    return super.close();
  }
}
