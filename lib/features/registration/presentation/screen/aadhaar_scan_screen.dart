import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/aadhaar.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../bloc/aadhaar_capture_cubit.dart';
import '../widgets/aadhaar_problem_l10n.dart';
import '../widgets/aadhaar_widgets.dart';
import '../widgets/gender_l10n.dart';

/// Takes both sides of an Aadhaar card on one screen and reads them: the front
/// gives the number, name, gender and date of birth; the back, the address.
/// Pops with what was found (or null if the person backs out).
class AadhaarScanScreen extends StatelessWidget {
  const AadhaarScanScreen({super.key});

  static Future<AadhaarReading?> open(BuildContext context) =>
      Navigator.of(context).push<AadhaarReading>(
        MaterialPageRoute(builder: (_) => const AadhaarScanScreen()),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<AadhaarCaptureCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l.aadhaarScan)),
        body: BlocBuilder<AadhaarCaptureCubit, AadhaarCaptureState>(
          builder: (context, s) => ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              Text(l.aadhaarScanIntro, style: context.text.bodySmall),
              const SizedBox(height: AppSpacing.lg),
              if (s.result == null) ...[
                _SideCard(
                  side: AadhaarSide.front,
                  title: l.aadhaarSideFront,
                  hint: l.aadhaarSideFrontHint,
                  path: s.frontPath,
                  enabled: !s.reading,
                ),
                const SizedBox(height: AppSpacing.lg),
                _SideCard(
                  side: AadhaarSide.back,
                  title: l.aadhaarSideBack,
                  hint: l.aadhaarSideBackHint,
                  path: s.backPath,
                  enabled: !s.reading,
                ),
                const SizedBox(height: AppSpacing.lg),
                const _Tips(),
                if (s.failed) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l.aadhaarProbError,
                    style: context.text.bodyMedium!.copyWith(
                      color: AppColors.absent,
                    ),
                  ),
                ],
                if (s.frontPath != null && s.backPath == null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(l.aadhaarAddBack, style: context.text.bodySmall),
                ],
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: s.canRead
                      ? context.read<AadhaarCaptureCubit>().read
                      : null,
                  icon: s.reading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: context.brand.onPrimary,
                          ),
                        )
                      : const Icon(Icons.document_scanner_outlined),
                  label: Text(s.reading ? l.aadhaarReading : l.aadhaarRead),
                ),
              ] else
                _Result(reading: s.result!, hasBack: s.backPath != null),
            ],
          ),
        ),
      ),
    );
  }
}

/// One side of the card: its photo (or a place for it) and the buttons to
/// take or choose one.
class _SideCard extends StatelessWidget {
  const _SideCard({
    required this.side,
    required this.title,
    required this.hint,
    required this.path,
    required this.enabled,
  });

  final AadhaarSide side;
  final String title;
  final String hint;
  final String? path;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<AadhaarCaptureCubit>();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                path == null ? Icons.circle_outlined : Icons.check_circle,
                color: path == null ? AppColors.textMuted : AppColors.present,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.text.titleMedium),
                    Text(hint, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: AppRadius.mdAll,
            child: AspectRatio(
              aspectRatio: 1.6,
              child: path == null
                  ? Container(
                      color: AppColors.pendingLight,
                      child: Icon(
                        side == AadhaarSide.front
                            ? Icons.badge_outlined
                            : Icons.flip_outlined,
                        size: AppIconSize.hero,
                        color: AppColors.textMuted,
                      ),
                    )
                  : Image.file(File(path!), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: enabled
                      ? () => cubit.pick(side, PhotoSource.camera)
                      : null,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(
                    path == null ? l.scanCamera : l.aadhaarRetakeSide,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: enabled
                      ? () => cubit.pick(side, PhotoSource.gallery)
                      : null,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l.scanGallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tips extends StatelessWidget {
  const _Tips();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.aadhaarTipsTitle, style: context.text.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        for (final tip in [
          (Icons.wb_sunny_outlined, l.aadhaarTipLight),
          (Icons.crop_free, l.aadhaarTipFlat),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Icon(
                  tip.$1,
                  size: AppIconSize.sm,
                  color: context.brand.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(tip.$2, style: context.text.bodySmall)),
              ],
            ),
          ),
      ],
    );
  }
}

/// What was found, field by field, before anything goes into the form.
class _Result extends StatelessWidget {
  const _Result({required this.reading, required this.hasBack});

  final AadhaarReading reading;
  final bool hasBack;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<AadhaarCaptureCubit>();
    final r = reading;
    final numberOk = r.problem == AadhaarProblem.none;
    final formatted = r.number == null
        ? null
        : AadhaarInputFormatter()
              .formatEditUpdate(
                TextEditingValue.empty,
                TextEditingValue(text: r.number!),
              )
              .text;
    final rows = <_FoundRow>[
      _FoundRow(
        label: l.fieldAadhaar,
        value: numberOk ? formatted : null,
        problem: numberOk ? null : r.problem.title(l),
        detail: numberOk ? null : r.problem.body(l, number: r.number),
      ),
      _FoundRow(
        label: l.fieldFullName,
        value: r.name ?? r.nameHi,
        detail: _otherScript(r.name, r.nameHi),
      ),
      _FoundRow(label: l.fieldGender, value: r.gender?.label(l)),
      _FoundRow(
        label: l.fieldDob,
        value: r.dateOfBirth == null
            ? null
            : formatShortDate(context, r.dateOfBirth!),
      ),
      _FoundRow(
        label: l.fieldAddress,
        value: r.addressHi ?? r.address,
        detail: r.conflictingNumber != null
            ? l.aadhaarMismatchAddress
            : (r.address == null && r.addressHi == null && hasBack
                  ? l.aadhaarBackNoAddress
                  : null),
      ),
    ];
    final anything = rows.any((x) => x.value != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (r.conflictingNumber != null) ...[
          _MismatchWarning(
            front: formatted ?? '',
            back: AadhaarInputFormatter()
                .formatEditUpdate(
                  TextEditingValue.empty,
                  TextEditingValue(text: r.conflictingNumber!),
                )
                .text,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        SectionTitle(l.aadhaarFound),
        AppCard(
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                rows[i],
                if (i != rows.length - 1)
                  Divider(height: AppSpacing.xl, color: AppColors.border),
              ],
            ],
          ),
        ),
        if (kDebugMode && r.debugText != null) ...[
          const SizedBox(height: AppSpacing.md),
          // Only in debug builds: the raw text the phone read, to see why a
          // photo was not understood.
          ExpansionTile(
            title: const Text('Debug: text the phone read'),
            children: [SelectableText(r.debugText!)],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: anything ? () => Navigator.of(context).pop(reading) : null,
          icon: const Icon(Icons.check),
          label: Text(l.aadhaarUse),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: cubit.startOver,
          icon: const Icon(Icons.photo_camera_outlined),
          label: Text(l.aadhaarRetakeBoth),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.aadhaarTypeInstead),
        ),
      ],
    );
  }
}

/// When a value was read in both languages, the one not shown as the main
/// value, labelled with its language (named in its own script, as elsewhere).
String? _otherScript(String? english, String? hindi) {
  if (english != null && hindi != null) return 'हिन्दी: $hindi';
  return null;
}

class _FoundRow extends StatelessWidget {
  const _FoundRow({required this.label, this.value, this.problem, this.detail});

  final String label;

  /// What was found, or null when nothing was.
  final String? value;

  /// A short reason the value could not be used, and a longer explanation.
  final String? problem;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final found = value != null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          found ? Icons.check_circle : Icons.warning_amber_rounded,
          color: found ? AppColors.present : AppColors.late,
          size: AppIconSize.md,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.text.labelSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                found ? value! : (problem ?? l.aadhaarNotFound),
                style: found
                    ? context.text.titleSmall
                    : context.text.bodyMedium!.copyWith(color: AppColors.late),
              ),
              if (detail != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(detail!, style: context.text.bodySmall),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// The front and back photos show different Aadhaar numbers: probably two
/// different cards, so nothing from the back was used.
class _MismatchWarning extends StatelessWidget {
  const _MismatchWarning({required this.front, required this.back});

  final String front;
  final String back;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.absentLight,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.absent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.absent),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  l.aadhaarMismatchTitle,
                  style: context.text.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l.aadhaarMismatchBody(front, back),
            style: context.text.bodyMedium,
          ),
        ],
      ),
    );
  }
}
