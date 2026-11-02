import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../di/injector.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../fees/domain/entities/fee_payment.dart';
import '../../../fees/presentation/widgets/fee_labels.dart';
import '../../../proofs/presentation/bloc/proof_cubit.dart';
import '../../../proofs/presentation/widgets/proof_photo_field.dart';
import '../../../proofs/presentation/widgets/signature_pad.dart';
import '../bloc/settle_bloc.dart';
import '../widgets/bill_labels.dart';

/// Pays approved bills: how it was paid, a reference, and the proof (a
/// screenshot, or the receiver's signature for cash). A voucher is kept.
class SettleScreen extends StatefulWidget {
  const SettleScreen({super.key, required this.args});

  final SettleArgs args;

  static Future<void> open(BuildContext context, SettleArgs args) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<SettleBloc>(param1: args)),
              BlocProvider(create: (_) => sl<ProofCubit>(param1: 'payments')),
            ],
            child: SettleScreen(args: args),
          ),
        ),
      );

  @override
  State<SettleScreen> createState() => _SettleScreenState();
}

class _SettleScreenState extends State<SettleScreen> {
  late final TextEditingController _reference;

  @override
  void initState() {
    super.initState();
    _reference = TextEditingController();
  }

  @override
  void dispose() {
    _reference.dispose();
    super.dispose();
  }

  void _confirm() {
    final proof = context.read<ProofCubit>().state;
    final mode = context.read<SettleBloc>().state.mode;
    context.read<SettleBloc>().add(
      SettleConfirmed(
        paidBy: context.read<AuthBloc>().state.user?.name ?? '',
        reference: _reference.text,
        // Cash is proved by the receiver's signature, the rest by a photo.
        proofPath: mode == PaymentMode.cash
            ? proof.signaturePath
            : proof.photoPath,
      ),
    );
  }

  Future<void> _pickDay(DateTime current) async {
    final bloc = context.read<SettleBloc>();
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(today.year - 1),
      lastDate: today,
    );
    if (picked != null) bloc.add(SettleDateChosen(picked));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = widget.args;
    final me = context.select((AuthBloc b) => b.state.user?.name ?? '');
    return BlocListener<SettleBloc, SettleState>(
      listenWhen: (x, y) => x.settled == null && y.settled != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.settleSaved(state.settled!.voucherNo))),
        );
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.settleTitle)),
        body: ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            Container(
              width: double.infinity,
              padding: AppSpacing.card,
              decoration: BoxDecoration(
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      a.staffName,
                      if (a.vehicleNumber != null) a.vehicleNumber!,
                    ].join(' · '),
                    style: context.text.titleSmall,
                  ),
                  Text(
                    l.settlementBills(a.bills.length),
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            InputDecorator(
              decoration: InputDecoration(labelText: l.settleAmountPaid),
              child: Text(
                formatRupees(context, a.total),
                style: context.text.bodyLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l.fieldHowPaid, style: context.text.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<SettleBloc, SettleState>(
              buildWhen: (x, y) => x.mode != y.mode,
              builder: (context, s) => SizedBox(
                width: double.infinity,
                child: SegmentedButton<PaymentMode>(
                  showSelectedIcon: false,
                  segments: [
                    for (final m in PaymentMode.values)
                      ButtonSegment(value: m, label: Text(m.label(l))),
                  ],
                  selected: {s.mode},
                  onSelectionChanged: (v) =>
                      context.read<SettleBloc>().add(SettleModeChosen(v.first)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<SettleBloc, SettleState>(
              buildWhen: (x, y) => x.mode != y.mode,
              builder: (context, s) => TextField(
                controller: _reference,
                decoration: InputDecoration(
                  labelText: s.mode.referenceLabel(l),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<SettleBloc, SettleState>(
              buildWhen: (x, y) => x.day != y.day,
              builder: (context, s) => PickerField(
                label: l.fieldPaidOn,
                prefixIcon: Icons.event,
                value: formatShortDate(context, s.day),
                onTap: () => _pickDay(s.day),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l.settleProof, style: context.text.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<SettleBloc, SettleState>(
              buildWhen: (x, y) => x.mode != y.mode,
              builder: (context, s) => s.mode == PaymentMode.cash
                  ? SignaturePad(label: l.accSignTitle)
                  : ProofPhotoField(label: l.fieldProofPhoto, required: true),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.settlePaidBy(me), style: context.text.bodySmall),
            BlocBuilder<SettleBloc, SettleState>(
              buildWhen: (x, y) =>
                  x.paymentProblem != y.paymentProblem ||
                  x.settleProblem != y.settleProblem,
              builder: (context, s) {
                final text =
                    s.paymentProblem?.message(l) ?? s.settleProblem?.message(l);
                return text == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          text,
                          style: context.text.bodySmall!.copyWith(
                            color: AppColors.absent,
                          ),
                        ),
                      );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            BlocBuilder<SettleBloc, SettleState>(
              buildWhen: (x, y) => x.saving != y.saving,
              builder: (context, s) => FilledButton(
                onPressed: s.saving ? null : _confirm,
                child: Text(l.settleConfirm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
