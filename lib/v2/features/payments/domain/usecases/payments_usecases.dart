import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/money.dart';
import '../entities/payments.dart';
import '../repository/payments_repository.dart';

class GetPayeesParams extends Equatable {
  const GetPayeesParams(this.group, {this.query = ''});

  final PayeeGroup group;
  final String query;

  @override
  List<Object?> get props => [group, query];
}

class GetPayees implements UseCase<List<Payee>, GetPayeesParams> {
  const GetPayees(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<List<Payee>> call(GetPayeesParams p) =>
      _repository.payees(p.group, query: p.query);
}

class GetPersonAccount implements UseCase<PersonAccount, String> {
  const GetPersonAccount(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<PersonAccount> call(String personId) => _repository.account(personId);
}

class GetSalaryHistory implements UseCase<List<SalaryRate>, String> {
  const GetSalaryHistory(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<List<SalaryRate>> call(String personId) =>
      _repository.salaryHistory(personId);
}

class SetSalaryParams extends Equatable {
  const SetSalaryParams(this.personId, this.amount, this.fromMonth);

  final String personId;
  final Money amount;

  /// `2026-10`.
  final String fromMonth;

  @override
  List<Object?> get props => [personId, amount, fromMonth];
}

class SetSalary implements UseCase<void, SetSalaryParams> {
  const SetSalary(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<void> call(SetSalaryParams p) =>
      _repository.setSalary(p.personId, p.amount, p.fromMonth);
}

class PayPerson implements UseCase<void, PaymentDraft> {
  const PayPerson(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<void> call(PaymentDraft draft) => _repository.pay(draft);
}

class NoPaymentParams extends Equatable {
  const NoPaymentParams();

  @override
  List<Object?> get props => const [];
}

class GetMyAccount implements UseCase<PersonAccount, NoPaymentParams> {
  const GetMyAccount(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<PersonAccount> call(NoPaymentParams params) => _repository.myAccount();
}
