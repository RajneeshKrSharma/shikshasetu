import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../core/money.dart';
import '../../domain/entities/fleet.dart';
import '../bloc/fuel_bills_bloc.dart';
import 'fleet_labels.dart';

/// Adds a fuel bill. The van is the driver's own unless [vans] is given (a
/// manager choosing one).
Future<void> showFuelBillDialog(
  BuildContext context, {
  List<Van> vans = const [],
}) async {
  final bloc = context.read<FuelBillsBloc>();
  final draft = await showDialog<FuelBillDraft>(
    context: context,
    builder: (_) => _FuelBillDialog(vans: vans),
  );
  if (draft != null) bloc.add(FuelBillSubmitted(draft));
}

class _FuelBillDialog extends StatefulWidget {
  const _FuelBillDialog({required this.vans});

  final List<Van> vans;

  @override
  State<_FuelBillDialog> createState() => _FuelBillDialogState();
}

class _FuelBillDialogState extends State<_FuelBillDialog> {
  late final TextEditingController _litres;
  late final TextEditingController _rate;
  late final TextEditingController _odometer;
  late final ValueNotifier<FuelType> _fuel;
  late final ValueNotifier<DateTime> _day;
  late final ValueNotifier<String?> _van;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _litres = TextEditingController();
    _rate = TextEditingController();
    _odometer = TextEditingController();
    _fuel = ValueNotifier(FuelType.diesel);
    _day = ValueNotifier(DateTime(now.year, now.month, now.day));
    _van = ValueNotifier(null);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _litres.dispose();
    _rate.dispose();
    _odometer.dispose();
    _fuel.dispose();
    _day.dispose();
    _van.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? number(String? v) =>
        double.tryParse(v ?? '') == null ? l.errorAmountInvalid : null;
    return AlertDialog(
      title: Text(l.fltBillAdd),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.vans.isNotEmpty)
                ValueListenableBuilder<String?>(
                  valueListenable: _van,
                  builder: (context, id, _) => DropdownButtonFormField<String>(
                    initialValue: id,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.fltVan),
                    items: [
                      for (final v in widget.vans)
                        DropdownMenuItem(value: v.id, child: Text(v.name)),
                    ],
                    onChanged: (v) => _van.value = v,
                    validator: (v) => v == null ? l.errorRequired : null,
                  ),
                ),
              ValueListenableBuilder<FuelType>(
                valueListenable: _fuel,
                builder: (context, fuel, _) =>
                    DropdownButtonFormField<FuelType>(
                      initialValue: fuel,
                      decoration: InputDecoration(labelText: l.fltFuelType),
                      items: [
                        for (final f in FuelType.values)
                          DropdownMenuItem(value: f, child: Text(f.label(l))),
                      ],
                      onChanged: (v) => _fuel.value = v ?? fuel,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<DateTime>(
                valueListenable: _day,
                builder: (context, day, _) => PickerField(
                  label: l.fltBilledOn,
                  value: formatShortDate(context, day),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: day,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) _day.value = picked;
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _litres,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: l.fltLitres),
                validator: number,
              ),
              TextFormField(
                controller: _rate,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.fltRate,
                  prefixText: '₹ ',
                ),
                validator: (v) => Money.tryParse(v ?? '') == null
                    ? l.errorAmountInvalid
                    : null,
              ),
              TextFormField(
                controller: _odometer,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.fltOdometer),
                validator: (v) =>
                    int.tryParse(v ?? '') == null ? l.errorAmountInvalid : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
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
              FuelBillDraft(
                vanId: _van.value,
                billedOn: _day.value,
                fuel: _fuel.value,
                litres: double.parse(_litres.text).toStringAsFixed(2),
                rate: Money.tryParse(_rate.text)!,
                odometerKm: int.parse(_odometer.text),
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
