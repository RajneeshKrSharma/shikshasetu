import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../data_monitor/presentation/screen/restore_preview_screen.dart';
import '../../domain/entities/restore_record.dart';
import '../../../home/presentation/shared_data_loader.dart';
import '../bloc/backup_bloc.dart';
import '../bloc/data_mirror_cubit.dart';

/// Restores from a backup file, and shows the automatic copy (Principal only).
class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<BackupBloc>()..add(const BackupStarted()),
        child: const BackupScreen(),
      ),
    ),
  );

  /// Shows what restoring would change; the backup is restored only if the
  /// user then chooses to.
  Future<void> _previewRestore(BuildContext context, RestoreOffer offer) async {
    final bloc = context.read<BackupBloc>();
    final userId = context.read<AuthBloc>().state.user?.id;
    final restore = await RestorePreviewScreen.open(context, offer.jsonText);
    bloc.add(
      restore == true
          ? RestoreConfirmed(userId: userId)
          : const RestoreDeclined(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<BackupBloc, BackupState>(
          listenWhen: (a, b) => b.notice != null && a.notice != b.notice,
          listener: (context, state) =>
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(switch (state.notice!.kind) {
                    BackupNoticeKind.backupDownloaded =>
                      l.messageBackupDownloaded,
                    BackupNoticeKind.backupFailed => l.messageBackupFailed,
                    BackupNoticeKind.restoreFailed => l.messageRestoreFailed,
                    BackupNoticeKind.notABackup => l.errBackupNotBackup,
                    BackupNoticeKind.newerVersion => l.errBackupNewer,
                    BackupNoticeKind.corrupt => l.errBackupCorrupt,
                  }),
                ),
              ),
        ),
        BlocListener<BackupBloc, BackupState>(
          listenWhen: (a, b) => a.offer != b.offer && b.offer != null,
          listener: (context, state) => _previewRestore(context, state.offer!),
        ),
        BlocListener<BackupBloc, BackupState>(
          listenWhen: (a, b) => !a.restored && b.restored,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.messageRestoreDone)));
            if (state.signInAgain) {
              // The file was not written by this Principal: its accounts may
              // differ, so sign in again.
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              Navigator.of(context).popUntil((r) => r.isFirst);
            } else {
              // Their own file: stay signed in, and show the restored data.
              SharedDataLoader(context)();
              context.read<AuthBloc>().add(const AuthStarted());
              context.read<BackupBloc>().add(const BackupStarted());
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l.backupTitle)),
        body: BlocBuilder<BackupBloc, BackupState>(
          builder: (context, state) {
            return ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                const _AutoCopyCard(),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: state.busy
                            ? null
                            : () => context.read<BackupBloc>().add(
                                const BackupShareRequested(),
                              ),
                        icon: const Icon(Icons.ios_share),
                        label: Text(l.actionBackupShareZip),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: state.busy
                            ? null
                            : () => context.read<BackupBloc>().add(
                                const BackupDownloadRequested(),
                              ),
                        icon: const Icon(Icons.download_outlined),
                        label: Text(l.actionBackupDownload),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(l.backupShareHint, style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.lg),
                SectionTitle(l.sectionRestore),
                Text(l.restoreHint, style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: state.busy
                      ? null
                      : () => context.read<BackupBloc>().add(
                          const RestoreFilePickRequested(),
                        ),
                  icon: const Icon(Icons.restore),
                  label: Text(l.actionRestoreFromFile),
                ),
                if (state.busy) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const LinearProgressIndicator(),
                ],
                if (state.history.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.lg),
                  SectionTitle(l.rhTitle),
                  _HistoryRow(record: state.history.first),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// When the data was last copied to Downloads/ShikshaSetu by itself.
class _AutoCopyCard extends StatelessWidget {
  const _AutoCopyCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<DataMirrorCubit, DataMirrorState>(
      builder: (context, m) {
        final at = m.copyWrittenAt;
        final (IconData icon, Color color, String text) = m.copyFailed
            ? (Icons.error_outline, AppColors.absent, l.backupAutoFailed)
            : at == null
            ? (Icons.warning_amber_rounded, AppColors.late, l.backupAutoNone)
            : (
                Icons.check_circle,
                AppColors.present,
                l.backupAutoLast(
                  '${formatShortDate(context, at)} ${formatTime(context, at)}',
                ),
              );
        return AppCard(
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(text, style: context.text.titleSmall)),
            ],
          ),
        );
      },
    );
  }
}

/// One restore that was done, and what it overrode.
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.record});

  final RestoreRecord record;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String when(DateTime t) =>
        '${formatShortDate(context, t)} ${formatTime(context, t)}';
    final backupAt = record.backupAt;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        borderColor: record.appWasNewer
            ? AppColors.absent.withValues(alpha: 0.5)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.rhLine(
                when(record.at),
                backupAt == null ? '—' : when(backupAt),
              ),
              style: context.text.titleSmall,
            ),
            Text(
              l.rhCounts(record.added, record.changed, record.removed),
              style: context.text.bodySmall,
            ),
            if (record.appWasNewer)
              Text(
                l.rhForced,
                style: context.text.bodySmall!.copyWith(
                  color: AppColors.absent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            Text(
              record.earlierDataFile == null ? l.rhNotSaved : l.rhSaved,
              style: context.text.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
