import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../core/widgets/time_format.dart';
import '../../../../di/v2_injector.dart';
import '../../domain/entities/school.dart';
import '../bloc/timing_editor_bloc.dart';
import '../widgets/season_look.dart';

/// One season's school day: when it opens and closes, and its periods. Anyone
/// can look; whoever may change the school can edit and save.
class TimingScreen extends StatelessWidget {
  const TimingScreen({super.key, required this.timing, required this.canEdit});

  final SeasonTiming timing;
  final bool canEdit;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TimingEditorBloc>(param1: timing),
    child: _TimingView(canEdit: canEdit),
  );
}

class _TimingView extends StatelessWidget {
  const _TimingView({required this.canEdit});

  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<TimingEditorBloc, TimingEditorState>(
      failureOf: (s) => s.failure,
      child: BlocListener<TimingEditorBloc, TimingEditorState>(
        listenWhen: (a, b) => a.doneCount != b.doneCount,
        listener: (context, _) => Navigator.of(context).pop(),
        child: BlocBuilder<TimingEditorBloc, TimingEditorState>(
          builder: (context, state) {
            final timing = state.timing;
            final bloc = context.read<TimingEditorBloc>();
            return Scaffold(
              appBar: AppBar(
                title: Text(l.schoolTimingOf(timing.season.label(l))),
              ),
              body: ListView(
                padding: AppSpacing.pageOf(context, fab: canEdit),
                children: [
                  PickerField(
                    label: l.fieldOpens,
                    value: timing.opensAt?.clock(context),
                    suffixIcon: Icons.schedule,
                    onTap: !canEdit
                        ? () {}
                        : () async {
                            final m = await pickMinute(
                              context,
                              initial: timing.opensAt,
                            );
                            if (m != null) bloc.add(OpensChanged(m));
                          },
                    errorText: _fieldError(context, state, 'opens_at'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PickerField(
                    label: l.fieldCloses,
                    value: timing.closesAt?.clock(context),
                    suffixIcon: Icons.schedule,
                    onTap: !canEdit
                        ? () {}
                        : () async {
                            final m = await pickMinute(
                              context,
                              initial: timing.closesAt,
                            );
                            if (m != null) bloc.add(ClosesChanged(m));
                          },
                    errorText: _fieldError(context, state, 'closes_at'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionTitle(
                    l.schoolPeriods,
                    trailing: canEdit
                        ? TextButton.icon(
                            onPressed: () => bloc.add(const PeriodAdded()),
                            icon: const Icon(Icons.add),
                            label: Text(l.schoolAddPeriod),
                          )
                        : null,
                  ),
                  if (timing.periods.isEmpty)
                    Text(l.schoolNoPeriods, style: context.text.bodySmall),
                  for (var i = 0; i < timing.periods.length; i++)
                    _PeriodRow(
                      key: ValueKey('$i-${timing.periods.length}'),
                      index: i,
                      period: timing.periods[i],
                      canEdit: canEdit,
                    ),
                  if (state.failure?.onField('periods') case final problem?)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        problem,
                        style: context.text.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
              floatingActionButton: canEdit
                  ? FloatingActionButton.extended(
                      onPressed: state.busy || !timing.isSet
                          ? null
                          : () => bloc.add(const TimingSaved()),
                      icon: state.busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(l.actionSave),
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }

  String? _fieldError(
    BuildContext context,
    TimingEditorState s,
    String field,
  ) => s.failure?.onField(field);
}

class _PeriodRow extends StatelessWidget {
  const _PeriodRow({
    super.key,
    required this.index,
    required this.period,
    required this.canEdit,
  });

  final int index;
  final Period period;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<TimingEditorBloc>();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: period.name,
                    enabled: canEdit,
                    maxLength: 60,
                    decoration: InputDecoration(
                      labelText: l.schoolPeriodName(index + 1),
                      counterText: '',
                    ),
                    onChanged: (v) => bloc.add(PeriodEdited(index, name: v)),
                  ),
                ),
                if (canEdit)
                  IconButton(
                    tooltip: l.actionRemove,
                    onPressed: () => bloc.add(PeriodRemoved(index)),
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: PickerField(
                    label: l.fieldStarts,
                    value: period.startsAt.clock(context),
                    suffixIcon: Icons.schedule,
                    onTap: !canEdit
                        ? () {}
                        : () async {
                            final m = await pickMinute(
                              context,
                              initial: period.startsAt,
                            );
                            if (m != null) {
                              bloc.add(PeriodEdited(index, startsAt: m));
                            }
                          },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PickerField(
                    label: l.fieldEnds,
                    value: period.endsAt.clock(context),
                    suffixIcon: Icons.schedule,
                    onTap: !canEdit
                        ? () {}
                        : () async {
                            final m = await pickMinute(
                              context,
                              initial: period.endsAt,
                            );
                            if (m != null) {
                              bloc.add(PeriodEdited(index, endsAt: m));
                            }
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
