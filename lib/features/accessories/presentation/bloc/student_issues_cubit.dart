import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/accessory_issue.dart';
import '../../domain/usecases/accessories_usecases.dart';

class StudentIssuesState extends Equatable {
  const StudentIssuesState({this.loading = true, this.issues = const []});

  final bool loading;

  /// Newest first.
  final List<AccessoryIssue> issues;

  @override
  List<Object?> get props => [loading, issues];
}

/// Everything given to one student, for their profile.
class StudentIssuesCubit extends Cubit<StudentIssuesState> {
  StudentIssuesCubit({
    required this.studentId,
    required GetStudentIssues getIssues,
  }) : _get = getIssues,
       super(const StudentIssuesState());

  final String studentId;
  final GetStudentIssues _get;

  Future<void> load() async =>
      emit(StudentIssuesState(loading: false, issues: await _get(studentId)));
}
