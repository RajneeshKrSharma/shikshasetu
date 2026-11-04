import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/server/json.dart';
import '../../domain/entities/timetable.dart';
import '../bloc/timetable_bloc.dart';

/// One subject: its date, and (when the school shows times) start time,
/// duration and marks. Anything left empty uses the school's default.
class TimetableRowCard extends StatelessWidget {
  const TimetableRowCard({
    super.key,
    required this.index,
    required this.row,
    required this.settings,
  });

  final int index;
  final TimetableRow row;
  final TimetableSettings settings;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<TimetableBloc>();
    void change(TimetableRow next) =>
        bloc.add(TimetableRowChanged(index, next));
    final day = row.heldOn;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.subject, style: context.text.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: PickerField(
                  label: l.ttbDate,
                  value: day == null
                      ? null
                      : '${formatWeekdayShort(context, day)}, '
                            '${formatShortDate(context, day)}',
                  onTap: () async {
                    final today = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: settings.firstOpenDay(day ?? today),
                      firstDate: DateTime(today.year, today.month, today.day),
                      lastDate: DateTime(
                        today.year + 3,
                        today.month,
                        today.day,
                      ),
                      selectableDayPredicate: (d) => !settings.isOffDay(d),
                    );
                    if (picked != null) change(row.copyWith(heldOn: picked));
                  },
                ),
              ),
              if (day != null)
                IconButton(
                  tooltip: l.actionRemove,
                  icon: const Icon(Icons.close),
                  onPressed: () => change(row.copyWith(clearDate: true)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              if (settings.showTime)
                SizedBox(
                  width: 170,
                  child: PickerField(
                    label: l.ttbStart,
                    suffixIcon: Icons.schedule,
                    value: row.startsAtMinutes == null
                        ? null
                        : WireFormat.minutes(row.startsAtMinutes!),
                    helperText: settings.defaultStartMinutes == null
                        ? null
                        : WireFormat.minutes(settings.defaultStartMinutes!),
                    onTap: () async {
                      final start =
                          row.startsAtMinutes ?? settings.defaultStartMinutes;
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: start == null
                            ? TimeOfDay.now()
                            : TimeOfDay(hour: start ~/ 60, minute: start % 60),
                      );
                      if (picked != null) {
                        change(
                          row.copyWith(
                            startsAtMinutes: picked.hour * 60 + picked.minute,
                          ),
                        );
                      }
                    },
                  ),
                ),
              if (settings.showTime)
                SizedBox(
                  width: 130,
                  child: _NumberField(
                    label: l.ttbDuration,
                    hint: '${settings.defaultDurationMinutes}',
                    initial: row.durationMinutes,
                    onChanged: (v) => change(
                      v == null
                          ? row.copyWith(clearDuration: true)
                          : row.copyWith(durationMinutes: v),
                    ),
                  ),
                ),
              SizedBox(
                width: 110,
                child: _NumberField(
                  label: l.ttbMarks,
                  hint: '${settings.defaultMaxMarks}',
                  initial: row.maxMarks,
                  onChanged: (v) => change(
                    v == null
                        ? row.copyWith(clearMarks: true)
                        : row.copyWith(maxMarks: v),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A whole-number field that shows the school's default as a grey hint while
/// empty.
class _NumberField extends StatefulWidget {
  const _NumberField({
    required this.label,
    required this.hint,
    required this.initial,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final int? initial;
  final ValueChanged<int?> onChanged;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initial == null ? '' : '${widget.initial}',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: widget.label, hintText: widget.hint),
    onChanged: (v) => widget.onChanged(int.tryParse(v.trim())),
  );
}
