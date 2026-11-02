/// Brings a school that was registered earlier (on another phone, or before a
/// reinstall) onto this phone. Every method throws `AuthException` on failure.
abstract interface class SchoolRestorer {
  /// Copies everything the signed-in Principal's school has in the cloud.
  /// Throws `AuthFailure.schoolNotFound` when the account owns no school.
  Future<void> restoreForPrincipal();

  /// Copies what a teacher needs: the school's settings, calendar and notices,
  /// plus their own profile, class, students, papers and attendance. Throws
  /// `AuthFailure.schoolNotFound` when no school has added this account as a
  /// teacher.
  Future<void> restoreForTeacher();
}
