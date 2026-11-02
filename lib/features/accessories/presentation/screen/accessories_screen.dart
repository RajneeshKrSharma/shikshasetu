import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/choice_tile.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../l10n/class_label.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import 'accessory_add_screen.dart';
import 'accessory_records_screen.dart';
import 'accessory_sets_screen.dart';
import 'dress_sizes_screen.dart';
import 'give_accessories_screen.dart';

/// Dress and books: asks what you need, with one tile for each choice.
class AccessoriesScreen extends StatelessWidget {
  const AccessoriesScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const AccessoriesScreen()));

  Future<void> _pickClassForSizes(BuildContext context) async {
    final l = context.l10n;
    final classes = context.read<ClassesBloc>().state.classes;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(l.accPickClass, style: ctx.text.titleMedium)),
            for (final c in classes)
              ListTile(
                title: Text(l.classLabel(c.name)),
                onTap: () => Navigator.of(ctx).pop(c.name),
              ),
          ],
        ),
      ),
    );
    if (picked != null && context.mounted) {
      await DressSizesScreen.open(context, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.featureAccessories)),
      body: ChoiceScreenBody(
        question: l.wsAsk,
        tiles: [
          ChoiceTile(
            highlight: true,
            icon: Icons.add,
            title: l.accAddTitle,
            description: l.accAddHint,
            onTap: () => AccessoryAddScreen.open(context),
          ),
          ChoiceTile(
            icon: Icons.edit_note,
            title: l.accManageTitle,
            description: l.accManageHint,
            onTap: () => AccessorySetsScreen.open(context),
          ),
          ChoiceTile(
            icon: Icons.checkroom_outlined,
            title: l.accGiveTitle,
            description: l.accGiveHint,
            onTap: () => GiveAccessoriesScreen.open(context),
          ),
          ChoiceTile(
            icon: Icons.straighten,
            title: l.accSizesTitle,
            description: l.accSizesHint,
            onTap: () => _pickClassForSizes(context),
          ),
          ChoiceTile(
            icon: Icons.receipt_long_outlined,
            title: l.accRecordsTitle,
            description: l.accRecordsHint,
            onTap: () => AccessoryRecordsScreen.open(context),
          ),
        ],
      ),
    );
  }
}
