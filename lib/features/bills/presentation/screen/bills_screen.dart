import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../proofs/presentation/widgets/proof_viewer.dart';
import '../../domain/entities/staff_bill.dart';
import '../bloc/bills_bloc.dart';
import '../widgets/bill_row.dart';
import '../widgets/staff_choice_sheet.dart';
import '../widgets/school_note.dart';
import 'add_bill_screen.dart';

/// The fuel bills of one staff member, or of everyone. Each is waiting for
/// approval, approved, turned down or paid.
class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key, this.staffId});

  final String? staffId;

  static Future<void> open(BuildContext context, {String? staffId}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<BillsBloc>(param1: staffId)..add(const BillsStarted()),
            child: BillsScreen(staffId: staffId),
          ),
        ),
      );

  Future<void> _add(BuildContext context) async {
    final bloc = context.read<BillsBloc>();
    final who = staffId ?? await StaffChoiceSheet.show(context);
    if (who == null || !context.mounted) return;
    await AddBillScreen.open(context, who);
    bloc.add(const BillsStarted());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.billsTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppSizes.buttonCompact),
              ),
              onPressed: () => _add(context),
              child: Text(l.billsAdd),
            ),
          ),
        ],
      ),
      body: BlocBuilder<BillsBloc, BillsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final bloc = context.read<BillsBloc>();
          const tabs = <BillPhase?>[
            null,
            BillPhase.pending,
            BillPhase.approved,
            BillPhase.paid,
          ];
          String name(BillPhase? p) => switch (p) {
            null => l.billsTabAll,
            BillPhase.pending => l.billsTabPending,
            BillPhase.approved => l.billsTabApproved,
            BillPhase.paid => l.billsTabPaid,
            BillPhase.rejected => l.billPhaseRejected,
          };
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<BillPhase?>(
                    showSelectedIcon: false,
                    segments: [
                      for (final t in tabs)
                        ButtonSegment(
                          value: t,
                          label: Text('${name(t)} ${state.countOf(t)}'),
                        ),
                    ],
                    selected: {state.tab},
                    onSelectionChanged: (v) =>
                        bloc.add(BillsTabChosen(v.first)),
                  ),
                ),
              ),
              Expanded(
                child: state.visible.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        message: l.billsEmpty,
                      )
                    : ListView(
                        padding: AppSpacing.pageOf(context),
                        children: [
                          for (final b in state.visible)
                            BillRow(
                              bill: b,
                              showStaff: staffId == null,
                              onTap: b.photoPath == null
                                  ? null
                                  : () =>
                                        ProofViewer.show(context, b.photoPath!),
                            ),
                        ],
                      ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md + MediaQuery.paddingOf(context).bottom,
                ),
                child: SchoolNote(l.billsRule),
              ),
            ],
          );
        },
      ),
    );
  }
}
