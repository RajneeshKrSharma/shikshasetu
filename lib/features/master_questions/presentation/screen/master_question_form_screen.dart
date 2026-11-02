import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../teaching/presentation/bloc/teaching_access_x.dart';
import '../../../exams/presentation/widgets/question_editor_card.dart';
import '../../domain/entities/master_question.dart';
import '../bloc/master_question_form_cubit.dart';
import '../bloc/master_questions_bloc.dart';

/// Writes a new master question, or edits one.
class MasterQuestionFormScreen extends StatefulWidget {
  const MasterQuestionFormScreen({super.key});

  /// Opens the form. With [initial] it edits; otherwise it starts a new
  /// question of [type].
  static Future<void> open(
    BuildContext context, {
    MasterQuestion? initial,
    QuestionType? type,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => MasterQuestionFormCubit(initial: initial, type: type),
        child: const MasterQuestionFormScreen(),
      ),
    ),
  );

  @override
  State<MasterQuestionFormScreen> createState() =>
      _MasterQuestionFormScreenState();
}

class _MasterQuestionFormScreenState extends State<MasterQuestionFormScreen> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<MasterQuestionFormCubit>();
    final me = context.read<AuthBloc>().state.user?.id;
    context.read<MasterQuestionsBloc>().add(
      MasterQuestionSaved(
        cubit.state.draft.toQuestion(),
        id: cubit.id,
        subject: cubit.state.subject,
        createdBy: me,
      ),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.masterSaved)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<MasterQuestionFormCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(cubit.id == null ? l.masterAdd : l.masterEdit),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            BlocBuilder<MasterQuestionFormCubit, MasterFormState>(
              buildWhen: (a, b) => a.subject != b.subject,
              builder: (context, s) => DropdownButtonFormField<String?>(
                initialValue: s.subject,
                decoration: InputDecoration(labelText: l.masterSubjectOptional),
                items: [
                  const DropdownMenuItem<String?>(child: Text('—')),
                  for (final sub in {
                    ...watchTeachingAccess(context).subjects(),
                    ?s.subject,
                  })
                    DropdownMenuItem<String?>(value: sub, child: Text(sub)),
                ],
                onChanged: cubit.subjectChosen,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            BlocBuilder<MasterQuestionFormCubit, MasterFormState>(
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
          child: FilledButton(onPressed: _save, child: Text(l.actionSave)),
        ),
      ),
    );
  }
}
