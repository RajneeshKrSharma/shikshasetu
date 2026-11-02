import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/presentation/bloc/members_bloc.dart';
import '../../../members/presentation/screen/members_tab.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/teaching.dart';
import '../bloc/allotments_bloc.dart';
import '../bloc/lesson_board_bloc.dart';
import 'allotments_tab.dart';
import 'lesson_board_tab.dart';

/// Everything about teachers in one place: the teachers, the classes they
/// take, and whether they have recorded the day's lesson.
class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  static const _kind = TeacherKind();

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    final teaching = TeachingAccess.of(account);
    final l = context.l10n;
    final tabs = <({String title, Widget body})>[
      if (_kind.canSee(account))
        (title: l.memTeachers, body: const MembersTab(kind: _kind)),
      if (_kind.canSee(account))
        (title: l.tchAllotments, body: const AllotmentsTab()),
      if (teaching.canSeeBoard)
        (title: l.tchLessonBoard, body: const LessonBoardTab()),
    ];
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<MembersBloc>(param1: (kind: _kind, account: account))
                ..add(const MembersStarted()),
        ),
        BlocProvider(
          create: (_) =>
              sl<AllotmentsBloc>(param1: account)
                ..add(const AllotmentsStarted()),
        ),
        BlocProvider(
          create: (_) => sl<LessonBoardBloc>()..add(const LessonBoardStarted()),
        ),
      ],
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.memTeachers),
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
