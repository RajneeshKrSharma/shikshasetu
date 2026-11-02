import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/fleet.dart';
import '../repository/fleet_repository.dart';

class GetVans implements UseCase<List<Van>, NoVanParams> {
  const GetVans(this._repository);

  final FleetRepository _repository;

  @override
  Future<List<Van>> call(NoVanParams params) => _repository.vans();
}

class NoVanParams extends Equatable {
  const NoVanParams();

  @override
  List<Object?> get props => const [];
}

class SaveVan implements UseCase<void, VanDraft> {
  const SaveVan(this._repository);

  final FleetRepository _repository;

  @override
  Future<void> call(VanDraft draft) => _repository.saveVan(draft);
}

class RemoveVan implements UseCase<void, String> {
  const RemoveVan(this._repository);

  final FleetRepository _repository;

  @override
  Future<void> call(String id) => _repository.removeVan(id);
}

class GetFuelBills implements UseCase<List<FuelBill>, BillStatus?> {
  const GetFuelBills(this._repository);

  final FleetRepository _repository;

  @override
  Future<List<FuelBill>> call(BillStatus? status) =>
      _repository.bills(status: status);
}

class SubmitFuelBill implements UseCase<void, FuelBillDraft> {
  const SubmitFuelBill(this._repository);

  final FleetRepository _repository;

  @override
  Future<void> call(FuelBillDraft draft) => _repository.submit(draft);
}

class WithdrawFuelBill implements UseCase<void, String> {
  const WithdrawFuelBill(this._repository);

  final FleetRepository _repository;

  @override
  Future<void> call(String id) => _repository.withdraw(id);
}

class ApproveFuelBill implements UseCase<void, String> {
  const ApproveFuelBill(this._repository);

  final FleetRepository _repository;

  @override
  Future<void> call(String id) => _repository.approve(id);
}

class RejectFuelBillParams extends Equatable {
  const RejectFuelBillParams(this.id, this.reason);

  final String id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

class RejectFuelBill implements UseCase<void, RejectFuelBillParams> {
  const RejectFuelBill(this._repository);

  final FleetRepository _repository;

  @override
  Future<void> call(RejectFuelBillParams p) =>
      _repository.reject(p.id, p.reason.trim());
}
