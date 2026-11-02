import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/exams.dart';

/// One field per student for the marks, or absent; closes with the entries.
class MarksEntryScreen extends StatefulWidget {
  const MarksEntryScreen({
    super.key,
    required this.lines,
    required this.maxMarks,
  });

  final List<MarkLine> lines;
  final int maxMarks;

  @override
  State<MarksEntryScreen> createState() => _MarksEntryScreenState();
}

class _MarksEntryScreenState extends State<MarksEntryScreen> {
  late final Map<String, TextEditingController> _marks;
  late final Map<String, ValueNotifier<bool>> _absent;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _marks = {
      for (final l in widget.lines)
        l.studentId: TextEditingController(
          text: l.marks == null ? '' : '${l.marks}',
        ),
    };
    _absent = {
      for (final l in widget.lines) l.studentId: ValueNotifier(l.absent),
    };
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    for (final c in _marks.values) {
      c.dispose();
    }
    for (final n in _absent.values) {
      n.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_key.currentState!.validate()) return;
    final entries = <MarkEntry>[];
    for (final l in widget.lines) {
      final absent = _absent[l.studentId]!.value;
      final text = _marks[l.studentId]!.text.trim();
      if (!absent && text.isEmpty) continue;
      entries.add(
        MarkEntry(
          studentId: l.studentId,
          marks: absent ? null : int.parse(text),
          absent: absent,
        ),
      );
    }
    Navigator.of(context).pop(entries);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.exmEnterMarks),
        actions: [TextButton(onPressed: _save, child: Text(l.exmMarksSave))],
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: AppSpacing.page,
          children: [
            for (final line in widget.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _absent[line.studentId]!,
                  builder: (context, absent, _) => Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${line.rollNumber}. ${line.name}',
                          style: context.text.bodyMedium,
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          controller: _marks[line.studentId],
                          enabled: !absent,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '/ ${widget.maxMarks}',
                          ),
                          validator: (v) {
                            if (absent || v == null || v.trim().isEmpty) {
                              return null;
                            }
                            final n = int.tryParse(v.trim());
                            if (n == null || n < 0) return l.errorAmountInvalid;
                            return n > widget.maxMarks
                                ? l.exmMarksTooHigh
                                : null;
                          },
                        ),
                      ),
                      Checkbox(
                        value: absent,
                        onChanged: (v) =>
                            _absent[line.studentId]!.value = v ?? false,
                      ),
                      Text(l.exmAbsent, style: context.text.labelSmall),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
