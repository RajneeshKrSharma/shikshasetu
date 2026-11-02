import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/sync_l10n.dart';
import '../../domain/entities/table_diff.dart';
import '../bloc/data_monitor_cubit.dart';
import 'source_labels.dart';

/// One table, row by row, with the values each place holds. A row that
/// differs shows the values of both places side by side, with the columns
/// that differ marked.
class TableDiffScreen extends StatelessWidget {
  const TableDiffScreen({super.key, required this.table});

  final String table;

  /// With [backupJson] the table is compared with that backup file instead of
  /// with the cloud or the data file.
  static Future<void> open(
    BuildContext context,
    String table, {
    String? backupJson,
  }) {
    final cubit = context.read<DataMonitorCubit>();
    // Started here, so the screen opens already reading.
    backupJson == null
        ? cubit.openTable(table)
        : cubit.openBackupTable(backupJson, table);
    return Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: TableDiffScreen(table: table),
            ),
          ),
        )
        .then((_) => cubit.closeTable());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<DataMonitorCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(syncTableLabel(l, table))),
      body: BlocBuilder<DataMonitorCubit, DataMonitorState>(
        builder: (context, s) {
          if (s.diffLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.diffFailed) {
            return Center(child: Text(l.monProblemOther));
          }
          final d = s.diff;
          if (d == null) return const SizedBox();
          final differing = d.onlyLeft + d.onlyRight + d.changed;
          final shown = [
            for (final e in d.entries)
              if (s.showAll || e.status != RowStatus.same) e,
          ];
          return Column(
            children: [
              // The totals and the filter stay in place; only the rows scroll.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${d.left.label(l)}  ↔  ${d.right.label(l)}',
                      style: context.text.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.monCountsLine(
                        d.same,
                        d.left.label(l),
                        d.onlyLeft,
                        d.right.label(l),
                        d.onlyRight,
                        d.changed,
                      ),
                      style: context.text.bodySmall,
                    ),
                    if (d.matches) ...[
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.present,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(l.monMatches, style: context.text.titleSmall),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.md,
                      children: [
                        ChoiceChip(
                          label: Text(l.monShowDifferences(differing)),
                          selected: !s.showAll,
                          onSelected: (_) => cubit.showAllRows(false),
                        ),
                        ChoiceChip(
                          label: Text(l.monShowAll(d.total)),
                          selected: s.showAll,
                          onSelected: (_) => cubit.showAllRows(true),
                        ),
                      ],
                    ),
                    if (d.truncated)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          l.monShowing(d.entries.length),
                          style: context.text.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  children: [
                    for (final e in shown) _RowCard(entry: e, diff: d),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  const _RowCard({required this.entry, required this.diff});

  final RowEntry entry;
  final TableDiff diff;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (String status, Color color, Color bg) = switch (entry.status) {
      RowStatus.same => (
        l.monStatusSame,
        AppColors.present,
        AppColors.presentLight,
      ),
      RowStatus.onlyLeft => (
        l.monOnlyIn(diff.left.label(l)),
        AppColors.late,
        AppColors.lateLight,
      ),
      RowStatus.onlyRight => (
        l.monOnlyIn(diff.right.label(l)),
        AppColors.late,
        AppColors.lateLight,
      ),
      RowStatus.changed => (
        l.monStatusDifferent,
        AppColors.absent,
        AppColors.absentLight,
      ),
    };
    final columns = {...?entry.left?.keys, ...?entry.right?.keys}.toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: EdgeInsets.zero,
        borderColor: entry.status == RowStatus.same
            ? null
            : color.withValues(alpha: 0.6),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: entry.status == RowStatus.changed,
            tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            childrenPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            // The tile's own arrow stays at the end, so it opens and closes.
            title: Row(
              children: [
                Expanded(
                  child: Text(entry.name, style: context.text.titleSmall),
                ),
                const SizedBox(width: AppSpacing.sm),
                StatusChip(label: status, color: color, background: bg),
              ],
            ),
            children: [
              for (final c in columns)
                _Field(
                  column: c,
                  entry: entry,
                  diff: diff,
                  l: l,
                  differs: entry.changedColumns.contains(c),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.column,
    required this.entry,
    required this.diff,
    required this.l,
    required this.differs,
  });

  final String column;
  final RowEntry entry;
  final TableDiff diff;
  final AppLocalizations l;
  final bool differs;

  @override
  Widget build(BuildContext context) {
    final left = entry.left;
    final right = entry.right;
    Widget line(String? source, Map<String, Object?>? row) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (source != null)
          SizedBox(
            width: 70,
            child: Text(source, style: context.text.labelSmall),
          ),
        Expanded(
          child: Text(
            row == null ? '—' : _show(context, column, row[column]),
            style: context.text.bodyMedium,
          ),
        ),
      ],
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: differs ? AppColors.lateLight : null,
        borderRadius: AppRadius.smAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(column, style: context.text.labelSmall),
          if (differs) ...[
            line(diff.left.label(l), left),
            line(diff.right.label(l), right),
          ] else
            line(null, left ?? right),
        ],
      ),
    );
  }

  /// A value as text; a time stored as milliseconds is shown as a date.
  String _show(BuildContext context, String column, Object? v) {
    if (v == null) return l.monEmptyValue;
    if (v is int && v > 100000000000 && _timeColumn.hasMatch(column)) {
      final t = DateTime.fromMillisecondsSinceEpoch(v);
      return '${formatLongDate(context, t)} ${formatTime(context, t)}';
    }
    final text = '$v';
    return text.isEmpty ? l.monEmptyValue : text;
  }

  static final _timeColumn = RegExp(r'(_at|_on|date|check_in|check_out)$');
}
