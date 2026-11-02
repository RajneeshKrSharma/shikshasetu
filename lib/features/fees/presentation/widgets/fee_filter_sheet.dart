import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/date_range_chips.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/fee_account.dart';
import '../bloc/fee_filter_cubit.dart';
import 'fee_status_style.dart';

/// Every filter and the sort order of one fees tab, applied as they change.
/// [classes] are the classes to offer (students only).
class FeeFilterSheet extends StatelessWidget {
  const FeeFilterSheet({super.key, required this.classes});

  final List<String> classes;

  static Future<void> show(BuildContext context, List<String> classes) {
    final cubit = context.read<FeeFilterCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: FeeFilterSheet(classes: classes),
      ),
    );
  }

  String _sortLabel(FeeSort s, BuildContext context) {
    final l = context.l10n;
    return switch (s) {
      FeeSort.urgency => l.feesSortUrgency,
      FeeSort.name => l.feesSortName,
      FeeSort.pending => l.feesSortPending,
      FeeSort.dueDate => l.feesSortDue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<FeeFilterCubit>();
    return SafeArea(
      child: BlocBuilder<FeeFilterCubit, FeeFilterState>(
        builder: (context, f) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(l.feesFilterStatus),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final s in FeeStatus.values)
                    FilterChip(
                      label: Text(s.label(l)),
                      selected: f.statuses.contains(s),
                      onSelected: (_) => cubit.toggleStatus(s),
                    ),
                ],
              ),
              if (classes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                SectionTitle(l.feesFilterClass),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    for (final c in classes)
                      FilterChip(
                        label: Text(c),
                        selected: f.classes.contains(c),
                        onSelected: (_) => cubit.toggleClass(c),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SectionTitle(l.feesFilterDueDate),
              DateRangeChips(value: f.dueRange, onChanged: cubit.setDueRange),
              const SizedBox(height: AppSpacing.lg),
              SectionTitle(l.feesFilterSort),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final s in FeeSort.values)
                    ChoiceChip(
                      label: Text(_sortLabel(s, context)),
                      selected: f.sort == s,
                      onSelected: (_) => cubit.setSort(s),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: f.isFiltering ? cubit.clear : null,
                      child: Text(l.feesClearAll),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l.feesShowResults),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
