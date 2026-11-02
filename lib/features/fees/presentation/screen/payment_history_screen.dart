import '../../../../l10n/class_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/date_range_chips.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment_record.dart';
import '../bloc/payment_history_cubit.dart';
import '../widgets/fee_labels.dart';
import 'fee_ledger_screen.dart';

/// Every payment recorded, newest first, with filters. With a [personId] (and
/// [personName]) it is that one person's history, e.g. a teacher's.
class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key, this.personId, this.personName});

  final String? personId;
  final String? personName;

  static Future<void> open(
    BuildContext context, {
    String? personId,
    String? personName,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          PaymentHistoryScreen(personId: personId, personName: personName),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<PaymentHistoryCubit>(param1: personId)..load(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            personName == null ? l.modulePayments : l.paymentsOf(personName!),
          ),
        ),
        body: _HistoryBody(showGroups: personId == null),
      ),
    );
  }
}

class _HistoryBody extends StatelessWidget {
  const _HistoryBody({required this.showGroups});

  final bool showGroups;

  String _groupLabel(FeeGroup g, BuildContext context) {
    final l = context.l10n;
    return switch (g) {
      FeeGroup.student => l.tabStudents,
      FeeGroup.teacher => l.tabTeachers,
      FeeGroup.other => l.tabOthers,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaymentHistoryCubit>();
    return BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
      builder: (context, s) {
        if (s.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final visible = s.visible;
        return ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            TextField(
              onChanged: cubit.search,
              decoration: InputDecoration(
                hintText: l.searchByName,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            if (showGroups) ...[
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final g in FeeGroup.values)
                    FilterChip(
                      label: Text(_groupLabel(g, context)),
                      selected: s.groups.contains(g),
                      onSelected: (_) => cubit.toggleGroup(g),
                    ),
                ],
              ),
            ],
            if (s.classOptions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final c in s.classOptions)
                    FilterChip(
                      label: Text(l.classLabel(c)),
                      selected: s.classes.contains(c),
                      onSelected: (_) => cubit.toggleClass(c),
                    ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            SectionTitle(
              l.paymentsFilterDate,
              trailing: s.activeCount == 0 && s.query.isEmpty
                  ? null
                  : TextButton(
                      onPressed: cubit.clear,
                      child: Text(l.feesClearAll),
                    ),
            ),
            DateRangeChips(value: s.range, onChanged: cubit.setRange),
            const SizedBox(height: AppSpacing.lg),
            if (visible.isEmpty)
              EmptyState(
                icon: Icons.receipt_long_outlined,
                message: l.paymentsNone,
              )
            else ...[
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  l.paymentsSummary(
                    visible.length,
                    formatRupees(context, s.visibleTotal),
                  ),
                  style: context.text.labelMedium,
                ),
              ),
              for (final r in visible) ...[
                _PaymentRow(
                  record: r,
                  onTap: r.personId == null
                      ? null
                      : () async {
                          await FeeLedgerScreen.open(context, r.personId!);
                          // A payment may have been added there.
                          await cubit.load();
                        },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.record, required this.onTap});

  final FeePaymentRecord record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final detail = record.classSection != null
        ? l.classLabel(record.classSection!)
        : record.subtitle;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Row(
        children: [
          InitialsAvatar(record.personName, radius: 20),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.personName, style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(detail, style: context.text.bodySmall),
                Text(
                  '${record.payment.receiptNo} · '
                  '${formatShortDate(context, record.payment.paidAt)} · '
                  '${record.payment.mode.label(l)} · '
                  '${record.payment.hasProof ? l.paymentProofYes : l.paymentProofNo}',
                  style: context.text.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            formatRupees(context, record.payment.amount),
            style: context.text.titleMedium!.copyWith(color: AppColors.present),
          ),
        ],
      ),
    );
  }
}
