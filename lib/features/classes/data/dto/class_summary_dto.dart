/// A class row joined with its student count and class teacher.
class ClassSummaryDto {
  const ClassSummaryDto({
    required this.name,
    required this.studentCount,
    this.classTeacherName,
  });

  final String name;
  final int studentCount;
  final String? classTeacherName;

  factory ClassSummaryDto.fromMap(Map<String, Object?> m) => ClassSummaryDto(
    name: m['name']! as String,
    studentCount: m['student_count']! as int,
    classTeacherName: m['teacher_name'] as String?,
  );
}
