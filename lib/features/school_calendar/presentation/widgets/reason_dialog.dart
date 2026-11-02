import 'package:flutter/material.dart';

import '../../../../core/utils/context_ext.dart';
import '../../domain/usecases/calendar_usecases.dart';

/// Asks the Principal why a day is being changed. Pops with the reason; it
/// cannot be left empty.
class ReasonDialog extends StatefulWidget {
  const ReasonDialog({super.key});

  static Future<String?> show(BuildContext context) => showDialog<String>(
    context: context,
    builder: (_) => const ReasonDialog(),
  );

  @override
  State<ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<ReasonDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
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
      title: Text(l.calendarReasonTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          minLines: 2,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l.calendarReasonHint),
          validator: (v) =>
              (v ?? '').trim().length < EditSchoolDay.minReasonLength
              ? l.calendarReasonRequired
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: Text(l.calendarSave),
        ),
      ],
    );
  }
}
