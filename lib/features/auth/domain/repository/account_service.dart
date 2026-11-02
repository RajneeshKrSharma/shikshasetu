/// The online login accounts. Every method throws `AuthException` on failure.
abstract interface class AccountService {
  /// Email of the account signed in from an earlier session, if any. Works
  /// offline.
  String? get signedInEmail;

  /// Id of the account signed in from an earlier session, if any. Works
  /// offline.
  String? get signedInUid;

  /// The account's email as the server has it now. Falls back to
  /// [signedInEmail] when offline.
  Future<String?> currentEmail();

  /// Starts changing the account's email. Throws
  /// `AuthFailure.wrongCurrentPassword` when [password] is wrong.
  Future<void> requestEmailChange({
    required String password,
    required String newEmail,
  });

  /// Creates a teacher's account without changing who is signed in. Returns
  /// its id.
  Future<String> createFor({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String subject,
  });

  Future<void> signIn(String email, String password);

  Future<void> signOut();

  /// Throws `AuthFailure.wrongCurrentPassword` when [current] is wrong.
  Future<void> changePassword({required String current, required String next});
}
