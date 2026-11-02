import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../../../permissions/presentation/widgets/permissions_section.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/member.dart';
import '../bloc/members_bloc.dart';
import 'members_tab.dart';

/// The Principal's Vice Principals: appoint, remove, and choose what each may do.
class VicePrincipalsScreen extends StatelessWidget {
  const VicePrincipalsScreen({super.key});

  static const _kind = VicePrincipalKind();

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<MembersBloc>(param1: (kind: _kind, account: account))
            ..add(const MembersStarted()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.memVicePrincipals)),
        body: MembersTab(
          kind: _kind,
          detailExtra: (context, member) =>
              PermissionsSection(userId: member.id),
        ),
      ),
    );
  }
}
