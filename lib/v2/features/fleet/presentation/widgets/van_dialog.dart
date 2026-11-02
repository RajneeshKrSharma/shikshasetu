import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/fleet.dart';
import '../bloc/vans_bloc.dart';

/// Adds a van, or changes (or removes) [existing].
Future<void> showVanDialog(BuildContext context, {Van? existing}) async {
  final bloc = context.read<VansBloc>();
  final drivers = bloc.state.drivers;
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _VanDialog(
      existing: existing,
      drivers: [for (final d in drivers) (id: d.id, name: d.name)],
    ),
  );
  if (result is VanDraft) bloc.add(VanSaved(result));
  if (result is String) bloc.add(VanRemoved(result));
}

class _VanDialog extends StatefulWidget {
  const _VanDialog({required this.drivers, this.existing});

  final Van? existing;
  final List<({String id, String name})> drivers;

  @override
  State<_VanDialog> createState() => _VanDialogState();
}

class _VanDialogState extends State<_VanDialog> {
  late final TextEditingController _name;
  late final ValueNotifier<String?> _driver;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _driver = ValueNotifier(widget.existing?.driverId);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _driver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;
    return AlertDialog(
      title: Text(editing ? l.fltVanEdit : l.fltVanAdd),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                maxLength: 60,
                decoration: InputDecoration(labelText: l.fltVanName),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _driver,
                builder: (context, id, _) => DropdownButtonFormField<String?>(
                  initialValue: id,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.fltDriver),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l.fltNoDriver),
                    ),
                    for (final d in widget.drivers)
                      DropdownMenuItem<String?>(
                        value: d.id,
                        child: Text(d.name),
                      ),
                  ],
                  onChanged: (v) => _driver.value = v,
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
              VanDraft(
                id: widget.existing?.id,
                name: _name.text,
                driverId: _driver.value,
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
