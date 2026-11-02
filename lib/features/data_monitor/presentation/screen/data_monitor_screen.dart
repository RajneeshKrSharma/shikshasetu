import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/sync_l10n.dart';
import '../../../backup/presentation/bloc/data_mirror_cubit.dart';
import '../../domain/entities/data_source_kind.dart';
import '../bloc/data_monitor_cubit.dart';
import 'source_labels.dart';
import 'table_diff_screen.dart';

/// Shows what the cloud, the data file and the phone's database each hold,
/// table by table, and lets the Principal open any table to see exactly
/// which rows differ.
class DataMonitorScreen extends StatelessWidget {
  const DataMonitorScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<DataMonitorCubit>()..load(),
        child: const DataMonitorScreen(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<DataMonitorCubit>();
    return BlocBuilder<DataMonitorCubit, DataMonitorState>(
      builder: (context, s) {
        final tables = [...?s.summaries[DataSourceKind.localDb]?.counts.keys];
        final differing = [
          for (final t in tables)
            if (s.countsMatch(t) == false) t,
        ];
        return Scaffold(
          appBar: AppBar(title: Text(l.monTitle)),
          // The choices and the totals stay in place; only the tables scroll.
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _KindDropdown(
                            label: l.monCheck,
                            value: s.check,
                            onChanged: cubit.checkChanged,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _KindDropdown(
                            label: l.monAgainst,
                            value: s.against,
                            onChanged: cubit.againstChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Says what it reads: only the two places chosen above.
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(36),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          textStyle: context.text.labelMedium,
                        ),
                        onPressed: s.reading.isEmpty ? cubit.load : null,
                        icon: const Icon(Icons.refresh, size: AppIconSize.sm),
                        label: Text(
                          l.monRefreshLabel(
                            s.check.label(l),
                            s.against.label(l),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // All three cards are as tall as the tallest.
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final k in [
                            DataSourceKind.localDb,
                            DataSourceKind.file,
                            DataSourceKind.cloud,
                          ]) ...[
                            Expanded(
                              child: _SourceCard(kind: k, state: s),
                            ),
                            if (k != DataSourceKind.cloud)
                              const SizedBox(width: AppSpacing.sm),
                          ],
                        ],
                      ),
                    ),
                    const _FileStatus(),
                    if (tables.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      _Verdict(differing: differing.length, known: _known(s)),
                      const _HeaderRow(),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  children: [
                    for (final t in tables)
                      _TableRow(
                        table: t,
                        state: s,
                        onTap: () => TableDiffScreen.open(context, t),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _known(DataMonitorState s) =>
      (s.summaries[s.check]?.available ?? false) &&
      (s.summaries[s.against]?.available ?? false);
}

class _KindDropdown extends StatelessWidget {
  const _KindDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DataSourceKind value;
  final ValueChanged<DataSourceKind> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DropdownButtonFormField<DataSourceKind>(
      initialValue: value,
      isExpanded: true,
      isDense: true,
      style: context.text.bodyMedium!.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
      ),
      items: [
        for (final k in DataSourceKind.values)
          DropdownMenuItem(value: k, child: Text(k.label(l))),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.kind, required this.state});

  final DataSourceKind kind;
  final DataMonitorState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final summary = state.summaries[kind];
    final reading = state.reading.contains(kind);
    final selected = kind == state.check || kind == state.against;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      borderColor: selected ? context.brand.primary : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(kind.icon, size: AppIconSize.sm),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  kind.label(l),
                  style: context.text.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (reading)
            Text(l.monReading, style: context.text.labelSmall)
          else if (summary == null)
            Text(l.monNotRead, style: context.text.labelSmall)
          else if (!summary.available)
            Text(
              summary.problem!.label(l),
              style: context.text.labelSmall!.copyWith(color: AppColors.absent),
            )
          else ...[
            Text(
              l.monRows(summary.total),
              style: context.text.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (summary.asOf != null)
              Text(
                l.monAsOf(formatTime(context, summary.asOf)),
                style: context.text.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}

class _FileStatus extends StatelessWidget {
  const _FileStatus();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<DataMirrorCubit, DataMirrorState>(
      builder: (context, m) {
        Widget line(String text, {required bool failed}) => Text(
          text,
          style: context.text.labelSmall!.copyWith(
            color: failed ? AppColors.absent : AppColors.textMuted,
          ),
        );
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (m.failed)
                line(l.monFileFailed, failed: true)
              else if (m.lastWrittenAt != null)
                line(
                  l.monFileWritten(formatTime(context, m.lastWrittenAt)),
                  failed: false,
                ),
              if (m.copyFailed)
                line(l.monExternalFailed, failed: true)
              else if (m.copyWrittenAt != null)
                line(
                  l.monExternalWritten(formatTime(context, m.copyWrittenAt)),
                  failed: false,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict({required this.differing, required this.known});

  final int differing;
  final bool known;

  @override
  Widget build(BuildContext context) {
    if (!known) return const SizedBox();
    final l = context.l10n;
    final ok = differing == 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: ok ? AppColors.presentLight : AppColors.lateLight,
        borderRadius: AppRadius.lgAll,
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.warning_amber_rounded,
            size: AppIconSize.md,
            color: ok ? AppColors.present : AppColors.late,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            ok ? l.monAllMatch : l.monSomeDiffer(differing),
            style: context.text.labelLarge,
          ),
        ],
      ),
    );
  }
}

const _countWidth = 56.0;

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget head(String text) => SizedBox(
      width: _countWidth,
      child: Text(
        text,
        textAlign: TextAlign.end,
        style: context.text.labelSmall,
        overflow: TextOverflow.ellipsis,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const SizedBox(width: AppIconSize.md + AppSpacing.sm),
          Expanded(child: Text(l.monTable, style: context.text.labelSmall)),
          head(DataSourceKind.localDb.label(l)),
          head(DataSourceKind.file.label(l)),
          head(DataSourceKind.cloud.label(l)),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.table,
    required this.state,
    required this.onTap,
  });

  final String table;
  final DataMonitorState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final match = state.countsMatch(table);
    Widget count(DataSourceKind k) {
      final s = state.summaries[k];
      final n = s == null || !s.available ? null : s.counts[table] ?? 0;
      final chosen = k == state.check || k == state.against;
      return SizedBox(
        width: _countWidth,
        child: Text(
          n == null ? '—' : '$n',
          textAlign: TextAlign.end,
          style: context.text.bodyMedium!.copyWith(
            fontWeight: chosen ? FontWeight.w700 : FontWeight.w400,
            color: chosen ? null : AppColors.textMuted,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          // A table whose counts differ stands out from the ones that match.
          color: match == false ? AppColors.lateLight : null,
          border: Border(
            bottom: BorderSide(color: AppColors.border),
            left: BorderSide(
              width: 4,
              color: match == false ? AppColors.late : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          children: [
            if (match == null)
              const SizedBox(width: AppIconSize.md)
            else
              Icon(
                match ? Icons.check_circle : Icons.warning_amber_rounded,
                size: AppIconSize.md,
                color: match ? AppColors.present : AppColors.late,
              ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                syncTableLabel(l, table),
                style: context.text.bodyMedium!.copyWith(
                  fontWeight: match == false ? FontWeight.w700 : null,
                ),
              ),
            ),
            count(DataSourceKind.localDb),
            count(DataSourceKind.file),
            count(DataSourceKind.cloud),
          ],
        ),
      ),
    );
  }
}
