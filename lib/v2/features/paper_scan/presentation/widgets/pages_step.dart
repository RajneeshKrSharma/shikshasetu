import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/info_banner.dart';
import '../../../../../features/exams/domain/entities/scanned_question.dart';
import '../bloc/paper_scan_bloc.dart';
import 'ai_key_card.dart';

/// Step 1: add a photo of every page, in order.
class PagesStep extends StatelessWidget {
  const PagesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperScanBloc>();
    return BlocBuilder<PaperScanBloc, PaperScanState>(
      buildWhen: (a, b) => a.pages != b.pages || a.busy != b.busy,
      builder: (context, s) => Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.page,
              children: [
                InfoBanner(message: l.paperScanIntro),
                const SizedBox(height: AppSpacing.lg),
                const AiKeyCard(),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    FilledButton.icon(
                      onPressed: s.busy
                          ? null
                          : () => bloc.add(
                              const PhotoRequested(PhotoSource.camera),
                            ),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: Text(l.scanCamera),
                    ),
                    OutlinedButton.icon(
                      onPressed: s.busy
                          ? null
                          : () => bloc.add(
                              const PhotoRequested(PhotoSource.gallery),
                            ),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l.scanGallery),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                if (s.pages.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Center(
                      child: Text(
                        l.paperScanNoPages,
                        style: context.text.bodyMedium!.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (var i = 0; i < s.pages.length; i++)
                        _PageThumb(
                          path: s.pages[i],
                          label: l.paperScanPageN(i + 1),
                          onRemove: s.busy
                              ? null
                              : () => bloc.add(PageRemoved(i)),
                        ),
                    ],
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
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: s.pages.isEmpty || s.busy
                      ? null
                      : () => bloc.add(const ReadRequested()),
                  icon: s.busy
                      ? SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: context.brand.onPrimary,
                          ),
                        )
                      : const Icon(Icons.document_scanner_outlined),
                  label: Text(s.busy ? l.scanProcessing : l.paperScanRead),
                ),
              ),
            ),
          ),
        ],
      ),
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
  final VoidCallback? onRemove;

  static const _size = 120.0;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: _size,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.file(
                File(path),
                width: _size,
                height: _size * 1.3,
                fit: BoxFit.cover,
                cacheWidth: 360,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton.filledTonal(
                visualDensity: VisualDensity.compact,
                onPressed: onRemove,
                icon: const Icon(Icons.close, size: AppIconSize.md),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: context.text.labelMedium),
      ],
    ),
  );
}
