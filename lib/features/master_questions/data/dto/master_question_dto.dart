/// A row of the `master_questions` table.
class MasterQuestionDto {
  const MasterQuestionDto({
    required this.id,
    required this.type,
    required this.text,
    required this.createdAt,
    this.marks,
    this.details,
    this.subject,
    this.className,
    this.createdBy,
    this.unitId,
  });

  final String id;
  final String type;
  final String text;
  final int createdAt;
  final int? marks;
  final String? details;
  final String? subject;
  final String? className;
  final String? createdBy;
  final String? unitId;

  factory MasterQuestionDto.fromMap(Map<String, Object?> m) =>
      MasterQuestionDto(
        id: m['id']! as String,
        type: m['type']! as String,
        text: m['text']! as String,
        createdAt: m['created_at']! as int,
        marks: m['marks'] as int?,
        details: m['details'] as String?,
        subject: m['subject'] as String?,
        className: m['class_name'] as String?,
        createdBy: m['created_by'] as String?,
        unitId: m['unit_id'] as String?,
      );

  Map<String, Object?> toMap() => {
    'id': id,
    'type': type,
    'text': text,
    'marks': marks,
    'details': details,
    'subject': subject,
    'class_name': className,
    'created_by': createdBy,
    'created_at': createdAt,
    'unit_id': unitId,
  };
}
