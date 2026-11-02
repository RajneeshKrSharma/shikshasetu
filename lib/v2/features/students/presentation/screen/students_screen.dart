import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../../../accessories/presentation/bloc/accessory_items_bloc.dart';
import '../../../accessories/presentation/screen/accessories_tab.dart';
import '../../../fees/presentation/bloc/fee_accounts_bloc.dart';
import '../../../fees/presentation/bloc/fee_structure_bloc.dart';
import '../../../fees/presentation/screen/fee_structure_tab.dart';
import '../../../fees/presentation/screen/fees_tab.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/students_access.dart';
import '../bloc/classes_bloc.dart';
import '../bloc/students_bloc.dart';
import 'classes_tab.dart';
import 'students_tab.dart';

/// Everything about students in one place: the students and their classes,
/// and, for those who may, fees and dress and books.
class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    final access = StudentsAccess.of(account);
    final l = context.l10n;
    final tabs = <({String title, Widget body})>[
      if (access.canSeeStudents) ...[
        (title: l.stuTabStudents, body: const StudentsTab()),
        (title: l.stuTabClasses, body: const ClassesTab()),
      ],
      if (access.canSeeFees) ...[
        (title: l.feeTab, body: const FeesTab()),
        (title: l.feeSetupTab, body: const FeeStructureTab()),
      ],
      if (access.canSeeAccessories)
        (title: l.itemsTab, body: const AccessoriesTab()),
    ];
    return MultiBlocProvider(
      providers: [
        if (access.canSeeStudents) ...[
          BlocProvider(
            create: (_) =>
                sl<StudentsBloc>(param1: account)..add(const StudentsStarted()),
          ),
          BlocProvider(
            create: (_) =>
                sl<ClassesBloc>(param1: account)..add(const ClassesStarted()),
          ),
        ],
        if (access.canSeeFees) ...[
          BlocProvider(
            create: (_) =>
                sl<FeeAccountsBloc>()..add(const FeeAccountsStarted()),
          ),
          BlocProvider(
            create: (_) =>
                sl<FeeStructureBloc>()..add(const FeeStructureStarted()),
          ),
        ],
        if (access.canSeeAccessories)
          BlocProvider(
            create: (_) =>
                sl<AccessoryItemsBloc>()..add(const AccessoryItemsStarted()),
          ),
      ],
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.stuTitle),
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
