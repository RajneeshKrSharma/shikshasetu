import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../di/v2_injector.dart';
import '../bloc/paper_scan_bloc.dart';
import '../widgets/pages_step.dart';
import '../widgets/preview_step.dart';
import '../widgets/review_step.dart';

/// Turns photos of a handwritten question paper into a printable PDF. Needs no
/// sign-in, so it can be opened from the login screen.
class PaperScanScreen extends StatelessWidget {
  const PaperScanScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const PaperScanScreen()));

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<PaperScanBloc>()..add(const PaperScanStarted()),
    child: const _PaperScanView(),
  );
}

class _PaperScanView extends StatelessWidget {
  const _PaperScanView();

  String _notice(BuildContext context, PaperScanState s) {
    final l = context.l10n;
    return switch (s.notice!) {
      PaperScanNotice.missingKey => l.paperScanErrMissingKey,
      PaperScanNotice.noInternet => l.paperScanErrNoInternet,
      PaperScanNotice.invalidKey => l.paperScanErrInvalidKey,
      PaperScanNotice.quotaExceeded => l.paperScanErrQuota,
      PaperScanNotice.noCredit => l.paperScanErrNoCredit,
      PaperScanNotice.timedOut => l.paperScanErrTimeout,
      PaperScanNotice.serviceBusy => l.paperScanErrBusy,
      PaperScanNotice.tooLarge => l.paperScanErrTooLarge,
      PaperScanNotice.badReply => l.paperScanErrBadReply,
      PaperScanNotice.noQuestions => l.paperScanErrNoQuestions,
      PaperScanNotice.serviceError => l.paperScanErrService(
        s.noticeDetail ?? '',
      ),
      PaperScanNotice.readFailed => l.scanFailed,
      PaperScanNotice.buildFailed => l.paperScanBuildFailed,
      PaperScanNotice.printSent => l.printSent,
      PaperScanNotice.printCancelled => l.printCancelled,
      PaperScanNotice.printFailed => l.printFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperScanBloc>();
    return BlocListener<PaperScanBloc, PaperScanState>(
      listenWhen: (a, b) => a.noticeId != b.noticeId && b.notice != null,
      listener: (context, s) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_notice(context, s)))),
      child: BlocBuilder<PaperScanBloc, PaperScanState>(
        buildWhen: (a, b) => a.step != b.step,
        builder: (context, s) => PopScope(
          // On the first step the back button leaves; on the others it goes
          // back one step.
          canPop: s.step == PaperScanStep.pages,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) bloc.add(const BackRequested());
          },
          child: Scaffold(
            appBar: AppBar(title: Text(l.paperScanTitle)),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: switch (s.step) {
                  PaperScanStep.pages => const PagesStep(),
                  PaperScanStep.review => const ReviewStep(),
                  PaperScanStep.preview => const PreviewStep(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
