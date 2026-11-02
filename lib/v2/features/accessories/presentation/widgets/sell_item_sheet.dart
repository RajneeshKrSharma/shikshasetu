import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../bloc/sell_item_bloc.dart';
import 'accessory_labels.dart';

/// Lets the person choose what to sell to the student; true when something
/// was sold.
Future<bool?> showSellItemSheet(
  BuildContext context, {
  required String studentId,
  required String classId,
}) => showModalBottomSheet<bool>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => BlocProvider(
    create: (_) =>
        sl<SellItemBloc>(param1: studentId, param2: classId)
          ..add(const SellItemStarted()),
    child: const _Sheet(),
  ),
);

class _Sheet extends StatefulWidget {
  const _Sheet();

  @override
  State<_Sheet> createState() => _SheetState();
}

class _SheetState extends State<_Sheet> {
  late final ValueNotifier<int> _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = ValueNotifier(1);
  }

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<SellItemBloc, SellItemState>(
      failureOf: (s) => s.failure,
      child: BlocConsumer<SellItemBloc, SellItemState>(
        listenWhen: (a, b) => b.sold,
        listener: (context, _) => Navigator.of(context).pop(true),
        builder: (context, state) => SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _quantity,
                    builder: (context, q, _) => Row(
                      children: [
                        Expanded(child: Text(l.itemQuantity)),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: q > 1
                              ? () => _quantity.value = q - 1
                              : null,
                        ),
                        Text('$q', style: context.text.titleMedium),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _quantity.value = q + 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: AsyncBody(
                    status: state.status,
                    failure: state.failure,
                    isEmpty: state.items.isEmpty,
                    emptyText: l.itemsForSale,
                    emptyIcon: Icons.shopping_bag_outlined,
                    builder: (context) => ListView(
                      shrinkWrap: true,
                      children: [
                        for (final item in state.items)
                          ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                              '${item.kind.label(l)} · ${item.price.format()}',
                            ),
                            trailing: FilledButton(
                              style: FilledButton.styleFrom(
                                minimumSize: AppSizes.dialogButton,
                              ),
                              onPressed: state.busy
                                  ? null
                                  : () => context.read<SellItemBloc>().add(
                                      SellItemSubmitted(
                                        item.id,
                                        _quantity.value,
                                      ),
                                    ),
                              child: Text(l.itemSellAction),
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
