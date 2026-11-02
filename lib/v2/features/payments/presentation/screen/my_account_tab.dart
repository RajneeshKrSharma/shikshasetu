import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/async_body.dart';
import '../../../../di/v2_injector.dart';
import '../bloc/my_account_bloc.dart';
import '../widgets/account_view.dart';

/// A teacher's or staff member's own salary, fuel dues and payments.
class MyAccountTab extends StatelessWidget {
  const MyAccountTab({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<MyAccountBloc>()..add(const MyAccountStarted()),
    child: BlocBuilder<MyAccountBloc, MyAccountState>(
      builder: (context, state) => AsyncBody(
        status: state.status,
        failure: state.failure,
        onRetry: () =>
            context.read<MyAccountBloc>().add(const MyAccountStarted()),
        builder: (context) => AccountView(account: state.account!),
      ),
    ),
  );
}
