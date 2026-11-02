import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../../../exams/presentation/widgets/question_editor_card.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../../domain/entities/bank_scope.dart';
import '../bloc/photo_questions_cubit.dart';
import '../../domain/entities/review.dart';
import '../widgets/review_flag_style.dart';
import '../widgets/unit_picker.dart';
import 'paper_maker_screen.dart';

/// Photographs the questions of a unit, reads them, lets the teacher check
/// and fix each one, and saves them into the unit.
class PhotoQuestionsScreen extends StatelessWidget {
  const PhotoQuestionsScreen({super.key, required this.source});

  /// The way the teacher chose to get the photo.
  final PhotoSource source;

  static Future<void> open(
    BuildContext context,
    BankScope scope, {
    required PhotoSource source,
    String? unitId,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) =>
            sl<PhotoQuestionsCubit>(param1: scope, param2: unitId)..load(),
        child: PhotoQuestionsScreen(source: source),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PhotoQuestionsCubit>();
    return BlocBuilder<PhotoQuestionsCubit, PhotoQuestionsState>(
      buildWhen: (a, b) =>
          a.step != b.step ||
          a.fixIndex != b.fixIndex ||
          a.items.length != b.items.length,
      builder: (context, s) {
        final fixing = s.step == PhotoStep.fix;
        final n = switch (s.step) {
          PhotoStep.setup => 1,
          PhotoStep.review => 3,
          PhotoStep.fix => 3,
          PhotoStep.saved => 4,
        };
        return PopScope(
          canPop: !fixing,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) cubit.fixFinished();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(fixing ? l.photoFixTitle : l.photoTitle),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Center(
                    child: Text(
                      fixing
                          ? l.photoFixOf((s.fixIndex ?? 0) + 1, s.items.length)
                          : l.photoStep(n),
                      style: context.text.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
            body: switch (s.step) {
              PhotoStep.setup => _SetupBody(source: source),
              PhotoStep.review => const _ReviewBody(),
              PhotoStep.fix => const _FixBody(),
              PhotoStep.saved => const _SavedBody(),
            },
          ),
        );
      },
    );
  }
}

class _SetupBody extends StatelessWidget {
  const _SetupBody({required this.source});

  final PhotoSource source;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PhotoQuestionsCubit>();
    return BlocBuilder<PhotoQuestionsCubit, PhotoQuestionsState>(
      builder: (context, s) {
        final camera = FilledButton.icon(
          onPressed: s.reading
              ? null
              : () => cubit.takePhoto(PhotoSource.camera),
          icon: const Icon(Icons.photo_camera_outlined),
          label: Text(s.pages.isEmpty ? l.scanCamera : l.photoAddPage),
        );
        final gallery = OutlinedButton.icon(
          onPressed: s.reading
              ? null
              : () => cubit.takePhoto(PhotoSource.gallery),
          icon: const Icon(Icons.photo_library_outlined),
          label: Text(l.scanGallery),
        );
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  Text(l.photoWhereGo, style: context.text.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${l.bankClassSubject}: '
                    '${l.classLabel(cubit.scope.classSection)} · '
                    '${cubit.scope.subject}',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  UnitPicker(
                    units: s.units,
                    unitId: s.unitId,
                    error: s.unitMissing,
                    onChosen: cubit.unitChosen,
                    onNewUnit: cubit.unitAdded,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(l.scanLanguage, style: context.text.labelSmall),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ScanScript>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: ScanScript.latin,
                          label: Text('English'),
                        ),
                        ButtonSegment(
                          value: ScanScript.devanagari,
                          label: Text('हिन्दी'),
                        ),
                      ],
                      selected: {s.script},
                      onSelectionChanged: (v) => cubit.scriptChosen(v.first),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.photoTips, style: context.text.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        for (final t in [l.photoTip1, l.photoTip2, l.photoTip3])
                          Text('• $t', style: context.text.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (s.pages.isNotEmpty) ...[
                    Text(
                      l.photoPages(s.pages.length),
                      style: context.text.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: s.pages.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, i) => _PageThumb(
                          path: s.pages[i],
                          label: l.photoPageN(i + 1),
                          onRemove: () => cubit.pageRemoved(i),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (s.nothingFound)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: Text(
                        l.photoNothing,
                        style: context.text.bodyMedium!.copyWith(
                          color: AppColors.absent,
                        ),
                      ),
                    ),
                  if (source == PhotoSource.gallery) ...[
                    gallery,
                    const SizedBox(height: AppSpacing.md),
                    camera,
                  ] else ...[
                    camera,
                    const SizedBox(height: AppSpacing.md),
                    gallery,
                  ],
                ],
              ),
            ),
            if (s.pages.isNotEmpty)
              SafeArea(
                child: Padding(
                  padding: AppSpacing.pageOf(context),
                  child: s.reading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(l.photoReading),
                          ],
                        )
                      : FilledButton(
                          onPressed: cubit.read,
                          child: Text(l.photoRead),
                        ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PageThumb extends StatelessWidget {
  const _PageThumb({
    required this.path,
    required this.label,
    required this.onRemove,
  });

  final String path;
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: AppRadius.mdAll,
          child: Image.file(
            File(path),
            width: 72,
            height: 96,
            fit: BoxFit.cover,
            semanticLabel: label,
            errorBuilder: (_, _, _) => Container(
              width: 72,
              height: 96,
              color: AppColors.pendingLight,
              alignment: Alignment.center,
              child: Text(label, style: context.text.labelSmall),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: onRemove,
            child: const Icon(Icons.cancel, size: AppIconSize.md),
          ),
        ),
      ],
    );
  }
}

class _ReviewBody extends StatelessWidget {
  const _ReviewBody();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PhotoQuestionsCubit>();
    return BlocBuilder<PhotoQuestionsCubit, PhotoQuestionsState>(
      builder: (context, s) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  Text(
                    l.photoFound(
                      s.items.length,
                      s.pages.length,
                      s.unit?.name ?? '',
                    ),
                    style: context.text.titleSmall,
                  ),
                  Text(l.photoCheckEach, style: context.text.bodySmall),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md,
                    children: [
                      for (final (f, label) in [
                        (ReviewFilter.all, l.photoFilterAll(s.items.length)),
                        (
                          ReviewFilter.needAnswer,
                          l.photoFilterNeed(
                            s.countOf(ReviewFlag.answerMissing),
                          ),
                        ),
                        (
                          ReviewFilter.check,
                          l.photoFilterCheck(s.countOf(ReviewFlag.checkPairs)),
                        ),
                      ])
                        ChoiceChip(
                          label: Text(label),
                          selected: s.filter == f,
                          onSelected: (_) => cubit.filterChanged(f),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final (i, item) in s.visible)
                    _ReviewRow(
                      item: item,
                      onToggle: () => cubit.toggled(i),
                      onOpen: () => cubit.fixOpened(i),
                    ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.pageOf(context),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.photoSaveTo(s.unit?.name ?? ''),
                        style: context.text.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FilledButton(
                      onPressed: s.saving || s.includedCount == 0
                          ? null
                          : cubit.save,
                      child: Text(l.photoSaveN(s.includedCount)),
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

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.item,
    required this.onToggle,
    required this.onOpen,
  });

  final ReviewItem item;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = item.draft;
    return InkWell(
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Checkbox(value: item.included, onChanged: (_) => onToggle()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium,
                  ),
                  Text(
                    item.flag == ReviewFlag.leftOut
                        ? l.photoHeadingNote
                        : '${d.type.label(l)}'
                              '${d.marks.isEmpty ? '' : ' · ${d.marks}'}',
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            StatusChip(
              label: item.flag.label(l),
              color: item.flag.color,
              background: item.flag.background,
            ),
          ],
        ),
      ),
    );
  }
}

class _FixBody extends StatelessWidget {
  const _FixBody();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PhotoQuestionsCubit>();
    return BlocBuilder<PhotoQuestionsCubit, PhotoQuestionsState>(
      builder: (context, s) {
        final i = s.fixIndex!;
        final last = i >= s.items.length - 1;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  QuestionEditorCard(draft: s.items[i].draft, handler: cubit),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.pageOf(context),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: i == 0
                            ? null
                            : () => cubit.fixFinished(by: -1),
                        child: Text(l.photoPrevious),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => cubit.fixFinished(by: last ? 0 : 1),
                        child: Text(last ? l.actionDone : l.photoNext),
                      ),
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

class _SavedBody extends StatelessWidget {
  const _SavedBody();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PhotoQuestionsCubit>();
    return BlocBuilder<PhotoQuestionsCubit, PhotoQuestionsState>(
      builder: (context, s) {
        final name = s.unit?.name ?? '';
        return ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.present,
              size: AppIconSize.xl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l.photoSavedCount(s.savedCount),
              textAlign: TextAlign.center,
              style: context.text.titleLarge,
            ),
            Text(
              '${l.classLabel(cubit.scope.classSection)} · '
              '${cubit.scope.subject} · $name',
              textAlign: TextAlign.center,
              style: context.text.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        Text(
                          l.photoBefore(name),
                          style: context.text.bodySmall,
                        ),
                        Text('${s.unitBefore}', style: context.text.titleLarge),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        Text(l.photoNow(name), style: context.text.bodySmall),
                        Text('${s.unitNow}', style: context.text.titleLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(
              onPressed: cubit.another,
              child: Text(l.photoTakeAnother),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => PaperMakerScreen.open(context, cubit.scope),
              child: Text(l.photoMakePaper),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.actionDone),
            ),
          ],
        );
      },
    );
  }
}
