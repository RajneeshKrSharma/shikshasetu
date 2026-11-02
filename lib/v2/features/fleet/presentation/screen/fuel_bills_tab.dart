import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../domain/entities/fleet.dart';
import '../bloc/fuel_bills_bloc.dart';
import '../widgets/fleet_labels.dart';
import '../widgets/fuel_bill_dialog.dart';

/// Fuel bills: the driver adds theirs; approvers approve or reject.
class FuelBillsTab extends StatelessWidget {
  const FuelBillsTab({super.key, this.vans = const []});

  /// For a manager adding a bill on a driver's behalf: the vans to choose from.
  final List<Van> vans;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<FuelBillsBloc, FuelBillsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<FuelBillsBloc, FuelBillsState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canSubmit
              ? FloatingActionButton.extended(
                  onPressed: state.busy
                      ? null
                      : () => showFuelBillDialog(context, vans: vans),
                  icon: const Icon(Icons.add),
                  label: Text(l.fltBillAdd),
                )
              : null,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    ChoiceChip(
                      label: Text(l.fltAllStatuses),
                      selected: state.filter == null,
                      onSelected: (_) => context.read<FuelBillsBloc>().add(
                        const FuelBillsFiltered(null),
                      ),
                    ),
                    for (final s in BillStatus.values)
                      ChoiceChip(
                        label: Text(s.label(l)),
                        selected: state.filter == s,
                        onSelected: (_) => context.read<FuelBillsBloc>().add(
                          FuelBillsFiltered(s),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () => context.read<FuelBillsBloc>().add(
                    const FuelBillsStarted(),
                  ),
                  isEmpty: state.bills.isEmpty,
                  emptyText: l.fltBillsEmpty,
                  emptyIcon: Icons.local_gas_station_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.pageOf(context, fab: state.canSubmit),
                    children: [
                      for (final b in state.bills)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _BillCard(bill: b, state: state),
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

class _BillCard extends StatelessWidget {
  const _BillCard({required this.bill, required this.state});

  final FuelBill bill;
  final FuelBillsState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<FuelBillsBloc>();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${bill.vanName} · ${bill.fuel.label(l)}',
                  style: context.text.titleSmall,
                ),
              ),
              Text(bill.amount.format(), style: context.text.titleSmall),
            ],
          ),
          Text(
            '${formatShortDate(context, bill.billedOn)} · '
            '${l.fltBillLine(bill.litres, bill.rate.format())}',
            style: context.text.bodySmall,
          ),
          if (bill.distanceKm != null && bill.kmPerLitre != null)
            Text(
              l.fltMileage('${bill.distanceKm}', bill.kmPerLitre!),
              style: context.text.bodySmall,
            ),
          Text(
            l.fltSubmittedBy(bill.submittedByName),
            style: context.text.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(bill.status.label(l), style: context.text.labelLarge),
          if (bill.rejectReason.isNotEmpty)
            Text(
              l.fltRejectedWhy(bill.rejectReason),
              style: context.text.bodySmall,
            ),
          if (bill.isPending)
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (state.canApprove) ...[
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: AppSizes.dialogButton,
                    ),
                    onPressed: state.busy
                        ? null
                        : () => bloc.add(FuelBillApproved(bill.id)),
                    child: Text(l.fltApprove),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: AppSizes.dialogButton,
                    ),
                    onPressed: state.busy ? null : () => _reject(context),
                    child: Text(l.fltReject),
                  ),
                ],
                if (state.canSubmit && !state.canApprove)
                  TextButton(
                    onPressed: state.busy
                        ? null
                        : () => bloc.add(FuelBillWithdrawn(bill.id)),
                    child: Text(l.fltWithdraw),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _reject(BuildContext context) async {
    final l = context.l10n;
    final bloc = context.read<FuelBillsBloc>();
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.fltReject),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 200,
          decoration: InputDecoration(labelText: l.fltRejectReason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l.fltReject),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason != null) bloc.add(FuelBillRejected(bill.id, reason));
  }
}
