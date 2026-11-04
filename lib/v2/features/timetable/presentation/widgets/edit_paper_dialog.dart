import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../core/server/json.dart';
import '../../../exams/domain/entities/exams.dart';
import '../../domain/entities/timetable.dart';

/// Changes a saved paper's date, marks and (when the school shows times) start
/// time and duration. Pops an [ExamDraft] with what was set, or nothing.
class EditPaperDialog extends StatefulWidget {
  const EditPaperDialog({
    super.key,
    required this.exam,
    required this.settings,
  });

  final Exam exam;
  final TimetableSettings settings;

  @override
  State<EditPaperDialog> createState() => _EditPaperDialogState();
}

class _EditPaperDialogState extends State<EditPaperDialog> {
  late final ValueNotifier<DateTime> _day;
  late final ValueNotifier<int?> _start;
  late final TextEditingController _marks;
  late final TextEditingController _duration;

  @override
  void initState() {
    super.initState();
    final e = widget.exam;
    _day = ValueNotifier(e.heldOn);
    _start = ValueNotifier(e.startsAtMinutes);
    _marks = TextEditingController(text: '${e.maxMarks}');
    _duration = TextEditingController(text: '${e.durationMinutes ?? ''}');
  }

  @override
  void dispose() {
    _day.dispose();
    _start.dispose();
    _marks.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _day.value,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 3, today.month, today.day),
      selectableDayPredicate: (d) => !widget.settings.isOffDay(d),
    );
    if (picked != null) _day.value = picked;
  }

  Future<void> _pickStart() async {
    final now = _start.value ?? widget.settings.defaultStartMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: now == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: now ~/ 60, minute: now % 60),
    );
    if (picked != null) _start.value = picked.hour * 60 + picked.minute;
  }

  void _save() {
    final e = widget.exam;
    Navigator.pop(
      context,
      ExamDraft(
        id: e.id,
        type: e.type,
        classId: e.classId,
        subject: e.subject,
        heldOn: _day.value,
        maxMarks: int.tryParse(_marks.text.trim()) ?? e.maxMarks,
        startsAtMinutes: _start.value,
        durationMinutes: int.tryParse(_duration.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.exam.subject),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _day,
              builder: (context, day, _) => PickerField(
                label: l.ttbDate,
                value:
                    '${formatWeekdayShort(context, day)}, '
                    '${formatShortDate(context, day)}',
                onTap: _pickDay,
              ),
            ),
            if (widget.settings.showTime) ...[
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<int?>(
                valueListenable: _start,
                builder: (context, start, _) => PickerField(
                  label: l.ttbStart,
                  suffixIcon: Icons.schedule,
                  value: start == null ? null : WireFormat.minutes(start),
                  onTap: _pickStart,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _duration,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.ttbDuration),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _marks,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l.ttbMarks),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.actionCancel),
        ),
        FilledButton(onPressed: _save, child: Text(l.actionSave)),
      ],
    );
  }
}
