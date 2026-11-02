import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../students/domain/entities/school_class.dart';

/// A class dropdown beside a day picker.
class ClassDayBar extends StatelessWidget {
  const ClassDayBar({
    super.key,
    required this.classes,
    required this.classId,
    required this.day,
    required this.onClass,
    required this.onDay,
  });

  final List<SchoolClass> classes;
  final String? classId;
  final DateTime day;
  final ValueChanged<String> onClass;
  final ValueChanged<DateTime> onDay;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: classId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.fieldClass),
              items: [
                for (final c in classes)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) {
                if (v != null) onClass(v);
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: PickerField(
              label: l.attDay,
              value: formatShortDate(context, day),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: day,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) onDay(picked);
              },
            ),
          ),
        ],
      ),
    );
  }
}
