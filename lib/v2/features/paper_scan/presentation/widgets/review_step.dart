import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/info_banner.dart';
import '../../../../../features/exams/presentation/widgets/paper_labels.dart';
import '../bloc/paper_scan_bloc.dart';
import 'details_form.dart';
import 'question_editor.dart';

/// Step 2: fix the school details and the questions that were read.
class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperScanBloc>();
    final start = bloc.state;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: AppSpacing.page,
            children: [
              InfoBanner(
                message: l.paperScanReviewHint,
                kind: BannerKind.warning,
              ),
              const SizedBox(height: AppSpacing.lg),
              DetailsForm(
                initial: start.details,
                schoolName: start.identity.name,
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<PaperScanBloc, PaperScanState>(
                buildWhen: (a, b) => a.questions.length != b.questions.length,
                builder: (context, s) => Column(
                  children: [
                    for (var i = 0; i < s.questions.length; i++)
                      QuestionEditor(
                        key: ValueKey(s.questions[i].id),
                        number: i + 1,
                        question: s.questions[i],
                      ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: () => bloc.add(const QuestionAdded()),
                  icon: const Icon(Icons.add),
                  label: Text(l.paperScanAddQuestion),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: BlocBuilder<PaperScanBloc, PaperScanState>(
              buildWhen: (a, b) => a.canBuild != b.canBuild || a.busy != b.busy,
              builder: (context, s) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!s.canBuild)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        l.paperScanNeedMore,
                        style: context.text.bodySmall,
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: s.canBuild && !s.busy
                        ? () => bloc.add(PdfRequested(paperLabelsOf(l)))
                        : null,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: Text(l.paperScanMakePdf),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
