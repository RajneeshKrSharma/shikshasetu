/// A request as stored: which kind, which day, and its decision.
class ApprovalDto {
  const ApprovalDto({
    required this.category,
    required this.day,
    required this.status,
    this.refId,
    this.title,
    this.detail,
  });

  final String category;

  /// Calendar day, as a database key like "2026-10-01".
  final String day;
  final String status;
  final String? refId;
  final String? title;
  final String? detail;
}
