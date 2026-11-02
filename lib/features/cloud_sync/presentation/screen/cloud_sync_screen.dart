import '../../../../core/widgets/info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/sync_l10n.dart';
import '../../domain/entities/cloud_entities.dart';
import '../bloc/cloud_sync_cubit.dart';

/// See what was sent to the cloud, and sync.
/// Expects a [CloudSyncCubit] above it (the app keeps one).
class CloudSyncScreen extends StatelessWidget {
  const CloudSyncScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const CloudSyncScreen()));

  String _notice(CloudNotice n, AppLocalizations l) => switch (n) {
    CloudNotice.synced => l.cloudSyncedNotice,
    CloudNotice.upToDate => l.cloudUpToDate,
    CloudNotice.needSignIn => l.cloudNeedSignIn,
    CloudNotice.notOwner => l.cloudNotOwner,
    CloudNotice.offline => l.cloudOffline,
    CloudNotice.failed => l.cloudFailed,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<CloudSyncCubit, CloudSyncState>(
      listenWhen: (a, b) => a.noticeId != b.noticeId && b.notice != null,
      listener: (context, s) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_notice(s.notice!, l)))),
      child: Scaffold(
        appBar: AppBar(title: Text(l.cloudTitle)),
        body: BlocBuilder<CloudSyncCubit, CloudSyncState>(
          builder: (context, s) {
            final connection = s.connection;
            return ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                Text(l.cloudIntro, style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.lg),
                if (connection == null)
                  const Center(child: CircularProgressIndicator())
                else if (connection.status == CloudStatus.notConfigured)
                  _Banner(text: l.cloudNotConfigured, warning: true)
                else if (connection.status == CloudStatus.signedOut)
                  _Banner(text: l.cloudSignedOutBanner, warning: true)
                else
                  _ConnectedCard(state: s),
                const SizedBox(height: AppSpacing.lg),
                SectionTitle(l.cloudWhatIsSent),
                Text(l.cloudWhatIsSentBody, style: context.text.bodySmall),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, this.warning = false});

  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) => InfoBanner(
    message: text,
    kind: warning ? BannerKind.warning : BannerKind.info,
    icon: Icons.cloud_off_outlined,
  );
}

class _ConnectedCard extends StatelessWidget {
  const _ConnectedCard({required this.state});

  final CloudSyncState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<CloudSyncCubit>();
    final connection = state.connection!;
    final run = state.lastRun;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cloud_done_outlined,
                    color: AppColors.present,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      l.cloudConnectedAs(connection.email ?? ''),
                      style: context.text.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                run == null
                    ? l.cloudNeverSynced
                    : l.cloudLastSync(
                        '${formatShortDate(context, run.at)}, '
                        '${formatTime(context, run.at)}',
                      ),
                style: context.text.bodySmall,
              ),
              if (run != null) ...[
                const SizedBox(height: AppSpacing.sm),
                if (run.isEmpty)
                  Text(l.cloudUpToDate, style: context.text.bodySmall)
                else
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final e in run.uploadedByFeature.entries)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text('${e.key.label(l)} · ${e.value}'),
                        ),
                    ],
                  ),
                if (!run.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      [
                        if (run.totalUploaded > 0)
                          l.cloudSentSummary(run.totalUploaded),
                        if (run.totalDeleted > 0)
                          l.cloudRemovedSummary(run.totalDeleted),
                      ].join(' · '),
                      style: context.text.labelSmall,
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: state.syncing ? null : cubit.syncNow,
          icon: state.syncing
              ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: context.brand.onPrimary,
                  ),
                )
              : const Icon(Icons.sync),
          label: Text(state.syncing ? l.cloudSyncing : l.cloudSyncNow),
        ),
        if (state.syncing && state.progress != null) ...[
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(value: state.progress!.fraction),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.cloudSyncProgress(state.progress!.done, state.progress!.total),
            style: context.text.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        _AutoSyncCard(minutes: state.intervalMinutes),
      ],
    );
  }
}

/// How often the phone saves to the cloud by itself.
class _AutoSyncCard extends StatelessWidget {
  const _AutoSyncCard({required this.minutes});

  final int minutes;

  static String _label(AppLocalizations l, int minutes) =>
      minutes == 0 ? l.cloudAutoSyncOff : syncIntervalLabel(l, minutes);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<CloudSyncCubit>();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.cloudAutoSyncTitle, style: context.text.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(l.cloudAutoSyncHelp, style: context.text.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final m in [0, ...kSyncIntervalChoices])
                ChoiceChip(
                  label: Text(_label(l, m)),
                  selected: minutes == m,
                  onSelected: (_) => cubit.setInterval(m),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
