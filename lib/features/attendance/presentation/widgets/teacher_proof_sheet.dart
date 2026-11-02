import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/entities/check_point.dart';
import '../../domain/entities/teacher_attendance.dart';

/// The selfie and distance recorded at check-in and check-out.
class TeacherProofSheet extends StatelessWidget {
  const TeacherProofSheet({super.key, required this.record});

  final TeacherAttendance record;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.teacherName, style: context.text.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Proof(
                    title: l.labelCheckIn,
                    time: record.checkIn,
                    point: record.checkInPoint,
                  ),
                ),
                if (record.checkOut != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _Proof(
                      title: l.labelCheckOut,
                      time: record.checkOut,
                      point: record.checkOutPoint,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Proof extends StatelessWidget {
  const _Proof({required this.title, this.time, this.point});

  final String title;
  final DateTime? time;
  final CheckPoint? point;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final selfie = point?.selfiePath;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.text.labelSmall),
        Text(formatTime(context, time), style: context.text.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.mdAll,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: selfie != null && File(selfie).existsSync()
                ? Image.file(File(selfie), fit: BoxFit.cover)
                : Container(
                    color: AppColors.pendingLight,
                    child: Icon(
                      Icons.no_photography_outlined,
                      color: AppColors.textMuted,
                    ),
                  ),
          ),
        ),
        if (point != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.distanceFromSchool(point!.distanceMeters.round()),
            style: context.text.labelSmall,
          ),
          if (point!.faceScore != null)
            Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: AppIconSize.sm,
                  color: AppColors.present,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l.faceScore((point!.faceScore! * 100).round()),
                  style: context.text.labelSmall,
                ),
              ],
            ),
        ],
      ],
    );
  }
}
