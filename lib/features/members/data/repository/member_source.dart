import '../../domain/entities/member_kind.dart';
import '../../domain/entities/member_summary.dart';

/// How one group of people is read and switched on or off. A new group is
/// added with one more source; the directory does not change.
abstract class MemberSource {
  const MemberSource();

  MemberKind get kind;

  Future<List<MemberSummary>> list();

  Future<void> setActive(String id, bool active);
}
