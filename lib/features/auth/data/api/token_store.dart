import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the Bearer tokens the server issued.
abstract interface class TokenStore {
  Future<String?> access();
  Future<String?> refresh();
  Future<void> save({required String access, String? refresh});
  Future<void> clear();
}

/// Tokens live in the phone's Keystore / Keychain, never in plain preferences.
class SecureTokenStore implements TokenStore {
  const SecureTokenStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'api_access_token';
  static const _refreshKey = 'api_refresh_token';

  @override
  Future<String?> access() => _storage.read(key: _accessKey);

  @override
  Future<String?> refresh() => _storage.read(key: _refreshKey);

  @override
  Future<void> save({required String access, String? refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    if (refresh != null) await _storage.write(key: _refreshKey, value: refresh);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
