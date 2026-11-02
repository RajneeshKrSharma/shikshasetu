import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';

/// Asks what was taught; null when cancelled.
Future<String?> showTopicDialog(
  BuildContext context, {
  required String title,
  String initial = '',
}) => showDialog<String>(
  context: context,
  builder: (_) => _TopicDialog(title: title, initial: initial),
);

class _TopicDialog extends StatefulWidget {
  const _TopicDialog({required this.title, required this.initial});

  final String title;
  final String initial;

  @override
  State<_TopicDialog> createState() => _TopicDialogState();
}

class _TopicDialogState extends State<_TopicDialog> {
  late final TextEditingController _topic;

  @override
  void initState() {
    super.initState();
    _topic = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _topic,
        autofocus: true,
        maxLength: 500,
        maxLines: 4,
        minLines: 2,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: l.tchTopic),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (_topic.text.trim().isEmpty) return;
            Navigator.pop(context, _topic.text.trim());
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
