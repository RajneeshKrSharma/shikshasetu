import 'package:equatable/equatable.dart';

/// What kind of thing needs the Principal's decision. New kinds (leave
/// requests, etc.) are added here and in the repository.
enum ApprovalCategory { examPaper, teachingSubject, staffBill }

enum ApprovalStatus { pending, approved, rejected }

/// One thing waiting for, or already given, the Principal's decision.
class ApprovalRequest extends Equatable {
  const ApprovalRequest({
    required this.category,
    required this.date,
    required this.status,
    this.refId,
    this.title,
    this.detail,
  });

  final ApprovalCategory category;

  /// The day the request is about (for a paper, the day it was sent).
  final DateTime date;
  final ApprovalStatus status;

  /// What the request is about, when it is a particular record (a paper's id).
  final String? refId;

  /// Name of the thing asked about (a paper's title), and a line under it.
  final String? title;
  final String? detail;

  bool get isPending => status == ApprovalStatus.pending;

  @override
  List<Object?> get props => [category, date, status, refId, title, detail];
}
