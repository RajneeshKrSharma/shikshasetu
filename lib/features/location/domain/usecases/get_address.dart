import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/address_repository.dart';

class AddressQuery extends Equatable {
  const AddressQuery({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Looks up the street address of a point on the map.
class GetAddress implements UseCase<String?, AddressQuery> {
  const GetAddress(this._repository);

  final AddressRepository _repository;

  @override
  Future<String?> call(AddressQuery params) =>
      _repository.addressOf(params.latitude, params.longitude);
}
