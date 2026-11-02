import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/notice.dart';
import '../../domain/repository/notices_repository.dart';
import '../models/notice_model.dart';

class ServerNoticesRepository implements NoticesRepository {
  ServerNoticesRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Notice>> getNotices() async => [
    for (final n in jsonObjects(await _client.send('GET', '/notices/')))
      NoticeModel.fromJson(n),
  ];

  @override
  Future<Notice> post({
    required NoticeKind kind,
    required String title,
    required String body,
  }) async => NoticeModel.fromJson(
    jsonObject(
      await _client.send(
        'POST',
        '/notices/',
        body: {'kind': kind.code, 'title': title, 'body': body},
      ),
    ),
  );

  @override
  Future<void> withdraw(String id) async {
    await _client.send('DELETE', '/notices/$id/');
  }
}
