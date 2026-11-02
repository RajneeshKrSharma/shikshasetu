import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Lets API calls be read while developing. Release builds use
/// [NoInspector].
abstract interface class HttpInspector {
  /// Goes on the HTTP client, or null when nothing is recorded.
  Interceptor? get interceptor;
}

class NoInspector implements HttpInspector {
  const NoInspector();

  @override
  Interceptor? get interceptor => null;
}

/// Prints each call to the debug console as one block: what was asked, what
/// came back and how long it took. Passwords and tokens are hidden.
class ConsoleInspector implements HttpInspector {
  ConsoleInspector({void Function(String)? sink})
    : _interceptor = _ConsoleInterceptor(sink ?? debugPrint);

  final Interceptor _interceptor;

  @override
  Interceptor? get interceptor => _interceptor;
}

class _ConsoleInterceptor extends Interceptor {
  _ConsoleInterceptor(this._print);

  final void Function(String) _print;

  static const _hidden = {
    'password',
    'new',
    'current',
    'access',
    'refresh',
    'id_token',
    'setup_key',
  };
  static const _startKey = 'inspector_started_at';
  static const _json = JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now().millisecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> r, ResponseInterceptorHandler handler) {
    final code = r.statusCode ?? 0;
    final ok = code >= 200 && code < 300;
    _print(
      _block(
        r.requestOptions,
        head: '${ok ? '✅' : '❌'} $code ${_meaning(code)}',
        lines: {'Response': _body(r.data)},
      ),
    );
    handler.next(r);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    _print(
      _block(
        e.requestOptions,
        head: '⛔ No answer (${e.type.name})',
        lines: {
          'Why':
              'The server could not be reached. Is it running, and is the '
              'address right?',
        },
      ),
    );
    handler.next(e);
  }

  String _block(
    RequestOptions o, {
    required String head,
    required Map<String, String> lines,
  }) {
    final started = o.extra[_startKey] as int?;
    final ms = started == null
        ? ''
        : '  ${DateTime.now().millisecondsSinceEpoch - started} ms';
    final signedIn =
        (o.headers['Authorization'] as String?)?.isNotEmpty ?? false;
    final rows = <String, String>{
      'URL': o.uri.toString(),
      'Bearer': signedIn ? 'sent' : 'not sent',
      if (o.data != null) 'Request': _body(o.data),
      ...lines,
    };
    final out = StringBuffer('┌─ API  $head   ${o.method} ${o.path}$ms');
    for (final e in rows.entries) {
      final text = e.value.split('\n');
      out.write('\n│ ${e.key.padRight(9)} ${text.first}');
      for (final more in text.skip(1)) {
        out.write('\n│           $more');
      }
    }
    out.write('\n└───────────────');
    return out.toString();
  }

  String _meaning(int code) => switch (code) {
    200 => 'OK',
    201 => 'Created',
    204 => 'Done',
    400 => 'Bad request (check the fields)',
    401 => 'Not signed in / wrong credentials',
    403 => 'Not allowed',
    404 => 'Not found',
    429 => 'Too many attempts',
    >= 500 => 'Server error',
    _ => '',
  };

  String _body(Object? body) {
    if (body == null || (body is String && body.isEmpty)) return '(empty)';
    final text = _json.convert(_redact(body));
    return text.length > 1500 ? '${text.substring(0, 1500)}\n…' : text;
  }

  Object? _redact(Object? v) => switch (v) {
    final Map<dynamic, dynamic> m => {
      for (final e in m.entries)
        // Only values are secret. A field's error messages (a list) are not.
        e.key: _hidden.contains(e.key) && e.value is! List && e.value is! Map
            ? '***'
            : _redact(e.value),
    },
    final List<dynamic> l => [for (final x in l) _redact(x)],
    _ => v,
  };
}
