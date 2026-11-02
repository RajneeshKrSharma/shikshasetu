import '../../../../core/usecase/usecase.dart';
import '../entities/notice.dart';
import '../repository/notices_repository.dart';

class GetNotices implements UseCase<List<Notice>, NoParams> {
  const GetNotices(this._repository);

  final NoticesRepository _repository;

  @override
  Future<List<Notice>> call(NoParams params) => _repository.getNotices();
}
