import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../domain/entities/accessory_kind.dart';
import '../bloc/accessory_set_cubit.dart';
import '../widgets/accessory_labels.dart';

/// Adds one piece of dress, or one book, to a class's set.
class AccessoryAddScreen extends StatefulWidget {
  const AccessoryAddScreen({super.key});

  static Future<void> open(BuildContext context) {
    final classes = context.read<ClassesBloc>().state.classes;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<AccessorySetCubit>(
            param1: classes.isEmpty ? null : classes.first.name,
          )..load(),
          child: const AccessoryAddScreen(),
        ),
      ),
    );
  }

  @override
  State<AccessoryAddScreen> createState() => _AccessoryAddScreenState();
}

class _AccessoryAddScreenState extends State<AccessoryAddScreen> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.select((ClassesBloc b) => b.state.classes);
    final cubit = context.read<AccessorySetCubit>();
    return BlocListener<AccessorySetCubit, AccessorySetState>(
      listenWhen: (a, b) => a.addedCount != b.addedCount,
      listener: (context, s) {
        _name.clear();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.accItemAdded)));
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.accAddTitle)),
        body: BlocBuilder<AccessorySetCubit, AccessorySetState>(
          builder: (context, s) => ListView(
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
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                initialValue: s.className,
                isExpanded: true,
                decoration: InputDecoration(labelText: l.fieldClass),
                items: [
                  for (final c in classes)
                    DropdownMenuItem(
                      value: c.name,
                      child: Text(l.classLabel(c.name)),
                    ),
                ],
                onChanged: (v) {
                  if (v != null) cubit.classChosen(v);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l.accItemName,
                  hintText: s.kind.setHint(l),
                ),
                onSubmitted: (v) => _add(cubit, v),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => _add(cubit, _name.text),
                child: Text(l.accAddTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _add(AccessorySetCubit cubit, String name) {
    if (name.trim().isNotEmpty) cubit.add(name.trim());
  }
}
