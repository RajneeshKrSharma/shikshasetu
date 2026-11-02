import '../entities/notice.dart';

abstract interface class NoticesRepository {
  /// Newest first.
  Future<List<Notice>> getNotices();

  Future<Notice> post({
    required NoticeKind kind,
    required String title,
    required String body,
  });

  /// Takes a notice down; the record stays on the server.
  Future<void> withdraw(String id);
}
