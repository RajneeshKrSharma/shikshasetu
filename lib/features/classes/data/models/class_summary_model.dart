import '../../domain/entities/class_summary.dart';
import '../dto/class_summary_dto.dart';

class ClassSummaryModel extends ClassSummary {
  const ClassSummaryModel({
    required super.name,
    required super.studentCount,
    super.classTeacherName,
  });

  factory ClassSummaryModel.fromDto(ClassSummaryDto d) => ClassSummaryModel(
    name: d.name,
    studentCount: d.studentCount,
    classTeacherName: d.classTeacherName,
  );
}
