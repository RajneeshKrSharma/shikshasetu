import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../domain/entities/accessory_kind.dart';
import '../bloc/accessory_set_cubit.dart';
import '../widgets/accessory_labels.dart';

/// The dress set or book list of each class: every piece, with a way to
/// rename it or take it away.
class AccessorySetsScreen extends StatelessWidget {
  const AccessorySetsScreen({super.key});

  static Future<void> open(BuildContext context) {
    final classes = context.read<ClassesBloc>().state.classes;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<AccessorySetCubit>(
            param1: classes.isEmpty ? null : classes.first.name,
          )..load(),
          child: const AccessorySetsScreen(),
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, String name) async {
    final l = context.l10n;
    final cubit = context.read<AccessorySetCubit>();
    final controller = TextEditingController(text: name);
    final to = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.accEditItem),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(l.actionSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (to != null && to.isNotEmpty && to != name) cubit.rename(name, to);
  }

  Future<void> _delete(BuildContext context, String name) async {
    final l = context.l10n;
    final cubit = context.read<AccessorySetCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.accDeleteItemTitle),
        content: Text(name),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.absent),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.actionDelete),
          ),
        ],
      ),
    );
    if (ok == true) cubit.remove(name);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.select((ClassesBloc b) => b.state.classes);
    final cubit = context.read<AccessorySetCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(l.accManageTitle)),
      body: BlocBuilder<AccessorySetCubit, AccessorySetState>(
        builder: (context, s) {
          if (s.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (classes.isEmpty) {
            return EmptyState(
              icon: Icons.class_outlined,
              message: l.accNoClasses,
            );
          }
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
                  selected: {s.kind},
                  onSelectionChanged: (v) => cubit.kindChosen(v.first),
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
                        selected: s.className == c.name,
                        onSelected: (_) => cubit.classChosen(c.name),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (s.className != null)
                Text(
                  '${l.classLabel(s.className!)} · ${s.kind.setTitle(l)}',
                  style: context.text.titleSmall,
                ),
              if (s.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Text(l.accNothingHere),
                ),
              for (final name in s.items)
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l.accEditItem,
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _rename(context, name),
                        ),
                        IconButton(
                          tooltip: l.actionDelete,
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _delete(context, name),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
