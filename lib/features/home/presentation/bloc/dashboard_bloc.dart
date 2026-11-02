import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => const [];
}

/// Loads (or reloads) the dashboard for the signed-in role.
final class DashboardRequested extends DashboardEvent {
  const DashboardRequested({required this.includeFees});

  final bool includeFees;

  @override
  List<Object?> get props => [includeFees];
}

class DashboardState extends Equatable {
  const DashboardState({this.loading = true, this.summary});

  final bool loading;
  final DashboardSummary? summary;

  @override
  List<Object?> get props => [loading, summary];
}

/// The numbers and "needs attention" list shown on the Dashboard.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required UseCase<DashboardSummary, DashboardQuery> getDashboardSummary,
    DateTime Function()? now,
  }) : _get = getDashboardSummary,
       _now = now ?? DateTime.now,
       super(const DashboardState()) {
    on<DashboardRequested>(_onRequested);
  }

  final UseCase<DashboardSummary, DashboardQuery> _get;
  final DateTime Function() _now;

  /// Identifies the newest request, so a slow older one cannot overwrite it.
  int _latest = 0;

  Future<void> _onRequested(
    DashboardRequested e,
    Emitter<DashboardState> emit,
  ) async {
    final mine = ++_latest;
    final summary = await _get(
      DashboardQuery(now: _now(), includeFees: e.includeFees),
    );
    if (mine != _latest) return;
    emit(DashboardState(loading: false, summary: summary));
  }
}
