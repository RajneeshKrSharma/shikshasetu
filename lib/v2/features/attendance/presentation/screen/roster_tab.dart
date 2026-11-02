import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../domain/entities/attendance.dart';
import '../bloc/roster_bloc.dart';
import '../widgets/attendance_labels.dart';
import '../widgets/class_day_bar.dart';

/// Marks a class present, late or absent for a day.
class RosterTab extends StatelessWidget {
  const RosterTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<RosterBloc, RosterState>(
      failureOf: (s) => s.failure,
      child: BlocConsumer<RosterBloc, RosterState>(
        listenWhen: (a, b) => b.savedCount > a.savedCount,
        listener: (context, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.attSaved))),
        builder: (context, state) => Column(
          children: [
            ClassDayBar(
              classes: state.classes,
              classId: state.classId,
              day: state.day,
              onClass: (id) =>
                  context.read<RosterBloc>().add(RosterClassChosen(id)),
              onDay: (d) => context.read<RosterBloc>().add(RosterDayChosen(d)),
            ),
            if (state.canMark && state.lines.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => context.read<RosterBloc>().add(
                        const AllMarkedPresent(),
                      ),
                      icon: const Icon(Icons.done_all),
                      label: Text(l.attMarkAll),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: AppSizes.dialogButton,
                      ),
                      onPressed: state.busy
                          ? null
                          : () => context.read<RosterBloc>().add(
                              const RosterSaved(),
                            ),
                      child: Text(l.attSave),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: AsyncBody(
                status: state.status,
                failure: state.failure,
                onRetry: () =>
                    context.read<RosterBloc>().add(const RosterStarted()),
                isEmpty: state.lines.isEmpty,
                emptyText: state.classes.isEmpty
                    ? l.feeNoClasses
                    : l.attRosterEmpty,
                emptyIcon: Icons.how_to_reg_outlined,
                builder: (context) => ListView(
                  padding: AppSpacing.page,
                  children: [
                    for (final line in state.lines)
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
                                      line.name,
                                      style: context.text.titleSmall,
                                    ),
                                    Text(
                                      l.stuRoll(line.rollNumber),
                                      style: context.text.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              SegmentedButton<StudentMark>(
                                showSelectedIcon: false,
                                emptySelectionAllowed: true,
                                selected: {if (line.mark != null) line.mark!},
                                onSelectionChanged: state.canMark
                                    ? (s) {
                                        if (s.isNotEmpty) {
                                          context.read<RosterBloc>().add(
                                            StudentMarked(
                                              line.studentId,
                                              s.first,
                                            ),
                                          );
                                        }
                                      }
                                    : null,
                                segments: [
                                  for (final m in StudentMark.values)
                                    ButtonSegment(
                                      value: m,
                                      label: Text(m.label(l).characters.first),
                                      tooltip: m.label(l),
                                    ),
                                ],
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
