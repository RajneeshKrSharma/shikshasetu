import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/fee_account.dart';
import '../entities/fee_person.dart';
import '../repository/fees_repository.dart';

class CreateFeeAccountParams extends Equatable {
  const CreateFeeAccountParams({
    required this.group,
    required this.person,
    required this.total,
    required this.dueDate,
    this.head = FeeHead.academic,
  });

  final FeeGroup group;
  final FeePerson person;
  final int total;
  final DateTime dueDate;
  final FeeHead head;

  @override
  List<Object?> get props => [group, person, total, dueDate, head];
}

class CreateFeeAccount implements UseCase<void, CreateFeeAccountParams> {
  const CreateFeeAccount(this._repository);

  final FeesRepository _repository;

  @override
  Future<void> call(CreateFeeAccountParams p) => _repository.createAccount(
    group: p.group,
    person: p.person,
    total: p.total,
    dueDate: p.dueDate,
    head: p.head,
  );
}
