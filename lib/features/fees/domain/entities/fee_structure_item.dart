import 'package:equatable/equatable.dart';

import 'fee_account.dart';

/// What a class pays for one kind of fee, and by when.
class FeeStructureItem extends Equatable {
  const FeeStructureItem({
    required this.className,
    required this.head,
    required this.amount,
    required this.dueDate,
    this.lastDate,
  });

  final String className;
  final FeeHead head;
  final int amount;
  final DateTime dueDate;

  /// After this day the fee is overdue; the due date when not set.
  final DateTime? lastDate;

  @override
  List<Object?> get props => [className, head, amount, dueDate, lastDate];
}
