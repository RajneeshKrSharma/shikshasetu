import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/context_ext.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/teacher_self_view.dart';

/// A teacher's own attendance: their check-in and check-out. (The Principal
/// sees everyone's on the Students, Teachers and Others tabs.)
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const AttendanceScreen()));

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc b) => b.state.user);
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myAttendanceTitle)),
      body: TeacherSelfView(user: user),
    );
  }
}
