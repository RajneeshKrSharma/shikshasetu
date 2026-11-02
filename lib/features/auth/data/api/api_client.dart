import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/network/http_inspector.dart';
import '../../domain/repository/auth_repository.dart';
import 'api_config.dart';
import 'token_store.dart';

/// What the server answered.
class ApiResponse {
  const ApiResponse(this.status, this.body);

  final int status;
  final Object? body;

  bool get ok => status >= 200 && status < 300;

  Map<String, dynamic> get json =>
      body is Map<String, dynamic> ? body! as Map<String, dynamic> : const {};
}

/// Talks to the school's server. Sends the Bearer token on every request and,
/// when it has expired, swaps the refresh token for a new one and retries once.
class ApiClient {
  ApiClient(ApiConfig config, this._tokens, HttpInspector inspector, [Dio? dio])
    : _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = config.baseUrl
      ..connectTimeout = _timeout
      ..sendTimeout = _timeout
      ..receiveTimeout = _timeout
      ..headers = {'Accept': 'application/json'}
      // A 400 or 401 is an answer to read, not an error to catch.
      ..validateStatus = (_) => true;
    final tap = inspector.interceptor;
    if (tap != null) _dio.interceptors.add(tap);
  }

  final Dio _dio;
  final TokenStore _tokens;

  static const _timeout = Duration(seconds: 20);

  Future<bool>? _refreshing;

  /// [auth] false is for the calls made before there is a token (sign-in).
  Future<ApiResponse> send(
    String method,
    String path, {
    Object? body,
    bool auth = true,
  }) async {
    var response = await _once(method, path, body, auth);
    if (response.status == 401 && auth && await _refreshTokens()) {
      response = await _once(method, path, body, auth);
    }
    return response;
  }

  Future<ApiResponse> _once(
    String method,
    String path,
    Object? body,
    bool auth,
  ) async {
    final token = auth ? await _tokens.access() : null;
    try {
      final r = await _dio.request<Object?>(
        path,
        data: body,
        options: Options(
          method: method,
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return ApiResponse(r.statusCode ?? 0, r.data);
    } on DioException {
      // No answer at all: no network, or the server is not reachable.
      throw const AuthException(AuthFailure.offline);
    }
  }

  /// One refresh at a time, however many calls found the token expired.
  Future<bool> _refreshTokens() =>
      _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);

  Future<bool> _doRefresh() async {
    final refresh = await _tokens.refresh();
    if (refresh == null) return false;
    final r = await _once('POST', '/auth/refresh/', {
      'refresh': refresh,
    }, false);
    final access = r.json['access'];
    if (!r.ok || access is! String) {
      await _tokens.clear();
      return false;
    }
    await _tokens.save(access: access, refresh: r.json['refresh'] as String?);
    return true;
  }
}
