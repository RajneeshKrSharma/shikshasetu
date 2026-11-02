/// A row of the `teacher_subjects` table.
class TeachingDto {
  const TeachingDto({
    required this.id,
    required this.teacherId,
    required this.className,
    required this.subject,
    required this.status,
    required this.requestedBy,
    required this.requestedAt,
    this.decidedAt,
  });

  final String id;
  final String teacherId;
  final String className;
  final String subject;
  final String status;
  final String requestedBy;
  final int requestedAt;
  final int? decidedAt;

  factory TeachingDto.fromMap(Map<String, Object?> m) => TeachingDto(
    id: m['id']! as String,
    teacherId: m['teacher_id']! as String,
    className: m['class_name']! as String,
    subject: m['subject']! as String,
    status: m['status']! as String,
    requestedBy: m['requested_by']! as String,
    requestedAt: m['requested_at']! as int,
    decidedAt: m['decided_at'] as int?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'teacher_id': teacherId,
    'class_name': className,
    'subject': subject,
    'status': status,
    'requested_by': requestedBy,
    'requested_at': requestedAt,
    'decided_at': decidedAt,
  };
}
