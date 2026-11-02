import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../students/domain/entities/student.dart';
import '../../domain/entities/attendance_status.dart';
import 'attendance_status_style.dart';

/// "P 12" style count chip.
class StatusCount extends StatelessWidget {
  const StatusCount({super.key, required this.status, required this.count});

  final AttendanceStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    return StatusChip(
      label: '${status.shortLabel(context.l10n)} $count',
      color: status.color,
      background: status.background,
    );
  }
}

/// One person with P / A / L buttons (or a read-only chip). [leading] is a
/// short mark in front of the name, such as a roll number.
class MarkRow extends StatelessWidget {
  const MarkRow({
    super.key,
    required this.leading,
    required this.title,
    required this.status,
    required this.readOnly,
    required this.onChanged,
    this.subtitle,
  });

  final String leading;
  final String title;
  final String? subtitle;
  final AttendanceStatus status;
  final bool readOnly;
  final ValueChanged<AttendanceStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 10,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(leading, style: context.text.bodySmall),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.bodyLarge),
                  if (subtitle != null)
                    Text(subtitle!, style: context.text.bodySmall),
                ],
              ),
            ),
            if (readOnly)
              StatusChip(
                label: status.label(context.l10n),
                color: status.color,
                background: status.background,
              )
            else
              Row(
                children: [
                  for (final s in AttendanceStatus.values)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 6),
                      child: _StatusButton(
                        status: s,
                        selected: s == status,
                        onTap: () => onChanged(s),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// One student with P / A / L buttons (or a read-only chip).
class StudentMarkRow extends StatelessWidget {
  const StudentMarkRow({
    super.key,
    required this.student,
    required this.status,
    required this.readOnly,
    required this.onChanged,
  });

  final Student student;
  final AttendanceStatus status;
  final bool readOnly;
  final ValueChanged<AttendanceStatus> onChanged;

  @override
  Widget build(BuildContext context) => MarkRow(
    leading: '${student.rollNo}',
    title: student.name,
    status: status,
    readOnly: readOnly,
    onChanged: onChanged,
  );
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final AttendanceStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.smAll,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? status.color : Colors.transparent,
          borderRadius: AppRadius.smAll,
          border: Border.all(color: selected ? status.color : AppColors.border),
        ),
        child: Text(
          status.shortLabel(context.l10n),
          style: context.text.titleSmall!.copyWith(
            color: selected ? context.brand.onPrimary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
