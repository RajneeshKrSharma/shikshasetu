import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../exams/presentation/paper_subjects.dart';

/// The class and subject chosen in [SubjectSheet].
typedef SubjectChoice = ({String className, String subject});

/// Pick a class, then a subject. A teacher uses it to ask for a subject; the
/// Principal to give one.
class SubjectSheet extends StatefulWidget {
  const SubjectSheet({
    super.key,
    required this.classes,
    required this.title,
    required this.actionLabel,
  });

  final List<String> classes;
  final String title;
  final String actionLabel;

  static Future<SubjectChoice?> show(
    BuildContext context, {
    required List<String> classes,
    required String title,
    required String actionLabel,
  }) => showModalBottomSheet<SubjectChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        SubjectSheet(classes: classes, title: title, actionLabel: actionLabel),
  );

  @override
  State<SubjectSheet> createState() => _SubjectSheetState();
}

class _SubjectSheetState extends State<SubjectSheet> {
  late final ValueNotifier<String?> _class;
  late final ValueNotifier<String?> _subject;

  @override
  void initState() {
    super.initState();
    _class = ValueNotifier(null);
    _subject = ValueNotifier(null);
  }

  @override
  void dispose() {
    _class.dispose();
    _subject.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: context.text.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(l.subjectSheetHint, style: context.text.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            ValueListenableBuilder<String?>(
              valueListenable: _class,
              builder: (context, cls, _) => DropdownButtonFormField<String>(
                initialValue: cls,
                decoration: InputDecoration(labelText: l.fieldClass),
                items: [
                  for (final c in widget.classes)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => _class.value = v,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ValueListenableBuilder<String?>(
              valueListenable: _subject,
              builder: (context, subject, _) => DropdownButtonFormField<String>(
                initialValue: subject,
                decoration: InputDecoration(labelText: l.fieldSubject),
                items: [
                  for (final s in kPaperSubjects)
                    DropdownMenuItem(value: s, child: Text(s)),
                ],
                onChanged: (v) => _subject.value = v,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListenableBuilder(
              listenable: Listenable.merge([_class, _subject]),
              builder: (context, _) {
                final ready = _class.value != null && _subject.value != null;
                return FilledButton(
                  onPressed: ready
                      ? () => Navigator.of(context).pop((
                          className: _class.value!,
                          subject: _subject.value!,
                        ))
                      : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
                  ),
                  child: Text(widget.actionLabel),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
