import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repository/auth_repository.dart';

/// The sign-in flow: [signedOut] shows login. A Principal
/// whose school has no name yet then goes to [namingSchool] before the app
/// opens ([signedIn]).
enum AuthStatus { loading, signedOut, namingSchool, signedIn }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.loading,
    this.user,
    this.busy = false,
    this.failure,
    this.failureMessage,
  });

  final AuthStatus status;
  final AppUser? user;

  /// A login or registration request is in flight.
  final bool busy;
  final AuthFailure? failure;

  /// What the server said about [failure], when it said something.
  final String? failureMessage;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    bool clearUser = false,
    bool? busy,
    AuthFailure? failure,
    String? failureMessage,
    bool clearFailure = false,
  }) => AuthState(
    status: status ?? this.status,
    user: clearUser ? null : (user ?? this.user),
    busy: busy ?? this.busy,
    failure: clearFailure ? null : (failure ?? this.failure),
    failureMessage: clearFailure
        ? null
        : (failureMessage ?? this.failureMessage),
  );

  @override
  List<Object?> get props => [status, user, busy, failure, failureMessage];
}
