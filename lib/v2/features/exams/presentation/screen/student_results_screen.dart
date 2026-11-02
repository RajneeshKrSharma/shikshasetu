import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../di/v2_injector.dart';
import '../bloc/student_results_bloc.dart';
import '../widgets/exam_labels.dart';

/// All the exams of one student, with the marks and the total.
class StudentResultsScreen extends StatelessWidget {
  const StudentResultsScreen({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) =>
          sl<StudentResultsBloc>(param1: studentId)
            ..add(const StudentResultsStarted()),
      child: Scaffold(
        appBar: AppBar(title: Text(l.exmStudentResults)),
        body: BlocBuilder<StudentResultsBloc, StudentResultsState>(
          builder: (context, state) => AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () => context.read<StudentResultsBloc>().add(
              const StudentResultsStarted(),
            ),
            isEmpty: state.results?.exams.isEmpty ?? true,
            emptyText: l.exmStudentEmpty,
            emptyIcon: Icons.description_outlined,
            builder: (context) {
              final r = state.results!;
              return ListView(
                padding: AppSpacing.page,
                children: [
                  if (r.percentage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        l.exmStudentTotal(
                          '${r.totalObtained}',
                          '${r.totalOutOf}',
                          r.percentage!,
                        ),
                        style: context.text.titleMedium,
                      ),
                    ),
                  for (final e in r.exams)
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
                                    e.subject,
                                    style: context.text.titleSmall,
                                  ),
                                  Text(
                                    '${e.type.label(l)} · '
                                    '${formatShortDate(context, e.heldOn)}',
                                    style: context.text.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              e.absent
                                  ? l.exmAbsent
                                  : e.marks == null
                                  ? l.exmNotEntered
                                  : l.exmMarksOf(e.marks!, '${e.maxMarks}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
