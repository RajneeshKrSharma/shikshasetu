/// A row of the `exam_papers` table.
class ExamPaperDto {
  const ExamPaperDto({
    required this.id,
    required this.title,
    required this.subject,
    required this.className,
    required this.examDate,
    required this.durationMinutes,
    required this.status,
    this.createdBy,
    this.instructions,
    this.reviewNote,
    this.submittedAt,
    this.examType,
  });

  final String id;
  final String title;
  final String subject;
  final String className;
  final int examDate;
  final int durationMinutes;
  final String status;
  final String? createdBy;
  final String? instructions;
  final String? reviewNote;
  final int? submittedAt;
  final String? examType;

  factory ExamPaperDto.fromMap(Map<String, Object?> m) => ExamPaperDto(
    id: m['id']! as String,
    title: m['title']! as String,
    subject: m['subject']! as String,
    className: m['class_name']! as String,
    examDate: m['exam_date']! as int,
    durationMinutes: m['duration_minutes']! as int,
    status: m['status']! as String,
    createdBy: m['created_by'] as String?,
    instructions: m['instructions'] as String?,
    reviewNote: m['review_note'] as String?,
    submittedAt: m['submitted_at'] as int?,
    examType: m['exam_type'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'subject': subject,
    'class_name': className,
    'exam_date': examDate,
    'duration_minutes': durationMinutes,
    'status': status,
    'created_by': createdBy,
    'instructions': instructions,
    'review_note': reviewNote,
    'submitted_at': submittedAt,
    'exam_type': examType,
  };
}

/// A row of the `exam_questions` table.
class ExamQuestionDto {
  const ExamQuestionDto({
    required this.paperId,
    required this.position,
    required this.text,
    required this.marks,
    required this.type,
    this.details,
  });

  final String paperId;
  final int position;
  final String text;
  final int marks;
  final String type;
  final String? details;

  factory ExamQuestionDto.fromMap(Map<String, Object?> m) => ExamQuestionDto(
    paperId: m['paper_id']! as String,
    position: m['position']! as int,
    text: m['text']! as String,
    marks: m['marks']! as int,
    type: m['type'] as String? ?? 'shortAnswer',
    details: m['details'] as String?,
  );

  Map<String, Object?> toMap() => {
    'paper_id': paperId,
    'position': position,
    'text': text,
    'marks': marks,
    'type': type,
    'details': details,
  };
}

/// A row of the `exam_marks` table.
class ExamMarkDto {
  const ExamMarkDto({
    required this.paperId,
    required this.studentId,
    required this.marksObtained,
  });

  final String paperId;
  final String studentId;
  final int marksObtained;

  factory ExamMarkDto.fromMap(Map<String, Object?> m) => ExamMarkDto(
    paperId: m['paper_id']! as String,
    studentId: m['student_id']! as String,
    marksObtained: m['marks_obtained']! as int,
  );

  Map<String, Object?> toMap() => {
    'paper_id': paperId,
    'student_id': studentId,
    'marks_obtained': marksObtained,
  };
}
