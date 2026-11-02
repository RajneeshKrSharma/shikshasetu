import 'package:equatable/equatable.dart';

class Student extends Equatable {
  const Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.classId,
    required this.className,
    required this.guardianName,
    required this.usesVan,
    required this.isActive,
  });

  final String id;
  final String name;
  final String rollNumber;
  final String classId;
  final String className;
  final String guardianName;
  final bool usesVan;
  final bool isActive;

  @override
  List<Object?> get props => [
    id,
    name,
    rollNumber,
    classId,
    className,
    guardianName,
    usesVan,
    isActive,
  ];
}

/// What is asked of the server to add or change a student. A roll number left
/// empty is given by the server (the next free one in the class).
class StudentDraft extends Equatable {
  const StudentDraft({
    this.id,
    required this.name,
    this.rollNumber = '',
    required this.classId,
    required this.guardianName,
    required this.usesVan,
  });

  /// Null for a student not yet saved.
  final String? id;
  final String name;
  final String rollNumber;
  final String classId;
  final String guardianName;
  final bool usesVan;

  @override
  List<Object?> get props => [
    id,
    name,
    rollNumber,
    classId,
    guardianName,
    usesVan,
  ];
}
