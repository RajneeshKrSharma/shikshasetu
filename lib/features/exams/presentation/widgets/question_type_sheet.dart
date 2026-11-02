import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../domain/entities/exam_paper.dart';
import 'question_type_style.dart';

/// Lets the setter choose a question type (to add, or to switch to).
class QuestionTypeSheet extends StatelessWidget {
  const QuestionTypeSheet({super.key, this.current});

  /// The type already chosen, shown ticked.
  final QuestionType? current;

  static Future<QuestionType?> show(
    BuildContext context, {
    QuestionType? current,
  }) => showModalBottomSheet<QuestionType>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => QuestionTypeSheet(current: current),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
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
            Text(l.paperChooseType, style: context.text.titleMedium),
            const SizedBox(height: AppSpacing.md),
            for (final t in QuestionType.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(t.icon, color: context.brand.primary),
                title: Text(t.label(l)),
                subtitle: Text(t.hint(l)),
                trailing: t == current ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(t),
              ),
          ],
        ),
      ),
    );
  }
}
