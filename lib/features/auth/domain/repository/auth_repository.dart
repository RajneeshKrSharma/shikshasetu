import '../entities/app_user.dart';

enum AuthFailure {
  invalidCredentials,
  inactiveAccount,
  wrongCurrentPassword,
  emailTaken,
  weakPassword,
  invalidEmail,
  tooManyRequests,

  /// The device has no internet, which signing in and creating accounts need.
  offline,

  /// Signed in, but this phone has no profile for the account yet.
  profileMissing,

  /// The login server is not connected in this build, or failed unexpectedly.
  unavailable,

  /// Signed in, but no school was registered with this account.
  schoolNotFound,
}

class AuthException implements Exception {
  const AuthException(this.failure, {this.message});
  final AuthFailure failure;

  /// What the server said, in words for the person. Null when there was no
  /// answer (offline) or the app found the problem itself.
  final String? message;
}

/// Shortest password the app accepts.
const kMinPasswordLength = 8;

abstract interface class AuthRepository {
  /// Signs in. A phone that does not have this person yet is given their
  /// profile from the server.
  Future<AppUser> signIn(String email, String password);

  /// The school's name on this phone; empty until the Principal has named it.
  Future<String> schoolName();

  /// Names the school, here and on the server.
  Future<void> nameSchool(String name);

  /// The signed-in user from the last session, if still valid.
  Future<AppUser?> restoreSession();
  Future<void> signOut();

  Future<void> changePassword({
    required String userId,
    required String current,
    required String next,
  });

  /// Starts changing the signed-in user's email: a verification link goes to
  /// [newEmail] and nothing changes until it is opened.
  Future<void> requestEmailChange({
    required String password,
    required String newEmail,
  });

  /// Brings this phone's copy of the signed-in user's email in line with the
  /// account. Returns the updated user, or null when nothing changed.
  Future<AppUser?> syncVerifiedEmail();

  Future<AppUser> updateProfile({
    required String userId,
    required String name,
    required String phone,
  });
}
