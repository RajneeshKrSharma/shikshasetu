import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/cloud_sync_cubit.dart';
import '../bloc/school_refresh_cubit.dart';
import '../screen/sync_details_screen.dart';

/// When the data was last synced, when the next sync is due, and how much the
/// last one moved, for the Principal and the teachers. Only shows the status
/// (it never syncs itself); tap it for the details. Always two lines of a
/// fixed height, so the page does not jump while it syncs. Takes no space for
/// a Principal whose cloud is not connected.
class SyncStatusStrip extends StatelessWidget {
  const SyncStatusStrip({super.key});

  /// "3:25 PM" for today, "2 Oct 2026, 3:25 PM" for any other day.
  static String when(BuildContext context, DateTime at) {
    final now = DateTime.now();
    final today =
        at.year == now.year && at.month == now.month && at.day == now.day;
    return today
        ? formatTime(context, at)
        : '${formatShortDate(context, at)}, ${formatTime(context, at)}';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final principal =
        context.select((AuthBloc b) => b.state.user?.isPrincipal) ?? false;
    final cloud = context.watch<CloudSyncCubit>().state;
    final exchange = context.watch<SchoolRefreshCubit>().state;
    if (!_shown(principal: principal, cloud: cloud)) {
      return const SizedBox.shrink();
    }

    final syncing = cloud.syncing || exchange.running;
    final lastAt = _latest(
      principal ? cloud.lastRun?.at : null,
      exchange.lastAt,
    );
    final nextAt = principal && cloud.intervalMinutes > 0
        ? cloud.nextSyncAt ?? exchange.nextAt
        : exchange.nextAt;
    final progress = cloud.progress;

    final sent =
        (principal ? cloud.lastChangeRun?.totalUploaded ?? 0 : 0) +
        (exchange.lastChange?.totalSent ?? 0);
    final received = exchange.lastChange?.totalReceived ?? 0;

    // Always two lines, so the strip is the same height whether it is idle
    // or syncing, and the page below does not move.
    final first = syncing
        ? (progress == null
              ? l.syncStripSyncing
              : '${l.syncStripSyncing} '
                    '${l.cloudSyncProgress(progress.done, progress.total)}')
        : lastAt == null
        ? l.cloudNeverSynced
        : l.syncStripLast(when(context, lastAt));
    final second = [
      if (nextAt != null && !syncing) l.syncStripNext(when(context, nextAt)),
      if (!syncing)
        if (sent == 0 && received == 0)
          l.syncStripNothingYet
        else ...[
          if (sent > 0) l.syncStripSent(sent),
          if (received > 0) l.syncStripReceived(received),
        ],
    ].join(' · ');

    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: () => SyncDetailsScreen.open(context),
        child: Container(
          height: _height,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: AppIconSize.sm,
                height: AppIconSize.sm,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: syncing
                      ? SizedBox(
                          key: const ValueKey('syncing'),
                          height: AppIconSize.sm,
                          width: AppIconSize.sm,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: progress?.fraction,
                          ),
                        )
                      : const Icon(
                          Icons.cloud_done_outlined,
                          key: ValueKey('done'),
                          size: AppIconSize.sm,
                          color: AppColors.present,
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      first,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall,
                    ),
                    Text(
                      second,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l.syncStripDetails,
                style: context.text.labelMedium!.copyWith(
                  color: context.brand.primary,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: AppIconSize.sm,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fixed, so the strip never changes size.
  static const height = 56.0;
  static const _height = height;

  /// A Principal whose cloud is not connected has no strip.
  static bool _shown({
    required bool principal,
    required CloudSyncState cloud,
  }) => !principal || cloud.connection?.isReady == true;

  static DateTime? _latest(DateTime? a, DateTime? b) => a == null
      ? b
      : b == null
      ? a
      : (a.isAfter(b) ? a : b);
}

/// The status strip as a pinned sliver: it stays in place while the page
/// below scrolls (and takes no room when there is no strip).
class SyncStatusSliver extends StatelessWidget {
  const SyncStatusSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final principal =
        context.select((AuthBloc b) => b.state.user?.isPrincipal) ?? false;
    final cloud = context.watch<CloudSyncCubit>().state;
    if (!SyncStatusStrip._shown(principal: principal, cloud: cloud)) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverPersistentHeader(pinned: true, delegate: _FixedStrip());
  }
}

class _FixedStrip extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => SyncStatusStrip.height;

  @override
  double get maxExtent => SyncStatusStrip.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) =>
      const SyncStatusStrip();

  @override
  bool shouldRebuild(_FixedStrip old) => false;
}
