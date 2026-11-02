import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/fees_repository.dart';

class ChangeFeeDatesParams extends Equatable {
  const ChangeFeeDatesParams({
    required this.accountId,
    required this.dueDate,
    required this.note,
    this.lastDate,
  });

  final String accountId;
  final DateTime dueDate;
  final DateTime? lastDate;
  final String note;

  @override
  List<Object?> get props => [accountId, dueDate, lastDate, note];
}

/// Gives one student's fee dates of its own.
class ChangeFeeDates implements UseCase<void, ChangeFeeDatesParams> {
  const ChangeFeeDates(this._repository);

  final FeesRepository _repository;

  @override
  Future<void> call(ChangeFeeDatesParams p) => _repository.changeDates(
    accountId: p.accountId,
    dueDate: p.dueDate,
    lastDate: p.lastDate,
    note: p.note,
  );
}
