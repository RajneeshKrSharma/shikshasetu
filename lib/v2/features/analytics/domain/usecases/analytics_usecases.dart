import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/analytics.dart';
import '../repository/analytics_repository.dart';

class GetGraphParams extends Equatable {
  const GetGraphParams(this.kind, this.from, this.to, {this.classId});

  final GraphKind kind;
  final DateTime from;
  final DateTime to;
  final String? classId;

  @override
  List<Object?> get props => [kind, from, to, classId];
}

class GetGraph implements UseCase<GraphData, GetGraphParams> {
  const GetGraph(this._repository);

  final AnalyticsRepository _repository;

  @override
  Future<GraphData> call(GetGraphParams p) =>
      _repository.graph(p.kind, from: p.from, to: p.to, classId: p.classId);
}
