import '../../../../core/usecase/usecase.dart';
import '../entities/member_kind.dart';
import '../entities/member_workspace.dart';
import '../entities/workspace_catalog.dart';

class GetWorkspace implements UseCase<MemberWorkspace, MemberKind> {
  const GetWorkspace(this._catalog);

  final WorkspaceCatalog _catalog;

  @override
  Future<MemberWorkspace> call(MemberKind kind) async => _catalog.of(kind);
}
