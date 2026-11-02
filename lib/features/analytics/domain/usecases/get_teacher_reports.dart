import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/teacher_report.dart';
import '../repository/analytics_repository.dart';

class TeacherReportsParams extends Equatable {
  const TeacherReportsParams(this.today, this.days);

  final DateTime today;
  final int days;

  @override
  List<Object?> get props => [today, days];
}

class GetTeacherReports
    implements UseCase<List<TeacherReport>, TeacherReportsParams> {
  const GetTeacherReports(this._repository);

  final AnalyticsRepository _repository;

  @override
  Future<List<TeacherReport>> call(TeacherReportsParams p) =>
      _repository.getTeacherReports(p.today, p.days);
}
