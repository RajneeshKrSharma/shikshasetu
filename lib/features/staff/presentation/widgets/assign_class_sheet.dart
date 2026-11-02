import '../../../../l10n/class_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../bloc/staff_bloc.dart';

/// Lets the Principal choose which class a teacher leads.
class AssignClassSheet extends StatelessWidget {
  const AssignClassSheet({super.key, required this.memberId});

  final String memberId;

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
        child: BlocBuilder<StaffBloc, StaffState>(
          builder: (context, staff) {
            final member = staff.staff.firstWhere((m) => m.id == memberId);
            final classes = context.watch<ClassesBloc>().state.classes;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.sheetAssignTitle(member.name),
                  style: context.text.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final c in classes)
                  Builder(
                    builder: (_) {
                      final holder = staff.classTeacherOf(c.name);
                      final takenByOther =
                          holder != null && holder.id != member.id;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        enabled: !takenByOther,
                        title: Text(l.classLabel(c.name)),
                        subtitle: takenByOther
                            ? Text(l.classTakenBy(holder.name))
                            : null,
                        trailing: member.classSection == c.name
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.present,
                              )
                            : null,
                        onTap: takenByOther
                            ? null
                            : () {
                                context.read<StaffBloc>().add(
                                  ClassTeacherAssigned(member.id, c.name),
                                );
                                Navigator.of(context).pop();
                              },
                      );
                    },
                  ),
                if (member.classSection != null)
                  TextButton.icon(
                    onPressed: () {
                      context.read<StaffBloc>().add(
                        ClassTeacherAssigned(member.id, null),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.link_off),
                    label: Text(l.actionRemoveAssignment),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
