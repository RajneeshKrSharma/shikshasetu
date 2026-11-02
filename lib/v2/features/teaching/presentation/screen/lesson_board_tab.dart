import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/lesson_board_bloc.dart';

/// For one day: who has recorded their lesson and who has not.
class LessonBoardTab extends StatelessWidget {
  const LessonBoardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<LessonBoardBloc, LessonBoardState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<LessonBoardBloc, LessonBoardState>(
        builder: (context, state) {
          final shown = state.day ?? DateTime.now();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: PickerField(
                  label: l.tchDayPick,
                  value: formatShortDate(context, shown),
                  onTap: () async {
                    final bloc = context.read<LessonBoardBloc>();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: shown,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) bloc.add(LessonBoardDayChosen(picked));
                  },
                ),
              ),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () => context.read<LessonBoardBloc>().add(
                    const LessonBoardStarted(),
                  ),
                  isEmpty: state.rows.isEmpty,
                  emptyText: l.tchBoardEmpty,
                  emptyIcon: Icons.menu_book_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.page,
                    children: [
                      for (final r in state.rows)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        r.allotment.teacherName,
                                        style: context.text.titleSmall,
                                      ),
                                    ),
                                    Icon(
                                      r.recorded
                                          ? Icons.check_circle_outline
                                          : Icons.pending_outlined,
                                      size: AppIconSize.sm,
                                      color: r.recorded
                                          ? context.brand.primary
                                          : null,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      r.recorded ? l.tchRecorded : l.tchPending,
                                      style: context.text.labelSmall,
                                    ),
                                  ],
                                ),
                                Text(
                                  l.tchClassSubject(
                                    r.allotment.className,
                                    r.allotment.subject,
                                  ),
                                  style: context.text.bodySmall,
                                ),
                                if (r.lesson != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.xs,
                                    ),
                                    child: Text(
                                      r.lesson!.topic,
                                      style: context.text.bodyMedium,
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
          );
        },
      ),
    );
  }
}
