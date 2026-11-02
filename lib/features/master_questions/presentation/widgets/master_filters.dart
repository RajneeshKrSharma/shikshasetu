import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/scroll_hint.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../bloc/master_browse_cubit.dart';

/// Search box and type chips for the master bank. Expects a
/// [MasterBrowseCubit] above it.
class MasterFilters extends StatelessWidget {
  const MasterFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<MasterBrowseCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        children: [
          TextField(
            onChanged: cubit.search,
            decoration: InputDecoration(
              hintText: l.fieldQuestion,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          BlocBuilder<MasterBrowseCubit, MasterBrowseState>(
            buildWhen: (a, b) => a.types != b.types,
            builder: (context, s) => ScrollHint(
              itemCount: QuestionType.values.length,
              builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final t in QuestionType.values) ...[
                      FilterChip(
                        avatar: Icon(t.icon, size: AppIconSize.sm),
                        label: Text(t.label(l)),
                        selected: s.types.contains(t),
                        onSelected: (_) => cubit.toggleType(t),
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
