abstract interface class BackupStorageRepository {
  /// Lets the user choose where to save the file at [path], under [name].
  /// True if it was saved, false if they cancelled.
  Future<bool> saveToDevice(String path, String name);

  /// Lets the user pick a backup file; returns its text, or null if cancelled.
  Future<String?> pickBackupText();
}
