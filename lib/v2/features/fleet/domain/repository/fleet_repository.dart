import '../entities/fleet.dart';

abstract interface class FleetRepository {
  Future<List<Van>> vans();

  Future<void> saveVan(VanDraft draft);

  Future<void> removeVan(String id);

  Future<List<FuelBill>> bills({BillStatus? status});

  Future<void> submit(FuelBillDraft draft);

  Future<void> withdraw(String id);

  Future<void> approve(String id);

  Future<void> reject(String id, String reason);
}
