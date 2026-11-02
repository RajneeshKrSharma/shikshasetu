import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../printing/domain/entities/printer_device.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/exam_paper.dart';
import '../../domain/entities/paper_document.dart';
import '../bloc/paper_print_cubit.dart';
import '../widgets/paper_labels.dart';

/// Preview a paper and print it: on any A4 printer through the phone's print
/// dialog, or on a Bluetooth thermal printer. With [canPrint] false (the
/// paper is not approved yet) it is a preview only.
class PaperPrintScreen extends StatelessWidget {
  const PaperPrintScreen({
    super.key,
    required this.paper,
    required this.canPrint,
  });

  final ExamPaper paper;
  final bool canPrint;

  static Future<void> open(
    BuildContext context,
    ExamPaper paper, {
    required bool canPrint,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => PaperPrintScreen(paper: paper, canPrint: canPrint),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings = context.read<SettingsBloc>().state.settings;
    final dateText = formatShortDate(context, paper.date);
    final durationText = l.durationMinutes(paper.durationMinutes);
    final labels = paperLabelsOf(l);

    return BlocProvider(
      create: (_) => sl<PaperPrintCubit>(
        param1: (PaperLayout layout, bool key) => PaperDocumentRequest(
          paper: paper,
          schoolName: settings.schoolName,
          logoPath: settings.logoPath,
          labels: labels,
          dateText: dateText,
          durationText: durationText,
          includeAnswerKey: key,
          layout: layout,
        ),
        param2: paper.title,
      )..start(),
      child: _PrintView(canPrint: canPrint, hasAnswers: _hasAnswers(paper)),
    );
  }

  bool _hasAnswers(ExamPaper p) => p.questions.any(
    (q) =>
        q.correctIndex != null ||
        q.answer.isNotEmpty ||
        q.type == QuestionType.matchFollowing,
  );
}

class _PrintView extends StatelessWidget {
  const _PrintView({required this.canPrint, required this.hasAnswers});

  final bool canPrint;
  final bool hasAnswers;

  String _notice(PrintNotice n, BuildContext context) {
    final l = context.l10n;
    return switch (n) {
      PrintNotice.sent => l.printSent,
      PrintNotice.cancelled => l.printCancelled,
      PrintNotice.pickPrinter => l.printPickPrinter,
      PrintNotice.connectFailed => l.printConnectFailed,
      PrintNotice.writeFailed => l.printWriteFailed,
      PrintNotice.unsupported => l.printUnsupported,
      PrintNotice.failed => l.printFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperPrintCubit>();
    return BlocListener<PaperPrintCubit, PaperPrintState>(
      listenWhen: (a, b) => a.noticeId != b.noticeId && b.notice != null,
      listener: (context, s) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_notice(s.notice!, context)))),
      child: Scaffold(
        appBar: AppBar(title: Text(l.paperPreviewPrint)),
        body: BlocBuilder<PaperPrintCubit, PaperPrintState>(
          builder: (context, s) => ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              if (!canPrint) ...[
                _Tip(text: l.printOnlyApproved, warning: true),
                const SizedBox(height: AppSpacing.lg),
              ] else ...[
                SegmentedButton<PrintMode>(
                  segments: [
                    ButtonSegment(
                      value: PrintMode.system,
                      icon: const Icon(Icons.print_outlined),
                      label: Text(l.printModeInk),
                    ),
                    ButtonSegment(
                      value: PrintMode.thermal,
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: Text(l.printModeThermal),
                    ),
                  ],
                  selected: {s.mode},
                  onSelectionChanged: (v) => cubit.setMode(v.single),
                ),
                const SizedBox(height: AppSpacing.lg),
                _Tip(
                  text: s.mode == PrintMode.system
                      ? l.printTipInk
                      : l.printTipThermal,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (s.mode == PrintMode.thermal) ...[
                  _ThermalPanel(state: s),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (hasAnswers)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.printIncludeKey),
                    value: s.includeAnswerKey,
                    onChanged: cubit.setIncludeAnswerKey,
                  ),
                if (s.mode == PrintMode.thermal)
                  _CopiesRow(copies: s.copies, onChanged: cubit.setCopies),
                const SizedBox(height: AppSpacing.lg),
              ],
              _Preview(state: s),
            ],
          ),
        ),
        bottomNavigationBar: canPrint
            ? SafeArea(
                child: Padding(
                  padding: AppSpacing.pageOf(context),
                  child: BlocBuilder<PaperPrintCubit, PaperPrintState>(
                    buildWhen: (a, b) =>
                        a.busy != b.busy ||
                        a.building != b.building ||
                        a.pdf != b.pdf,
                    builder: (context, s) {
                      final ready = s.pdf != null && !s.building && !s.busy;
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: ready ? cubit.share : null,
                              icon: const Icon(Icons.ios_share),
                              label: Text(l.printShare),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: ready ? cubit.print : null,
                              icon: const Icon(Icons.print),
                              label: Text(l.printAction),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.text, this.warning = false});

  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) => InfoBanner(
    message: text,
    kind: warning ? BannerKind.warning : BannerKind.info,
  );
}

class _CopiesRow extends StatelessWidget {
  const _CopiesRow({required this.copies, required this.onChanged});

  final int copies;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(context.l10n.printCopies, style: context.text.bodyLarge),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: copies > 1 ? () => onChanged(copies - 1) : null,
        ),
        Text('$copies', style: context.text.titleMedium),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => onChanged(copies + 1),
        ),
      ],
    );
  }
}

class _ThermalPanel extends StatelessWidget {
  const _ThermalPanel({required this.state});

  final PaperPrintState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperPrintCubit>();
    final access = state.access;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.printRoll, style: context.text.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ThermalWidth>(
            segments: [
              ButtonSegment(value: ThermalWidth.mm58, label: Text(l.printMm58)),
              ButtonSegment(value: ThermalWidth.mm80, label: Text(l.printMm80)),
            ],
            selected: {state.width},
            onSelectionChanged: (v) => cubit.setWidth(v.single),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(l.printPrinters, style: context.text.labelMedium),
              ),
              TextButton.icon(
                onPressed: cubit.loadPrinters,
                icon: const Icon(Icons.refresh, size: AppIconSize.sm),
                label: Text(l.printRefresh),
              ),
            ],
          ),
          if (access == ThermalAccess.unsupported)
            Text(l.printUnsupported, style: context.text.bodySmall)
          else if (access == ThermalAccess.permissionDenied)
            Text(l.printNeedPermission, style: context.text.bodySmall)
          else if (access == ThermalAccess.bluetoothOff)
            Text(l.printBluetoothOff, style: context.text.bodySmall)
          else if (state.devices.isEmpty)
            Text(l.printNoPrinters, style: context.text.bodySmall)
          else
            RadioGroup<PrinterDevice>(
              groupValue: state.selected,
              onChanged: (d) {
                if (d != null) cubit.selectPrinter(d);
              },
              child: Column(
                children: [
                  for (final d in state.devices)
                    RadioListTile<PrinterDevice>(
                      contentPadding: EdgeInsets.zero,
                      value: d,
                      title: Text(d.name),
                      subtitle: Text(d.address),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.state});

  final PaperPrintState state;

  @override
  Widget build(BuildContext context) {
    final pdf = state.pdf;
    return Container(
      height: 480,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
      ),
      child: pdf == null
          ? Center(
              child: state.building
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          context.l10n.printBuilding,
                          style: context.text.bodySmall,
                        ),
                      ],
                    )
                  : Text(context.l10n.printFailed),
            )
          : Stack(
              children: [
                PdfPreview(
                  // A new key rebuilds the preview when the document changes.
                  key: ValueKey(Object.hash(pdf.length, state.layout)),
                  build: (_) async => pdf,
                  useActions: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  canDebug: false,
                  allowPrinting: false,
                  allowSharing: false,
                  scrollViewDecoration: BoxDecoration(
                    color: AppColors.background,
                  ),
                ),
                if (state.building)
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
