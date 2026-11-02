import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../di/injector.dart';
import '../../../proofs/presentation/bloc/proof_cubit.dart';
import '../../../proofs/presentation/widgets/proof_photo_field.dart';
import '../../domain/entities/staff_bill.dart';
import '../bloc/add_bill_bloc.dart';
import '../widgets/bill_labels.dart';

/// Sends one fuel bill for the Principal's approval: petrol or diesel, the
/// date, litres, amount and a photo of the bill.
class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  static Future<void> open(BuildContext context, String staffId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<AddBillBloc>(param1: staffId)),
              BlocProvider(create: (_) => sl<ProofCubit>(param1: 'bills')),
            ],
            child: const AddBillScreen(),
          ),
        ),
      );

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  late final TextEditingController _litres;
  late final TextEditingController _amount;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _litres = TextEditingController();
    _amount = TextEditingController();
    _note = TextEditingController();
  }

  @override
  void dispose() {
    _litres.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  void _submit() => context.read<AddBillBloc>().add(
    BillSubmitted(
      amount: int.tryParse(_amount.text.trim()) ?? 0,
      litres: double.tryParse(_litres.text.trim()),
      note: _note.text,
      photoPath: context.read<ProofCubit>().state.photoPath,
    ),
  );

  Future<void> _pickDay(DateTime current) async {
    final bloc = context.read<AddBillBloc>();
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(today.year - 1),
      lastDate: today,
    );
    if (picked != null) bloc.add(BillDateChosen(picked));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<AddBillBloc, AddBillState>(
      listenWhen: (a, b) => a.saved == null && b.saved != null,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.billSent)));
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.addBillTitle)),
        body: ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            BlocBuilder<AddBillBloc, AddBillState>(
              buildWhen: (a, b) => a.kind != b.kind,
              builder: (context, s) => SizedBox(
                width: double.infinity,
                child: SegmentedButton<FuelKind>(
                  showSelectedIcon: false,
                  segments: [
                    for (final k in FuelKind.values)
                      ButtonSegment(value: k, label: Text(k.label(l))),
                  ],
                  selected: {s.kind},
                  onSelectionChanged: (v) =>
                      context.read<AddBillBloc>().add(FuelKindChosen(v.first)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<AddBillBloc, AddBillState>(
              buildWhen: (a, b) => a.day != b.day,
              builder: (context, s) => PickerField(
                label: l.fieldBillDate,
                prefixIcon: Icons.event,
                value: formatShortDate(context, s.day),
                onTap: () => _pickDay(s.day),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _litres,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(labelText: l.fieldLitres),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l.fieldBillAmount,
                      prefixText: '₹ ',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ProofPhotoField(label: l.fieldBillPhoto, required: true),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.fieldBillNote),
            ),
            BlocBuilder<AddBillBloc, AddBillState>(
              buildWhen: (a, b) => a.problem != b.problem,
              builder: (context, s) => s.problem == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        s.problem!.message(l),
                        style: context.text.bodySmall!.copyWith(
                          color: AppColors.absent,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.xl),
            BlocBuilder<AddBillBloc, AddBillState>(
              buildWhen: (a, b) => a.saving != b.saving,
              builder: (context, s) => FilledButton(
                onPressed: s.saving ? null : _submit,
                child: Text(l.billSendForApproval),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
