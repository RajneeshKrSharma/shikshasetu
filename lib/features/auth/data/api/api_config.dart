import 'package:flutter/foundation.dart';

/// Where the school's server is, and the keys the app needs to talk to it.
/// Set at build time:
/// `--dart-define=API_BASE_URL=https://your-app.up.railway.app/api`
class ApiConfig {
  const ApiConfig();

  static const _baseUrl = String.fromEnvironment('API_BASE_URL');

  /// The local dev server: the Android emulator reaches the computer at
  /// 10.0.2.2, everything else at localhost.
  String get baseUrl {
    if (_baseUrl.isNotEmpty) return _baseUrl;
    return defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8000/api'
        : 'http://127.0.0.1:8000/api';
  }
}
