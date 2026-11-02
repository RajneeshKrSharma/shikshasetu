import 'member_feature.dart';
import 'member_kind.dart';

/// What one group of people offers: the features opened from its screen.
/// Add a group, or a feature to a group, by adding or editing one class here
/// and nothing else.
abstract class MemberWorkspace {
  const MemberWorkspace();

  MemberKind get kind;
  List<MemberFeature> get features;
}

class StudentWorkspace extends MemberWorkspace {
  const StudentWorkspace();

  @override
  MemberKind get kind => MemberKind.student;

  @override
  List<MemberFeature> get features => const [
    MemberFeature.fees,
    MemberFeature.accessories,
    MemberFeature.performance,
    MemberFeature.studentAttendance,
    MemberFeature.classes,
  ];
}

class TeacherWorkspace extends MemberWorkspace {
  const TeacherWorkspace();

  @override
  MemberKind get kind => MemberKind.teacher;

  @override
  List<MemberFeature> get features => const [
    MemberFeature.teacherPayment,
    MemberFeature.questionBank,
    MemberFeature.examPapers,
    MemberFeature.teacherAttendance,
    MemberFeature.subjects,
  ];
}

class OtherStaffWorkspace extends MemberWorkspace {
  const OtherStaffWorkspace();

  @override
  MemberKind get kind => MemberKind.other;

  @override
  List<MemberFeature> get features => const [
    MemberFeature.otherAttendance,
    MemberFeature.staffPayment,
    MemberFeature.bills,
  ];
}
