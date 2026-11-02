import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/fee_structure_bloc.dart';
import '../widgets/amount_dialog.dart';
import '../widgets/fee_head_label.dart';

/// The tuition and van fee of each class.
class FeeStructureTab extends StatelessWidget {
  const FeeStructureTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<FeeStructureBloc, FeeStructureState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<FeeStructureBloc, FeeStructureState>(
        builder: (context, state) => AsyncBody(
          status: state.status,
          failure: state.failure,
          onRetry: () =>
              context.read<FeeStructureBloc>().add(const FeeStructureStarted()),
          isEmpty: state.classes.isEmpty,
          emptyText: l.feeNoClasses,
          emptyIcon: Icons.class_outlined,
          builder: (context) => ListView(
            padding: AppSpacing.page,
            children: [
              DropdownButtonFormField<String>(
                initialValue: state.classId,
                isExpanded: true,
                decoration: InputDecoration(labelText: l.fieldClass),
                items: [
                  for (final c in state.classes)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (id) {
                  if (id != null) {
                    context.read<FeeStructureBloc>().add(FeeClassChosen(id));
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              for (final line in state.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    onTap: state.busy
                        ? null
                        : () async {
                            final bloc = context.read<FeeStructureBloc>();
                            final result = await showAmountDialog(
                              context,
                              title: line.head.label(l),
                              initial: line.amount,
                            );
                            if (result != null) {
                              bloc.add(
                                FeeAmountChanged(line.head, result.amount),
                              );
                            }
                          },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            line.head.label(l),
                            style: context.text.titleSmall,
                          ),
                        ),
                        Text(
                          line.amount?.format() ?? l.feeNotSet,
                          style: context.text.bodyMedium,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(Icons.edit_outlined, size: AppIconSize.sm),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
