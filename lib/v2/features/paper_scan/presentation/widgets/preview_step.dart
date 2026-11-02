import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../bloc/paper_scan_bloc.dart';

/// Step 3: the finished paper, to print or share.
class PreviewStep extends StatelessWidget {
  const PreviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperScanBloc>();
    return BlocBuilder<PaperScanBloc, PaperScanState>(
      buildWhen: (a, b) => a.pdf != b.pdf || a.busy != b.busy,
      builder: (context, s) {
        final pdf = s.pdf;
        return Column(
          children: [
            Expanded(
              child: pdf == null
                  ? const Center(child: CircularProgressIndicator())
                  : PdfPreview(
                      build: (_) async => pdf,
                      useActions: false,
                      canChangePageFormat: false,
                      canChangeOrientation: false,
                      canDebug: false,
                    ),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.page,
                child: Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: s.busy
                          ? null
                          : () => bloc.add(const BackRequested()),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(l.paperScanEditQuestions),
                    ),
                    OutlinedButton.icon(
                      onPressed: pdf == null || s.busy
                          ? null
                          : () => bloc.add(const ShareRequested()),
                      icon: const Icon(Icons.ios_share),
                      label: Text(l.printShare),
                    ),
                    FilledButton.icon(
                      onPressed: pdf == null || s.busy
                          ? null
                          : () => bloc.add(const PrintRequested()),
                      icon: const Icon(Icons.print),
                      label: Text(l.printAction),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
