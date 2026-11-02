import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/presentation/bloc/members_bloc.dart';
import '../../../members/presentation/screen/members_tab.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/fleet.dart';
import '../bloc/fuel_bills_bloc.dart';
import '../bloc/vans_bloc.dart';
import 'fuel_bills_tab.dart';
import 'vans_tab.dart';

/// Everything about staff in one place: the people, the vans they drive and
/// the fuel bills.
class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  static const _kind = StaffKind();

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    final fleet = FleetAccess.of(account);
    final l = context.l10n;
    final tabs = <({String title, Widget body})>[
      if (_kind.canSee(account))
        (title: l.memStaff, body: const MembersTab(kind: _kind)),
      if (fleet.canAllotVans) (title: l.fltVans, body: const VansTab()),
      if (fleet.canApprove) (title: l.fltFuelBills, body: const FuelBillsTab()),
    ];
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<MembersBloc>(param1: (kind: _kind, account: account))
                ..add(const MembersStarted()),
        ),
        if (fleet.canAllotVans)
          BlocProvider(
            create: (_) =>
                sl<VansBloc>(param1: account)..add(const VansStarted()),
          ),
        if (fleet.canApprove)
          BlocProvider(
            create: (_) =>
                sl<FuelBillsBloc>(param1: account)
                  ..add(const FuelBillsStarted()),
          ),
      ],
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.memStaff),
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
