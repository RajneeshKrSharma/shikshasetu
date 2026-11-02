import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../question_bank/presentation/screen/paper_maker_screen.dart';
import '../screen/create_paper_screen.dart';

/// "New paper": made from the teacher's question bank, or written by hand.
class NewPaperSheet extends StatelessWidget {
  const NewPaperSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => const NewPaperSheet(),
  );

  void _go(BuildContext context, void Function(BuildContext) open) {
    final navigator = Navigator.of(context);
    final behind = navigator.context;
    navigator.pop();
    Future<void>.microtask(() {
      if (behind.mounted) open(behind);
    });
  }

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
            Text(l.newPaperTitle, style: context.text.titleMedium),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: const Icon(Icons.library_books_outlined),
              title: Text(l.newPaperFromBank),
              subtitle: Text(l.newPaperFromBankHint),
              onTap: () => _go(context, PaperMakerScreen.open),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l.newPaperWrite),
              subtitle: Text(l.newPaperWriteHint),
              onTap: () => _go(context, CreatePaperScreen.open),
            ),
          ],
        ),
      ),
    );
  }
}
