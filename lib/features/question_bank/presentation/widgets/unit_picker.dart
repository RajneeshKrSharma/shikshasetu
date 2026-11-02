import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../domain/entities/bank_unit.dart';

/// Which unit the questions go to, with a way to start a new one. The
/// choice itself is kept by whoever shows this.
class UnitPicker extends StatelessWidget {
  const UnitPicker({
    super.key,
    required this.units,
    required this.unitId,
    required this.onChosen,
    required this.onNewUnit,
    this.error = false,
  });

  final List<BankUnit> units;
  final String? unitId;
  final ValueChanged<String> onChosen;
  final ValueChanged<String> onNewUnit;
  final bool error;

  Future<void> _newUnit(BuildContext context) async {
    final name = await NewUnitDialog.show(context);
    if (name != null) onNewUnit(name);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: units.any((u) => u.id == unitId) ? unitId : null,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l.bankUnitLabel,
              errorText: error ? l.bankPickUnit : null,
            ),
            items: [
              for (final u in units)
                DropdownMenuItem(value: u.id, child: Text(u.name)),
            ],
            onChanged: (v) {
              if (v != null) onChosen(v);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        TextButton(
          onPressed: () => _newUnit(context),
          child: Text(l.bankNewUnit),
        ),
      ],
    );
  }
}

/// Asks for the name of a new unit.
class NewUnitDialog extends StatefulWidget {
  const NewUnitDialog({super.key});

  static Future<String?> show(BuildContext context) => showDialog<String>(
    context: context,
    builder: (_) => const NewUnitDialog(),
  );

  @override
  State<NewUnitDialog> createState() => _NewUnitDialogState();
}

class _NewUnitDialogState extends State<NewUnitDialog> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.bankNewUnitTitle),
      content: TextField(
        controller: _name,
        autofocus: true,
        decoration: InputDecoration(hintText: l.bankNewUnitHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            final v = _name.text.trim();
            if (v.isNotEmpty) Navigator.of(context).pop(v);
          },
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
