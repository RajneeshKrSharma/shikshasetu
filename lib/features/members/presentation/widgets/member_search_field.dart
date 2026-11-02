import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/member_workspace_bloc.dart';

/// The search box of a workspace. It owns only its text controller.
class MemberSearchField extends StatefulWidget {
  const MemberSearchField({super.key, required this.hint});

  final String hint;

  @override
  State<MemberSearchField> createState() => _MemberSearchFieldState();
}

class _MemberSearchFieldState extends State<MemberSearchField> {
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

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    onChanged: (v) =>
        context.read<MemberWorkspaceBloc>().add(WorkspaceQueryChanged(v)),
    decoration: InputDecoration(
      hintText: widget.hint,
      prefixIcon: const Icon(Icons.search),
    ),
  );
}
