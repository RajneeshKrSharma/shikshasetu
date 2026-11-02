import '../entities/member.dart';

/// Reading, adding and changing one kind of person. Students, teachers and
/// other staff each implement this for their own type.
abstract interface class MemberRepository<T extends Member> {
  Future<T?> get(String id);

  /// Saves a new person and returns them as stored (with their id, and for a
  /// student their roll number).
  Future<T> add(T draft);

  Future<void> update(T member);
}
