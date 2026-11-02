import 'package:equatable/equatable.dart';

class ClassSummary extends Equatable {
  const ClassSummary({
    required this.name,
    required this.studentCount,
    this.classTeacherName,
  });

  /// Display name and key, e.g. "6-A".
  final String name;
  final int studentCount;
  final String? classTeacherName;

  @override
  List<Object?> get props => [name, studentCount, classTeacherName];
}
