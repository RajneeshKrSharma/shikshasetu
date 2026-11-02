import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../core/widgets/time_format.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/school.dart';
import '../bloc/school_bloc.dart';
import '../widgets/season_look.dart';
import '../widgets/rename_school_dialog.dart';
import 'holidays_screen.dart';
import 'timing_screen.dart';

/// The school's name, which timing is in use, and the way into each timing and
/// the holidays.
class SchoolScreen extends StatelessWidget {
  const SchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<SchoolBloc>(param1: account)..add(const SchoolStarted()),
      child: const _SchoolView(),
    );
  }
}

class _SchoolView extends StatelessWidget {
  const _SchoolView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<SchoolBloc, SchoolState>(
      failureOf: (s) => s.failure,
      child: BlocListener<SchoolBloc, SchoolState>(
        listenWhen: (a, b) => a.savedCount != b.savedCount,
        listener: (context, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageSaved))),
        child: Scaffold(
          appBar: AppBar(title: Text(l.schoolTitle)),
          body: BlocBuilder<SchoolBloc, SchoolState>(
            builder: (context, state) => AsyncBody(
              status: state.status,
              failure: state.failure,
              onRetry: () =>
                  context.read<SchoolBloc>().add(const SchoolStarted()),
              builder: (context) => RefreshIndicator(
                onRefresh: () async =>
                    context.read<SchoolBloc>().add(const SchoolStarted()),
                child: ListView(
                  padding: AppSpacing.pageOf(context),
                  children: [
                    _NameCard(state: state),
                    const SizedBox(height: AppSpacing.md),
                    for (final season in Season.values) ...[
                      _TimingCard(state: state, season: season),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const HolidaysScreen(),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.beach_access_outlined,
                            color: context.brand.primary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              l.schoolHolidays,
                              style: context.text.titleSmall,
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  const _NameCard({required this.state});

  final SchoolState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final school = state.school!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  school.name.isEmpty ? l.schoolNameNotSet : school.name,
                  style: context.text.headlineSmall,
                ),
              ),
              if (state.canEdit)
                IconButton(
                  tooltip: l.actionEdit,
                  onPressed: state.busy
                      ? null
                      : () => showRenameSchoolDialog(context, school.name),
                  icon: const Icon(Icons.edit_outlined),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l.schoolSeasonInUse, style: context.text.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          SegmentedButton<Season>(
            showSelectedIcon: false,
            emptySelectionAllowed: true,
            segments: [
              for (final s in Season.values)
                ButtonSegment(value: s, label: Text(s.label(l))),
            ],
            selected: {?school.activeSeason},
            onSelectionChanged: state.canEdit && !state.busy
                ? (s) => context.read<SchoolBloc>().add(SeasonChosen(s.first))
                : null,
          ),
        ],
      ),
    );
  }
}

class _TimingCard extends StatelessWidget {
  const _TimingCard({required this.state, required this.season});

  final SchoolState state;
  final Season season;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final timing = state.timings!.of(season);
    final inUse = state.school!.activeSeason == season;
    return AppCard(
      onTap: () async {
        final bloc = context.read<SchoolBloc>();
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                TimingScreen(timing: timing, canEdit: state.canEdit),
          ),
        );
        bloc.add(const SchoolStarted());
      },
      child: Row(
        children: [
          Icon(season.icon, color: context.brand.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.schoolTimingOf(season.label(l)),
                  style: context.text.titleSmall,
                ),
                Text(
                  timing.isSet
                      ? l.schoolHours(
                          timing.opensAt!.clock(context),
                          timing.closesAt!.clock(context),
                        )
                      : l.schoolTimingNotSet,
                  style: context.text.bodySmall,
                ),
                if (timing.isSet)
                  Text(
                    l.schoolPeriodCount(timing.periods.length),
                    style: context.text.bodySmall,
                  ),
              ],
            ),
          ),
          if (inUse)
            StatusChip(
              label: l.schoolInUse,
              color: context.brand.primary,
              background: context.brand.primary.withValues(alpha: 0.1),
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
