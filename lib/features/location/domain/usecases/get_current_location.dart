import '../../../../core/usecase/usecase.dart';
import '../entities/location_reading.dart';
import '../repository/location_repository.dart';

class GetCurrentLocation implements UseCase<LocationReading, NoParams> {
  const GetCurrentLocation(this._repository);

  final LocationRepository _repository;

  @override
  Future<LocationReading> call(NoParams params) => _repository.current();
}
