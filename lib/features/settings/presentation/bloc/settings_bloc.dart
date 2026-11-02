import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/school_settings.dart';
import '../../domain/usecases/get_school_settings.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../../../exams/domain/usecases/pick_photo.dart';
import '../../domain/usecases/save_announcement.dart';
import '../../domain/usecases/save_school_logo.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => const [];
}

/// (Re)reads the school settings.
final class SettingsLoaded extends SettingsEvent {
  const SettingsLoaded();
}

/// The Principal picked the accent color (null = follow the main color).
/// The Principal wants to choose a logo from the gallery.
final class LogoPickRequested extends SettingsEvent {
  const LogoPickRequested();
}

final class LogoRemoved extends SettingsEvent {
  const LogoRemoved();
}

/// The Principal set (or, with null, stopped) the announcement.
final class AnnouncementChanged extends SettingsEvent {
  const AnnouncementChanged(this.text);

  final String? text;

  @override
  List<Object?> get props => [text];
}

class SettingsState extends Equatable {
  const SettingsState({this.settings = const SchoolSettings(schoolName: '')});

  final SchoolSettings settings;

  @override
  List<Object?> get props => [settings];
}

/// Holds the school's settings for the whole app.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSchoolSettings getSchoolSettings,
    required SaveSchoolLogo saveSchoolLogo,
    required SaveAnnouncement saveAnnouncement,
    required PickPhoto pickPhoto,
  }) : _get = getSchoolSettings,
       _saveLogo = saveSchoolLogo,
       _saveAnnouncement = saveAnnouncement,
       _pickPhoto = pickPhoto,
       super(const SettingsState()) {
    on<SettingsLoaded>(_onLoaded);
    on<AnnouncementChanged>((e, emit) async {
      await _saveAnnouncement(e.text);
      await _onLoaded(const SettingsLoaded(), emit);
    });
    on<LogoPickRequested>((e, emit) async {
      final path = await _pickPhoto(PhotoSource.gallery);
      if (path == null) return; // cancelled
      await _saveLogo(path);
      await _onLoaded(const SettingsLoaded(), emit);
    });
    on<LogoRemoved>((e, emit) async {
      await _saveLogo(null);
      await _onLoaded(const SettingsLoaded(), emit);
    });
  }

  final GetSchoolSettings _get;
  final SaveSchoolLogo _saveLogo;
  final SaveAnnouncement _saveAnnouncement;
  final PickPhoto _pickPhoto;

  Future<void> _onLoaded(SettingsEvent e, Emitter<SettingsState> emit) async {
    emit(SettingsState(settings: await _get(const NoParams())));
  }
}
