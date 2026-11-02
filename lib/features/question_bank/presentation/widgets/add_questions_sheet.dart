import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../../domain/entities/bank_scope.dart';
import '../screen/add_question_screen.dart';
import '../screen/photo_questions_screen.dart';

/// "Add questions": a photo (the quickest), a photo from the phone, or one
/// typed question.
class AddQuestionsSheet extends StatelessWidget {
  const AddQuestionsSheet({super.key, required this.scope, this.unitId});

  final BankScope scope;
  final String? unitId;

  static Future<void> show(
    BuildContext context,
    BankScope scope, {
    String? unitId,
  }) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => AddQuestionsSheet(scope: scope, unitId: unitId),
  );

  /// Closes the sheet, then opens the chosen flow on the screen behind it.
  void _go(BuildContext context, VoidCallback open) {
    Navigator.of(context).pop();
    Future<void>.microtask(open);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final root = Navigator.of(context, rootNavigator: false).context;
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
            Text(l.bankAddTitle, style: context.text.titleMedium),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.bankAddPhoto),
              subtitle: Text(l.bankAddPhotoHint),
              trailing: Text(l.bankFastest, style: context.text.labelSmall),
              onTap: () => _go(
                context,
                () => PhotoQuestionsScreen.open(
                  root,
                  scope,
                  source: PhotoSource.camera,
                  unitId: unitId,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.bankAddGallery),
              subtitle: Text(l.bankAddGalleryHint),
              onTap: () => _go(
                context,
                () => PhotoQuestionsScreen.open(
                  root,
                  scope,
                  source: PhotoSource.gallery,
                  unitId: unitId,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l.bankAddType),
              subtitle: Text(l.bankAddTypeHint),
              onTap: () => _go(
                context,
                () => AddQuestionScreen.open(root, scope, unitId: unitId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
