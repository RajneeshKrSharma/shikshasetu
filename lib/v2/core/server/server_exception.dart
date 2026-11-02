/// What went wrong when talking to the server, as the app can act on it.
enum ServerFailure {
  /// No answer at all: no network, or the server cannot be reached.
  offline,

  /// Wrong email or password, or the account is switched off.
  invalidCredentials,

  /// The signed-in session is over and could not be renewed.
  sessionExpired,

  /// Signed in, but not allowed to do this.
  forbidden,

  /// The thing asked for is not there.
  notFound,

  /// The input has problems the person can fix; see [ServerException.fields].
  invalid,

  /// A school rule said no; [ServerException.message] says why.
  rejected,

  /// Too many wrong tries or requests.
  tooManyRequests,

  /// The server failed, or answered in a way the app does not know.
  unavailable,
}

class ServerException implements Exception {
  const ServerException(
    this.failure, {
    this.message,
    this.code,
    this.fields = const {},
  });

  final ServerFailure failure;

  /// The server's own sentence for the person; null when there was no answer.
  final String? message;

  /// The server's machine code, such as `wrong_current_password`.
  final String? code;

  /// Problems by field name, for [ServerFailure.invalid].
  final Map<String, List<String>> fields;

  @override
  String toString() => 'ServerException($failure, $code, $message)';
}
