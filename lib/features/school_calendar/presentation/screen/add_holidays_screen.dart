import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/picker_field.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/usecases/holiday_usecases.dart';
import '../bloc/add_holidays_bloc.dart';
import '../widgets/suggested_holidays_sheet.dart';

/// The Principal's form for the holiday list: any number of holidays, each
/// with its dates and a reason, saved in one go. Pops with true when saved.
class AddHolidaysScreen extends StatefulWidget {
  const AddHolidaysScreen({super.key});

  static Future<bool?> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<bool>(builder: (_) => const AddHolidaysScreen()));

  @override
  State<AddHolidaysScreen> createState() => _AddHolidaysScreenState();
}

class _AddHolidaysScreenState extends State<AddHolidaysScreen> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  void _save(BuildContext context) {
    // The dates show their own error, so check them as well as the reasons.
    final drafts = context.read<AddHolidaysBloc>().state.drafts;
    final datesOk = drafts.every((d) => d.range != null);
    final fieldsOk = _formKey.currentState!.validate();
    if (!datesOk || !fieldsOk) return;
    final user = context.read<AuthBloc>().state.user!;
    context.read<AddHolidaysBloc>().add(
      HolidaysSubmitted(changedBy: user.id, isPrincipal: user.isPrincipal),
    );
  }

  Future<void> _pickDates(BuildContext context, HolidayDraft d) async {
    final bloc = context.read<AddHolidaysBloc>();
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3, 12, 31),
      initialDateRange: d.range,
      helpText: context.l10n.holidayPickDates,
    );
    if (picked != null) bloc.add(HolidayRangeChosen(d.id, picked));
  }

  Future<void> _suggest(BuildContext context) async {
    final bloc = context.read<AddHolidaysBloc>();
    final hindi = Localizations.localeOf(context).languageCode == 'hi';
    final picked = await SuggestedHolidaysSheet.show(context);
    if (picked == null || picked.isEmpty) return;
    bloc.add(
      HolidaysSuggested([
        for (final h in picked)
          HolidaySeed(
            reason: h.name(hindi: hindi),
            date: h.date,
          ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<AddHolidaysBloc>(),
      child: BlocConsumer<AddHolidaysBloc, AddHolidaysState>(
        listenWhen: (a, b) =>
            (a.result == null && b.result != null) ||
            (a.errorId != b.errorId && b.error != null),
        listener: (context, s) {
          final messenger = ScaffoldMessenger.of(context);
          if (s.result != null) {
            final r = s.result!;
            // Today may now be a holiday: attendance and approvals follow.
            context.read<AttendanceBloc>().add(const AttendanceRefreshed());
            context.read<ApprovalsBloc>().add(const ApprovalsRequested());
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  r.skipped == 0
                      ? l.holidaySaved(r.added)
                      : l.holidaySavedSkipped(r.added, r.skipped),
                ),
              ),
            );
            Navigator.of(context).pop(true);
            return;
          }
          messenger.showSnackBar(
            SnackBar(
              content: Text(switch (s.error!) {
                AddHolidaysError.notAllowed => l.calendarNotAllowed,
                AddHolidaysError.reasonRequired => l.calendarReasonRequired,
                AddHolidaysError.invalidDates => l.holidayInvalidDates(
                  AddHolidays.maxDays,
                ),
                AddHolidaysError.failed => l.calendarFailed,
              }),
            ),
          );
        },
        builder: (context, s) => Scaffold(
          appBar: AppBar(title: Text(l.holidayAdd)),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                Text(l.holidayAddIntro, style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () => _suggest(context),
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: Text(l.holidaySuggestedPick),
                ),
                const SizedBox(height: AppSpacing.lg),
                for (var i = 0; i < s.drafts.length; i++) ...[
                  _HolidayCard(
                    key: ValueKey(s.drafts[i].id),
                    number: i + 1,
                    draft: s.drafts[i],
                    canRemove: s.drafts.length > 1,
                    onPick: () => _pickDates(context, s.drafts[i]),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                OutlinedButton.icon(
                  onPressed: () => context.read<AddHolidaysBloc>().add(
                    const HolidayDraftAdded(),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(l.holidayAnother),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: AppSpacing.pageOf(context),
              child: FilledButton(
                onPressed: s.saving ? null : () => _save(context),
                child: Text(l.holidaySaveAll(s.totalDays)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HolidayCard extends StatelessWidget {
  const _HolidayCard({
    super.key,
    required this.number,
    required this.draft,
    required this.canRemove,
    required this.onPick,
  });

  final int number;
  final HolidayDraft draft;
  final bool canRemove;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<AddHolidaysBloc>();
    final r = draft.range;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.holidayEntryTitle(number),
                  style: context.text.titleMedium,
                ),
              ),
              if (canRemove)
                IconButton(
                  tooltip: l.actionRemove,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => bloc.add(HolidayDraftRemoved(draft.id)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            initialValue: draft.reason,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (v) => bloc.add(HolidayReasonEdited(draft.id, v)),
            decoration: InputDecoration(
              labelText: l.holidayReason,
              hintText: l.holidayReasonHint,
            ),
            validator: (v) =>
                (v ?? '').trim().length < 3 ? l.calendarReasonRequired : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          FormField<bool>(
            // Re-checked whenever the dates change.
            key: ValueKey('dates-${draft.id}-${r?.start}-${r?.end}'),
            validator: (_) => r == null ? l.holidayDatesRequired : null,
            builder: (field) => PickerField(
              label: l.holidayPickDates,
              value: r == null
                  ? null
                  : '${formatDateRange(context, r)}  ·  '
                        '${l.holidayDays(draft.days)}',
              helperText: r == null ? l.holidayDatesHelp : null,
              errorText: field.errorText,
              prefixIcon: Icons.event_outlined,
              suffixIcon: Icons.edit_calendar_outlined,
              onTap: onPick,
            ),
          ),
        ],
      ),
    );
  }
}
