import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

/// App start: decides between login and the signed-in app.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// The new Principal named the school.
final class AuthSchoolNamed extends AuthEvent {
  const AuthSchoolNamed(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Check whether the user's email was changed (they opened the verification
/// link) and update this phone if so.
final class AuthEmailSyncRequested extends AuthEvent {
  const AuthEmailSyncRequested();
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// The signed-in user's details changed (e.g. profile edited).
final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}
