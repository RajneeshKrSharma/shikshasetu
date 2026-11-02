import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../domain/entities/teaching.dart';
import '../bloc/allotments_bloc.dart';
import '../widgets/allot_dialog.dart';

/// Which teacher takes which class for which subject.
class AllotmentsTab extends StatelessWidget {
  const AllotmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<AllotmentsBloc, AllotmentsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<AllotmentsBloc, AllotmentsState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canAllot
              ? FloatingActionButton.extended(
                  onPressed: state.busy ? null : () => showAllotDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.tchAllot),
                )
              : null,
          body: AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () =>
                context.read<AllotmentsBloc>().add(const AllotmentsStarted()),
            isEmpty: state.allotments.isEmpty,
            emptyText: l.tchAllotmentsEmpty,
            emptyIcon: Icons.menu_book_outlined,
            builder: (context) => ListView(
              padding: AppSpacing.pageOf(context, fab: state.canAllot),
              children: [
                for (final a in state.allotments)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.tchClassSubject(a.className, a.subject),
                                  style: context.text.titleSmall,
                                ),
                                Text(
                                  a.teacherName,
                                  style: context.text.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (state.canAllot)
                            IconButton(
                              tooltip: l.actionRemove,
                              icon: const Icon(Icons.link_off),
                              onPressed: state.busy
                                  ? null
                                  : () => _remove(context, a),
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

  Future<void> _remove(BuildContext context, Allotment a) async {
    final l = context.l10n;
    final bloc = context.read<AllotmentsBloc>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(l.tchRemoveAllotmentAsk(a.subject, a.className)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.actionRemove),
          ),
        ],
      ),
    );
    if (ok == true) bloc.add(AllotmentRemoved(a.id));
  }
}
