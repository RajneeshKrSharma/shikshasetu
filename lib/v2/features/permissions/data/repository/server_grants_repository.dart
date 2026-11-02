import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/grants.dart';
import '../../domain/repository/grants_repository.dart';

class ServerGrantsRepository implements GrantsRepository {
  ServerGrantsRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Capability>> capabilities() async => [
    for (final c in jsonObjects(
      await _client.send('GET', '/auth/capabilities/'),
    ))
      Capability(code: c.string('code'), label: c.string('label')),
  ];

  @override
  Future<List<Grant>> grants(String userId) async => [
    for (final g in jsonObjects(
      await _client.send('GET', '/auth/grants/', query: {'user_id': userId}),
    ))
      Grant(
        id: g.string('id'),
        userId: g.string('user_id'),
        capability: g.string('capability'),
        reason: g.string('reason'),
        isActive: g.flag('is_active', otherwise: true),
      ),
  ];

  @override
  Future<void> grant(GrantDraft d) => _client.send(
    'POST',
    '/auth/grants/',
    body: {
      'user_id': d.userId,
      'capability': d.capability,
      'reason': d.reason.trim(),
    },
  );

  @override
  Future<void> revoke(String grantId) =>
      _client.send('DELETE', '/auth/grants/$grantId/');
}
