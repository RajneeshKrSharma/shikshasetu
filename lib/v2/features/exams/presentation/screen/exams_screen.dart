import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/exams.dart';
import '../bloc/exams_bloc.dart';
import '../bloc/question_bank_bloc.dart';
import 'exams_tab.dart';
import 'question_bank_tab.dart';

/// Exams in one place: the schedule, with marks and papers, and the question
/// bank.
class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    final access = ExamsAccess.of(account);
    final l = context.l10n;
    final tabs = <({String title, Widget body})>[
      if (access.canConduct) (title: l.exmTabExams, body: const ExamsTab()),
      if (access.canSeeBank)
        (title: l.exmTabBank, body: const QuestionBankTab()),
    ];
    if (tabs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.exmTitle)),
        body: Center(child: Text(l.srvForbidden)),
      );
    }
    return MultiBlocProvider(
      providers: [
        if (access.canConduct)
          BlocProvider(
            create: (_) =>
                sl<ExamsBloc>(param1: account)..add(const ExamsStarted()),
          ),
        if (access.canSeeBank)
          BlocProvider(
            create: (_) =>
                sl<QuestionBankBloc>(param1: account)
                  ..add(const QuestionBankStarted()),
          ),
      ],
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.exmTitle),
            bottom: tabs.length > 1
                ? TabBar(tabs: [for (final t in tabs) Tab(text: t.title)])
                : null,
          ),
          body: TabBarView(children: [for (final t in tabs) t.body]),
        ),
      ),
    );
  }
}
