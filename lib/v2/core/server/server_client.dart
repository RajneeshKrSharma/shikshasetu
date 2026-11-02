import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/network/http_inspector.dart';
import 'api_config.dart';
import 'server_exception.dart';
import 'token_store.dart';

/// Talks to the school's server. Sends the token on every request and, when it
/// has expired, swaps the refresh token for a new one and tries once more.
/// A good answer comes back as decoded JSON; anything else throws a
/// [ServerException] carrying the server's own words.
class ServerClient {
  ServerClient(
    ApiConfig config,
    this._tokens,
    HttpInspector inspector, [
    Dio? dio,
  ]) : _dio = dio ?? Dio() {
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
  final StreamController<void> _sessionEnded = StreamController.broadcast();

  static const _timeout = Duration(seconds: 20);

  Future<bool>? _refreshing;

  /// Fires when the session ended on the server's side (the tokens could not
  /// be renewed), so the app can send the person back to sign in.
  Stream<void> get sessionEnded => _sessionEnded.stream;

  /// [auth] false is for the calls made before there is a token (sign-in).
  /// [query] values that are null or empty are left out.
  Future<Object?> send(
    String method,
    String path, {
    Object? body,
    Map<String, Object?> query = const {},
    bool auth = true,
  }) async {
    final cleaned = {
      for (final e in query.entries)
        if (e.value != null && '${e.value}'.isNotEmpty) e.key: '${e.value}',
    };
    var response = await _once(method, path, body, cleaned, auth);
    if (response.statusCode == 401 && auth && await _refreshTokens()) {
      response = await _once(method, path, body, cleaned, auth);
    }
    return _read(response);
  }

  Future<Response<Object?>> _once(
    String method,
    String path,
    Object? body,
    Map<String, String> query,
    bool auth,
  ) async {
    final token = auth ? await _tokens.access() : null;
    try {
      return await _dio.request<Object?>(
        path,
        data: body,
        queryParameters: query.isEmpty ? null : query,
        options: Options(
          method: method,
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException {
      throw const ServerException(ServerFailure.offline);
    }
  }

  /// One refresh at a time, however many calls found the token expired.
  Future<bool> _refreshTokens() =>
      _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);

  Future<bool> _doRefresh() async {
    final refresh = await _tokens.refresh();
    if (refresh == null) {
      _sessionEnded.add(null);
      return false;
    }
    final r = await _once(
      'POST',
      '/auth/refresh/',
      {'refresh': refresh},
      const {},
      false,
    );
    final data = r.data;
    final access = data is Map ? data['access'] : null;
    final code = r.statusCode ?? 0;
    if (code < 200 || code >= 300 || access is! String) {
      await _tokens.clear();
      _sessionEnded.add(null);
      return false;
    }
    await _tokens.save(
      access: access,
      refresh: (data as Map)['refresh'] as String?,
    );
    return true;
  }

  Object? _read(Response<Object?> r) {
    final status = r.statusCode ?? 0;
    if (status >= 200 && status < 300) return r.data;
    final data = r.data;
    final map = data is Map ? data : const {};
    final code = map['code'] as String?;
    final message = map['message'] as String?;
    final fields = <String, List<String>>{};
    final errors = map['errors'];
    if (errors is Map) {
      for (final e in errors.entries) {
        fields['${e.key}'] = [
          for (final text in (e.value is List ? e.value as List : [e.value]))
            '$text',
        ];
      }
    }
    ServerException failure(ServerFailure f) =>
        ServerException(f, message: message, code: code, fields: fields);
    return switch (status) {
      400 when code == 'validation_error' => throw failure(
        ServerFailure.invalid,
      ),
      400 => throw failure(
        fields.isEmpty ? ServerFailure.rejected : ServerFailure.invalid,
      ),
      401 when code == 'no_active_account' => throw failure(
        ServerFailure.invalidCredentials,
      ),
      401 => throw failure(ServerFailure.sessionExpired),
      403 => throw failure(ServerFailure.forbidden),
      404 => throw failure(ServerFailure.notFound),
      429 => throw failure(ServerFailure.tooManyRequests),
      _ => throw failure(ServerFailure.unavailable),
    };
  }
}
