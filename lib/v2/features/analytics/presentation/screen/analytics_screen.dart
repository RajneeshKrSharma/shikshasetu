import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/date_range_chips.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../domain/entities/analytics.dart';
import '../bloc/analytics_bloc.dart';
import '../widgets/analytics_labels.dart';
import '../widgets/series_chart.dart';

/// The graphs of the school: pick one, a period, and (for some) a class.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<AnalyticsBloc>()..add(const AnalyticsStarted()),
    child: const _View(),
  );
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<AnalyticsBloc, AnalyticsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(l.anaTitle)),
          body: Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  children: [
                    for (final k in GraphKind.values)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: ChoiceChip(
                          label: Text(k.label(l)),
                          selected: state.kind == k,
                          onSelected: (_) =>
                              context.read<AnalyticsBloc>().add(GraphChosen(k)),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    DateRangeChips(
                      value: state.range,
                      onChanged: (r) {
                        if (r != null) {
                          context.read<AnalyticsBloc>().add(
                            AnalyticsRangeChosen(r),
                          );
                        }
                      },
                    ),
                    if (state.kind.byClass)
                      DropdownButtonFormField<String?>(
                        initialValue: state.classId,
                        isExpanded: true,
                        decoration: InputDecoration(labelText: l.fieldClass),
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text(l.stuAllClasses),
                          ),
                          for (final c in state.classes)
                            DropdownMenuItem<String?>(
                              value: c.id,
                              child: Text(c.name),
                            ),
                        ],
                        onChanged: (id) => context.read<AnalyticsBloc>().add(
                          AnalyticsClassChosen(id),
                        ),
                      ),
                  ],
                ),
              ),
              if (state.busy) const LinearProgressIndicator(),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () => context.read<AnalyticsBloc>().add(
                    const AnalyticsStarted(),
                  ),
                  isEmpty: state.data?.isEmpty ?? true,
                  emptyText: l.anaEmpty,
                  emptyIcon: Icons.insights_outlined,
                  builder: (context) {
                    final data = state.data!;
                    return ListView(
                      padding: AppSpacing.page,
                      children: [
                        if (data.summary.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                for (final s in data.summary)
                                  Expanded(
                                    child: StatTile(
                                      label: s.id.label(l),
                                      value: s.value.format(),
                                      icon:
                                          Icons.account_balance_wallet_outlined,
                                      color: context.brand.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        for (final series in data.series)
                          if (series.points.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: SeriesChart(series: series),
                            ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
