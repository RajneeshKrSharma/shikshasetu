import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/server/token_store.dart';
import '../../domain/entities/account.dart';
import '../../domain/repository/session_repository.dart';
import '../models/account_model.dart';

class ServerSessionRepository implements SessionRepository {
  ServerSessionRepository(this._client, this._tokens);

  final ServerClient _client;
  final TokenStore _tokens;

  @override
  Stream<void> get sessionEnded => _client.sessionEnded;

  @override
  Future<Account> signIn(String email, String password) async {
    final body = jsonObject(
      await _client.send(
        'POST',
        '/auth/login/',
        auth: false,
        body: {'email': email, 'password': password},
      ),
    );
    await _tokens.save(
      access: body.string('access'),
      refresh: body.stringOrNull('refresh'),
    );
    try {
      return await _me();
    } on ServerException {
      // Signed in, but this person cannot use the app: do not stay signed in.
      await _tokens.clear();
      rethrow;
    }
  }

  @override
  Future<Account?> restore() async {
    if (await _tokens.access() == null) return null;
    try {
      return await _me();
    } on ServerException catch (e) {
      if (e.failure == ServerFailure.sessionExpired ||
          e.failure == ServerFailure.forbidden) {
        await _tokens.clear();
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() => _tokens.clear();

  @override
  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    await _client.send(
      'POST',
      '/auth/change-password/',
      body: {'current': current, 'new': next},
    );
  }

  @override
  Future<Account> rename(String name) async => AccountModel.fromJson(
    jsonObject(await _client.send('PATCH', '/auth/me/', body: {'name': name})),
  );

  Future<Account> _me() async =>
      AccountModel.fromJson(jsonObject(await _client.send('GET', '/auth/me/')));
}
