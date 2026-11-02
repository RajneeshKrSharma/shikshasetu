import 'package:equatable/equatable.dart';

import '../../../../core/money.dart';

/// What a student can owe for. Tuition and van are set for each class; dress
/// and books come from what the school sells the student.
enum FeeHead {
  tuition('tuition', setPerClass: true),
  van('van', setPerClass: true),
  dress('dress'),
  books('books');

  const FeeHead(this.code, {this.setPerClass = false});

  final String code;

  /// True when the Principal gives the amount for each class.
  final bool setPerClass;

  static FeeHead? fromCode(String? code) {
    for (final h in values) {
      if (h.code == code) return h;
    }
    return null;
  }
}

/// The fixed fee of a class for one head; the amount is null until it is set.
class FeeStructureLine extends Equatable {
  const FeeStructureLine({required this.head, required this.amount});

  final FeeHead head;
  final Money? amount;

  @override
  List<Object?> get props => [head, amount];
}

class FeeLine extends Equatable {
  const FeeLine({
    required this.head,
    required this.due,
    required this.paid,
    required this.balance,
  });

  final FeeHead head;
  final Money due;
  final Money paid;
  final Money balance;

  @override
  List<Object?> get props => [head, due, paid, balance];
}

class FeePayment extends Equatable {
  const FeePayment({
    required this.id,
    required this.receiptNo,
    required this.head,
    required this.amount,
    required this.paidOn,
    required this.note,
  });

  final String id;
  final String receiptNo;
  final FeeHead head;
  final Money amount;
  final DateTime paidOn;
  final String note;

  @override
  List<Object?> get props => [id, receiptNo, head, amount, paidOn, note];
}

/// What one student owes, has paid and still has to pay.
class FeeStatement extends Equatable {
  const FeeStatement({
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.classId,
    required this.className,
    required this.usesVan,
    required this.lines,
    required this.totalDue,
    required this.totalPaid,
    required this.balance,
    this.payments = const [],
  });

  final String studentId;
  final String studentName;
  final String rollNumber;
  final String classId;
  final String className;
  final bool usesVan;
  final List<FeeLine> lines;
  final Money totalDue;
  final Money totalPaid;
  final Money balance;

  /// Filled for one student's own page; empty in the school-wide list.
  final List<FeePayment> payments;

  bool get hasDue => balance.isPositive;

  @override
  List<Object?> get props => [
    studentId,
    studentName,
    rollNumber,
    classId,
    className,
    usesVan,
    lines,
    totalDue,
    totalPaid,
    balance,
    payments,
  ];
}
