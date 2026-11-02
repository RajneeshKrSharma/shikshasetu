import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../attendance/presentation/bloc/attendance_event.dart';
import '../../classes/presentation/bloc/classes_bloc.dart';
import '../../exams/presentation/bloc/exams_bloc.dart';
import '../../fees/presentation/bloc/fees_bloc.dart';
import '../../master_questions/presentation/bloc/master_questions_bloc.dart';
import '../../notices/presentation/bloc/notices_bloc.dart';
import '../../registration/presentation/bloc/registration_bloc.dart';
import '../../settings/presentation/bloc/settings_bloc.dart';
import '../../staff/presentation/bloc/staff_bloc.dart';
import '../../teaching/presentation/bloc/teaching_bloc.dart';

/// Asks every block that holds school data to read it again: when the app is
/// entered, and after a restore replaced the data underneath them.
class SharedDataLoader {
  const SharedDataLoader(this._context);

  final BuildContext _context;

  void call() {
    final c = _context;
    c.read<AttendanceBloc>().add(const AttendanceStarted());
    c.read<ApprovalsBloc>().add(const ApprovalsRequested());
    c.read<ClassesBloc>().add(const ClassesLoaded());
    c.read<StaffBloc>().add(const StaffLoaded());
    c.read<SettingsBloc>().add(const SettingsLoaded());
    c.read<ExamsBloc>().add(const ExamsLoaded());
    c.read<FeesBloc>().add(const FeesLoaded());
    c.read<RegistrationBloc>().add(const PeopleLoaded());
    c.read<NoticesBloc>().add(const NoticesLoaded());
    c.read<TeachingBloc>().add(const TeachingLoaded());
    c.read<MasterQuestionsBloc>().add(const MasterQuestionsLoaded());
  }
}
