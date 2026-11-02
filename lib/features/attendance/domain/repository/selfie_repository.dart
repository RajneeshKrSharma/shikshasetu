abstract interface class SelfieRepository {
  /// Opens the front camera and returns the saved photo path, or null if the
  /// user cancelled.
  Future<String?> capture(String teacherId);
}
