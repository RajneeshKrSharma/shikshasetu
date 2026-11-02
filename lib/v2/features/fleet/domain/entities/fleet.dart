import 'package:equatable/equatable.dart';

import '../../../../core/money.dart';
import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

class Van extends Equatable {
  const Van({
    required this.id,
    required this.name,
    required this.driverId,
    required this.driverName,
  });

  final String id;
  final String name;
  final String? driverId;
  final String driverName;

  @override
  List<Object?> get props => [id, name, driverId, driverName];
}

class VanDraft extends Equatable {
  const VanDraft({this.id, required this.name, this.driverId});

  final String? id;
  final String name;

  /// Null leaves the van without a driver.
  final String? driverId;

  @override
  List<Object?> get props => [id, name, driverId];
}

enum FuelType {
  petrol('petrol'),
  diesel('diesel');

  const FuelType(this.code);

  final String code;

  static FuelType? fromCode(String? code) {
    for (final f in values) {
      if (f.code == code) return f;
    }
    return null;
  }
}

enum BillStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const BillStatus(this.code);

  final String code;

  static BillStatus? fromCode(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return null;
  }
}

class FuelBill extends Equatable {
  const FuelBill({
    required this.id,
    required this.vanName,
    required this.submittedByName,
    required this.billedOn,
    required this.fuel,
    required this.litres,
    required this.rate,
    required this.amount,
    required this.odometerKm,
    required this.distanceKm,
    required this.kmPerLitre,
    required this.status,
    required this.rejectReason,
  });

  final String id;
  final String vanName;
  final String submittedByName;
  final DateTime billedOn;
  final FuelType fuel;
  final String litres;
  final Money rate;
  final Money amount;
  final int odometerKm;

  /// Null for a van's first bill.
  final int? distanceKm;
  final String? kmPerLitre;
  final BillStatus status;
  final String rejectReason;

  bool get isPending => status == BillStatus.pending;

  @override
  List<Object?> get props => [
    id,
    vanName,
    submittedByName,
    billedOn,
    fuel,
    litres,
    rate,
    amount,
    odometerKm,
    distanceKm,
    kmPerLitre,
    status,
    rejectReason,
  ];
}

class FuelBillDraft extends Equatable {
  const FuelBillDraft({
    this.vanId,
    required this.billedOn,
    required this.fuel,
    required this.litres,
    required this.rate,
    required this.odometerKm,
  });

  /// Null for a driver's own van.
  final String? vanId;
  final DateTime billedOn;
  final FuelType fuel;
  final String litres;
  final Money rate;
  final int odometerKm;

  @override
  List<Object?> get props => [vanId, billedOn, fuel, litres, rate, odometerKm];
}

/// What a person may do about vans and fuel bills.
class FleetAccess {
  const FleetAccess._({
    required this.canAllotVans,
    required this.canSubmit,
    required this.canApprove,
  });

  factory FleetAccess.of(Account account) => FleetAccess._(
    canAllotVans: account.can(Permission.allotVans),
    canSubmit: account.can(Permission.submitFuelBill),
    canApprove: account.can(Permission.approveFuelBills),
  );

  final bool canAllotVans;
  final bool canSubmit;
  final bool canApprove;

  bool get canSeeBills => canSubmit || canApprove;
}
