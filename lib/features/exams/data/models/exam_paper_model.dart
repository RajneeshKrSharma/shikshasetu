import '../../domain/entities/exam_paper.dart';
import '../dto/exam_dto.dart';
import '../dto/question_details_codec.dart';

class ExamPaperModel extends ExamPaper {
  const ExamPaperModel({
    required super.id,
    required super.title,
    required super.subject,
    required super.classSection,
    required super.date,
    required super.durationMinutes,
    required super.questions,
    required super.status,
    super.createdBy,
    super.instructions,
    super.reviewNote,
    super.submittedAt,
    super.kind,
  });

  factory ExamPaperModel.fromDto(
    ExamPaperDto d,
    List<ExamQuestionDto> questions,
  ) => ExamPaperModel(
    id: d.id,
    title: d.title,
    subject: d.subject,
    classSection: d.className,
    date: DateTime.fromMillisecondsSinceEpoch(d.examDate),
    durationMinutes: d.durationMinutes,
    status: PaperStatus.parse(d.status),
    createdBy: d.createdBy,
    instructions: d.instructions ?? '',
    reviewNote: d.reviewNote,
    kind: ExamKind.parse(d.examType),
    submittedAt: d.submittedAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.submittedAt!),
    questions: [
      for (final q in questions)
        QuestionDetailsCodec.decode(
          text: q.text,
          marks: q.marks,
          type: q.type,
          details: q.details,
        ),
    ],
  );

  static ExamPaperDto toDto(ExamPaper p, String createdBy) => ExamPaperDto(
    id: p.id,
    title: p.title,
    subject: p.subject,
    className: p.classSection,
    examDate: p.date.millisecondsSinceEpoch,
    durationMinutes: p.durationMinutes,
    status: p.status.name,
    createdBy: p.createdBy ?? createdBy,
    instructions: p.instructions.isEmpty ? null : p.instructions,
    reviewNote: p.reviewNote,
    submittedAt: p.submittedAt?.millisecondsSinceEpoch,
    examType: p.kind?.name,
  );

  static List<ExamQuestionDto> questionDtos(ExamPaper p) => [
    for (var i = 0; i < p.questions.length; i++)
      ExamQuestionDto(
        paperId: p.id,
        position: i,
        text: p.questions[i].text,
        marks: p.questions[i].marks,
        type: p.questions[i].type.name,
        details: QuestionDetailsCodec.encode(p.questions[i]),
      ),
  ];
}
