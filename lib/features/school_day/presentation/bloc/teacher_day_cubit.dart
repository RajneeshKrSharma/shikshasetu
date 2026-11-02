import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/school_day_usecases.dart';

class TeacherDayState extends Equatable {
  const TeacherDayState({this.day, this.loading = true});

  final TeacherDay? day;
  final bool loading;

  @override
  List<Object?> get props => [day, loading];
}

/// A teacher's day: the periods they teach and their assembly duty.
class TeacherDayCubit extends Cubit<TeacherDayState> {
  TeacherDayCubit({required this.teacherId, required GetTeacherDay getDay})
    : _getDay = getDay,
      super(const TeacherDayState());

  final String teacherId;
  final GetTeacherDay _getDay;

  Future<void> load() async {
    final day = await _getDay(TeacherDayQuery(teacherId, DateTime.now()));
    if (!isClosed) emit(TeacherDayState(day: day, loading: false));
  }
}
