import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../bloc/accessory_records_cubit.dart';
import '../widgets/issue_log_card.dart';

/// Everything that was given to students, newest first, with the receipt,
/// who received it and the proof.
class AccessoryRecordsScreen extends StatelessWidget {
  const AccessoryRecordsScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<AccessoryRecordsCubit>()..load(),
        child: const AccessoryRecordsScreen(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.accRecordsTitle)),
      body: BlocBuilder<AccessoryRecordsCubit, AccessoryRecordsState>(
        builder: (context, s) {
          if (s.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.records.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              message: l.accNoRecords,
            );
          }
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              for (final r in s.records) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(
                    [
                      r.studentName,
                      if (r.className != null) l.classLabel(r.className!),
                    ].join(' · '),
                    style: context.text.labelMedium,
                  ),
                ),
                IssueLogCard(issue: r.issue),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }
}
