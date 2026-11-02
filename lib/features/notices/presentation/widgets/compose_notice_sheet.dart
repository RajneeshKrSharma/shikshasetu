import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';

/// Asks for a notice's title and message, and whether it should also run along
/// the top of everyone's Dashboard. Pops with `(title, body, announce)`.
class ComposeNoticeSheet extends StatefulWidget {
  const ComposeNoticeSheet({super.key});

  @override
  State<ComposeNoticeSheet> createState() => _ComposeNoticeSheetState();
}

class _ComposeNoticeSheetState extends State<ComposeNoticeSheet> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _title;
  late final TextEditingController _body;
  late final ValueNotifier<bool> _announce;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _title = TextEditingController();
    _body = TextEditingController();
    _announce = ValueNotifier(false);
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _announce.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop((_title.text, _body.text, _announce.value));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l.errorRequired : null;

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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _title,
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.fieldNoticeTitle),
              validator: required,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _body,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.fieldNoticeBody),
              validator: required,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _announce,
              builder: (context, on, _) => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l.noticeAnnounceTitle,
                  style: context.text.titleSmall,
                ),
                subtitle: Text(l.noticeAnnounceHint),
                value: on,
                onChanged: (v) => _announce.value = v,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: _submit, child: Text(l.actionPostNotice)),
          ],
        ),
      ),
    );
  }
}
