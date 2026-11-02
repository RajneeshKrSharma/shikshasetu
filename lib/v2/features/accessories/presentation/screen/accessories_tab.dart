import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../domain/entities/accessory.dart';
import '../bloc/accessory_items_bloc.dart';
import '../widgets/accessory_labels.dart';
import '../widgets/item_dialog.dart';

/// What the school sells: dress and books, with their prices.
class AccessoriesTab extends StatelessWidget {
  const AccessoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<AccessoryItemsBloc, AccessoryItemsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<AccessoryItemsBloc, AccessoryItemsState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: state.busy
                ? null
                : () => showItemDialog(context, classes: state.classes),
            icon: const Icon(Icons.add),
            label: Text(l.itemAdd),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    ChoiceChip(
                      label: Text(l.stuAllClasses),
                      selected: state.kind == null,
                      onSelected: (_) => context.read<AccessoryItemsBloc>().add(
                        const AccessoryKindChosen(null),
                      ),
                    ),
                    for (final k in AccessoryKind.values)
                      ChoiceChip(
                        label: Text(k.label(l)),
                        selected: state.kind == k,
                        onSelected: (_) => context
                            .read<AccessoryItemsBloc>()
                            .add(AccessoryKindChosen(k)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () => context.read<AccessoryItemsBloc>().add(
                    const AccessoryItemsStarted(),
                  ),
                  isEmpty: state.items.isEmpty,
                  emptyText: l.itemsEmpty,
                  emptyIcon: Icons.checkroom_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.pageOf(context, fab: true),
                    children: [
                      for (final item in state.items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            onTap: () => showItemDialog(
                              context,
                              classes: state.classes,
                              existing: item,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: context.text.titleSmall,
                                      ),
                                      Text(
                                        item.kind.label(l),
                                        style: context.text.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.price.format(),
                                  style: context.text.titleSmall,
                                ),
                              ],
                            ),
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
    );
  }
}
