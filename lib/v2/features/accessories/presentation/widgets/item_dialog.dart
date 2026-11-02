import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../core/money.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../domain/entities/accessory.dart';
import '../bloc/accessory_items_bloc.dart';
import 'accessory_labels.dart';

/// Adds an item for sale, or changes (or removes) [existing].
Future<void> showItemDialog(
  BuildContext context, {
  required List<SchoolClass> classes,
  AccessoryItem? existing,
}) async {
  final bloc = context.read<AccessoryItemsBloc>();
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _ItemDialog(classes: classes, existing: existing),
  );
  if (result is AccessoryItemDraft) bloc.add(AccessoryItemSaved(result));
  if (result is String) bloc.add(AccessoryItemRemoved(result));
}

class _ItemDialog extends StatefulWidget {
  const _ItemDialog({required this.classes, this.existing});

  final List<SchoolClass> classes;
  final AccessoryItem? existing;

  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final ValueNotifier<AccessoryKind> _kind;
  late final ValueNotifier<String?> _classId;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final i = widget.existing;
    _name = TextEditingController(text: i?.name ?? '');
    _price = TextEditingController(text: i?.price.wire ?? '');
    _kind = ValueNotifier(i?.kind ?? AccessoryKind.dress);
    _classId = ValueNotifier(i?.classId);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _kind.dispose();
    _classId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;
    return AlertDialog(
      title: Text(editing ? l.itemEdit : l.itemAdd),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!editing)
                ValueListenableBuilder<AccessoryKind>(
                  valueListenable: _kind,
                  builder: (context, kind, _) =>
                      DropdownButtonFormField<AccessoryKind>(
                        initialValue: kind,
                        decoration: InputDecoration(labelText: l.itemKind),
                        items: [
                          for (final k in AccessoryKind.values)
                            DropdownMenuItem(value: k, child: Text(k.label(l))),
                        ],
                        onChanged: (v) => _kind.value = v ?? kind,
                      ),
                ),
              TextFormField(
                controller: _name,
                maxLength: 80,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l.itemName),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.itemPrice,
                  prefixText: '₹ ',
                ),
                validator: (v) => Money.tryParse(v ?? '') == null
                    ? l.errorAmountInvalid
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<String?>(
                valueListenable: _classId,
                builder: (context, id, _) => DropdownButtonFormField<String?>(
                  initialValue: id,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.itemClass),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l.itemAllClasses),
                    ),
                    for (final c in widget.classes)
                      DropdownMenuItem<String?>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                  ],
                  onChanged: (v) => _classId.value = v,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (editing)
          TextButton(
            onPressed: () => Navigator.pop(context, widget.existing!.id),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              minimumSize: AppSizes.dialogButton,
            ),
            child: Text(l.actionRemove),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_key.currentState!.validate()) return;
            Navigator.pop(
              context,
              AccessoryItemDraft(
                id: widget.existing?.id,
                kind: _kind.value,
                name: _name.text.trim(),
                price: Money.tryParse(_price.text)!,
                classId: _classId.value,
              ),
            );
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
