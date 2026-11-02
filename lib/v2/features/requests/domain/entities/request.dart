import 'package:equatable/equatable.dart';

import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

/// What a request asks for. Each kind knows who may raise and decide it.
enum RequestKind {
  leave(
    'leave',
    raise: Permission.recordOwnAttendance,
    decide: Permission.approveLeaves,
  ),
  meeting(
    'meeting',
    raise: Permission.raiseMeetingQuery,
    decide: Permission.decideRequests,
  );

  const RequestKind(this.code, {required this.raise, required this.decide});

  final String code;
  final Permission raise;
  final Permission decide;

  static RequestKind? fromCode(String? code) {
    for (final k in values) {
      if (k.code == code) return k;
    }
    return null;
  }
}

enum RequestStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  withdrawn('withdrawn');

  const RequestStatus(this.code);

  final String code;

  static RequestStatus fromCode(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return RequestStatus.pending;
  }
}

class Request extends Equatable {
  const Request({
    required this.id,
    required this.kind,
    required this.status,
    required this.requesterId,
    required this.requesterName,
    required this.decidedByName,
    required this.decidedOn,
    required this.decisionNote,
    this.startsOn,
    this.endsOn,
    this.reason = '',
    this.subject = '',
    this.details = '',
    this.preferredOn,
    this.meetingOn,
    this.meetingAt,
  });

  final String id;
  final RequestKind kind;
  final RequestStatus status;
  final String requesterId;
  final String requesterName;
  final String decidedByName;
  final DateTime? decidedOn;
  final String decisionNote;
  final DateTime? startsOn;
  final DateTime? endsOn;
  final String reason;
  final String subject;
  final String details;
  final DateTime? preferredOn;
  final DateTime? meetingOn;

  /// Minutes since midnight.
  final int? meetingAt;

  bool get isPending => status == RequestStatus.pending;

  @override
  List<Object?> get props => [
    id,
    kind,
    status,
    requesterId,
    requesterName,
    decidedByName,
    decidedOn,
    decisionNote,
    startsOn,
    endsOn,
    reason,
    subject,
    details,
    preferredOn,
    meetingOn,
    meetingAt,
  ];
}

sealed class RequestDraft extends Equatable {
  const RequestDraft();

  @override
  List<Object?> get props => const [];
}

final class LeaveDraft extends RequestDraft {
  const LeaveDraft({
    required this.startsOn,
    required this.endsOn,
    required this.reason,
  });

  final DateTime startsOn;
  final DateTime endsOn;
  final String reason;

  @override
  List<Object?> get props => [startsOn, endsOn, reason];
}

final class MeetingDraft extends RequestDraft {
  const MeetingDraft({
    required this.subject,
    this.details = '',
    this.preferredOn,
  });

  final String subject;
  final String details;
  final DateTime? preferredOn;

  @override
  List<Object?> get props => [subject, details, preferredOn];
}

class RequestsAccess {
  const RequestsAccess._(this._account);

  factory RequestsAccess.of(Account account) => RequestsAccess._(account);

  final Account _account;

  bool canRaise(RequestKind kind) => _account.can(kind.raise);

  bool canDecide(RequestKind kind) => _account.can(kind.decide);

  bool isMine(Request request) => request.requesterId == _account.id;

  Iterable<RequestKind> get raisable => RequestKind.values.where(canRaise);
}
