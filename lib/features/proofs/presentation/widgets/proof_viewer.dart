import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';

/// Shows a saved proof (photo or signature) full size.
class ProofViewer extends StatelessWidget {
  const ProofViewer({super.key, required this.path});

  final String path;

  static Future<void> show(BuildContext context, String path) =>
      showDialog<void>(
        context: context,
        builder: (_) => ProofViewer(path: path),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Dialog(
      child: Padding(
        padding: AppSpacing.card,
        child: InteractiveViewer(
          child: Image.file(
            File(path),
            errorBuilder: (_, _, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(l.proofMissing),
            ),
          ),
        ),
      ),
    );
  }
}
