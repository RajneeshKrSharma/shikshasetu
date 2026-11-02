import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';

/// Asks for one number: the marks to give every question.
class MarksForAllDialog extends StatefulWidget {
  const MarksForAllDialog({super.key});

  static Future<int?> show(BuildContext context) => showDialog<int>(
    context: context,
    builder: (_) => const MarksForAllDialog(),
  );

  @override
  State<MarksForAllDialog> createState() => _MarksForAllDialogState();
}

class _MarksForAllDialogState extends State<MarksForAllDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.paperSetMarksAll),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: l.paperMarksForAll),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            final n = int.tryParse(_controller.text.trim());
            if (n != null && n > 0) Navigator.of(context).pop(n);
          },
          child: Text(l.paperApply),
        ),
      ],
    );
  }
}

/// A big text box to paste questions into. Pops with the text.
class PasteQuestionsSheet extends StatefulWidget {
  const PasteQuestionsSheet({super.key});

  static Future<String?> show(BuildContext context) =>
      showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => const PasteQuestionsSheet(),
      );

  @override
  State<PasteQuestionsSheet> createState() => _PasteQuestionsSheetState();
}

class _PasteQuestionsSheetState extends State<PasteQuestionsSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        // Above the keyboard, or above the phone's navigation bar.
        math.max(
              MediaQuery.viewInsetsOf(context).bottom,
              MediaQuery.paddingOf(context).bottom,
            ) +
            AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.paperPasteTitle, style: context.text.titleMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: 8,
            maxLines: 12,
            decoration: InputDecoration(hintText: l.paperPasteHint),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: Text(l.paperPasteAction),
          ),
        ],
      ),
    );
  }
}

/// What to shuffle. Pops with `true` to include MCQ options too.
class ShuffleSheet extends StatelessWidget {
  const ShuffleSheet({super.key});

  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (_) => const ShuffleSheet(),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
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
            Text(l.paperShuffle, style: context.text.titleMedium),
            Text(l.paperShuffleNote, style: context.text.bodySmall),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.shuffle),
              title: Text(l.paperShuffleQuestions),
              onTap: () => Navigator.of(context).pop(false),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.shuffle_on_outlined),
              title: Text(l.paperShuffleOptions),
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}
