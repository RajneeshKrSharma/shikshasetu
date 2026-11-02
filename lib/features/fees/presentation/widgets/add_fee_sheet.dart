import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/picker_field.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_person.dart';
import '../bloc/add_fee_bloc.dart';
import '../bloc/fees_bloc.dart';

/// Assigns a fee to a student, teacher or other staff member.
class AddFeeSheet extends StatefulWidget {
  const AddFeeSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => BlocProvider(
      create: (_) => sl<AddFeeBloc>()..add(const AddFeeStarted()),
      child: const AddFeeSheet(),
    ),
  );

  @override
  State<AddFeeSheet> createState() => _AddFeeSheetState();
}

class _AddFeeSheetState extends State<AddFeeSheet> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _total;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _total = TextEditingController();
  }

  @override
  void dispose() {
    _total.dispose();
    super.dispose();
  }

  Future<void> _pickDue(DateTime current) async {
    final bloc = context.read<AddFeeBloc>();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) bloc.add(FeeDueDateChosen(picked));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AddFeeBloc>().add(FeeSubmitted(int.parse(_total.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String groupLabel(FeeGroup g) => switch (g) {
      FeeGroup.student => l.tabStudents,
      FeeGroup.teacher => l.tabTeachers,
      FeeGroup.other => l.tabOthers,
    };

    return BlocListener<AddFeeBloc, AddFeeState>(
      listenWhen: (a, b) => !a.saved && b.saved,
      listener: (context, state) {
        context.read<FeesBloc>().add(const FeesLoaded());
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageFeeAdded)));
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.actionAddFee, style: context.text.titleMedium),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<AddFeeBloc, AddFeeState>(
                  buildWhen: (a, b) => a.group != b.group,
                  builder: (context, state) => SegmentedButton<FeeGroup>(
                    showSelectedIcon: false,
                    segments: [
                      for (final g in FeeGroup.values)
                        ButtonSegment(value: g, label: Text(groupLabel(g))),
                    ],
                    selected: {state.group},
                    onSelectionChanged: (s) => context.read<AddFeeBloc>().add(
                      FeeGroupChanged(s.first),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<AddFeeBloc, AddFeeState>(
                  buildWhen: (a, b) =>
                      a.people != b.people || a.peopleLoaded != b.peopleLoaded,
                  builder: (context, state) {
                    if (state.peopleLoaded && state.people.isEmpty) {
                      return Text(
                        l.emptyFeePeople,
                        style: context.text.bodySmall,
                      );
                    }
                    return DropdownButtonFormField<FeePerson>(
                      key: ValueKey(state.group),
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l.fieldPerson),
                      items: [
                        for (final p in state.people)
                          DropdownMenuItem(
                            value: p,
                            child: Text('${p.name} · ${p.subtitle}'),
                          ),
                      ],
                      onChanged: (v) =>
                          context.read<AddFeeBloc>().add(FeePersonChosen(v)),
                      validator: (v) => v == null ? l.errorRequired : null,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _total,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.feesTotal,
                    prefixText: '₹ ',
                  ),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    return (n == null || n <= 0) ? l.errorAmountInvalid : null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                BlocBuilder<AddFeeBloc, AddFeeState>(
                  buildWhen: (a, b) => a.dueDate != b.dueDate,
                  builder: (context, state) => PickerField(
                    label: l.fieldDueDate,
                    value: formatShortDate(context, state.dueDate),
                    onTap: () => _pickDue(state.dueDate),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<AddFeeBloc, AddFeeState>(
                  buildWhen: (a, b) => a.saving != b.saving,
                  builder: (context, state) => FilledButton(
                    onPressed: state.saving ? null : _save,
                    child: Text(l.actionSave),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
