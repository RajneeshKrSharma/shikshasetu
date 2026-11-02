import '../entities/account.dart';

abstract interface class SessionRepository {
  /// Signs in. Throws a ServerException for a wrong email or password.
  Future<Account> signIn(String email, String password);

  /// The person from the last session, if the server still accepts it.
  Future<Account?> restore();

  Future<void> signOut();

  Future<void> changePassword({required String current, required String next});

  Future<Account> rename(String name);

  /// Fires when the server ended the session (it could not be renewed).
  Stream<void> get sessionEnded;
}
