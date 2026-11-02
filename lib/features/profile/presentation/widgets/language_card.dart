import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../settings/presentation/bloc/locale_cubit.dart';

/// Language names are shown in their own script, so they are not localized.
const _languages = [(Locale('en'), 'English'), (Locale('hi'), 'हिन्दी')];

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Icon(Icons.translate, color: context.brand.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              context.l10n.profileLanguage,
              style: context.text.titleSmall,
            ),
          ),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) => SegmentedButton<Locale>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              segments: [
                for (final (l, name) in _languages)
                  ButtonSegment(value: l, label: Text(name)),
              ],
              selected: {locale},
              onSelectionChanged: (s) =>
                  context.read<LocaleCubit>().select(s.first),
            ),
          ),
        ],
      ),
    );
  }
}
