import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/suggested_holiday.dart';
import '../bloc/suggested_holidays_cubit.dart';

/// A list of India's public holidays for the Principal to tick. Pops with the
/// ones chosen.
class SuggestedHolidaysSheet extends StatelessWidget {
  const SuggestedHolidaysSheet({super.key});

  static Future<List<SuggestedHoliday>?> show(BuildContext context) =>
      showModalBottomSheet<List<SuggestedHoliday>>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => BlocProvider(
          create: (_) =>
              sl<SuggestedHolidaysCubit>(param1: DateTime.now().year)
                ..setYear(DateTime.now().year),
          child: const SuggestedHolidaysSheet(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hindi = Localizations.localeOf(context).languageCode == 'hi';
    final thisYear = DateTime.now().year;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: BlocBuilder<SuggestedHolidaysCubit, SuggestedHolidaysState>(
          builder: (context, s) {
            final cubit = context.read<SuggestedHolidaysCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.holidaySuggested, style: context.text.titleLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l.holidaySuggestedNote,
                        style: context.text.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.md,
                        children: [
                          for (final y in [thisYear, thisYear + 1])
                            ChoiceChip(
                              label: Text('$y'),
                              selected: s.year == y,
                              onSelected: (_) => cubit.setYear(y),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: s.items.length,
                    itemBuilder: (context, i) {
                      final h = s.items[i];
                      return CheckboxListTile(
                        value: s.selected.contains(i),
                        activeColor: AppColors.present,
                        tileColor: s.selected.contains(i)
                            ? AppColors.presentLight
                            : null,
                        onChanged: (_) => cubit.toggle(i),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(h.name(hindi: hindi)),
                        subtitle: Text(formatLongDate(context, h.date)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: AppSpacing.pageOf(context),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: s.selected.isEmpty
                          ? null
                          : () => Navigator.of(context).pop(s.chosen),
                      child: Text(l.holidaySuggestedAdd(s.selected.length)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
