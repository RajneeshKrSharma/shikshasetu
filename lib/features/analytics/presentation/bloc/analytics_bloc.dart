import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/class_analytics.dart';
import '../../domain/entities/teacher_report.dart';
import '../../domain/usecases/get_class_analytics.dart';
import '../../domain/usecases/get_teacher_reports.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => const [];
}

/// Shows the report for [classSection] (null when there are no classes).
final class AnalyticsClassSelected extends AnalyticsEvent {
  const AnalyticsClassSelected(this.classSection);

  final String? classSection;

  @override
  List<Object?> get props => [classSection];
}

class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.loading = true,
    this.classSection,
    this.classData,
    this.teachers = const [],
  });

  final bool loading;
  final String? classSection;
  final ClassAnalytics? classData;
  final List<TeacherReport> teachers;

  @override
  List<Object?> get props => [loading, classSection, classData, teachers];
}

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({
    required GetClassAnalytics getClassAnalytics,
    required GetTeacherReports getTeacherReports,
    DateTime Function()? now,
  }) : _getClass = getClassAnalytics,
       _getTeachers = getTeacherReports,
       _now = now ?? DateTime.now,
       super(const AnalyticsState()) {
    on<AnalyticsClassSelected>(_onSelected);
  }

  /// Length of the teacher report window.
  static const teacherWindowDays = 30;

  final GetClassAnalytics _getClass;
  final GetTeacherReports _getTeachers;
  final DateTime Function() _now;

  Future<void> _onSelected(
    AnalyticsClassSelected e,
    Emitter<AnalyticsState> emit,
  ) async {
    if (e.classSection == null) {
      emit(const AnalyticsState(loading: false));
      return;
    }
    emit(AnalyticsState(loading: true, classSection: e.classSection));
    final today = _now();
    final data = await _getClass(ClassAnalyticsParams(e.classSection!, today));
    final teachers = await _getTeachers(
      TeacherReportsParams(today, teacherWindowDays),
    );
    emit(
      AnalyticsState(
        loading: false,
        classSection: e.classSection,
        classData: data,
        teachers: teachers,
      ),
    );
  }
}
