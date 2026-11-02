import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../domain/entities/accessory_kind.dart';
import '../../domain/entities/class_accessories.dart';
import '../../domain/entities/student_accessory_row.dart';
import '../bloc/accessories_bloc.dart';
import '../bloc/issue_bloc.dart';
import '../widgets/accessory_labels.dart';
import 'dress_sizes_screen.dart';
import 'issue_screen.dart';

/// Hand over dress or books, class by class: which students have been given
/// theirs, and a button to give it to the rest.
class GiveAccessoriesScreen extends StatelessWidget {
  const GiveAccessoriesScreen({super.key});

  static Future<void> open(BuildContext context) {
    final classes = context.read<ClassesBloc>().state.classes;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<AccessoriesBloc>(
            param1: classes.isEmpty ? null : classes.first.name,
          )..add(const AccessoriesStarted()),
          child: const GiveAccessoriesScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.select((ClassesBloc b) => b.state.classes);
    return Scaffold(
      appBar: AppBar(title: Text(l.accGiveTitle)),
      body: BlocBuilder<AccessoriesBloc, AccessoriesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (classes.isEmpty || state.className == null) {
            return EmptyState(
              icon: Icons.class_outlined,
              message: l.accNoClasses,
            );
          }
          final bloc = context.read<AccessoriesBloc>();
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<AccessoryKind>(
                  showSelectedIcon: false,
                  segments: [
                    for (final k in AccessoryKind.values)
                      ButtonSegment(value: k, label: Text(k.label(l))),
                  ],
                  selected: {state.kind},
                  onSelectionChanged: (v) =>
                      bloc.add(AccessoryKindChosen(v.first)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final c in classes) ...[
                      ChoiceChip(
                        label: Text(c.name),
                        selected: state.className == c.name,
                        onSelected: (_) =>
                            bloc.add(AccessoryClassChosen(c.name)),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.view != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        child: Text(
                          l.accSummaryDone(
                            state.view!.completeCount,
                            state.view!.rows.length,
                          ),
                          style: context.text.titleSmall,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppCard(
                        child: Text(
                          l.accSummaryNot(state.view!.incompleteCount),
                          style: context.text.titleSmall,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final row in state.view!.rows) ...[
                  _StudentRow(view: state.view!, row: row),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.view, required this.row});

  final ClassAccessories view;
  final StudentAccessoryRow row;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<AccessoriesBloc>();
    final dress = view.kind == AccessoryKind.dress;
    final subtitle = dress
        ? [
            row.hasSize ? l.accSizeLabel(row.size!) : l.accSizeNotNoted,
            if (row.lastIssue != null) row.lastIssue!.receiptNo,
          ].join(' · ')
        : l.accGivenOf(row.givenCount, row.itemCount);

    Future<void> give() async {
      await IssueScreen.open(
        context,
        IssueArgs(
          kind: view.kind,
          row: row,
          className: view.className,
          itemNames: [for (final i in view.items) i.name],
        ),
      );
      bloc.add(const AccessoriesReloaded());
    }

    final Widget action = row.isComplete
        ? StatusChip(
            label: dress ? l.accIssuedTag : l.accComplete,
            color: AppColors.present,
            background: AppColors.presentLight,
          )
        : dress && !row.hasSize
        ? OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, AppSizes.buttonCompact),
            ),
            onPressed: () async {
              await DressSizesScreen.open(context, view.className);
              bloc.add(const AccessoriesReloaded());
            },
            child: Text(l.accNoteSize),
          )
        : FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, AppSizes.buttonCompact),
            ),
            onPressed: view.items.isEmpty ? null : give,
            child: Text(view.kind.giveLabel(l)),
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            InitialsAvatar(row.name, radius: 18),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(row.name, style: context.text.titleSmall),
                  Text(
                    '${l.feeRollNo(row.rollNo)} · $subtitle',
                    style: context.text.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            action,
          ],
        ),
      ),
    );
  }
}
