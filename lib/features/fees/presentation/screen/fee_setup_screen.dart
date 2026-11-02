import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_structure_item.dart';
import '../bloc/fee_setup_bloc.dart';
import '../bloc/fees_bloc.dart';
import '../widgets/fee_head_sheet.dart';
import '../widgets/fee_labels.dart';

/// What each class pays for each kind of fee, and its dates, and giving it to
/// the class's students.
class FeeSetupScreen extends StatelessWidget {
  const FeeSetupScreen({super.key});

  static Future<void> open(BuildContext context) {
    final classes = context.read<ClassesBloc>().state.classes;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<FeeSetupBloc>(
            param1: classes.isEmpty ? null : classes.first.name,
          )..add(const FeeSetupStarted()),
          child: const FeeSetupScreen(),
        ),
      ),
    );
  }

  static const _heads = [
    FeeHead.academic,
    FeeHead.dress,
    FeeHead.books,
    FeeHead.van,
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.select((ClassesBloc b) => b.state.classes);
    return BlocListener<FeeSetupBloc, FeeSetupState>(
      listenWhen: (a, b) => a.appliedId != b.appliedId,
      listener: (context, state) {
        context.read<FeesBloc>().add(const FeesLoaded());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.appliedCount == 0
                  ? l.feeSetupNoneToGive
                  : l.feeSetupGiven(state.appliedCount),
            ),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.feeSetupTitle)),
        body: BlocBuilder<FeeSetupBloc, FeeSetupState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (classes.isEmpty || state.className == null) {
              return EmptyState(
                icon: Icons.class_outlined,
                message: l.feeSetupNoClasses,
              );
            }
            return ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final c in classes) ...[
                        ChoiceChip(
                          label: Text(c.name),
                          selected: state.className == c.name,
                          onSelected: (_) => context.read<FeeSetupBloc>().add(
                            FeeSetupClassChosen(c.name),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                InfoBanner(message: l.feeSetupApplies(state.className!)),
                const SizedBox(height: AppSpacing.lg),
                for (final head in _heads) ...[
                  _HeadCard(
                    head: head,
                    className: state.className!,
                    item: state.itemOf(head),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Text(l.feeSetupMeaning, style: context.text.bodySmall),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeadCard extends StatelessWidget {
  const _HeadCard({
    required this.head,
    required this.className,
    required this.item,
  });

  final FeeHead head;
  final String className;
  final FeeStructureItem? item;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<FeeSetupBloc>();
    final i = item;
    Future<void> edit() async {
      final saved = await FeeHeadSheet.show(
        context,
        className: className,
        head: head,
        existing: i,
      );
      if (saved != null) bloc.add(FeeSetupItemSaved(saved));
    }

    Widget dateBox(String caption, String value) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(caption, style: context.text.labelSmall),
            Text(value, style: context.text.bodyMedium),
          ],
        ),
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(head.label(l), style: context.text.titleSmall),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, AppSizes.buttonCompact),
                ),
                onPressed: edit,
                child: Text(i == null ? l.feeSetupSetUp : l.feeSetupEdit),
              ),
            ],
          ),
          if (head == FeeHead.van)
            Text(l.feeSetupVanNote, style: context.text.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            i == null
                ? l.feeSetupNotSet
                : '${l.feeSetupAmount} ${formatRupees(context, i.amount)}',
            style: context.text.bodyMedium,
          ),
          if (i != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                dateBox(l.feeSetupDue, formatShortDate(context, i.dueDate)),
                const SizedBox(width: AppSpacing.sm),
                dateBox(
                  l.feeSetupLast,
                  i.lastDate == null
                      ? '–'
                      : formatShortDate(context, i.lastDate!),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, AppSizes.buttonCompact),
                ),
                onPressed: () => bloc.add(FeeSetupApplied(head)),
                child: Text(l.feeSetupGive),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
