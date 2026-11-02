import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/vans_bloc.dart';
import '../widgets/van_dialog.dart';

/// The school's vans and who drives each.
class VansTab extends StatelessWidget {
  const VansTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<VansBloc, VansState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<VansBloc, VansState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canAllot
              ? FloatingActionButton.extended(
                  onPressed: state.busy ? null : () => showVanDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.fltVanAdd),
                )
              : null,
          body: AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () => context.read<VansBloc>().add(const VansStarted()),
            isEmpty: state.vans.isEmpty,
            emptyText: l.fltVansEmpty,
            emptyIcon: Icons.directions_bus_outlined,
            builder: (context) => ListView(
              padding: AppSpacing.pageOf(context, fab: state.canAllot),
              children: [
                for (final v in state.vans)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: state.canAllot
                          ? () => showVanDialog(context, existing: v)
                          : null,
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_bus_outlined,
                            color: context.brand.primary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(v.name, style: context.text.titleSmall),
                                Text(
                                  v.driverName.isEmpty
                                      ? l.fltNoDriver
                                      : v.driverName,
                                  style: context.text.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
