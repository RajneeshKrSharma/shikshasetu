import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/exam_paper.dart';
import '../bloc/question_draft.dart';
import 'question_edit_handler.dart';
import 'question_type_sheet.dart';
import 'question_type_style.dart';

/// Editable card for one question, with the fields its type needs. The values
/// live in the bloc (or cubit); every edit goes through [handler].
class QuestionEditorCard extends StatelessWidget {
  const QuestionEditorCard({
    super.key,
    required this.draft,
    required this.handler,
    this.index,
    this.dragHandle,
    this.menu,
  });

  final QuestionDraft draft;
  final QuestionEditHandler handler;

  /// Position in the paper (0-based); null when the card is not in a list.
  final int? index;

  /// A drag handle for reordering, placed at the start of the header.
  final Widget? dragHandle;

  /// Extra actions (duplicate, delete...) at the end of the header.
  final Widget? menu;

  String _letter(int i) => String.fromCharCode(0x41 + i);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final id = draft.id;
    final type = draft.type;
    return AppCard(
      borderColor: draft.needsReview
          ? AppColors.late.withValues(alpha: 0.6)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ?dragHandle,
              if (index != null)
                Text(
                  l.questionNumber(index! + 1),
                  style: context.text.titleSmall,
                ),
              const SizedBox(width: AppSpacing.md),
              ActionChip(
                avatar: Icon(type.icon, size: AppIconSize.sm),
                label: Text(type.label(l)),
                onPressed: () async {
                  final picked = await QuestionTypeSheet.show(
                    context,
                    current: type,
                  );
                  if (picked != null) handler.type(picked);
                },
              ),
              if (draft.needsReview) ...[
                const SizedBox(width: AppSpacing.md),
                StatusChip(
                  label: l.paperCheckChip,
                  color: AppColors.late,
                  background: AppColors.lateLight,
                ),
              ],
              const Spacer(),
              ?menu,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: ValueKey('q-text-$id-${type.name}'),
            initialValue: draft.text,
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            onChanged: handler.text,
            decoration: InputDecoration(
              labelText: l.fieldQuestion,
              helperText: type == QuestionType.fillBlank ? l.qBlankHint : null,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l.errorRequired;
              if (type == QuestionType.fillBlank && !v.contains('__')) {
                return l.qNeedBlank;
              }
              return null;
            },
          ),
          ..._typeFields(context),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: ValueKey('q-marks-$id'),
            initialValue: draft.marks,
            keyboardType: TextInputType.number,
            onChanged: handler.marks,
            decoration: InputDecoration(labelText: l.fieldMarks),
            validator: (v) {
              final n = int.tryParse((v ?? '').trim());
              return (n == null || n <= 0) ? l.errorRequired : null;
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _typeFields(BuildContext context) {
    final l = context.l10n;
    final id = draft.id;
    switch (draft.type) {
      case QuestionType.mcq:
        return [
          const SizedBox(height: AppSpacing.lg),
          Text(l.qCorrectAnswer, style: context.text.labelMedium),
          // Room for the floating label of the first option.
          const SizedBox(height: AppSpacing.lg),
          RadioGroup<int>(
            groupValue: draft.correctIndex,
            onChanged: handler.correct,
            child: Column(
              children: [
                for (var i = 0; i < draft.options.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Row(
                      children: [
                        // A second tap on the chosen option clears the answer.
                        Radio<int>(value: i, toggleable: true),
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('o-$id-$i-${draft.options.length}'),
                            initialValue: draft.options[i],
                            onChanged: (v) => handler.optionEdited(i, v),
                            decoration: InputDecoration(
                              labelText: l.optionLabel(_letter(i)),
                            ),
                            validator: (v) =>
                                i < 2 && (v == null || v.trim().isEmpty)
                                ? l.qNeedOptions
                                : null,
                          ),
                        ),
                        if (draft.options.length > 2)
                          IconButton(
                            tooltip: l.actionRemove,
                            icon: const Icon(Icons.close),
                            onPressed: () => handler.optionRemoved(i),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (draft.options.length < 6)
            TextButton.icon(
              onPressed: handler.optionAdded,
              icon: const Icon(Icons.add),
              label: Text(l.qAddOption),
            ),
        ];
      case QuestionType.trueFalse:
        return [
          const SizedBox(height: AppSpacing.lg),
          Text(l.qCorrectAnswer, style: context.text.labelMedium),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            children: [
              for (final (i, label) in [(0, l.qTrue), (1, l.qFalse)])
                ChoiceChip(
                  label: Text(label),
                  selected: draft.correctIndex == i,
                  onSelected: (on) => handler.correct(on ? i : null),
                ),
            ],
          ),
        ];
      case QuestionType.fillBlank:
        return [
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: ValueKey('q-answer-$id'),
            initialValue: draft.answer,
            onChanged: handler.answer,
            decoration: InputDecoration(labelText: l.qBlankAnswer),
          ),
        ];
      case QuestionType.matchFollowing:
        return [
          const SizedBox(height: AppSpacing.lg),
          if (draft.needsReview)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                l.qCheckMatches,
                style: context.text.bodySmall!.copyWith(color: AppColors.late),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Text(l.qColumnA, style: context.text.labelMedium),
              ),
              const SizedBox(width: AppSpacing.xl + AppSpacing.md),
              Expanded(
                child: Text(l.qColumnB, style: context.text.labelMedium),
              ),
              const SizedBox(width: 40),
            ],
          ),
          for (var i = 0; i < draft.pairs.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey('pl-$id-$i-${draft.pairs.length}'),
                      initialValue: draft.pairs[i].left,
                      onChanged: (v) => handler.pairEdited(i, left: v),
                      validator: (v) => i < 2 && (v == null || v.trim().isEmpty)
                          ? l.qNeedPairs
                          : null,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Icon(Icons.compare_arrows, size: AppIconSize.md),
                  ),
                  Expanded(
                    child: TextFormField(
                      key: ValueKey('pr-$id-$i-${draft.pairs.length}'),
                      initialValue: draft.pairs[i].right,
                      onChanged: (v) => handler.pairEdited(i, right: v),
                      validator: (v) => i < 2 && (v == null || v.trim().isEmpty)
                          ? l.qNeedPairs
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: draft.pairs.length > 2
                        ? IconButton(
                            tooltip: l.actionRemove,
                            icon: const Icon(Icons.close),
                            onPressed: () => handler.pairRemoved(i),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          TextButton.icon(
            onPressed: handler.pairAdded,
            icon: const Icon(Icons.add),
            label: Text(l.qAddPair),
          ),
        ];
      case QuestionType.shortAnswer:
      case QuestionType.longAnswer:
        return const [];
    }
  }
}
