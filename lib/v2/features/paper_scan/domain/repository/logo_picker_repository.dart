abstract interface class LogoPickerRepository {
  /// Path of the chosen picture, or null if the user cancelled.
  Future<String?> pick();
}
