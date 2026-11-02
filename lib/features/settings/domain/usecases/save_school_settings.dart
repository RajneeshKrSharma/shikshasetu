import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

class SaveSchoolSettingsParams extends Equatable {
  const SaveSchoolSettingsParams({
    required this.schoolName,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });

  final String schoolName;
  final double latitude;
  final double longitude;
  final int radiusMeters;

  @override
  List<Object?> get props => [schoolName, latitude, longitude, radiusMeters];
}

class SaveSchoolSettings implements UseCase<void, SaveSchoolSettingsParams> {
  const SaveSchoolSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<void> call(SaveSchoolSettingsParams p) => _repository.saveSchool(
    schoolName: p.schoolName,
    latitude: p.latitude,
    longitude: p.longitude,
    radiusMeters: p.radiusMeters,
  );
}
