import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/date_range_chips.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/student_report_bloc.dart';

/// A class's attendance over a period, student by student.
class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<StudentReportBloc, StudentReportState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<StudentReportBloc, StudentReportState>(
        builder: (context, state) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: state.classId,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.fieldClass),
                    items: [
                      for (final c in state.classes)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        context.read<StudentReportBloc>().add(
                          ReportClassChosen(v),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DateRangeChips(
                    value: state.range,
                    onChanged: (r) {
                      if (r != null) {
                        context.read<StudentReportBloc>().add(
                          ReportRangeChosen(r),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncBody(
                status: state.status,
                failure: state.failure,
                onRetry: () => context.read<StudentReportBloc>().add(
                  const StudentReportStarted(),
                ),
                isEmpty: state.tallies.isEmpty,
                emptyText: state.range == null
                    ? l.attReportNeedsRange
                    : l.attRosterEmpty,
                emptyIcon: Icons.assessment_outlined,
                builder: (context) => ListView(
                  padding: AppSpacing.page,
                  children: [
                    for (final t in state.tallies)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.name,
                                      style: context.text.titleSmall,
                                    ),
                                    Text(
                                      l.attTally(t.present, t.late, t.absent),
                                      style: context.text.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
