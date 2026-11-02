import 'package:equatable/equatable.dart';

import 'accessory_issue.dart';

/// One student of a class and how they stand for dress or books.
class StudentAccessoryRow extends Equatable {
  const StudentAccessoryRow({
    required this.studentId,
    required this.name,
    required this.rollNo,
    required this.guardian,
    required this.itemCount,
    this.size,
    this.given = const {},
    this.lastIssue,
  });

  final String studentId;
  final String name;
  final int rollNo;
  final String guardian;

  /// The dress size noted for the student, if any.
  final String? size;

  /// How many pieces the class's set has.
  final int itemCount;

  /// The pieces already given, by name.
  final Set<String> given;
  final AccessoryIssue? lastIssue;

  int get givenCount => given.length;
  bool get isComplete => itemCount > 0 && givenCount >= itemCount;
  bool get hasSize => size != null && size!.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    studentId,
    name,
    rollNo,
    guardian,
    itemCount,
    size,
    given,
    lastIssue,
  ];
}
