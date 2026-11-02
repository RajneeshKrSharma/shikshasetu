import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/sync_l10n.dart';
import '../../domain/entities/restore_comparison.dart';
import '../bloc/data_monitor_cubit.dart';
import 'table_diff_screen.dart';

/// Shown before a backup is restored: what is in the app now against what is
/// in the backup, table by table, so nothing is replaced by mistake. Pops
/// with true when the user chooses to restore.
class RestorePreviewScreen extends StatelessWidget {
  const RestorePreviewScreen({super.key, required this.jsonText});

  final String jsonText;

  static Future<bool?> open(BuildContext context, String jsonText) =>
      Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => BlocProvider(
            create: (_) => sl<DataMonitorCubit>()..loadRestore(jsonText),
            child: RestorePreviewScreen(jsonText: jsonText),
          ),
        ),
      );

  /// Restoring is asked for again when it would override data in the app:
  /// they are told how many rows, before anything is replaced.
  Future<void> _restore(BuildContext context, RestoreComparison c) async {
    if (c.overridden == 0) {
      Navigator.of(context).pop(true);
      return;
    }
    final l = context.l10n;
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: AppColors.absent),
        title: Text(c.appIsNewer ? l.rpOldTitle : l.rpOverrideTitle),
        content: Text(
          c.appIsNewer
              ? l.rpOldBody(c.changed, c.removed)
              : l.rpOverrideBody(c.changed, c.removed),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.absent),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.rpOverrideConfirm),
          ),
        ],
      ),
    );
    if (ok == true) navigator.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.rpTitle)),
      body: BlocBuilder<DataMonitorCubit, DataMonitorState>(
        builder: (context, s) {
          if (s.comparisonFailed) {
            return Center(child: Text(l.monProblemOther));
          }
          final c = s.comparison;
          if (c == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (c.backupAt != null)
                      Text(
                        l.rpBackupFrom(
                          '${formatShortDate(context, c.backupAt!)} '
                          '${formatTime(context, c.backupAt)}',
                        ),
                        style: context.text.labelMedium,
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    _Verdict(comparison: c),
                    if (c.appIsNewer && c.overridden > 0)
                      _NewerBanner(comparison: c),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l.rpLegend, style: context.text.labelSmall),
                    const _HeaderRow(),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  children: [
                    for (final t in c.tables)
                      _TableRow(
                        change: t,
                        onTap: () => TableDiffScreen.open(
                          context,
                          t.table,
                          backupJson: jsonText,
                        ),
                      ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: c.noChange ? null : () => _restore(context, c),
                      child: Text(
                        c.noChange ? l.rpNothingToRestore : l.rpRestoreButton,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The app has newer changes than the backup: restoring would put older data
/// over them.
class _NewerBanner extends StatelessWidget {
  const _NewerBanner({required this.comparison});

  final RestoreComparison comparison;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String when(DateTime? t) => t == null
        ? '—'
        : '${formatShortDate(context, t)} ${formatTime(context, t)}';
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.absentLight,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.absent.withValues(alpha: 0.6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.history_toggle_off,
              color: AppColors.absent,
              size: AppIconSize.md,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l.rpNewerBanner(
                  when(comparison.appChangedAt),
                  when(comparison.backupAt),
                ),
                style: context.text.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict({required this.comparison});

  final RestoreComparison comparison;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = comparison;
    final (Color color, Color bg, IconData icon) = c.noChange
        ? (AppColors.present, AppColors.presentLight, Icons.check_circle)
        : c.removed > 0
        ? (AppColors.absent, AppColors.absentLight, Icons.warning_amber_rounded)
        : (AppColors.late, AppColors.lateLight, Icons.info_outline);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppIconSize.md),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.noChange
                      ? l.rpNoChange
                      : l.rpWillChange(c.added, c.changed, c.removed),
                  style: context.text.labelLarge,
                ),
                if (c.removed > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      l.rpLoseWarning(c.removed),
                      style: context.text.labelMedium!.copyWith(
                        color: AppColors.absent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _countWidth = 44.0;

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
          head(l.rpNow),
          head(l.rpBackup),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.change, required this.onTap});

  final TableRestoreChange change;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lose = change.removed > 0;
    final (Color accent, Color? bg) = lose
        ? (AppColors.absent, AppColors.absentLight)
        : change.differs
        ? (AppColors.late, AppColors.lateLight)
        : (AppColors.present, null);
    Widget count(int n) => SizedBox(
      width: _countWidth,
      child: Text(
        '$n',
        textAlign: TextAlign.end,
        style: context.text.bodyMedium!.copyWith(
          fontWeight: change.differs ? FontWeight.w700 : null,
        ),
      ),
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border(
            bottom: BorderSide(color: AppColors.border),
            left: BorderSide(
              width: 4,
              color: change.differs ? accent : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              change.differs ? Icons.warning_amber_rounded : Icons.check_circle,
              size: AppIconSize.md,
              color: accent,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    syncTableLabel(l, change.table),
                    style: context.text.bodyMedium!.copyWith(
                      fontWeight: change.differs ? FontWeight.w700 : null,
                    ),
                  ),
                  if (change.differs)
                    Text(
                      [
                        if (change.added > 0) l.rpAdd(change.added),
                        if (change.changed > 0) l.rpChange(change.changed),
                        if (change.removed > 0) l.rpRemove(change.removed),
                      ].join('  '),
                      style: context.text.labelSmall!.copyWith(
                        color: lose ? AppColors.absent : AppColors.late,
                      ),
                    ),
                ],
              ),
            ),
            count(change.now),
            count(change.backup),
          ],
        ),
      ),
    );
  }
}
