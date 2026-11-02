import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../di/injector.dart';
import '../../../exams/presentation/widgets/question_editor_card.dart';
import '../../domain/entities/bank_scope.dart';
import '../../../../l10n/class_label.dart';
import '../bloc/add_question_cubit.dart';
import '../widgets/unit_picker.dart';

/// Types one question into a unit of the bank.
class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  static Future<void> open(
    BuildContext context,
    BankScope scope, {
    String? unitId,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) =>
            sl<AddQuestionCubit>(param1: scope, param2: unitId)..load(),
        child: const AddQuestionScreen(),
      ),
    ),
  );

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  void _save(bool again) {
    if (_formKey.currentState!.validate()) {
      context.read<AddQuestionCubit>().save(again: again);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<AddQuestionCubit>();
    return BlocListener<AddQuestionCubit, AddQuestionState>(
      listenWhen: (a, b) => a.saves != b.saves,
      listener: (context, s) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.bankSaved)));
        if (s.closeAfterSave) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.bankAddOneTitle)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              Text(
                '${l.bankClassSubject}: '
                '${l.classLabel(cubit.scope.classSection)} · '
                '${cubit.scope.subject}',
                style: context.text.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<AddQuestionCubit, AddQuestionState>(
                buildWhen: (a, b) =>
                    a.units != b.units ||
                    a.unitId != b.unitId ||
                    a.unitMissing != b.unitMissing,
                builder: (context, s) => UnitPicker(
                  units: s.units,
                  unitId: s.unitId,
                  error: s.unitMissing,
                  onChosen: cubit.unitChosen,
                  onNewUnit: cubit.unitAdded,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<AddQuestionCubit, AddQuestionState>(
                buildWhen: (a, b) => a.draft != b.draft,
                builder: (context, s) =>
                    QuestionEditorCard(draft: s.draft, handler: cubit),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: AppSpacing.pageOf(context),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _save(true),
                    child: Text(l.bankSaveAnother),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _save(false),
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
