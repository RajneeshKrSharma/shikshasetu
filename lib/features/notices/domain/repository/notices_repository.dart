import '../entities/notice.dart';

abstract interface class NoticesRepository {
  /// Newest first.
  Future<List<Notice>> getNotices();
  Future<void> post(Notice notice);
}
