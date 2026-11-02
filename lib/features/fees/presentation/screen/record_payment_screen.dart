import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../proofs/presentation/bloc/proof_cubit.dart';
import '../../../proofs/presentation/widgets/proof_photo_field.dart';
import '../../domain/entities/fee_payment.dart';
import '../bloc/fees_bloc.dart';
import '../bloc/record_payment_bloc.dart';
import '../widgets/fee_labels.dart';

/// Records one payment against one fee: how much, how it was paid, a
/// reference and a photo as proof.
class RecordPaymentScreen extends StatefulWidget {
  const RecordPaymentScreen({super.key, required this.accountId});

  final String accountId;

  static Future<void> open(BuildContext context, String accountId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<RecordPaymentBloc>(param1: accountId),
              ),
              BlocProvider(create: (_) => sl<ProofCubit>(param1: 'fees')),
            ],
            child: RecordPaymentScreen(accountId: accountId),
          ),
        ),
      );

  @override
  State<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends State<RecordPaymentScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _amount;
  late final TextEditingController _reference;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _amount = TextEditingController();
    _reference = TextEditingController();
  }

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RecordPaymentBloc>().add(
      PaymentSubmitted(
        amount: int.parse(_amount.text.trim()),
        reference: _reference.text,
        proofPath: context.read<ProofCubit>().state.photoPath,
      ),
    );
  }

  Future<void> _pickDay(DateTime current) async {
    final bloc = context.read<RecordPaymentBloc>();
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(today.year - 2),
      lastDate: today,
    );
    if (picked != null) bloc.add(PaymentDateChosen(picked));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<RecordPaymentBloc, RecordPaymentState>(
      listenWhen: (a, b) => a.recorded == null && b.recorded != null,
      listener: (context, state) {
        context.read<FeesBloc>().add(const FeesLoaded());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l.messagePaymentSavedReceipt(state.recorded!.receiptNo),
            ),
          ),
        );
        Navigator.of(context).pop();
      },
      child: BlocBuilder<FeesBloc, FeesState>(
        builder: (context, fees) {
          final account = fees.accountById(widget.accountId);
          if (account == null) {
            return Scaffold(
              appBar: AppBar(),
              body: EmptyState(
                icon: Icons.receipt_long_outlined,
                message: l.feeAccountNotFound,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text(l.recordPaymentTitle)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  AppCard(
                    child: Row(
                      children: [
                        InitialsAvatar(account.name, radius: 20),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.name,
                                style: context.text.titleSmall,
                              ),
                              Text(
                                '${account.head.label(l)} · '
                                '${l.feesPending}: '
                                '${formatRupees(context, account.pending)}',
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l.fieldAmount,
                      prefixText: '₹ ',
                    ),
                    validator: (v) {
                      final n = int.tryParse((v ?? '').trim());
                      if (n == null || n <= 0) return l.errorAmountInvalid;
                      if (n > account.pending) return l.errorAmountExceeds;
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(l.fieldHowPaid, style: context.text.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  BlocBuilder<RecordPaymentBloc, RecordPaymentState>(
                    buildWhen: (a, b) => a.mode != b.mode,
                    builder: (context, s) => SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<PaymentMode>(
                        showSelectedIcon: false,
                        segments: [
                          for (final m in PaymentMode.values)
                            ButtonSegment(value: m, label: Text(m.label(l))),
                        ],
                        selected: {s.mode},
                        onSelectionChanged: (v) => context
                            .read<RecordPaymentBloc>()
                            .add(PaymentModeChosen(v.first)),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<RecordPaymentBloc, RecordPaymentState>(
                    buildWhen: (a, b) => a.mode != b.mode,
                    builder: (context, s) => TextFormField(
                      controller: _reference,
                      decoration: InputDecoration(
                        labelText: s.mode.referenceLabel(l),
                      ),
                      validator: (v) =>
                          s.mode.needsReference && (v ?? '').trim().isEmpty
                          ? l.errorReferenceRequired
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<RecordPaymentBloc, RecordPaymentState>(
                    buildWhen: (a, b) => a.day != b.day,
                    builder: (context, s) => PickerField(
                      label: l.fieldPaidOn,
                      prefixIcon: Icons.event,
                      value: formatShortDate(context, s.day),
                      onTap: () => _pickDay(s.day),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<RecordPaymentBloc, RecordPaymentState>(
                    buildWhen: (a, b) => a.mode != b.mode,
                    builder: (context, s) => ProofPhotoField(
                      label: l.fieldProofPhoto,
                      required: s.mode.needsProof,
                    ),
                  ),
                  BlocBuilder<RecordPaymentBloc, RecordPaymentState>(
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
                  BlocBuilder<RecordPaymentBloc, RecordPaymentState>(
                    buildWhen: (a, b) => a.saving != b.saving,
                    builder: (context, s) => FilledButton(
                      onPressed: s.saving ? null : _submit,
                      child: Text(l.actionRecordPayment),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
