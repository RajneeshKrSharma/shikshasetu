import '../../../../l10n/class_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../bloc/analytics_bloc.dart';
import '../widgets/analytics_charts.dart';
import '../widgets/fee_collection_card.dart';
import '../widgets/teacher_report_card.dart';

/// Reports and graphs for the Principal.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  /// Opens the screen with its own [AnalyticsBloc] on the first class.
  static Future<void> open(BuildContext context) {
    final first = context
        .read<ClassesBloc>()
        .state
        .classes
        .map((c) => c.name)
        .firstOrNull;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) =>
              sl<AnalyticsBloc>()..add(AnalyticsClassSelected(first)),
          child: const AnalyticsScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.watch<ClassesBloc>().state.classes;

    return Scaffold(
      appBar: AppBar(title: Text(l.analyticsTitle)),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (classes.isEmpty) {
            return EmptyState(
              icon: Icons.class_outlined,
              message: l.emptyClasses,
            );
          }
          final data = state.classData;
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final c in classes)
                    ChoiceChip(
                      label: Text(l.classLabel(c.name)),
                      selected: state.classSection == c.name,
                      onSelected: (_) => context.read<AnalyticsBloc>().add(
                        AnalyticsClassSelected(c.name),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (data == null || state.loading)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                ChartCard(
                  title: l.sectionAttendanceTrend,
                  child: data.hasAttendance
                      ? AttendanceTrendChart(values: data.attendanceTrend)
                      : EmptyState(
                          icon: Icons.show_chart,
                          message: l.emptyTrend,
                        ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ChartCard(
                  title: l.sectionSubjectAverages,
                  child: data.subjectAverages.isEmpty
                      ? EmptyState(icon: Icons.bar_chart, message: l.emptyMarks)
                      : SubjectAveragesChart(scores: data.subjectAverages),
                ),
                const SizedBox(height: AppSpacing.lg),
                const FeeCollectionCard(),
                const SizedBox(height: AppSpacing.lg),
                SectionTitle(l.sectionTeacherReport),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    l.teacherReportWindow(AnalyticsBloc.teacherWindowDays),
                    style: context.text.labelSmall,
                  ),
                ),
                for (final t in state.teachers) ...[
                  TeacherReportCard(report: t),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
