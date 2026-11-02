import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../core/widgets/time_format.dart';
import '../../domain/entities/attendance.dart';
import '../bloc/people_board_bloc.dart';
import '../widgets/attendance_labels.dart';

/// How each teacher and staff member came in on a day.
class PeopleBoardTab extends StatelessWidget {
  const PeopleBoardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<PeopleBoardBloc, PeopleBoardState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<PeopleBoardBloc, PeopleBoardState>(
        builder: (context, state) {
          void filtered({DateTime? day, String? role, bool all = false}) =>
              context.read<PeopleBoardBloc>().add(
                PeopleBoardFiltered(
                  day: day ?? state.day,
                  role: all ? null : (role ?? state.role),
                ),
              );
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    PickerField(
                      label: l.attDay,
                      value: formatShortDate(context, state.day),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.day,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) filtered(day: picked);
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        ChoiceChip(
                          label: Text(l.attAllRoles),
                          selected: state.role == null,
                          onSelected: (_) => filtered(all: true),
                        ),
                        ChoiceChip(
                          label: Text(l.attRoleTeachers),
                          selected: state.role == 'teacher',
                          onSelected: (_) => filtered(role: 'teacher'),
                        ),
                        ChoiceChip(
                          label: Text(l.attRoleStaff),
                          selected: state.role == 'staff',
                          onSelected: (_) => filtered(role: 'staff'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state.board?.isHoliday ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(l.attHolidayToday),
                ),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () => context.read<PeopleBoardBloc>().add(
                    const PeopleBoardStarted(),
                  ),
                  isEmpty: state.board?.people.isEmpty ?? true,
                  emptyText: l.attBoardEmpty,
                  emptyIcon: Icons.groups_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.page,
                    children: [
                      for (final p in state.board!.people)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            onTap: state.canCorrect
                                ? () => _correct(context, state, p)
                                : null,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: context.text.titleSmall,
                                      ),
                                      if (p.checkedInAt != null)
                                        Text(
                                          [
                                            l.attCheckedInAt(
                                              p.checkedInAt!.clock(context),
                                            ),
                                            if (p.checkedOutAt != null)
                                              l.attCheckedOutAt(
                                                p.checkedOutAt!.clock(context),
                                              ),
                                          ].join(' · '),
                                          style: context.text.bodySmall,
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  p.status.label(l),
                                  style: context.text.labelLarge!.copyWith(
                                    color: p.status.color,
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

  Future<void> _correct(
    BuildContext context,
    PeopleBoardState state,
    BoardLine line,
  ) async {
    final l = context.l10n;
    final bloc = context.read<PeopleBoardBloc>();
    final checkedIn = await pickMinute(
      context,
      initial: line.checkedInAt ?? 8 * 60,
    );
    if (checkedIn == null || !context.mounted) return;
    final checkedOut = await showDialog<int?>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.attCheckOutTime),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            onPressed: () async {
              final out = await pickMinute(
                context,
                initial: line.checkedOutAt ?? 15 * 60,
              );
              if (context.mounted) Navigator.pop(context, out ?? -1);
            },
            child: Text(l.attCheckOut),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, -1),
            child: Text(l.actionSave),
          ),
        ],
      ),
    );
    if (checkedOut == null) return;
    bloc.add(
      AttendanceCorrected(
        CorrectionDraft(
          personId: line.personId,
          day: state.day,
          checkedInAt: checkedIn,
          checkedOutAt: checkedOut < 0 ? null : checkedOut,
        ),
      ),
    );
  }
}
