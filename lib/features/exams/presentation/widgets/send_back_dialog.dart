import 'package:flutter/material.dart';

import '../../../../core/utils/context_ext.dart';

/// Asks the Principal why a paper is being sent back. Pops with the note.
class SendBackDialog extends StatefulWidget {
  const SendBackDialog({super.key});

  static Future<String?> show(BuildContext context) => showDialog<String>(
    context: context,
    builder: (_) => const SendBackDialog(),
  );

  @override
  State<SendBackDialog> createState() => _SendBackDialogState();
}

class _SendBackDialogState extends State<SendBackDialog> {
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
      title: Text(l.sendBackTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 3,
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: l.sendBackHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            final note = _controller.text.trim();
            if (note.isNotEmpty) Navigator.of(context).pop(note);
          },
          child: Text(l.actionSendBack),
        ),
      ],
    );
  }
}
