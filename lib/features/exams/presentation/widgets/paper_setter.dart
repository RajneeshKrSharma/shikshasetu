import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/context_ext.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../../domain/entities/exam_paper.dart';

/// Who set the paper: the signed-in user, a teacher from the staff list, or
/// the Principal (whose papers are not in that list).
String paperSetterName(BuildContext context, ExamPaper paper) {
  final me = context.read<AuthBloc>().state.user;
  if (paper.createdBy == null) return '';
  if (paper.createdBy == me?.id) return me!.name;
  for (final m in context.read<StaffBloc>().state.staff) {
    if (m.id == paper.createdBy) return m.name;
  }
  return context.l10n.roleLabelPrincipal;
}
