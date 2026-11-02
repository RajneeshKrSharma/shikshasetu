import '../../../auth/domain/entities/app_user.dart';
import 'teaching_assignment.dart';

/// Which classes and subjects a user may set papers and questions for.
///
/// The Principal may use any. A teacher may use what the Principal allotted
/// or accepted. A subject a teacher was registered with, before subjects were
/// given per class, stays allowed in every class until the Principal sets it
/// class by class.
class TeachingAccess {
  const TeachingAccess({
    required this.user,
    required this.assignments,
    required this.allSubjects,
    required this.allClasses,
  });

  final AppUser user;
  final List<TeachingAssignment> assignments;

  /// Every subject the school offers.
  final List<String> allSubjects;

  /// Every class of the school.
  final List<String> allClasses;

  bool get _unrestricted => user.isPrincipal;

  Iterable<TeachingAssignment> get _mine =>
      assignments.where((a) => a.teacherId == user.id && a.isApproved);

  String? get _legacySubject {
    final s = user.subject?.trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  /// Classes the user may choose.
  List<String> classes() {
    if (_unrestricted || _legacySubject != null) return allClasses;
    final mine = _mine.map((a) => a.className).toSet();
    return [
      for (final c in allClasses)
        if (mine.contains(c)) c,
    ];
  }

  /// Subjects the user may choose for [className] (or for any class when it
  /// is null).
  List<String> subjects({String? className}) {
    if (_unrestricted) return allSubjects;
    final result = <String>{
      ?_legacySubject,
      for (final a in _mine)
        if (className == null || a.className == className) a.subject,
    };
    return [
      for (final s in {...allSubjects, ...result})
        if (result.contains(s)) s,
    ];
  }

  /// The user has nothing they may teach yet.
  bool get hasNone => !_unrestricted && subjects().isEmpty;
}
