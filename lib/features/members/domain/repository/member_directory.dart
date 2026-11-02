import '../entities/member_kind.dart';
import '../entities/member_summary.dart';

/// The people of every group, as lists. One place to ask, whatever the group.
abstract interface class MemberDirectory {
  Future<List<MemberSummary>> list(MemberKind kind);

  /// Makes a person inactive (or active again). Nothing is deleted.
  Future<void> setActive(MemberKind kind, String id, bool active);
}
