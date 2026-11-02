import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/analytics.dart';
import 'analytics_labels.dart';

/// One series drawn as a line or as bars, in a titled card.
class SeriesChart extends StatelessWidget {
  const SeriesChart({super.key, required this.series});

  final ChartSeries series;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(series.id.label(l), style: context.text.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: switch (series.shape) {
              SeriesShape.line => _Line(series: series),
              SeriesShape.bar => _Bars(series: series),
            },
          ),
        ],
      ),
    );
  }
}

String _label(BuildContext context, ChartPoint p) {
  final at = p.at;
  if (at == null) return p.label;
  return DateFormat.MMMd(Localizations.localeOf(context).toString()).format(at);
}

FlTitlesData _titles(BuildContext context, ChartSeries series) {
  final every = (series.points.length / 5).ceil().clamp(1, 1000);
  const muted = TextStyle(fontSize: 11, color: AppColors.textMuted);
  return FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 44,
        getTitlesWidget: (v, meta) => Text(
          v == meta.max || v == meta.min
              ? ''
              : NumberFormat.compact().format(v),
          style: muted,
        ),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        interval: 1,
        getTitlesWidget: (v, meta) {
          final i = v.toInt();
          if (v != i.toDouble() ||
              i < 0 ||
              i >= series.points.length ||
              i % every != 0) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _label(context, series.points[i]),
              style: muted,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    ),
  );
}

class _Line extends StatelessWidget {
  const _Line({required this.series});

  final ChartSeries series;

  @override
  Widget build(BuildContext context) => LineChart(
    LineChartData(
      minY: 0,
      gridData: const FlGridData(drawVerticalLine: false),
      borderData: FlBorderData(show: false),
      titlesData: _titles(context, series),
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (var i = 0; i < series.points.length; i++)
              FlSpot(i.toDouble(), series.points[i].value),
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

class _Bars extends StatelessWidget {
  const _Bars({required this.series});

  final ChartSeries series;

  @override
  Widget build(BuildContext context) => BarChart(
    BarChartData(
      minY: 0,
      gridData: const FlGridData(drawVerticalLine: false),
      borderData: FlBorderData(show: false),
      titlesData: _titles(context, series),
      barGroups: [
        for (var i = 0; i < series.points.length; i++)
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: series.points[i].value,
                color: context.brand.primary,
                width: 14,
                borderRadius: AppRadius.smAll,
              ),
            ],
          ),
      ],
    ),
  );
}
