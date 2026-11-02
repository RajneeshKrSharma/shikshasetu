import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/classes_bloc.dart';
import '../widgets/class_dialog.dart';

/// Every class of the school; those who manage classes can add and change.
class ClassesTab extends StatelessWidget {
  const ClassesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<ClassesBloc, ClassesState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<ClassesBloc, ClassesState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canManage
              ? FloatingActionButton.extended(
                  onPressed: state.busy ? null : () => showClassDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.actionAddClass),
                )
              : null,
          body: AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () =>
                context.read<ClassesBloc>().add(const ClassesStarted()),
            isEmpty: state.classes.isEmpty,
            emptyText: l.stuClassesEmpty,
            emptyIcon: Icons.class_outlined,
            builder: (context) => ListView(
              padding: AppSpacing.pageOf(context, fab: state.canManage),
              children: [
                for (final c in state.classes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: state.canManage
                          ? () => showClassDialog(context, existing: c)
                          : null,
                      child: Row(
                        children: [
                          Icon(
                            Icons.class_outlined,
                            color: context.brand.primary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(c.name, style: context.text.titleSmall),
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
