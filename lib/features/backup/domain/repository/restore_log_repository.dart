import '../entities/restore_record.dart';

/// The restores that were done. Kept outside the database, because a restore
/// replaces the whole database.
abstract interface class RestoreLogRepository {
  /// Newest first.
  Future<List<RestoreRecord>> recent();

  Future<void> add(RestoreRecord record);
}
