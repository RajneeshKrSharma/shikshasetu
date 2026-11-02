import '../../../../core/usecase/usecase.dart';
import '../entities/person.dart';
import '../repository/registration_repository.dart';

class GetPeople implements UseCase<List<Person>, NoParams> {
  const GetPeople(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<List<Person>> call(NoParams params) => _repository.getPeople();
}
