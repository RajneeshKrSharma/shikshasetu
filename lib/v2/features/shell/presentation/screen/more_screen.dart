import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../session/domain/navigation/app_section.dart';
import '../widgets/section_look.dart';
import '../widgets/section_screens.dart';

/// The areas that do not fit along the bottom bar.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key, required this.sections});

  final List<AppSection> sections;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.navMore)),
    body: ListView(
      padding: AppSpacing.pageOf(context),
      children: [
        for (final section in sections)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SectionScreens().of(section),
                ),
              ),
              child: Row(
                children: [
                  Icon(section.icon, color: context.brand.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      section.label(context.l10n),
                      style: context.text.titleSmall,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
