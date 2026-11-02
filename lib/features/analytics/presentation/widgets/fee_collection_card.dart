import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../fees/presentation/bloc/fees_bloc.dart';

/// Donut of fees collected vs pending, from the shared fees state.
class FeeCollectionCard extends StatelessWidget {
  const FeeCollectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<FeesBloc, FeesState>(
      builder: (context, fees) {
        final total = fees.totalOf(null);
        final paid = fees.paidOf(null);
        final ratio = total == 0 ? 0.0 : paid / total;
        return AppCard(
          child: Row(
            children: [
              SizedBox(
                height: 90,
                width: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                        sections: [
                          PieChartSectionData(
                            value: paid.toDouble(),
                            color: AppColors.present,
                            radius: 14,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: (total - paid).toDouble(),
                            color: AppColors.absent,
                            radius: 14,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      l.percentValue((ratio * 100).round()),
                      style: context.text.titleSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.sectionFeeCollection,
                      style: context.text.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${l.feesCollected}: ${formatRupees(context, paid)}',
                      style: context.text.bodyMedium!.copyWith(
                        color: AppColors.present,
                      ),
                    ),
                    Text(
                      '${l.feesPending}: ${formatRupees(context, total - paid)}',
                      style: context.text.bodyMedium!.copyWith(
                        color: AppColors.absent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
