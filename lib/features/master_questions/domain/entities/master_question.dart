import 'package:equatable/equatable.dart';

import '../../../exams/domain/entities/exam_paper.dart';

/// A question kept in the shared bank so it can be added to any paper. The
/// [question]'s marks are only a suggestion (0 means none).
class MasterQuestion extends Equatable {
  const MasterQuestion({
    required this.id,
    required this.question,
    required this.createdAt,
    this.subject,
    this.classSection,
    this.createdBy,
    this.unitId,
  });

  final String id;
  final Question question;
  final DateTime createdAt;
  final String? subject;

  /// The class it suits, if the setter said.
  final String? classSection;
  final String? createdBy;

  /// The unit of a teacher's own bank it belongs to, if any.
  final String? unitId;

  @override
  List<Object?> get props => [
    id,
    question,
    createdAt,
    subject,
    classSection,
    createdBy,
    unitId,
  ];
}
