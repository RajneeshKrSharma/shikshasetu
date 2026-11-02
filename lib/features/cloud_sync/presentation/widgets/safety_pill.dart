import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../bloc/cloud_sync_cubit.dart';
import '../screen/sync_details_screen.dart';

/// One small pill that says whether the school's data is safe in the cloud:
/// green with the time of the last save, amber while it is being saved, red
/// when it could not be, grey when the cloud is not connected. Tap for the
/// details (and to save now).
class SafetyPill extends StatelessWidget {
  const SafetyPill({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.watch<CloudSyncCubit>().state;
    final at = s.lastRun?.at;
    final (
      IconData icon,
      Color color,
      Color bg,
      String text,
    ) = s.connection?.isReady != true
        ? (
            Icons.cloud_off_outlined,
            AppColors.textMuted,
            AppColors.pendingLight,
            l.safePillOff,
          )
        : s.failing
        ? (
            Icons.error_outline,
            AppColors.absent,
            AppColors.absentLight,
            l.safePillFailed,
          )
        : s.syncing || s.hasPending || at == null
        ? (
            Icons.cloud_upload_outlined,
            AppColors.late,
            AppColors.lateLight,
            l.safePillSaving,
          )
        : (
            Icons.verified_user_outlined,
            AppColors.present,
            AppColors.presentLight,
            l.safePillSafe(formatTime(context, at)),
          );
    return Material(
      color: bg,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => SyncDetailsScreen.open(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppIconSize.sm, color: color),
              const SizedBox(width: AppSpacing.xs + 2),
              Text(
                text,
                style: context.text.labelMedium!.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
