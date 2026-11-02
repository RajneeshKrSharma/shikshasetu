import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/account_service.dart';
import '../../domain/repository/auth_repository.dart';
import 'api_client.dart';
import 'token_store.dart';

/// Accounts kept by the school's server. Signing in returns a Bearer token
/// that is stored securely and sent with every later request.
class ApiAccountService implements AccountService {
  ApiAccountService(this._api, this._tokens, this._prefs);

  final ApiClient _api;
  final TokenStore _tokens;
  final SharedPreferences _prefs;

  static const _emailKey = 'api_user_email';
  static const _uidKey = 'api_user_id';

  @override
  String? get signedInEmail => _prefs.getString(_emailKey);

  @override
  String? get signedInUid => _prefs.getString(_uidKey);

  @override
  Future<String?> currentEmail() async => signedInEmail;

  @override
  Future<void> requestEmailChange({
    required String password,
    required String newEmail,
  }) => Future.error(const AuthException(AuthFailure.unavailable));

  @override
  Future<void> signIn(String email, String password) async {
    final r = await _api.send(
      'POST',
      '/auth/login/',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (!r.ok) throw _failure(r);
    await _keepTokens(r.json);
    await _rememberUser();
  }

  @override
  Future<String> createFor({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String subject,
  }) async {
    final r = await _api.send(
      'POST',
      '/auth/teachers/',
      body: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'subject': subject,
      },
    );
    if (!r.ok) throw _failure(r);
    return r.json['id'] as String;
  }

  @override
  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    final r = await _api.send(
      'POST',
      '/auth/change-password/',
      body: {'current': current, 'new': next},
    );
    if (!r.ok) throw _failure(r);
  }

  @override
  Future<void> signOut() async {
    await _tokens.clear();
    await _prefs.remove(_emailKey);
    await _prefs.remove(_uidKey);
  }

  Future<void> _keepTokens(Map<String, dynamic> json) => _tokens.save(
    access: json['access'] as String,
    refresh: json['refresh'] as String?,
  );

  Future<void> _rememberUser() async {
    final r = await _api.send('GET', '/auth/me/');
    if (!r.ok) throw _failure(r);
    _remember(r.json);
  }

  /// Remembers who is signed in (kept so it is known offline). Returns the id.
  String _remember(Object? user) {
    final map = user! as Map<String, dynamic>;
    _prefs.setString(_emailKey, (map['email']! as String).toLowerCase());
    _prefs.setString(_uidKey, map['id']! as String);
    return map['id']! as String;
  }

  /// What went wrong, from the server's answer: its own sentence for the
  /// person, and a kind the app can act on.
  AuthException _failure(ApiResponse r) {
    final code = r.json['code'];
    final text = '${r.body}'.toLowerCase();
    final kind = switch (r.status) {
      400 when code == 'wrong_current_password' =>
        AuthFailure.wrongCurrentPassword,
      400
          when r.json['errors'] is Map &&
                  (r.json['errors'] as Map).containsKey('password') ||
              (r.json['errors'] is Map &&
                  (r.json['errors'] as Map).containsKey('new')) =>
        AuthFailure.weakPassword,
      400 when text.contains('already exists') => AuthFailure.emailTaken,
      400
          when r.json['errors'] is Map &&
              (r.json['errors'] as Map).containsKey('email') =>
        AuthFailure.invalidEmail,
      401 => AuthFailure.invalidCredentials,
      403 when text.contains('deactivated') => AuthFailure.inactiveAccount,
      429 => AuthFailure.tooManyRequests,
      _ => AuthFailure.unavailable,
    };
    final message = r.json['message'];
    return AuthException(kind, message: message is String ? message : null);
  }
}
