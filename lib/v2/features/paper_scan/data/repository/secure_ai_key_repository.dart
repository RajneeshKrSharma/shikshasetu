import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../secrets.dart';

import '../../domain/repository/ai_key_repository.dart';

/// The key lives in the phone's Keystore / Keychain, never in the app's code
/// or plain preferences.
class SecureAiKeyRepository implements AiKeyRepository {
  const SecureAiKeyRepository([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _keyName = 'paper_scan.gemini_key';

  @override
  Future<String?> load() async {
    final saved = await _storage.read(key: _keyName);
    return saved != null && saved.isNotEmpty ? saved : geminiApiKey;
  }

  @override
  Future<void> save(String key) => _storage.write(key: _keyName, value: key);

  @override
  Future<void> clear() => _storage.delete(key: _keyName);
}
