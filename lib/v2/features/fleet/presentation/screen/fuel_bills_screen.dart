import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../bloc/fuel_bills_bloc.dart';
import 'fuel_bills_tab.dart';

/// The driver's own area: fuel bills for the van.
class FuelBillsScreen extends StatelessWidget {
  const FuelBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<FuelBillsBloc>(param1: account)..add(const FuelBillsStarted()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.fltFuelBills)),
        body: const FuelBillsTab(),
      ),
    );
  }
}
