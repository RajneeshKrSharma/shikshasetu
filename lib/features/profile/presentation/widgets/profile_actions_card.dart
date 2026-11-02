import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../demo_data/presentation/widgets/demo_data_dialog.dart';
import '../../../backup/presentation/screen/backup_screen.dart';
import '../../../data_monitor/presentation/screen/data_monitor_screen.dart';
import '../../../face_id/presentation/screen/face_id_screen.dart';
import '../../../cloud_sync/presentation/screen/cloud_sync_screen.dart';
import '../../../settings/presentation/screen/school_logo_screen.dart';
import '../../../settings/presentation/screen/school_settings_screen.dart';
import '../../../attendance/presentation/screen/attendance_screen.dart';
import '../../../notices/presentation/screen/notices_screen.dart';
import '../../../school_calendar/presentation/screen/school_calendar_screen.dart';
import 'profile_dialogs.dart';

/// Edit profile, change password, and (Principal) school settings + backup.
class ProfileActionsCard extends StatelessWidget {
  const ProfileActionsCard({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = <(IconData, String, VoidCallback)>[
      if (!user.isPrincipal) ...[
        (
          Icons.history,
          l.profileCheckInHistory,
          () => AttendanceScreen.open(context),
        ),
        (
          Icons.face_retouching_natural,
          l.faceTitle,
          () => FaceIdScreen.open(
            context,
            teacherId: user.id,
            teacherName: user.name,
            canManage: false,
          ),
        ),
        (
          Icons.event_outlined,
          l.profileCalendarHolidays,
          () => SchoolCalendarScreen.open(context),
        ),
        (
          Icons.campaign_outlined,
          l.noticesTitle,
          () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const NoticesScreen()),
          ),
        ),
      ],
      (
        Icons.alternate_email,
        l.actionChangeEmail,
        () => showChangeEmailDialog(context),
      ),
      (
        Icons.lock_reset,
        l.actionChangePassword,
        () => showChangePasswordDialog(context, user.id),
      ),
      if (user.isPrincipal) ...[
        (
          Icons.location_on_outlined,
          l.schoolSettingsTitle,
          () => SchoolSettingsScreen.open(context),
        ),
        (
          Icons.image_outlined,
          l.logoTitle,
          () => SchoolLogoScreen.open(context),
        ),
        (
          Icons.cloud_sync_outlined,
          l.cloudTitle,
          () => CloudSyncScreen.open(context),
        ),
        (
          Icons.backup_outlined,
          l.backupTitle,
          () => BackupScreen.open(context),
        ),
        (
          Icons.monitor_heart_outlined,
          l.monTitle,
          () => DataMonitorScreen.open(context),
        ),
        // For trying the app out; never shown in a release build.
        if (kDebugMode)
          (
            Icons.science_outlined,
            l.demoDataTitle,
            () => DemoDataDialog.show(context),
          ),
      ],
    ];
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              leading: Icon(items[i].$1, color: context.brand.primary),
              title: Text(items[i].$2, style: context.text.bodyLarge),
              trailing: const Icon(Icons.chevron_right),
              onTap: items[i].$3,
            ),
            if (i != items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
