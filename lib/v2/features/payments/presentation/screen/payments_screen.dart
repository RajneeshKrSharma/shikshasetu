import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/payments.dart';
import 'my_account_tab.dart';
import 'payees_tab.dart';

/// Payments in one place: the money you are owed, and — for the Principal —
/// what the school owes teachers and staff.
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    final access = PaymentsAccess.of(account);
    final l = context.l10n;
    final tabs = <({String title, Widget body})>[
      if (access.canSeeOwn) (title: l.payTabMine, body: const MyAccountTab()),
      for (final g in access.groups)
        (
          title: g == PayeeGroup.teachers ? l.payTabTeachers : l.payTabStaff,
          body: PayeesTab(group: g),
        ),
    ];
    if (tabs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.payTitle)),
        body: Center(child: Text(l.srvForbidden)),
      );
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.payTitle),
          bottom: tabs.length > 1
              ? TabBar(tabs: [for (final t in tabs) Tab(text: t.title)])
              : null,
        ),
        body: TabBarView(children: [for (final t in tabs) t.body]),
      ),
    );
  }
}
