import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/server/json.dart';
import '../../../exams/domain/entities/exams.dart';
import '../../domain/entities/timetable.dart';
import '../bloc/timetable_bloc.dart';

/// The papers already scheduled for the class, soonest first.
class SavedTimetable extends StatelessWidget {
  const SavedTimetable({
    super.key,
    required this.exams,
    required this.settings,
  });

  final List<Exam> exams;
  final TimetableSettings settings;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (exams.isEmpty) return Text(l.ttbNoneSaved);
    return Column(
      children: [
        for (final e in exams)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Column(
                      children: [
                        Text(
                          formatDayOfMonth(e.heldOn),
                          style: context.text.titleLarge,
                        ),
                        Text(
                          formatMonthShort(context, e.heldOn),
                          style: context.text.labelMedium,
                        ),
                        Text(
                          formatWeekdayShort(context, e.heldOn),
                          style: context.text.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.subject, style: context.text.titleSmall),
                        Text(_detail(l.ttbMarks, l.ttbDuration, e)),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l.actionDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmRemove(context, e),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _detail(String marks, String minutes, Exam e) => [
    if (settings.showTime && e.startsAtMinutes != null)
      WireFormat.minutes(e.startsAtMinutes!),
    if (settings.showTime && e.durationMinutes != null)
      '${e.durationMinutes} $minutes',
    '$marks ${e.maxMarks}',
  ].join(' · ');

  Future<void> _confirmRemove(BuildContext context, Exam e) async {
    final l = context.l10n;
    final bloc = context.read<TimetableBloc>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l.exmRemoveAsk),
        content: Text('${e.subject}, ${formatShortDate(dialog, e.heldOn)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(l.actionDelete),
          ),
        ],
      ),
    );
    if (ok ?? false) bloc.add(TimetableExamRemoved(e.id));
  }
}
