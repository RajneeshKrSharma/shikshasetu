import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/sync_l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/sync_feature.dart';
import '../../domain/entities/sync_record_change.dart';
import '../bloc/cloud_sync_cubit.dart';
import '../bloc/school_refresh_cubit.dart';

/// What the syncs did, for the Principal and the teachers: when the data last
/// synced and when it will next, and, feature by feature, what this phone
/// sent and what it received. Opened from the strip or the sync notification.
/// Expects the app's [CloudSyncCubit] and [SchoolRefreshCubit] above it.
class SyncDetailsScreen extends StatelessWidget {
  const SyncDetailsScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const SyncDetailsScreen()));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final principal =
        context.select((AuthBloc b) => b.state.user?.isPrincipal) ?? false;
    final cloud = context.watch<CloudSyncCubit>().state;
    final exchange = context.watch<SchoolRefreshCubit>().state;
    final syncing = cloud.syncing || exchange.running;

    // The Principal's phone saves to the cloud as a whole (by table); a
    // teacher's phone sends its own work.
    final sentRun = principal ? cloud.lastChangeRun : null;
    final sentTables = principal
        ? sentRun?.uploaded ?? const <String, int>{}
        : exchange.lastChange?.sent ?? const <String, int>{};
    final removedTables = sentRun?.deleted ?? const <String, int>{};
    final sentAt = principal ? sentRun?.at : exchange.lastChange?.at;
    final sentChanges = principal
        ? sentRun?.changes ?? const <SyncRecordChange>[]
        : exchange.lastChange?.sentChanges ?? const <SyncRecordChange>[];
    final received = exchange.lastChange?.received ?? const <String, int>{};
    final receivedChanges =
        exchange.lastChange?.receivedChanges ?? const <SyncRecordChange>[];

    return Scaffold(
      appBar: AppBar(title: Text(l.syncDetailsTitle)),
      body: ListView(
        padding: AppSpacing.pageOf(context),
        children: [
          _StatusCard(
            principal: principal,
            cloud: cloud,
            exchange: exchange,
            syncing: syncing,
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionTitle(l.syncDetailsSentTitle),
          _BreakdownCard(
            at: sentAt,
            perTable: sentTables,
            removedPerTable: removedTables,
            changes: sentChanges,
            empty: l.syncDetailsNothingSent,
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionTitle(l.syncDetailsReceivedTitle),
          _BreakdownCard(
            at: exchange.lastChange?.at,
            perTable: received,
            changes: receivedChanges,
            empty: l.syncDetailsNothingReceived,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: syncing
                ? null
                : () {
                    context.read<SchoolRefreshCubit>().refresh();
                    if (principal) context.read<CloudSyncCubit>().syncNow();
                  },
            icon: const Icon(Icons.sync),
            label: Text(syncing ? l.cloudSyncing : l.cloudSyncNow),
          ),
        ],
      ),
    );
  }
}

String _when(BuildContext context, DateTime at) => context.l10n
    .syncDetailsAtTime(formatShortDate(context, at), formatTime(context, at));

/// When it last synced and when it next will.
class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.principal,
    required this.cloud,
    required this.exchange,
    required this.syncing,
  });

  final bool principal;
  final CloudSyncState cloud;
  final SchoolExchangeState exchange;
  final bool syncing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lastCheck = exchange.lastAt;
    final cloudLast = cloud.lastRun?.at;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              syncing
                  ? const SizedBox(
                      height: AppIconSize.xl,
                      width: AppIconSize.xl,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : const Icon(
                      Icons.cloud_done_outlined,
                      color: AppColors.present,
                      size: AppIconSize.xl,
                    ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  syncing ? l.syncDetailsSyncingNow : l.syncDetailsStatus,
                  style: context.text.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _Line(
            label: l.syncDetailsLastCheck,
            value: lastCheck == null
                ? l.syncDetailsNeverChecked
                : _when(context, lastCheck),
          ),
          if (exchange.nextAt != null)
            _Line(
              label: l.syncDetailsNextSync,
              value: _when(context, exchange.nextAt!),
            ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l.syncDetailsChecksEvery(SchoolRefreshCubit.every.inSeconds),
              style: context.text.bodySmall,
            ),
          ),
          if (principal) ...[
            const Divider(height: AppSpacing.xl),
            Text(l.syncDetailsCloudUpload, style: context.text.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            _Line(
              label: l.syncDetailsLastSync,
              value: cloudLast == null
                  ? l.cloudNeverSynced
                  : _when(context, cloudLast),
            ),
            if (cloud.intervalMinutes == 0)
              Text(l.syncStripOff, style: context.text.bodySmall)
            else ...[
              if (cloud.nextSyncAt != null)
                _Line(
                  label: l.syncDetailsNextSync,
                  value: _when(context, cloud.nextSyncAt!),
                ),
              Text(
                l.syncNotifNext(syncIntervalLabel(l, cloud.intervalMinutes)),
                style: context.text.bodySmall,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// "Label     value", both wrapping rather than being cut short.
class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: context.text.bodyMedium)),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: context.text.titleSmall,
          ),
        ),
      ],
    ),
  );
}

/// Records moved, grouped by feature, each with the tables it came from.
class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({
    required this.at,
    required this.perTable,
    required this.empty,
    this.removedPerTable = const {},
    this.changes = const [],
  });

  final List<SyncRecordChange> changes;
  final DateTime? at;
  final Map<String, int> perTable;
  final Map<String, int> removedPerTable;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tables = {...perTable.keys, ...removedPerTable.keys};
    if (tables.isEmpty) {
      return AppCard(child: Text(empty, style: context.text.bodyMedium));
    }
    final total = perTable.values.fold(0, (a, b) => a + b);
    final removed = removedPerTable.values.fold(0, (a, b) => a + b);
    final byFeature = <SyncFeature, List<String>>{};
    for (final t in tables) {
      byFeature.putIfAbsent(SyncFeature.ofTable(t), () => []).add(t);
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (at != null)
            Text(_when(context, at!), style: context.text.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            [
              if (total > 0) l.syncDetailsRecordsSent(total),
              if (removed > 0) l.syncDetailsRecordsRemoved(removed),
              l.syncFeaturesCount(byFeature.length),
            ].join(' · '),
            style: context.text.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final f in SyncFeature.values)
            if (byFeature.containsKey(f))
              _FeatureBlock(
                feature: f,
                tables: byFeature[f]!..sort(),
                perTable: perTable,
                removedPerTable: removedPerTable,
                changes: changes,
                l: l,
              ),
        ],
      ),
    );
  }
}

class _FeatureBlock extends StatelessWidget {
  const _FeatureBlock({
    required this.feature,
    required this.tables,
    required this.perTable,
    required this.removedPerTable,
    required this.changes,
    required this.l,
  });

  final List<SyncRecordChange> changes;
  final SyncFeature feature;
  final List<String> tables;
  final Map<String, int> perTable;
  final Map<String, int> removedPerTable;
  final AppLocalizations l;

  static IconData _icon(SyncFeature f) => switch (f) {
    SyncFeature.settings => Icons.settings_outlined,
    SyncFeature.staff => Icons.badge_outlined,
    SyncFeature.classes => Icons.class_outlined,
    SyncFeature.students => Icons.school_outlined,
    SyncFeature.calendar => Icons.calendar_month_outlined,
    SyncFeature.attendance => Icons.fact_check_outlined,
    SyncFeature.exams => Icons.quiz_outlined,
    SyncFeature.fees => Icons.payments_outlined,
    SyncFeature.notices => Icons.campaign_outlined,
    SyncFeature.questionBank => Icons.library_books_outlined,
  };

  String _counts(String table) => [
    if ((perTable[table] ?? 0) > 0) l.syncDetailsRecordsSent(perTable[table]!),
    if ((removedPerTable[table] ?? 0) > 0)
      l.syncDetailsRecordsRemoved(removedPerTable[table]!),
  ].join(' · ');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon(feature), size: AppIconSize.md),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(feature.label(l), style: context.text.titleSmall),
              ),
            ],
          ),
          for (final t in tables)
            _TableSection(
              table: t,
              counts: _counts(t),
              total: (perTable[t] ?? 0) + (removedPerTable[t] ?? 0),
              records: [
                for (final c in changes)
                  if (c.table == t) c,
              ],
              l: l,
            ),
        ],
      ),
    );
  }
}

/// One table's records: its name and count, then each record with what
/// changed in it.
class _TableSection extends StatelessWidget {
  const _TableSection({
    required this.table,
    required this.counts,
    required this.total,
    required this.records,
    required this.l,
  });

  final String table;
  final String counts;
  final int total;
  final List<SyncRecordChange> records;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(syncTableLabel(l, table), style: context.text.bodyMedium),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            counts,
            textAlign: TextAlign.end,
            style: context.text.bodySmall,
          ),
        ),
      ],
    );
    final left = AppIconSize.md + AppSpacing.md;
    if (records.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: left, top: AppSpacing.xs),
        child: header,
      );
    }
    final more = total - records.length;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: records.length <= 5,
        tilePadding: EdgeInsets.only(left: left),
        childrenPadding: EdgeInsets.only(left: left, bottom: AppSpacing.sm),
        shape: const Border(),
        collapsedShape: const Border(),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: header,
        children: [
          for (final r in records) _RecordTile(change: r, l: l),
          if (more > 0)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l.syncDetailsMoreNotListed(more),
                style: context.text.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}

/// One record: its name, whether it is new, changed or removed, and each
/// field with what it was and what it is now.
class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.change, required this.l});

  final SyncRecordChange change;
  final AppLocalizations l;

  static String _name(String field) {
    final words = field.replaceAll('_', ' ').trim();
    return words.isEmpty ? field : words[0].toUpperCase() + words.substring(1);
  }

  /// A time stored as milliseconds is shown as a date and time.
  String _value(BuildContext context, String field, String? v) {
    if (v == null || v.isEmpty) return l.syncValueEmpty;
    final ms = int.tryParse(v);
    final isTime =
        field.endsWith('_at') ||
        field.endsWith('_on') ||
        field == 'dob' ||
        field == 'joined_on';
    if (isTime && ms != null && ms > 100000000000) {
      final at = DateTime.fromMillisecondsSinceEpoch(ms);
      return _when(context, at);
    }
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final (kindLabel, kindColor) = switch (change.kind) {
      RecordChangeKind.added => (l.syncKindAdded, AppColors.present),
      RecordChangeKind.changed => (l.syncKindChanged, AppColors.late),
      RecordChangeKind.removed => (l.syncKindRemoved, AppColors.absent),
    };
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  change.label.isEmpty ? change.key : change.label,
                  style: context.text.titleSmall,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                kindLabel,
                style: context.text.labelMedium!.copyWith(color: kindColor),
              ),
            ],
          ),
          for (final f in change.fields)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: _FieldLine(
                name: _name(f.field),
                change: change,
                before: _value(context, f.field, f.before),
                after: _value(context, f.field, f.after),
                l: l,
              ),
            ),
          if (change.kind == RecordChangeKind.changed && !change.beforeKnown)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l.syncDetailsEarlierUnknown,
                style: context.text.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _FieldLine extends StatelessWidget {
  const _FieldLine({
    required this.name,
    required this.change,
    required this.before,
    required this.after,
    required this.l,
  });

  final String name;
  final SyncRecordChange change;
  final String before;
  final String after;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final muted = context.text.bodySmall!.copyWith(color: AppColors.textMuted);
    final strong = context.text.bodySmall!.copyWith(
      fontWeight: FontWeight.w600,
    );
    final showBoth =
        change.kind == RecordChangeKind.changed && change.beforeKnown;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$name: ', style: muted),
          if (showBoth) ...[
            TextSpan(
              text: before,
              style: muted.copyWith(decoration: TextDecoration.lineThrough),
            ),
            TextSpan(text: '  →  ', style: muted),
            TextSpan(text: after, style: strong),
          ] else
            TextSpan(
              text: change.kind == RecordChangeKind.removed ? before : after,
              style: strong,
            ),
        ],
      ),
    );
  }
}
