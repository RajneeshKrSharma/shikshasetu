/// A row of the `student_attendance` table.
class StudentAttendanceDto {
  const StudentAttendanceDto({
    required this.studentId,
    required this.day,
    required this.status,
  });

  final String studentId;
  final String day;
  final String status;

  factory StudentAttendanceDto.fromMap(Map<String, Object?> m) =>
      StudentAttendanceDto(
        studentId: m['student_id']! as String,
        day: (m['day'] as String?) ?? '',
        status: m['status']! as String,
      );

  Map<String, Object?> toMap() => {
    'student_id': studentId,
    'day': day,
    'status': status,
  };
}
