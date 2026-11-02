import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../domain/entities/scanned_question.dart';

class ScanChoice {
  const ScanChoice(this.source, this.script);

  final PhotoSource source;
  final ScanScript script;
}

/// Language names are shown in their own script, so they are not localized.
const _scripts = [
  (ScanScript.latin, 'English'),
  (ScanScript.devanagari, 'हिन्दी'),
];

/// Asks where the photo comes from and which language the text is in.
class ScanSourceSheet extends StatefulWidget {
  const ScanSourceSheet({super.key, required this.initialScript});

  final ScanScript initialScript;

  @override
  State<ScanSourceSheet> createState() => _ScanSourceSheetState();
}

class _ScanSourceSheetState extends State<ScanSourceSheet> {
  // A purely visual choice inside this sheet, held in a notifier.
  late final ValueNotifier<ScanScript> _script;

  @override
  void initState() {
    super.initState();
    _script = ValueNotifier(widget.initialScript);
  }

  @override
  void dispose() {
    _script.dispose();
    super.dispose();
  }

  void _pick(PhotoSource source) =>
      Navigator.of(context).pop(ScanChoice(source, _script.value));

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
            Text(l.scanSourceTitle, style: context.text.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            Text(l.scanLanguage, style: context.text.labelSmall),
            const SizedBox(height: AppSpacing.sm),
            ValueListenableBuilder<ScanScript>(
              valueListenable: _script,
              builder: (context, script, _) => SegmentedButton<ScanScript>(
                showSelectedIcon: false,
                segments: [
                  for (final (s, name) in _scripts)
                    ButtonSegment(value: s, label: Text(name)),
                ],
                selected: {script},
                onSelectionChanged: (s) => _script.value = s.first,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => _pick(PhotoSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(l.scanCamera),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => _pick(PhotoSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(l.scanGallery),
            ),
          ],
        ),
      ),
    );
  }
}
