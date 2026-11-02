import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// A small capital heading above a group of tiles or rows ("PEOPLE").
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
    child: Text(
      text.toUpperCase(),
      style: context.text.labelSmall!.copyWith(
        letterSpacing: 1.1,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
