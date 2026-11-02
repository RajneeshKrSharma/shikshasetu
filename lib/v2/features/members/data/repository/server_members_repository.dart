import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/member.dart';
import '../../domain/repository/members_repository.dart';
import '../models/member_model.dart';

/// One repository for every kind of member: the kind gives the server path.
class ServerMembersRepository implements MembersRepository {
  ServerMembersRepository(this._client, this._kind);

  final ServerClient _client;
  final MemberKind _kind;

  String _one(String id) => '${_kind.path}$id/';

  @override
  Future<List<Member>> members({
    String query = '',
    bool onlyActive = true,
  }) async => [
    for (final m in jsonObjects(
      await _client.send(
        'GET',
        _kind.path,
        query: {'query': query, 'active': onlyActive ? 'true' : 'all'},
      ),
    ))
      MemberModel.fromJson(m),
  ];

  @override
  Future<Member> member(String id) async =>
      MemberModel.fromJson(jsonObject(await _client.send('GET', _one(id))));

  @override
  Future<Member> save(MemberDraft d) async {
    final saved = d.id == null
        ? await _client.send(
            'POST',
            _kind.path,
            body: {
              'name': d.name.trim(),
              'email': d.email.trim().toLowerCase(),
              'password': d.password,
              if (_kind.hasJobTitle) 'job_title': d.jobTitle.trim(),
            },
          )
        : await _client.send(
            'PATCH',
            _one(d.id!),
            body: {
              'name': d.name.trim(),
              if (_kind.hasJobTitle) 'job_title': d.jobTitle.trim(),
            },
          );
    return MemberModel.fromJson(jsonObject(saved));
  }

  @override
  Future<Member> setActive(String id, {required bool active}) async {
    if (!active) {
      await _client.send('DELETE', _one(id));
      return member(id);
    }
    return MemberModel.fromJson(
      jsonObject(
        await _client.send('PATCH', _one(id), body: {'is_active': true}),
      ),
    );
  }

  @override
  Future<void> setPassword(String id, String password) =>
      _client.send('PATCH', _one(id), body: {'password': password});
}
