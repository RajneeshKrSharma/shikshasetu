import 'package:equatable/equatable.dart';

enum AssignmentStatus { pending, approved, rejected }

/// One subject a teacher teaches in one class. A teacher can have many.
class TeachingAssignment extends Equatable {
  const TeachingAssignment({
    required this.id,
    required this.teacherId,
    required this.className,
    required this.subject,
    required this.status,
    required this.requestedByTeacher,
    required this.requestedAt,
    this.decidedAt,
  });

  final String id;
  final String teacherId;
  final String className;
  final String subject;
  final AssignmentStatus status;

  /// The teacher asked for it (false: the Principal allotted it).
  final bool requestedByTeacher;
  final DateTime requestedAt;
  final DateTime? decidedAt;

  bool get isApproved => status == AssignmentStatus.approved;
  bool get isPending => status == AssignmentStatus.pending;

  @override
  List<Object?> get props => [
    id,
    teacherId,
    className,
    subject,
    status,
    requestedByTeacher,
    requestedAt,
    decidedAt,
  ];
}
