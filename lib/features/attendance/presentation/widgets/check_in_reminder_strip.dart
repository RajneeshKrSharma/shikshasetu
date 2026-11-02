import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

/// A red strip for a teacher who has not checked in on a day school is open,
/// so their attendance is not missed. It goes away the moment they check in,
/// and its button does the check-in (location and selfie) right there.
class CheckInReminderStrip extends StatelessWidget {
  const CheckInReminderStrip({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      buildWhen: (a, b) =>
          a.isSchoolOpen != b.isSchoolOpen ||
          a.loading != b.loading ||
          a.checking != b.checking ||
          a.recordOf(user.id)?.checkIn != b.recordOf(user.id)?.checkIn,
      builder: (context, state) {
        final missed =
            !state.loading &&
            state.isSchoolOpen &&
            state.recordOf(user.id)?.isPresent != true;
        if (!missed) return const SizedBox.shrink();
        return Material(
          color: AppColors.absent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _PulsingIcon(),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.attReminderTitle,
                        style: context.text.titleSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.attReminderBody,
                        style: context.text.bodySmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                FilledButton(
                  style: FilledButton.styleFrom(
                    // The theme's buttons fill the width; this one sits in a
                    // row and is only as wide as its label.
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.absent,
                  ),
                  onPressed: state.checking
                      ? null
                      : () => context.read<AttendanceBloc>().add(
                          CheckInRequested(user.id, teacherName: user.name),
                        ),
                  child: state.checking
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l.actionCheckIn),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A warning icon that gently pulses to catch the eye.
class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon();

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const icon = Icon(
      Icons.notification_important_rounded,
      color: Colors.white,
      size: AppIconSize.xl,
    );
    if (MediaQuery.disableAnimationsOf(context)) return icon;
    return ScaleTransition(
      scale: Tween(
        begin: 0.9,
        end: 1.15,
      ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
      child: icon,
    );
  }
}
