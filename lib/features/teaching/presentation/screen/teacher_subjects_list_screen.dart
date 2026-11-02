import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../../domain/entities/teaching_assignment.dart';
import '../bloc/teaching_bloc.dart';
import 'subjects_screen.dart';

/// Every teacher, with how many subjects they are allowed to teach. Opening
/// one lets the Principal allot or remove subjects.
class TeacherSubjectsListScreen extends StatelessWidget {
  const TeacherSubjectsListScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const TeacherSubjectsListScreen()),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final staff = context.select((StaffBloc b) => b.state.staff);
    final teaching = context.watch<TeachingBloc>().state;
    return Scaffold(
      appBar: AppBar(title: Text(l.teacherSubjectsListTitle)),
      body: ListView(
        padding: AppSpacing.pageOf(context),
        children: [
          for (final t in staff.where((s) => s.active))
            InkWell(
              onTap: () => SubjectsScreen.open(
                context,
                teacherId: t.id,
                teacherName: t.name,
                registeredSubject: t.subject,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    InitialsAvatar(t.name, radius: 18),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: context.text.titleSmall),
                          Text(
                            l.teacherSubjectsLine(
                              teaching
                                  .of(t.id)
                                  .where(
                                    (a) =>
                                        a.status == AssignmentStatus.approved,
                                  )
                                  .length,
                            ),
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
