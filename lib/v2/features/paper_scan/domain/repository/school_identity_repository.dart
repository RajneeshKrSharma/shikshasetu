import '../entities/school_identity.dart';

abstract interface class SchoolIdentityRepository {
  Future<SchoolIdentity> load();

  /// Keeps the name, and copies the logo somewhere permanent.
  Future<SchoolIdentity> save(SchoolIdentity identity);
}
