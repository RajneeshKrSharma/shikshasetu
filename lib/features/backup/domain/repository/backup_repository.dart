import '../entities/backup_entities.dart';

abstract interface class BackupRepository {
  /// Writes the data now and packs it into one small ZIP file, ready to
  /// share. Returns the path of the ZIP.
  Future<String> createZip(DateTime at);

  /// Writes the data file kept beside the database: written whole, checked
  /// by reading it back, and only then put in place of the previous one.
  /// Returns the path of the file.
  Future<String> writeMirror(DateTime at);

  /// Keeps a copy of the current data before it is replaced. Returns the
  /// path of the copy.
  Future<String> createSafetyCopy(DateTime at);

  /// Removes a copy made by [createSafetyCopy] that is no longer needed.
  Future<void> discardCopy(String path);

  /// Checks that [jsonText] is a backup this app can restore.
  BackupPreview preview(String jsonText);

  /// Replaces all data with the backup's, or changes nothing on failure.
  Future<void> restore(String jsonText);
}
