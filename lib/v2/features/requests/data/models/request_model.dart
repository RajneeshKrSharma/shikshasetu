import '../../../../core/server/json.dart';
import '../../domain/entities/request.dart';

class RequestModel extends Request {
  const RequestModel({
    required super.id,
    required super.kind,
    required super.status,
    required super.requesterId,
    required super.requesterName,
    required super.decidedByName,
    required super.decidedOn,
    required super.decisionNote,
    super.startsOn,
    super.endsOn,
    super.reason,
    super.subject,
    super.details,
    super.preferredOn,
    super.meetingOn,
    super.meetingAt,
  });

  factory RequestModel.fromJson(Json j) => RequestModel(
    id: j.string('id'),
    kind: RequestKind.fromCode(j.stringOrNull('kind')) ?? RequestKind.leave,
    status: RequestStatus.fromCode(j.stringOrNull('status')),
    requesterId: j.string('requester_id'),
    requesterName: j.string('requester_name'),
    decidedByName: j.string('decided_by_name'),
    decidedOn: j.dayOrNull('decided_on'),
    decisionNote: j.string('decision_note'),
    startsOn: j.dayOrNull('starts_on'),
    endsOn: j.dayOrNull('ends_on'),
    reason: j.string('reason'),
    subject: j.string('subject'),
    details: j.string('details'),
    preferredOn: j.dayOrNull('preferred_on'),
    meetingOn: j.dayOrNull('meeting_on'),
    meetingAt: j.minuteOrNull('meeting_at'),
  );
}
