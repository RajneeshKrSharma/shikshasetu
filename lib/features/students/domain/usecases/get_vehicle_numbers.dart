import '../../../../core/usecase/usecase.dart';
import '../repository/students_repository.dart';

/// The vans a student can travel by (those that have a driver).
class GetVehicleNumbers implements UseCase<List<String>, NoParams> {
  const GetVehicleNumbers(this._repository);

  final StudentsRepository _repository;

  @override
  Future<List<String>> call(NoParams params) => _repository.getVehicleNumbers();
}
