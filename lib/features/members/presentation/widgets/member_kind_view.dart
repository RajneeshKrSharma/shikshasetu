import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../profiles/presentation/screen/student_profile_screen.dart';
import '../../../profiles/presentation/screen/teacher_profile_screen.dart';
import '../../../registration/domain/entities/person.dart';
import '../../../registration/presentation/screen/register_form_screen.dart';
import '../../../other_staff/presentation/screen/staff_profile_screen.dart';
import '../../domain/entities/member_kind.dart';
import '../../domain/entities/member_summary.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../../staff/presentation/widgets/assign_class_sheet.dart';
import '../../../teaching/presentation/screen/subjects_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One more thing that can be done with a person of a group, shown in their
/// menu: assign a teacher's class, allot their subjects...
class MemberActionView {
  const MemberActionView(this.label, this.run);

  final String Function(AppLocalizations) label;
  final Future<void> Function(BuildContext, MemberSummary) run;
}

/// Everything a screen needs to word and open one group of people. Students,
/// teachers and other staff each say it once, here; no screen asks "which
/// kind is this?".
abstract class MemberKindView {
  const MemberKindView();

  MemberKind get kind;
  IconData get icon;

  String title(AppLocalizations l);
  String addLabel(AppLocalizations l);
  String addHint(AppLocalizations l);
  String listLabel(AppLocalizations l);
  String searchHint(AppLocalizations l);
  String groupAllLabel(AppLocalizations l);

  /// Opens the form that adds one.
  Future<void> openAdd(BuildContext context);

  /// Null when this group has no profile screen yet.
  void Function(BuildContext, MemberSummary)? get openProfile => null;

  /// Null when this group cannot be edited yet.
  Future<void> Function(BuildContext, MemberSummary)? get openEdit => null;

  /// What else can be done with a person of this group.
  List<MemberActionView> get actions => const [];
}

class StudentKindView extends MemberKindView {
  const StudentKindView();

  @override
  MemberKind get kind => MemberKind.student;

  @override
  IconData get icon => Icons.backpack_outlined;

  @override
  String title(AppLocalizations l) => l.tabStudents;

  @override
  String addLabel(AppLocalizations l) => l.addStudentTitle;

  @override
  String addHint(AppLocalizations l) => l.wsAddStudentHint;

  @override
  String listLabel(AppLocalizations l) => l.wsListStudents;

  @override
  String searchHint(AppLocalizations l) => l.searchStudentsHint;

  @override
  String groupAllLabel(AppLocalizations l) => l.filterAllClasses;

  @override
  Future<void> openAdd(BuildContext context) =>
      RegisterFormScreen.open(context, PersonType.student);

  @override
  void Function(BuildContext, MemberSummary) get openProfile =>
      (c, m) => StudentProfileScreen.open(c, m.id);

  @override
  Future<void> Function(BuildContext, MemberSummary) get openEdit =>
      (c, m) => RegisterFormScreen.open(c, PersonType.student, studentId: m.id);
}

class TeacherKindView extends MemberKindView {
  const TeacherKindView();

  @override
  MemberKind get kind => MemberKind.teacher;

  @override
  IconData get icon => Icons.badge_outlined;

  @override
  String title(AppLocalizations l) => l.tabTeachers;

  @override
  String addLabel(AppLocalizations l) => l.addTeacherTitle;

  @override
  String addHint(AppLocalizations l) => l.wsAddTeacherHint;

  @override
  String listLabel(AppLocalizations l) => l.wsListTeachers;

  @override
  String searchHint(AppLocalizations l) => l.searchTeachersHint;

  @override
  String groupAllLabel(AppLocalizations l) => l.filterAll;

  @override
  Future<void> openAdd(BuildContext context) =>
      RegisterFormScreen.open(context, PersonType.teacher);

  @override
  void Function(BuildContext, MemberSummary) get openProfile =>
      (c, m) => TeacherProfileScreen.open(c, m.id);

  @override
  List<MemberActionView> get actions => [
    MemberActionView((l) => l.staffActionAssignClass, (c, m) async {
      // Make sure the class list is fresh before choosing.
      c.read<ClassesBloc>().add(const ClassesLoaded());
      await showModalBottomSheet<void>(
        context: c,
        showDragHandle: true,
        builder: (_) => AssignClassSheet(memberId: m.id),
      );
    }),
    MemberActionView((l) => l.staffActionSubjects, (c, m) {
      final subject = m.parts
          .where((p) => p.field == SummaryField.subject)
          .firstOrNull;
      return SubjectsScreen.open(
        c,
        teacherId: m.id,
        teacherName: m.name,
        registeredSubject: subject?.value,
      );
    }),
  ];
}

class OtherStaffKindView extends MemberKindView {
  const OtherStaffKindView();

  @override
  MemberKind get kind => MemberKind.other;

  @override
  IconData get icon => Icons.directions_bus_outlined;

  @override
  String title(AppLocalizations l) => l.tabOthers;

  @override
  String addLabel(AppLocalizations l) => l.addStaffTitle;

  @override
  String addHint(AppLocalizations l) => l.wsAddStaffHint;

  @override
  String listLabel(AppLocalizations l) => l.wsListStaff;

  @override
  String searchHint(AppLocalizations l) => l.searchStaffHint;

  @override
  String groupAllLabel(AppLocalizations l) => l.filterAll;

  @override
  Future<void> openAdd(BuildContext context) =>
      RegisterFormScreen.open(context, PersonType.other);

  @override
  void Function(BuildContext, MemberSummary) get openProfile =>
      (c, m) => StaffProfileScreen.open(c, m.id);
}

class MemberKindViews {
  const MemberKindViews._();

  static const _all = <MemberKind, MemberKindView>{
    MemberKind.student: StudentKindView(),
    MemberKind.teacher: TeacherKindView(),
    MemberKind.other: OtherStaffKindView(),
  };

  static MemberKindView of(MemberKind kind) => _all[kind]!;
}
