import '../../domain/entities/member_kind.dart';
import '../../domain/entities/member_summary.dart';
import '../../domain/repository/member_directory.dart';
import 'member_source.dart';

/// Asks the source of each group; knows nothing about any one of them.
class SqlMemberDirectory implements MemberDirectory {
  SqlMemberDirectory(Iterable<MemberSource> sources)
    : _byKind = {for (final s in sources) s.kind: s};

  final Map<MemberKind, MemberSource> _byKind;

  @override
  Future<List<MemberSummary>> list(MemberKind kind) => _byKind[kind]!.list();

  @override
  Future<void> setActive(MemberKind kind, String id, bool active) =>
      _byKind[kind]!.setActive(id, active);
}
