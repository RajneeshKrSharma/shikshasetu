import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../../exams/presentation/paper_subjects.dart';
import '../../domain/entities/teaching_access.dart';
import 'teaching_bloc.dart';

/// What the signed-in user may set papers and questions for. Rebuilds the
/// widget when the user, their subjects or the classes change.
TeachingAccess watchTeachingAccess(BuildContext context) {
  final user = context.select((AuthBloc b) => b.state.user)!;
  final assignments = context.select((TeachingBloc b) => b.state.assignments);
  final classes = context.select((ClassesBloc b) => b.state.classes);
  return TeachingAccess(
    user: user,
    assignments: assignments,
    allSubjects: kPaperSubjects,
    allClasses: [for (final c in classes) c.name],
  );
}
