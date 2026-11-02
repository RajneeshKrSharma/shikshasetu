import 'package:equatable/equatable.dart';

enum FeeGroup { student, teacher, other }

/// What a fee is for. A student can owe several; a teacher or other staff
/// member has a single [payment].
enum FeeHead { academic, dress, books, van, payment }

enum FeeStatus { paid, partial, overdue, due }

class FeeAccount extends Equatable {
  const FeeAccount({
    required this.id,
    required this.name,
    required this.group,
    required this.subtitle,
    required this.total,
    required this.paid,
    required this.dueDate,
    this.head = FeeHead.academic,
    this.lastDate,
    this.dateNote,
    this.personId,
    this.classSection,
    this.rollNo,
  });

  final String id;
  final String name;
  final FeeGroup group;
  final FeeHead head;
  final String? personId;

  /// The student's current class (null for teachers and other staff).
  final String? classSection;
  final int? rollNo;

  /// Class for students, subject for teachers, role for others.
  final String subtitle;
  final int total;
  final int paid;

  /// The day the fee becomes payable.
  final DateTime dueDate;

  /// After this day the fee counts as overdue. Without one, the due date is.
  final DateTime? lastDate;

  /// Why this one fee has dates of its own, when it has.
  final String? dateNote;

  int get pending => total - paid;

  /// The day after which an unpaid fee is overdue.
  DateTime get overdueAfter => lastDate ?? dueDate;

  FeeStatus statusAt(DateTime now) {
    if (pending <= 0) return FeeStatus.paid;
    if (overdueAfter.isBefore(now)) return FeeStatus.overdue;
    if (paid > 0) return FeeStatus.partial;
    return FeeStatus.due;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    group,
    head,
    personId,
    subtitle,
    total,
    paid,
    dueDate,
    lastDate,
    dateNote,
    classSection,
    rollNo,
  ];
}
