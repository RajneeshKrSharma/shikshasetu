import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../core/widgets/time_format.dart';
import '../../domain/entities/request.dart';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// Asks for the days and the reason of a leave.
Future<LeaveDraft?> showLeaveDialog(BuildContext context) =>
    showDialog<LeaveDraft>(
      context: context,
      builder: (_) => const _LeaveDialog(),
    );

class _LeaveDialog extends StatefulWidget {
  const _LeaveDialog();

  @override
  State<_LeaveDialog> createState() => _LeaveDialogState();
}

class _LeaveDialogState extends State<_LeaveDialog> {
  late final TextEditingController _reason;
  late final ValueNotifier<DateTime> _from;
  late final ValueNotifier<DateTime> _to;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _reason = TextEditingController();
    _from = ValueNotifier(_today());
    _to = ValueNotifier(_today());
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _reason.dispose();
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  Future<void> _pick(ValueNotifier<DateTime> which) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: which.value,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    which.value = picked;
    if (_to.value.isBefore(_from.value)) _to.value = _from.value;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.reqRaiseLeave),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<DateTime>(
                valueListenable: _from,
                builder: (context, d, _) => PickerField(
                  label: l.reqFrom,
                  value: formatShortDate(context, d),
                  onTap: () => _pick(_from),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<DateTime>(
                valueListenable: _to,
                builder: (context, d, _) => PickerField(
                  label: l.reqTo,
                  value: formatShortDate(context, d),
                  onTap: () => _pick(_to),
                ),
              ),
              TextFormField(
                controller: _reason,
                maxLength: 300,
                maxLines: 3,
                minLines: 2,
                decoration: InputDecoration(labelText: l.reqReason),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_key.currentState!.validate()) return;
            Navigator.pop(
              context,
              LeaveDraft(
                startsOn: _from.value,
                endsOn: _to.value,
                reason: _reason.text,
              ),
            );
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.reqSend),
        ),
      ],
    );
  }
}

/// Asks what the meeting is about.
Future<MeetingDraft?> showMeetingDialog(BuildContext context) =>
    showDialog<MeetingDraft>(
      context: context,
      builder: (_) => const _MeetingDialog(),
    );

class _MeetingDialog extends StatefulWidget {
  const _MeetingDialog();

  @override
  State<_MeetingDialog> createState() => _MeetingDialogState();
}

class _MeetingDialogState extends State<_MeetingDialog> {
  late final TextEditingController _subject;
  late final TextEditingController _details;
  late final ValueNotifier<DateTime?> _day;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _subject = TextEditingController();
    _details = TextEditingController();
    _day = ValueNotifier(null);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _subject.dispose();
    _details.dispose();
    _day.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.reqRaiseMeeting),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _subject,
                maxLength: 120,
                decoration: InputDecoration(labelText: l.reqSubject),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              TextFormField(
                controller: _details,
                maxLength: 1000,
                maxLines: 4,
                minLines: 2,
                decoration: InputDecoration(labelText: l.reqDetails),
              ),
              ValueListenableBuilder<DateTime?>(
                valueListenable: _day,
                builder: (context, d, _) => PickerField(
                  label: l.reqPreferredOn,
                  value: d == null ? '' : formatShortDate(context, d),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: d ?? _today(),
                      firstDate: _today(),
                      lastDate: _today().add(const Duration(days: 365)),
                    );
                    if (picked != null) _day.value = picked;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_key.currentState!.validate()) return;
            Navigator.pop(
              context,
              MeetingDraft(
                subject: _subject.text,
                details: _details.text,
                preferredOn: _day.value,
              ),
            );
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.reqSend),
        ),
      ],
    );
  }
}

/// Asks the day and time to give a meeting; null when cancelled.
Future<({DateTime day, int at})?> showMeetingTimeDialog(BuildContext context) =>
    showDialog<({DateTime day, int at})>(
      context: context,
      builder: (_) => const _MeetingTimeDialog(),
    );

class _MeetingTimeDialog extends StatefulWidget {
  const _MeetingTimeDialog();

  @override
  State<_MeetingTimeDialog> createState() => _MeetingTimeDialogState();
}

class _MeetingTimeDialogState extends State<_MeetingTimeDialog> {
  late final ValueNotifier<DateTime> _day;
  late final ValueNotifier<int> _at;

  @override
  void initState() {
    super.initState();
    _day = ValueNotifier(_today());
    _at = ValueNotifier(10 * 60);
  }

  @override
  void dispose() {
    _day.dispose();
    _at.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.reqApprove),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _day,
            builder: (context, d, _) => PickerField(
              label: l.reqMeetingOn,
              value: formatShortDate(context, d),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: d,
                  firstDate: _today(),
                  lastDate: _today().add(const Duration(days: 365)),
                );
                if (picked != null) _day.value = picked;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ValueListenableBuilder<int>(
            valueListenable: _at,
            builder: (context, m, _) => PickerField(
              label: l.reqMeetingAt,
              value: m.clock(context),
              onTap: () async {
                final picked = await pickMinute(context, initial: m);
                if (picked != null) _at.value = picked;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, (day: _day.value, at: _at.value)),
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.reqApprove),
        ),
      ],
    );
  }
}

/// Asks why a request is rejected; null when cancelled.
Future<String?> showRejectDialog(BuildContext context) =>
    showDialog<String>(context: context, builder: (_) => const _RejectDialog());

class _RejectDialog extends StatefulWidget {
  const _RejectDialog();

  @override
  State<_RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<_RejectDialog> {
  late final TextEditingController _reason;

  @override
  void initState() {
    super.initState();
    _reason = TextEditingController();
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.reqReject),
      content: TextField(
        controller: _reason,
        autofocus: true,
        maxLength: 200,
        decoration: InputDecoration(labelText: l.reqRejectReason),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _reason.text),
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.reqReject),
        ),
      ],
    );
  }
}
