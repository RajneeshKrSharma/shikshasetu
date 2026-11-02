import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/money.dart';
import '../entities/fees.dart';
import '../repository/fees_repository.dart';

class GetFeeStructure implements UseCase<List<FeeStructureLine>, String> {
  const GetFeeStructure(this._repository);

  final FeesRepository _repository;

  @override
  Future<List<FeeStructureLine>> call(String classId) =>
      _repository.structure(classId);
}

class SetFeeAmountParams extends Equatable {
  const SetFeeAmountParams(this.classId, this.head, this.amount);

  final String classId;
  final FeeHead head;
  final Money amount;

  @override
  List<Object?> get props => [classId, head, amount];
}

class SetFeeAmount implements UseCase<void, SetFeeAmountParams> {
  const SetFeeAmount(this._repository);

  final FeesRepository _repository;

  @override
  Future<void> call(SetFeeAmountParams p) =>
      _repository.setAmount(p.classId, p.head, p.amount);
}

class FeeAccountsParams extends Equatable {
  const FeeAccountsParams({
    this.classId,
    this.query = '',
    this.onlyDue = false,
  });

  final String? classId;
  final String query;
  final bool onlyDue;

  @override
  List<Object?> get props => [classId, query, onlyDue];
}

class GetFeeAccounts implements UseCase<List<FeeStatement>, FeeAccountsParams> {
  const GetFeeAccounts(this._repository);

  final FeesRepository _repository;

  @override
  Future<List<FeeStatement>> call(FeeAccountsParams p) => _repository.accounts(
    classId: p.classId,
    query: p.query,
    onlyDue: p.onlyDue,
  );
}

class GetStudentFees implements UseCase<FeeStatement, String> {
  const GetStudentFees(this._repository);

  final FeesRepository _repository;

  @override
  Future<FeeStatement> call(String studentId) =>
      _repository.studentFees(studentId);
}

class ReceiveFeeParams extends Equatable {
  const ReceiveFeeParams({
    required this.studentId,
    required this.head,
    required this.amount,
    this.paidOn,
    this.note = '',
  });

  final String studentId;
  final FeeHead head;
  final Money amount;
  final DateTime? paidOn;
  final String note;

  @override
  List<Object?> get props => [studentId, head, amount, paidOn, note];
}

class ReceiveFee implements UseCase<void, ReceiveFeeParams> {
  const ReceiveFee(this._repository);

  final FeesRepository _repository;

  @override
  Future<void> call(ReceiveFeeParams p) => _repository.receive(
    studentId: p.studentId,
    head: p.head,
    amount: p.amount,
    paidOn: p.paidOn,
    note: p.note,
  );
}
