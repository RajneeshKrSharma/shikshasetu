import '../entities/approval_request.dart';

abstract interface class ApprovalsRepository {
  /// Today's approval requests, from every category.
  Future<List<ApprovalRequest>> getRequests(DateTime today);

  /// Records the Principal's decision. Setting [ApprovalStatus.pending]
  /// takes a decision back.
  Future<void> decide(
    ApprovalRequest request,
    ApprovalStatus status,
    String decidedBy,
  );
}
