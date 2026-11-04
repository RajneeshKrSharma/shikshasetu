import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/info_banner.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../domain/entities/timetable.dart';
import '../bloc/timetable_bloc.dart';
import '../widgets/add_subject_field.dart';
import '../widgets/saved_timetable.dart';
import '../widgets/timetable_row_card.dart';
import 'timetable_print_screen.dart';
import 'timetable_settings_screen.dart';

/// The Principal makes a class's exam timetable here: pick the class and the
/// exam, give each subject a date, and save the lot at once.
class ExamTimetableScreen extends StatelessWidget {
  const ExamTimetableScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TimetableBloc>()..add(const TimetableStarted()),
    child: const _TimetableView(),
  );
}

class _TimetableView extends StatelessWidget {
  const _TimetableView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<TimetableBloc, TimetableState>(
      failureOf: (s) => s.failure,
      child: BlocListener<TimetableBloc, TimetableState>(
        listenWhen: (a, b) => b.savedCount > a.savedCount,
        listener: (context, _) => _say(context, l.ttbSaved),
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.navExamTimetable),
            actions: [
              BlocBuilder<TimetableBloc, TimetableState>(
                buildWhen: (a, b) => a.exams != b.exams || a.type != b.type,
                builder: (context, s) => IconButton(
                  tooltip: l.ttbPrint,
                  icon: const Icon(Icons.print_outlined),
                  onPressed: s.canPrint
                      ? () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => TimetablePrintScreen(
                              classId: s.classId!,
                              type: s.type,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              BlocBuilder<TimetableBloc, TimetableState>(
                buildWhen: (a, b) => a.settings != b.settings,
                builder: (context, s) => IconButton(
                  tooltip: l.ttbSettings,
                  icon: const Icon(Icons.tune),
                  onPressed: s.settings == null
                      ? null
                      : () => _openSettings(context, s.settings!),
                ),
              ),
            ],
          ),
          body: BlocBuilder<TimetableBloc, TimetableState>(
            builder: (context, s) => AsyncBody(
              status: s.status,
              failure: s.failure,
              onRetry: () =>
                  context.read<TimetableBloc>().add(const TimetableStarted()),
              builder: (_) => _Body(state: s),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSettings(
    BuildContext context,
    TimetableSettings settings,
  ) async {
    final bloc = context.read<TimetableBloc>();
    final saved = await Navigator.of(context).push<TimetableSettings>(
      MaterialPageRoute(
        builder: (_) => TimetableSettingsScreen(initial: settings),
      ),
    );
    if (saved == null) return;
    bloc.add(TimetableSettingsChanged(saved));
    if (context.mounted) _say(context, context.l10n.ttbSettingsSaved);
  }

  void _say(BuildContext context, String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final TimetableState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<TimetableBloc>();
    final settings = state.settings!;
    return ListView(
      padding: AppSpacing.pageOf(context),
      children: [
        DropdownButtonFormField<String>(
          initialValue: state.classId,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.fieldClass),
          items: [
            for (final c in state.classes)
              DropdownMenuItem(value: c.id, child: Text(c.name)),
          ],
          onChanged: (v) {
            if (v != null) bloc.add(TimetableClassChosen(v));
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final t in settings.typeLabels.keys)
              ChoiceChip(
                label: Text(settings.labelOf(t)),
                selected: state.type == t,
                onSelected: (_) => bloc.add(TimetableTypeChosen(t)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (state.classId == null)
          Text(l.ttbPickClass)
        else if (state.busy && state.rows.isEmpty)
          const Center(child: CircularProgressIndicator())
        else ...[
          if (state.rows.isEmpty)
            Text(l.ttbNoSubjects)
          else
            Text(l.ttbSkipHint, style: context.text.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < state.rows.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: TimetableRowCard(
                key: ValueKey('${state.classId}-${state.rows[i].subject}'),
                index: i,
                row: state.rows[i],
                settings: settings,
              ),
            ),
          const AddSubjectField(),
          const SizedBox(height: AppSpacing.md),
          if (state.warnings.isNotEmpty)
            InfoBanner(
              title: l.ttbNote,
              message: state.warnings.join('\n'),
              kind: BannerKind.warning,
            ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: state.canSave
                ? () => bloc.add(const TimetableSubmitted())
                : null,
            icon: state.busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.event_available_outlined),
            label: Text(l.ttbSave),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionTitle(
            '${l.ttbSavedHeading} · ${settings.labelOf(state.type)}',
          ),
          SavedTimetable(exams: state.savedOfType, settings: settings),
        ],
      ],
    );
  }
}
