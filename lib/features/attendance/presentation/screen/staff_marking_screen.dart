import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/attendance_status.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/staff_marking_bloc.dart';
import '../widgets/marking_widgets.dart';

/// The Principal marks other staff (driver, helper...) for a day.
class StaffMarkingScreen extends StatelessWidget {
  const StaffMarkingScreen({super.key, required this.day});

  final DateTime day;

  static Future<void> open(BuildContext context, DateTime day) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<StaffMarkingBloc>(param1: day)
                  ..add(const StaffMarkingStarted()),
            child: StaffMarkingScreen(day: day),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<StaffMarkingBloc, StaffMarkingState>(
      listenWhen: (a, b) => !a.saved && b.saved,
      listener: (context, state) {
        // The dashboard counts who is in.
        context.read<AttendanceBloc>().add(const AttendanceRefreshed());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageAttendanceSaved)));
        Navigator.of(context).pop();
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(l.attStaffMarkTitle)),
        body: state.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatLongDate(context, day),
                            style: context.text.bodySmall,
                          ),
                        ),
                        for (final s in AttendanceStatus.values)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 6),
                            child: StatusCount(
                              status: s,
                              count: state.count(s),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (state.staff.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          onPressed: () => context.read<StaffMarkingBloc>().add(
                            const AllStaffMarkedPresent(),
                          ),
                          icon: const Icon(Icons.done_all),
                          label: Text(l.actionMarkAllPresent),
                        ),
                      ),
                    ),
                  Expanded(
                    child: state.staff.isEmpty
                        ? EmptyState(
                            icon: Icons.group_off_outlined,
                            message: l.emptyStaff,
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.xs,
                              AppSpacing.lg,
                              AppSpacing.lg,
                            ),
                            itemCount: state.staff.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (_, i) {
                              final s = state.staff[i];
                              return MarkRow(
                                leading: '${i + 1}',
                                title: s.name,
                                subtitle: s.role,
                                status: state.marks[s.staffId]!,
                                readOnly: false,
                                onChanged: (v) => context
                                    .read<StaffMarkingBloc>()
                                    .add(StaffMarkChanged(s.staffId, v)),
                              );
                            },
                          ),
                  ),
                ],
              ),
        bottomNavigationBar: state.staff.isEmpty
            ? null
            : SafeArea(
                child: Padding(
                  padding: AppSpacing.pageOf(context),
                  child: FilledButton(
                    onPressed: state.saving
                        ? null
                        : () => context.read<StaffMarkingBloc>().add(
                            const StaffMarksSaveRequested(),
                          ),
                    child: state.saving
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: context.brand.onPrimary,
                            ),
                          )
                        : Text(l.actionSaveAttendance),
                  ),
                ),
              ),
      ),
    );
  }
}
