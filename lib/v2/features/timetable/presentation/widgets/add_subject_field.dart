import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../bloc/timetable_bloc.dart';

/// Lets the Principal add a subject to the timetable by typing its name.
class AddSubjectField extends StatefulWidget {
  const AddSubjectField({super.key});

  @override
  State<AddSubjectField> createState() => _AddSubjectFieldState();
}

class _AddSubjectFieldState extends State<AddSubjectField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    context.read<TimetableBloc>().add(TimetableSubjectAdded(_controller.text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l.ttbAddSubject),
            onSubmitted: (_) => _add(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton.filledTonal(
          tooltip: l.ttbAddSubject,
          icon: const Icon(Icons.add),
          onPressed: _add,
        ),
      ],
    );
  }
}
