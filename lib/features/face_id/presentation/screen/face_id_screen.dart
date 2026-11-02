import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/face_id_cubit.dart';

/// A teacher's Face ID: set it up, set it up again, or remove it. A teacher
/// can set up their own when it is not set up yet; replacing or removing is
/// for the Principal ([canManage]).
class FaceIdScreen extends StatelessWidget {
  const FaceIdScreen({
    super.key,
    required this.teacherId,
    required this.teacherName,
    required this.canManage,
  });

  final String teacherId;
  final String teacherName;
  final bool canManage;

  static Future<void> open(
    BuildContext context, {
    required String teacherId,
    required String teacherName,
    required bool canManage,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => FaceIdScreen(
        teacherId: teacherId,
        teacherName: teacherName,
        canManage: canManage,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = context.read<AuthBloc>().state.user?.id;
    return BlocProvider(
      create: (_) => sl<FaceIdCubit>(
        param1: FaceIdArgs(
          teacherId: teacherId,
          teacherName: teacherName,
          enrolledBy: me,
        ),
      )..load(),
      child: BlocConsumer<FaceIdCubit, FaceIdState>(
        listenWhen: (a, b) => a.noticeId != b.noticeId && b.notice != null,
        listener: (context, s) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(switch (s.notice!) {
              FaceIdNotice.setUp => l.faceSetUpDone,
              FaceIdNotice.removed => l.faceRemoved,
              FaceIdNotice.notFound => l.faceErrNotFound,
              FaceIdNotice.unavailable => l.faceErrUnavailable,
            }),
          ),
        ),
        builder: (context, s) {
          final cubit = context.read<FaceIdCubit>();
          return Scaffold(
            appBar: AppBar(title: Text(l.faceTitle)),
            body: s.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: AppSpacing.pageOf(context),
                    children: [
                      Text(l.faceIntro, style: context.text.bodySmall),
                      const SizedBox(height: AppSpacing.xl),
                      AppCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: s.isEnrolled
                                  ? AppColors.presentLight
                                  : AppColors.pendingLight,
                              child: Icon(
                                s.isEnrolled
                                    ? Icons.verified_user_outlined
                                    : Icons.face_retouching_off,
                                color: s.isEnrolled
                                    ? AppColors.present
                                    : AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacherName,
                                    style: context.text.titleMedium,
                                  ),
                                  Text(
                                    s.isEnrolled
                                        ? l.faceStatusOn
                                        : l.faceStatusOff,
                                    style: context.text.bodyMedium,
                                  ),
                                  if (s.isEnrolled)
                                    Text(
                                      l.faceEnrolledOn(
                                        formatShortDate(context, s.enrolledAt!),
                                      ),
                                      style: context.text.labelSmall,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (!s.isEnrolled || canManage)
                        FilledButton.icon(
                          onPressed: s.busy ? null : cubit.setUp,
                          icon: const Icon(Icons.face),
                          label: Text(
                            s.isEnrolled ? l.faceReplace : l.faceSetUp,
                          ),
                        ),
                      if (s.isEnrolled && canManage) ...[
                        const SizedBox(height: AppSpacing.md),
                        OutlinedButton.icon(
                          onPressed: s.busy ? null : cubit.remove,
                          icon: const Icon(Icons.delete_outline),
                          label: Text(l.faceRemove),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}
