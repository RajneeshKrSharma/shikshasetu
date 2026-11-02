import '../../../exams/data/dto/question_details_codec.dart';
import '../../domain/entities/master_question.dart';
import '../dto/master_question_dto.dart';

class MasterQuestionModel extends MasterQuestion {
  const MasterQuestionModel({
    required super.id,
    required super.question,
    required super.createdAt,
    super.subject,
    super.classSection,
    super.createdBy,
    super.unitId,
  });

  factory MasterQuestionModel.fromDto(MasterQuestionDto d) =>
      MasterQuestionModel(
        id: d.id,
        question: QuestionDetailsCodec.decode(
          text: d.text,
          marks: d.marks ?? 0,
          type: d.type,
          details: d.details,
        ),
        createdAt: DateTime.fromMillisecondsSinceEpoch(d.createdAt),
        subject: d.subject,
        classSection: d.className,
        createdBy: d.createdBy,
        unitId: d.unitId,
      );

  static MasterQuestionDto toDto(MasterQuestion q) => MasterQuestionDto(
    id: q.id,
    type: q.question.type.name,
    text: q.question.text,
    marks: q.question.marks > 0 ? q.question.marks : null,
    details: QuestionDetailsCodec.encode(q.question),
    subject: q.subject,
    className: q.classSection,
    createdBy: q.createdBy,
    unitId: q.unitId,
    createdAt: q.createdAt.millisecondsSinceEpoch,
  );
}
