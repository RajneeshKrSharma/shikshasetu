import '../../../../core/money.dart';
import '../../../../core/server/json.dart';
import '../../domain/entities/fleet.dart';

class FleetModels {
  const FleetModels._();

  static Van van(Json j) => Van(
    id: j.string('id'),
    name: j.string('name'),
    driverId: j.stringOrNull('driver_id'),
    driverName: j.string('driver_name'),
  );

  static FuelBill bill(Json j) => FuelBill(
    id: j.string('id'),
    vanName: j.string('van_name'),
    submittedByName: j.string('submitted_by_name'),
    billedOn: j.day('billed_on'),
    fuel: FuelType.fromCode(j.stringOrNull('fuel')) ?? FuelType.petrol,
    litres: j.string('litres'),
    rate: Money.fromServer(j['rate']),
    amount: Money.fromServer(j['amount']),
    odometerKm: j.integer('odometer_km'),
    distanceKm: j.integerOrNull('distance_km'),
    kmPerLitre: j.stringOrNull('km_per_litre'),
    status: BillStatus.fromCode(j.stringOrNull('status')) ?? BillStatus.pending,
    rejectReason: j.string('reject_reason'),
  );
}
