import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/fleet.dart';
import '../../domain/repository/fleet_repository.dart';
import '../models/fleet_models.dart';

class ServerFleetRepository implements FleetRepository {
  ServerFleetRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Van>> vans() async => [
    for (final v in jsonObjects(await _client.send('GET', '/vans/')))
      FleetModels.van(v),
  ];

  @override
  Future<void> saveVan(VanDraft d) => d.id == null
      ? _client.send(
          'POST',
          '/vans/',
          body: {'name': d.name.trim(), 'driver_id': d.driverId},
        )
      : _client.send(
          'PATCH',
          '/vans/${d.id}/',
          body: {'name': d.name.trim(), 'driver_id': d.driverId},
        );

  @override
  Future<void> removeVan(String id) => _client.send('DELETE', '/vans/$id/');

  @override
  Future<List<FuelBill>> bills({BillStatus? status}) async => [
    for (final b in jsonObjects(
      await _client.send(
        'GET',
        '/fuel-bills/',
        query: {'status': status?.code},
      ),
    ))
      FleetModels.bill(b),
  ];

  @override
  Future<void> submit(FuelBillDraft d) => _client.send(
    'POST',
    '/fuel-bills/',
    body: {
      'van_id': d.vanId,
      'billed_on': WireFormat.day(d.billedOn),
      'fuel': d.fuel.code,
      'litres': d.litres,
      'rate': d.rate.wire,
      'odometer_km': d.odometerKm,
    },
  );

  @override
  Future<void> withdraw(String id) =>
      _client.send('DELETE', '/fuel-bills/$id/');

  @override
  Future<void> approve(String id) =>
      _client.send('POST', '/fuel-bills/$id/approve/');

  @override
  Future<void> reject(String id, String reason) =>
      _client.send('POST', '/fuel-bills/$id/reject/', body: {'reason': reason});
}
