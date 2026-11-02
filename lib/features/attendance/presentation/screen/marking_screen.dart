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
import '../bloc/marking_bloc.dart';
import '../widgets/marking_widgets.dart';

/// Marks (or, read-only, shows) a class's attendance for today.
class MarkingScreen extends StatelessWidget {
  const MarkingScreen({
    super.key,
    required this.classSection,
    this.readOnly = false,
  });

  final String classSection;
  final bool readOnly;

  /// Opens the screen with its own [MarkingBloc] built from today's data.
  static Future<void> open(
    BuildContext context,
    String classSection, {
    bool readOnly = false,
  }) {
    final state = context.read<AttendanceBloc>().state;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<MarkingBloc>(
            param1: MarkingArgs(
              classSection: classSection,
              students: state.studentsOf(classSection),
              saved: state.marksOf(classSection),
            ),
          ),
          child: MarkingScreen(classSection: classSection, readOnly: readOnly),
        ),
      ),
    );
  }

  Future<bool> _confirmDiscard(BuildContext context) async {
    final l = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.dialogUnsavedTitle),
        content: Text(l.dialogUnsavedBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.actionKeepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.actionDiscard),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<MarkingBloc, MarkingState>(
      listenWhen: (a, b) => !a.saved && b.saved,
      listener: (context, state) {
        context.read<AttendanceBloc>().add(const AttendanceRefreshed());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageAttendanceSaved)));
        Navigator.of(context).pop();
      },
      builder: (context, state) {
        final students = context.read<AttendanceBloc>().state.studentsOf(
          classSection,
        );
        return PopScope(
          canPop: !state.dirty,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final navigator = Navigator.of(context);
            if (await _confirmDiscard(context)) navigator.pop();
          },
          child: Scaffold(
            appBar: AppBar(title: Text(l.markingTitle(classSection))),
            body: Column(
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
                          formatLongDate(context, DateTime.now()),
                          style: context.text.bodySmall,
                        ),
                      ),
                      for (final s in AttendanceStatus.values)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 6),
                          child: StatusCount(status: s, count: state.count(s)),
                        ),
                    ],
                  ),
                ),
                if (!readOnly && students.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: () => context.read<MarkingBloc>().add(
                          const AllMarkedPresent(),
                        ),
                        icon: const Icon(Icons.done_all),
                        label: Text(l.actionMarkAllPresent),
                      ),
                    ),
                  ),
                Expanded(
                  child: students.isEmpty
                      ? EmptyState(
                          icon: Icons.group_off_outlined,
                          message: l.emptyStudents,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.xs,
                            AppSpacing.lg,
                            AppSpacing.lg,
                          ),
                          itemCount: students.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (_, i) {
                            final s = students[i];
                            return StudentMarkRow(
                              student: s,
                              status: state.marks[s.id]!,
                              readOnly: readOnly,
                              onChanged: (v) => context.read<MarkingBloc>().add(
                                MarkChanged(s.id, v),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            bottomNavigationBar: (readOnly || students.isEmpty)
                ? null
                : SafeArea(
                    child: Padding(
                      padding: AppSpacing.pageOf(context),
                      child: FilledButton(
                        onPressed: state.saving
                            ? null
                            : () => context.read<MarkingBloc>().add(
                                const MarksSaveRequested(),
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
      },
    );
  }
}
