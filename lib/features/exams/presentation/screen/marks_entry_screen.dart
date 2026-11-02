import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../bloc/exams_bloc.dart';
import '../bloc/marks_entry_bloc.dart';

/// Marks each student obtained in a conducted paper. Feeds Analytics.
class MarksEntryScreen extends StatefulWidget {
  const MarksEntryScreen({super.key, required this.paperId});

  final String paperId;

  static Future<void> open(BuildContext context, String paperId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<MarksEntryBloc>(param1: paperId)
                  ..add(const MarksEntryStarted()),
            child: MarksEntryScreen(paperId: paperId),
          ),
        ),
      );

  @override
  State<MarksEntryScreen> createState() => _MarksEntryScreenState();
}

class _MarksEntryScreenState extends State<MarksEntryScreen> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<MarksEntryBloc>().add(const MarksEntrySaved());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paper = context.read<ExamsBloc>().state.paperById(widget.paperId)!;
    final students = context.read<AttendanceBloc>().state.studentsOf(
      paper.classSection,
    );

    return BlocConsumer<MarksEntryBloc, MarksEntryState>(
      listenWhen: (a, b) => !a.saved && b.saved,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageMarksSaved)));
        Navigator.of(context).pop();
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(l.marksEntryTitle(paper.title))),
        body: state.loading
            ? const Center(child: CircularProgressIndicator())
            : students.isEmpty
            ? EmptyState(
                icon: Icons.group_off_outlined,
                message: l.emptyStudents,
              )
            : Form(
                key: _formKey,
                child: ListView.separated(
                  padding: AppSpacing.pageOf(context),
                  itemCount: students.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final s = students[i];
                    return AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${s.rollNo}',
                              style: context.text.bodySmall,
                            ),
                          ),
                          Expanded(
                            child: Text(s.name, style: context.text.bodyLarge),
                          ),
                          SizedBox(
                            width: 96,
                            child: TextFormField(
                              key: ValueKey(s.id),
                              initialValue: state.values[s.id] ?? '',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) => context
                                  .read<MarksEntryBloc>()
                                  .add(StudentMarksEdited(s.id, v)),
                              decoration: InputDecoration(
                                hintText: l.outOfMarks(paper.totalMarks),
                                isDense: true,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return null;
                                }
                                return int.parse(v) > paper.totalMarks
                                    ? l.errorMarksTooHigh
                                    : null;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        bottomNavigationBar: state.loading || students.isEmpty
            ? null
            : SafeArea(
                child: Padding(
                  padding: AppSpacing.pageOf(context),
                  child: FilledButton(
                    onPressed: state.saving ? null : _save,
                    child: Text(l.actionSave),
                  ),
                ),
              ),
      ),
    );
  }
}
