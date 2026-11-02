import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../../domain/entities/assembly.dart';
import '../bloc/assembly_bloc.dart';
import '../widgets/school_day_widgets.dart';

/// When and where the assembly is, what is done in it, and who is on duty
/// each day.
class SchoolAssemblyScreen extends StatelessWidget {
  const SchoolAssemblyScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<AssemblyBloc>()..add(const AssemblyStarted()),
        child: const SchoolAssemblyScreen(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.assemblyTitle)),
      body: BlocBuilder<AssemblyBloc, AssemblyState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final a = state.settings;
          final bloc = context.read<AssemblyBloc>();
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              Row(
                children: [
                  Expanded(
                    child: ValueCard(
                      caption: l.assemblyTime,
                      value: a.start == null || a.end == null
                          ? l.timingNotSet
                          : l.periodTimeRange(
                              formatDayTime(context, a.start),
                              formatDayTime(context, a.end),
                            ),
                      // First when it starts, then when it ends.
                      onTap: () async {
                        final start = await pickDayTime(context, a.start);
                        if (start == null || !context.mounted) return;
                        final end = await pickDayTime(context, a.end ?? start);
                        if (end != null) {
                          bloc.add(
                            AssemblyTimesChanged(start: start, end: end),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ValueCard(
                      caption: l.assemblyPlace,
                      value: a.place.isEmpty ? l.timingNotSet : a.place,
                      onTap: () async {
                        final text = await _askText(
                          context,
                          l.assemblyPlace,
                          a.place,
                        );
                        if (text != null) bloc.add(AssemblyPlaceChanged(text));
                      },
                    ),
                  ),
                ],
              ),
              SectionLabel(l.assemblyDays),
              WeekdayChips(
                selected: a.days,
                onToggle: (d) => bloc.add(AssemblyDayToggled(d)),
              ),
              SectionLabel(l.assemblyOrder),
              AppCard(
                onTap: () async {
                  final text = await _askText(
                    context,
                    l.assemblyOrder,
                    a.order.join('\n'),
                    hint: l.assemblyOrderHint,
                    lines: true,
                  );
                  if (text != null) {
                    bloc.add(
                      AssemblyOrderChanged([
                        for (final line in text.split('\n'))
                          if (line.trim().isNotEmpty) line.trim(),
                      ]),
                    );
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        a.order.isEmpty
                            ? l.timingNotSet
                            : [
                                for (var i = 0; i < a.order.length; i++)
                                  '${i + 1} ${a.order[i]}',
                              ].join(' · '),
                        style: context.text.bodyMedium,
                      ),
                    ),
                    const Icon(Icons.edit_outlined, size: AppIconSize.md),
                  ],
                ),
              ),
              SectionLabel(l.assemblyDutyTitle),
              for (var d = 1; d <= 6; d++) ...[
                _DutyRow(duty: state.overview.dutyOf(d)),
                const Divider(height: 1),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Asks for a piece of text; null if dismissed.
  static Future<String?> _askText(
    BuildContext context,
    String title,
    String initial, {
    String? hint,
    bool lines = false,
  }) => showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        _TextSheet(title: title, initial: initial, hint: hint, lines: lines),
  );
}

class _TextSheet extends StatefulWidget {
  const _TextSheet({
    required this.title,
    required this.initial,
    required this.lines,
    this.hint,
  });

  final String title;
  final String initial;
  final String? hint;
  final bool lines;

  @override
  State<_TextSheet> createState() => _TextSheetState();
}

class _TextSheetState extends State<_TextSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: context.text.titleMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: widget.lines ? 4 : 1,
            maxLines: widget.lines ? 10 : 1,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: widget.hint),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: Text(context.l10n.actionSave),
          ),
        ],
      ),
    ),
  );
}

class _DutyRow extends StatelessWidget {
  const _DutyRow({required this.duty});

  final AssemblyDuty duty;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return InkWell(
      onTap: () async {
        final bloc = context.read<AssemblyBloc>();
        final picked = await showModalBottomSheet<AssemblyDuty>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => _DutySheet(duty: duty),
        );
        if (picked != null) bloc.add(AssemblyDutySaved(picked));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: context.brand.primaryLight,
              child: Text(
                weekdayName(context, duty.weekday),
                style: context.text.labelSmall!.copyWith(
                  color: context.brand.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    duty.className == null
                        ? l.timingNotSet
                        : l.classLabel(duty.className!),
                    style: context.text.titleSmall,
                  ),
                  if (duty.teacherName != null)
                    Text(
                      l.assemblyInCharge(duty.teacherName!),
                      style: context.text.bodySmall,
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

/// Chooses the class and the teacher in charge for one weekday.
class _DutySheet extends StatefulWidget {
  const _DutySheet({required this.duty});

  final AssemblyDuty duty;

  @override
  State<_DutySheet> createState() => _DutySheetState();
}

class _DutySheetState extends State<_DutySheet> {
  late final ValueNotifier<String?> _class;
  late final ValueNotifier<String?> _teacher;

  @override
  void initState() {
    super.initState();
    _class = ValueNotifier(widget.duty.className);
    _teacher = ValueNotifier(widget.duty.teacherId);
  }

  @override
  void dispose() {
    _class.dispose();
    _teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.read<ClassesBloc>().state.classes;
    final teachers = [
      for (final s in context.read<StaffBloc>().state.staff)
        if (s.active) s,
    ];
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
            Text(
              weekdayName(context, widget.duty.weekday),
              style: context.text.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ValueListenableBuilder<String?>(
              valueListenable: _class,
              builder: (context, v, _) => DropdownButtonFormField<String?>(
                initialValue: v,
                decoration: InputDecoration(labelText: l.assemblyDutyClass),
                items: [
                  for (final c in classes)
                    DropdownMenuItem(value: c.name, child: Text(c.name)),
                ],
                onChanged: (x) => _class.value = x,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ValueListenableBuilder<String?>(
              valueListenable: _teacher,
              builder: (context, v, _) => DropdownButtonFormField<String?>(
                initialValue: v,
                decoration: InputDecoration(labelText: l.assemblyDutyTeacher),
                items: [
                  for (final t in teachers)
                    DropdownMenuItem(value: t.id, child: Text(t.name)),
                ],
                onChanged: (x) => _teacher.value = x,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(
                AssemblyDuty(
                  weekday: widget.duty.weekday,
                  className: _class.value,
                  teacherId: _teacher.value,
                ),
              ),
              child: Text(l.actionSave),
            ),
            TextButton(
              onPressed: () => Navigator.of(
                context,
              ).pop(AssemblyDuty(weekday: widget.duty.weekday)),
              child: Text(l.assemblyDutyClear),
            ),
          ],
        ),
      ),
    );
  }
}
