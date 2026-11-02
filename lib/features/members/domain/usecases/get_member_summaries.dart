import '../../../../core/usecase/usecase.dart';
import '../entities/member_kind.dart';
import '../entities/member_summary.dart';
import '../repository/member_directory.dart';

class GetMemberSummaries implements UseCase<List<MemberSummary>, MemberKind> {
  const GetMemberSummaries(this._directory);

  final MemberDirectory _directory;

  @override
  Future<List<MemberSummary>> call(MemberKind kind) => _directory.list(kind);
}
