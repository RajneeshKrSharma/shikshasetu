import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../location/domain/entities/location_reading.dart';
import '../../../location/domain/repository/location_repository.dart';
import '../../../settings/domain/repository/settings_repository.dart';
import '../entities/attendance_status.dart';
import '../entities/check_point.dart';
import '../entities/check_result.dart';
import '../repository/attendance_repository.dart';
import '../repository/selfie_repository.dart';
import '../../../face_id/domain/entities/face_entities.dart';
import '../../../face_id/domain/repository/face_repositories.dart';
import '../../../face_id/domain/usecases/face_usecases.dart';
import 'haversine.dart';

class VerifyPresenceParams extends Equatable {
  const VerifyPresenceParams({
    required this.teacherId,
    required this.day,
    this.teacherName = '',
  });

  final String teacherId;
  final DateTime day;

  /// Shown on the Face ID camera screen.
  final String teacherName;

  @override
  List<Object?> get props => [teacherId, day, teacherName];
}

/// Checks the school day is open, the teacher is at school (real, not mocked
/// GPS, within the allowed distance), then confirms who it is: with Face ID
/// when the teacher has set it up (a live face that matches), otherwise with
/// a selfie.
class VerifyTeacherPresence
    implements UseCase<CheckResult, VerifyPresenceParams> {
  const VerifyTeacherPresence(
    this._attendance,
    this._settings,
    this._location,
    this._selfie,
    this._templates,
    this._capture,
    this._verifyFace,
  );

  final AttendanceRepository _attendance;
  final SettingsRepository _settings;
  final LocationRepository _location;
  final SelfieRepository _selfie;
  final FaceTemplateRepository _templates;
  final FaceCapturePort _capture;
  final VerifyFace _verifyFace;

  @override
  Future<CheckResult> call(VerifyPresenceParams p) async {
    final dayStatus = await _attendance.getDayStatus(p.day);
    if (dayStatus != SchoolDayStatus.approved) {
      return const CheckResult.fail(CheckFailure.schoolClosed);
    }

    final school = await _settings.get();
    if (!school.hasLocation) {
      return const CheckResult.fail(CheckFailure.locationNotConfigured);
    }

    final LocationReading reading;
    try {
      reading = await _location.current();
    } on LocationException catch (e) {
      return CheckResult.fail(switch (e.problem) {
        LocationProblem.servicesOff => CheckFailure.servicesOff,
        LocationProblem.denied => CheckFailure.permissionDenied,
        LocationProblem.deniedForever => CheckFailure.permissionDeniedForever,
        LocationProblem.unavailable => CheckFailure.locationUnavailable,
      });
    }

    if (reading.isMocked) {
      return const CheckResult.fail(CheckFailure.mockLocation);
    }

    final distance = distanceMeters(
      reading.latitude,
      reading.longitude,
      school.latitude!,
      school.longitude!,
    );
    if (distance > school.radiusMeters!) {
      return CheckResult.fail(CheckFailure.outsideSchool, distance: distance);
    }

    // With Face ID set up, the face must match (and blink, to be live);
    // otherwise a plain selfie is taken as before.
    final String? selfie;
    double? faceScore;
    if (await _templates.get(p.teacherId) != null) {
      final shots = await _capture.capture(
        purpose: FaceCapturePurpose.verify,
        personName: p.teacherName,
      );
      if (shots == null || shots.isEmpty) {
        return const CheckResult.fail(CheckFailure.selfieCancelled);
      }
      try {
        final match = await _verifyFace(
          VerifyFaceParams(p.teacherId, shots.first),
        );
        if (!match.matched) {
          return CheckResult.fail(CheckFailure.faceMismatch);
        }
        faceScore = match.score;
      } on FaceException catch (e) {
        return CheckResult.fail(
          e.problem == FaceProblem.notFound
              ? CheckFailure.faceNotFound
              : CheckFailure.faceUnavailable,
        );
      }
      selfie = shots.first;
    } else {
      selfie = await _selfie.capture(p.teacherId);
      if (selfie == null) {
        return const CheckResult.fail(CheckFailure.selfieCancelled);
      }
    }

    return CheckResult.ok(
      CheckPoint(
        latitude: reading.latitude,
        longitude: reading.longitude,
        distanceMeters: distance,
        selfiePath: selfie,
        faceScore: faceScore,
      ),
    );
  }
}
