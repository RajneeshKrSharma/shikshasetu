import '../../../../core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';

/// A titled card that holds a fixed-height chart.
class ChartCard extends StatelessWidget {
  const ChartCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.text.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(height: 180, child: child),
        ],
      ),
    );
  }
}

FlTitlesData _titles({
  required Widget Function(double, TitleMeta) bottom,
  required double leftInterval,
  required Color labelColor,
}) => FlTitlesData(
  topTitles: const AxisTitles(),
  rightTitles: const AxisTitles(),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: leftInterval,
      getTitlesWidget: (v, meta) => Text(
        v.toInt().toString(),
        style: TextStyle(fontSize: 11, color: labelColor),
      ),
    ),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 24,
      interval: 1,
      getTitlesWidget: bottom,
    ),
  ),
);

/// Attendance % per day for the last days, oldest first.
class AttendanceTrendChart extends StatelessWidget {
  const AttendanceTrendChart({super.key, required this.values});

  final List<double?> values;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final today = DateTime.now();

    return LineChart(
      LineChartData(
        minY: 60,
        maxY: 100,
        gridData: const FlGridData(drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: _titles(
          labelColor: AppColors.textMuted,
          leftInterval: 10,
          bottom: (v, meta) {
            final day = today.subtract(
              Duration(days: values.length - 1 - v.toInt()),
            );
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                DateFormat.E(locale).format(day),
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                values[i] == null
                    ? FlSpot.nullSpot
                    : FlSpot(i.toDouble(), values[i]!),
            ],
            isCurved: true,
            color: context.brand.primary,
            barWidth: 3,
            dotData: const FlDotData(),
            belowBarData: BarAreaData(
              show: true,
              color: context.brand.primaryLight.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Average marks % per subject.
class SubjectAveragesChart extends StatelessWidget {
  const SubjectAveragesChart({super.key, required this.scores});

  final Map<String, double> scores;

  @override
  Widget build(BuildContext context) {
    final entries = scores.entries.toList();
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: _titles(
          labelColor: AppColors.textMuted,
          leftInterval: 25,
          bottom: (v, meta) => Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              entries[v.toInt()].key,
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < entries.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: entries[i].value,
                  width: 22,
                  color: context.brand.accent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
