/// The school's details kept on the server. Throws `AuthException` on failure.
abstract interface class SchoolProfileService {
  Future<void> saveName(String name);
}
