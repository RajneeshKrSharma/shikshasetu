/// Keeps a copy of the data file where removing the app does not remove it
/// (the phone's Downloads folder).
abstract interface class ExternalCopyRepository {
  /// Puts the file at [sourcePath] in that folder as [name], replacing the
  /// copy made before. Throws when it cannot be done.
  Future<void> save(String sourcePath, String name);
}
