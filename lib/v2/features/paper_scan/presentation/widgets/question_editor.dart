import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/draft_question.dart';
import '../bloc/paper_scan_bloc.dart';

/// One question the teacher can fix: its text, its options (if it has any)
/// and its marks.
class QuestionEditor extends StatefulWidget {
  const QuestionEditor({
    super.key,
    required this.number,
    required this.question,
  });

  final int number;
  final DraftQuestion question;

  @override
  State<QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  late final TextEditingController _text;
  late final TextEditingController _options;
  late final TextEditingController _marks;

  @override
  void initState() {
    super.initState();
    final q = widget.question;
    _text = TextEditingController(text: q.text);
    _options = TextEditingController(text: q.options.join('\n'));
    _marks = TextEditingController(text: q.marks > 0 ? '${q.marks}' : '');
  }

  @override
  void dispose() {
    _text.dispose();
    _options.dispose();
    _marks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperScanBloc>();
    final id = widget.question.id;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.paperScanQuestionN(widget.number),
                  style: context.text.titleSmall,
                ),
              ),
              IconButton(
                tooltip: l.actionDelete,
                onPressed: () => bloc.add(QuestionRemoved(id)),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onChanged: (v) => bloc.add(QuestionTextChanged(id, v)),
          ),
          if (widget.question.options.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _options,
              minLines: 2,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: l.paperScanOptions),
              onChanged: (v) => bloc.add(QuestionOptionsChanged(id, v)),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              width: 160,
              child: TextField(
                controller: _marks,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.paperScanMarks),
                onChanged: (v) => bloc.add(QuestionMarksChanged(id, v)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
