import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../../domain/entities/bank_scope.dart';
import '../bloc/question_bank_cubit.dart';
import '../widgets/add_questions_sheet.dart';
import '../widgets/unit_picker.dart';
import 'unit_questions_screen.dart';

/// A teacher's own question bank: class and subject, then unit, with how
/// many questions of each type every unit holds.
class QuestionBankScreen extends StatelessWidget {
  const QuestionBankScreen({super.key});

  static Future<void> open(BuildContext context, [BankScope? scope]) {
    final user = context.read<AuthBloc>().state.user!;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) =>
              sl<QuestionBankCubit>(param1: user.id, param2: scope)..load(),
          child: const QuestionBankScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<QuestionBankCubit>();
    return BlocBuilder<QuestionBankCubit, QuestionBankState>(
      builder: (context, s) {
        final scope = s.scope;
        return Scaffold(
          appBar: AppBar(
            title: Text(l.bankTitle),
            actions: [
              if (scope != null)
                TextButton(
                  onPressed: () async {
                    await AddQuestionsSheet.show(context, scope);
                    await cubit.load();
                  },
                  child: Text(l.bankAddQuestion),
                ),
            ],
          ),
          body: s.loading
              ? const Center(child: CircularProgressIndicator())
              : scope == null
              ? EmptyState(
                  icon: Icons.menu_book_outlined,
                  message: l.bankNoScopes,
                )
              : ListView(
                  padding: AppSpacing.pageOf(context),
                  children: [
                    Wrap(
                      spacing: AppSpacing.md,
                      children: [
                        for (final sc in s.scopes)
                          ChoiceChip(
                            label: Text(
                              '${l.classLabel(sc.classSection)} · ${sc.subject}',
                            ),
                            selected: sc == scope,
                            onSelected: (_) => cubit.select(sc),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (s.overview != null) ...[
                      Text(
                        l.bankSummary(
                          s.overview!.total,
                          s.overview!.units.length,
                        ),
                        style: context.text.titleSmall,
                      ),
                      if (s.overview!.units.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: Text(l.bankNoUnits),
                        ),
                      for (final u in s.overview!.units)
                        InkWell(
                          onTap: () async {
                            await UnitQuestionsScreen.open(context, u.unit);
                            await cubit.load();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.border),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        u.unit.name,
                                        style: context.text.titleSmall,
                                      ),
                                      Text(
                                        u.total == 0
                                            ? l.bankUnitEmpty
                                            : [
                                                for (final e in u.byCount)
                                                  '${e.key.label(l)} ${e.value}',
                                              ].join(' · '),
                                        style: context.text.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${u.total}',
                                  style: context.text.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.lg),
                      OutlinedButton(
                        onPressed: () async {
                          final name = await NewUnitDialog.show(context);
                          if (name != null) await cubit.unitAdded(name);
                        },
                        child: Text(l.bankNewUnit),
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }
}
