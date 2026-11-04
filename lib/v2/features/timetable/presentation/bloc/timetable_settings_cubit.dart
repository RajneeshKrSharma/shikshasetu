import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/usecases/timetable_usecases.dart';

class TimetableSettingsState extends Equatable {
  const TimetableSettingsState({
    required this.settings,
    this.busy = false,
    this.failure,
    this.saved,
  });

  /// What is on the form now.
  final TimetableSettings settings;
  final bool busy;
  final ViewFailure? failure;

  /// Set once the server has saved the form.
  final TimetableSettings? saved;

  TimetableSettingsState copyWith({
    TimetableSettings? settings,
    bool? busy,
    ViewFailure? failure,
    bool clearFailure = false,
    TimetableSettings? saved,
  }) => TimetableSettingsState(
    settings: settings ?? this.settings,
    busy: busy ?? this.busy,
    failure: clearFailure ? null : (failure ?? this.failure),
    saved: saved ?? this.saved,
  );

  @override
  List<Object?> get props => [settings, busy, failure, saved];
}

/// The settings form: every edit changes [TimetableSettingsState.settings];
/// saving sends it to the server.
class TimetableSettingsCubit extends Cubit<TimetableSettingsState> {
  TimetableSettingsCubit({
    required TimetableSettings initial,
    required SaveTimetableSettings saveSettings,
  }) : _save = saveSettings,
       super(TimetableSettingsState(settings: initial));

  final SaveTimetableSettings _save;

  void edit(TimetableSettings settings) =>
      emit(state.copyWith(settings: settings, clearFailure: true));

  Future<void> save() async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      final saved = await _save(state.settings);
      emit(state.copyWith(busy: false, settings: saved, saved: saved));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
