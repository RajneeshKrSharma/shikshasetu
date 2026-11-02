import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/exams.dart';
import '../widgets/exam_labels.dart';

/// Ticks the questions for the paper; closes with the chosen ids.
class PaperComposeScreen extends StatefulWidget {
  const PaperComposeScreen({
    super.key,
    required this.available,
    required this.selected,
  });

  final List<Question> available;
  final List<String> selected;

  @override
  State<PaperComposeScreen> createState() => _PaperComposeScreenState();
}

class _PaperComposeScreenState extends State<PaperComposeScreen> {
  late final ValueNotifier<Set<String>> _chosen;

  @override
  void initState() {
    super.initState();
    _chosen = ValueNotifier({...widget.selected});
  }

  @override
  void dispose() {
    _chosen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.exmPaperCompose)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.page,
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: _chosen,
            builder: (context, chosen, _) => FilledButton(
              onPressed: () => Navigator.of(context).pop([
                for (final q in widget.available)
                  if (chosen.contains(q.id)) q.id,
              ]),
              child: Text(l.exmPaperUse(chosen.length)),
            ),
          ),
        ),
      ),
      body: widget.available.isEmpty
          ? Center(
              child: Padding(
                padding: AppSpacing.page,
                child: Text(l.exmPaperBankEmpty, textAlign: TextAlign.center),
              ),
            )
          : ValueListenableBuilder<Set<String>>(
              valueListenable: _chosen,
              builder: (context, chosen, _) => ListView(
                children: [
                  for (final q in widget.available)
                    CheckboxListTile(
                      value: chosen.contains(q.id),
                      title: Text(q.text),
                      subtitle: Text('${q.type.label(l)} · ${q.marks}'),
                      onChanged: (on) {
                        final next = {...chosen};
                        on == true ? next.add(q.id) : next.remove(q.id);
                        _chosen.value = next;
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
