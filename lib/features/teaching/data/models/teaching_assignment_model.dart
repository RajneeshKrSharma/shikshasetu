import '../../domain/entities/teaching_assignment.dart';
import '../dto/teaching_dto.dart';

class TeachingAssignmentModel extends TeachingAssignment {
  const TeachingAssignmentModel({
    required super.id,
    required super.teacherId,
    required super.className,
    required super.subject,
    required super.status,
    required super.requestedByTeacher,
    required super.requestedAt,
    super.decidedAt,
  });

  factory TeachingAssignmentModel.fromDto(TeachingDto d) =>
      TeachingAssignmentModel(
        id: d.id,
        teacherId: d.teacherId,
        className: d.className,
        subject: d.subject,
        status: AssignmentStatus.values.byName(d.status),
        requestedByTeacher: d.requestedBy == 'teacher',
        requestedAt: DateTime.fromMillisecondsSinceEpoch(d.requestedAt),
        decidedAt: d.decidedAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(d.decidedAt!),
      );
}
