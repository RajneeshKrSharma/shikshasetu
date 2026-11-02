import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/class_analytics.dart';
import '../repository/analytics_repository.dart';

class ClassAnalyticsParams extends Equatable {
  const ClassAnalyticsParams(this.classSection, this.today);

  final String classSection;
  final DateTime today;

  @override
  List<Object?> get props => [classSection, today];
}

class GetClassAnalytics
    implements UseCase<ClassAnalytics, ClassAnalyticsParams> {
  const GetClassAnalytics(this._repository);

  final AnalyticsRepository _repository;

  @override
  Future<ClassAnalytics> call(ClassAnalyticsParams p) =>
      _repository.getClassAnalytics(p.classSection, p.today);
}
