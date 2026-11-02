import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../domain/entities/proof_source.dart';
import '../bloc/proof_cubit.dart';
import 'proof_viewer.dart';

/// Adds a photo as proof: a button to take or choose one, then a thumbnail
/// that can be opened or removed. Expects a [ProofCubit] above it.
class ProofPhotoField extends StatelessWidget {
  const ProofPhotoField({
    super.key,
    required this.label,
    this.required = false,
  });

  final String label;

  /// Draws the box in the error color until a photo is added.
  final bool required;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<ProofCubit, ProofState>(
      buildWhen: (a, b) => a.photoPath != b.photoPath || a.busy != b.busy,
      builder: (context, state) {
        final cubit = context.read<ProofCubit>();
        final path = state.photoPath;
        return Container(
          width: double.infinity,
          padding: AppSpacing.card,
          decoration: BoxDecoration(
            borderRadius: AppRadius.lgAll,
            border: Border.all(
              color: required && path == null
                  ? AppColors.absent
                  : context.brand.primary.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.text.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              if (path == null)
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, AppSizes.buttonCompact),
                      ),
                      onPressed: state.busy
                          ? null
                          : () => cubit.takePhoto(ProofSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: Text(l.proofTakePhoto),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, AppSizes.buttonCompact),
                      ),
                      onPressed: state.busy
                          ? null
                          : () => cubit.takePhoto(ProofSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l.proofFromGallery),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    InkWell(
                      onTap: () => ProofViewer.show(context, path),
                      borderRadius: AppRadius.mdAll,
                      child: ClipRRect(
                        borderRadius: AppRadius.mdAll,
                        child: Image.file(
                          File(path),
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox(
                            width: 72,
                            height: 72,
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    TextButton(
                      onPressed: cubit.removePhoto,
                      child: Text(l.proofRemove),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
