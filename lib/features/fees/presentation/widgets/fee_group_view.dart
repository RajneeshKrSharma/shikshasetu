import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/fee_account.dart';
import '../bloc/fee_filter_cubit.dart';
import '../bloc/fees_bloc.dart';
import '../screen/fee_ledger_screen.dart';
import 'fee_ledger_row.dart';
import 'fee_filter_sheet.dart';
import 'fee_status_style.dart';
import 'fee_summary_card.dart';

/// One tab of the Fees screen: summary, search, filters and the accounts.
/// Expects a [FeeFilterCubit] above it.
class FeeGroupView extends StatelessWidget {
  const FeeGroupView({super.key, required this.group});

  final FeeGroup group;

  /// Classes that have a fee, in natural order (5-A before 10-A).
  List<String> _classesOf(List<FeeAccount> accounts) {
    final names = {
      for (final a in accounts)
        if (a.classSection != null) a.classSection!,
    }.toList();
    int number(String s) =>
        int.tryParse(RegExp(r'\d+').firstMatch(s)?.group(0) ?? '') ?? 0;
    return names..sort((a, b) {
      final byNumber = number(a).compareTo(number(b));
      return byNumber != 0 ? byNumber : a.compareTo(b);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<FeeFilterCubit>();
    return ListView(
      padding: AppSpacing.pageOf(context, fab: true),
      children: [
        FeeSummaryCard(group: group),
        const SizedBox(height: AppSpacing.lg),
        BlocBuilder<FeeFilterCubit, FeeFilterState>(
          buildWhen: (a, b) => a.activeCount != b.activeCount,
          builder: (context, filter) => Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: cubit.search,
                  decoration: InputDecoration(
                    hintText: l.searchByName,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Badge(
                isLabelVisible: filter.activeCount > 0,
                label: Text('${filter.activeCount}'),
                child: IconButton.filledTonal(
                  tooltip: l.feesFilters,
                  icon: const Icon(Icons.tune),
                  onPressed: () => FeeFilterSheet.show(
                    context,
                    group == FeeGroup.student
                        ? _classesOf(
                            context.read<FeesBloc>().state.accountsOf(group),
                          )
                        : const [],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        BlocBuilder<FeeFilterCubit, FeeFilterState>(
          buildWhen: (a, b) => a.statuses != b.statuses,
          builder: (context, f) => SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ChoiceChip(
                  label: Text(l.filterAll),
                  selected: f.statuses.isEmpty,
                  onSelected: (_) => cubit.chooseStatus(null),
                ),
                for (final s in const [
                  FeeStatus.paid,
                  FeeStatus.partial,
                  FeeStatus.due,
                  FeeStatus.overdue,
                ]) ...[
                  const SizedBox(width: AppSpacing.sm),
                  ChoiceChip(
                    label: Text(s.label(l)),
                    selected: f.statuses.length == 1 && f.statuses.contains(s),
                    onSelected: (_) => cubit.chooseStatus(s),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (group == FeeGroup.student)
          BlocBuilder<FeeFilterCubit, FeeFilterState>(
            buildWhen: (a, b) => a.classes != b.classes,
            builder: (context, f) {
              final classes = _classesOf(
                context.read<FeesBloc>().state.accountsOf(group),
              );
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final c in classes) ...[
                        ChoiceChip(
                          label: Text(c),
                          selected:
                              f.classes.length == 1 && f.classes.contains(c),
                          onSelected: (_) => cubit.chooseClass(
                            f.classes.contains(c) ? null : c,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: AppSpacing.md),
        BlocBuilder<FeesBloc, FeesState>(
          builder: (context, fees) =>
              BlocBuilder<FeeFilterCubit, FeeFilterState>(
                builder: (context, filter) {
                  final ledgers = filter.applyToLedgers(
                    fees.ledgersOf(group),
                    DateTime.now(),
                  );
                  if (ledgers.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off,
                      message: l.emptyNoResults,
                    );
                  }
                  final pending = ledgers.fold(0, (s, a) => s + a.pending);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Text(
                          l.feesResultSummary(
                            ledgers.length,
                            formatRupees(context, pending),
                          ),
                          style: context.text.labelMedium,
                        ),
                      ),
                      for (final ledger in ledgers) ...[
                        FeeLedgerRow(
                          ledger: ledger,
                          onTap: () =>
                              FeeLedgerScreen.open(context, ledger.personId),
                        ),
                      ],
                    ],
                  );
                },
              ),
        ),
      ],
    );
  }
}
