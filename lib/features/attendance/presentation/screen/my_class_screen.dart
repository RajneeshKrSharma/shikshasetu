import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../../../teaching/presentation/screen/subjects_screen.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_state.dart';
import 'marking_screen.dart';

/// A teacher's own class: its attendance today, its students and the
/// subjects they teach, in three tabs.
class MyClassScreen extends StatelessWidget {
  const MyClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    if (user == null) return const SizedBox.shrink();
    final myClass = context.select((StaffBloc b) => b.state.classOf(user.id));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(myClass == null ? l.navMyClass : l.myClassTitle(myClass)),
          bottom: TabBar(
            tabs: [
              Tab(text: l.navAttendance),
              Tab(text: l.tabStudents),
              Tab(text: l.moduleMySubjects),
            ],
          ),
        ),
        body: myClass == null
            ? Center(child: Text(l.myClassNone, textAlign: TextAlign.center))
            : TabBarView(
                children: [
                  _AttendanceTab(classSection: myClass),
                  _StudentsTab(classSection: myClass),
                  SubjectsScreen(
                    teacherId: user.id,
                    teacherName: user.name,
                    registeredSubject: user.subject,
                    embedded: true,
                  ),
                ],
              ),
      ),
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab({required this.classSection});

  final String classSection;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        final marks = state.marksOf(classSection);
        final present = state.classOf(classSection)?.presentCount ?? 0;
        return ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      marks != null
                          ? l.classPresentOfTotal(present, marks.length)
                          : l.classNotMarkedYet,
                      style: context.text.titleMedium,
                    ),
                  ),
                  StatusChip(
                    label: marks != null ? l.chipDone : l.chipNotMarked,
                    color: marks != null ? AppColors.present : AppColors.late,
                    background: marks != null
                        ? AppColors.presentLight
                        : AppColors.lateLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => MarkingScreen.open(context, classSection),
              child: Text(marks == null ? l.myClassMark : l.myClassView),
            ),
          ],
        );
      },
    );
  }
}

class _StudentsTab extends StatelessWidget {
  const _StudentsTab({required this.classSection});

  final String classSection;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        final students = state.studentsOf(classSection);
        if (students.isEmpty) {
          return EmptyState(
            icon: Icons.groups_outlined,
            message: context.l10n.tabStudents,
          );
        }
        return ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            for (final s in students)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: InitialsAvatar(s.name, radius: 18),
                title: Text(s.name),
                subtitle: Text('${s.rollNo}'),
              ),
          ],
        );
      },
    );
  }
}
