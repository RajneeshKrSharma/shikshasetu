import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/attendance.dart';
import '../bloc/my_attendance_bloc.dart';
import '../bloc/people_board_bloc.dart';
import '../bloc/roster_bloc.dart';
import '../bloc/student_report_bloc.dart';
import 'my_attendance_tab.dart';
import 'people_board_tab.dart';
import 'report_tab.dart';
import 'roster_tab.dart';

/// Attendance in one place; each person sees the parts they may use.
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    final access = AttendanceAccess.of(account);
    final l = context.l10n;
    final tabs = <({String title, Widget body})>[
      if (access.canRecordOwn)
        (title: l.attMineTab, body: const MyAttendanceTab()),
      if (access.canViewStudents)
        (title: l.attStudentsTab, body: const RosterTab()),
      if (access.canViewStudents)
        (title: l.attReportTab, body: const ReportTab()),
      if (access.canViewPeople)
        (title: l.attPeopleTab, body: const PeopleBoardTab()),
    ];
    return MultiBlocProvider(
      providers: [
        if (access.canRecordOwn)
          BlocProvider(
            create: (_) =>
                sl<MyAttendanceBloc>()..add(const MyAttendanceStarted()),
          ),
        if (access.canViewStudents) ...[
          BlocProvider(
            create: (_) =>
                sl<RosterBloc>(param1: account)..add(const RosterStarted()),
          ),
          BlocProvider(
            create: (_) =>
                sl<StudentReportBloc>()..add(const StudentReportStarted()),
          ),
        ],
        if (access.canViewPeople)
          BlocProvider(
            create: (_) =>
                sl<PeopleBoardBloc>(param1: account)
                  ..add(const PeopleBoardStarted()),
          ),
      ],
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.navAttendance),
            bottom: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [for (final t in tabs) Tab(text: t.title)],
            ),
          ),
          body: TabBarView(children: [for (final t in tabs) t.body]),
        ),
      ),
    );
  }
}
