import '../../../../core/usecase/usecase.dart';
import '../entities/staff_member.dart';
import '../repository/staff_repository.dart';

class GetStaff implements UseCase<List<StaffMember>, NoParams> {
  const GetStaff(this._repository);

  final StaffRepository _repository;

  @override
  Future<List<StaffMember>> call(NoParams params) => _repository.getStaff();
}
