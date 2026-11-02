/// Why a handwritten paper could not be read.
enum PaperReadFailure {
  /// No AI key has been saved on this phone.
  missingKey,

  /// The phone could not reach the AI service.
  noInternet,

  /// The service refused the key (wrong, expired or not allowed).
  invalidKey,

  /// Too many requests in a short time.
  quotaExceeded,

  /// The Anthropic account has no credit left.
  noCredit,

  /// The service took too long to answer.
  timedOut,

  /// The service is overloaded; trying again in a minute usually works.
  serviceBusy,

  /// The photos together are too big to send.
  tooLarge,

  /// The service answered, but not with a usable list of questions.
  badReply,

  /// The photos were read but held no questions.
  noQuestions,

  /// Any other error from the service; [PaperReadException.detail] says what.
  serviceError,
}

class PaperReadException implements Exception {
  const PaperReadException(this.reason, [this.detail]);

  final PaperReadFailure reason;

  /// The service's own message, when it gave one.
  final String? detail;

  @override
  String toString() => 'PaperReadException($reason, $detail)';
}
