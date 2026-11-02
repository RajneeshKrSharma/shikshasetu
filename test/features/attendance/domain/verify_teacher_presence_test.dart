import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/check_result.dart';
import 'package:shiksha_setu/features/attendance/domain/repository/attendance_repository.dart';
import 'package:shiksha_setu/features/attendance/domain/repository/selfie_repository.dart';
import 'package:shiksha_setu/features/attendance/domain/usecases/verify_teacher_presence.dart';
import 'package:shiksha_setu/features/location/domain/entities/location_reading.dart';
import 'package:shiksha_setu/features/location/domain/repository/location_repository.dart';
import 'package:shiksha_setu/features/settings/domain/entities/school_settings.dart';
import 'package:shiksha_setu/features/settings/domain/repository/settings_repository.dart';

class FakeAttendance implements AttendanceRepository {
  FakeAttendance(this.status);

  final SchoolDayStatus status;

  @override
  Future<SchoolDayStatus> getDayStatus(DateTime day) async => status;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class FakeSettings implements SettingsRepository {
  FakeSettings(this.settings);

  final SchoolSettings settings;

  @override
  Future<SchoolSettings> get() async => settings;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class FakeLocation implements LocationRepository {
  FakeLocation(this.reading, {this.problem});

  final LocationReading reading;
  final LocationProblem? problem;
  int calls = 0;

  @override
  Future<LocationReading> current() async {
    calls++;
    if (problem != null) throw LocationException(problem!);
    return reading;
  }
}

class FakeSelfie implements SelfieRepository {
  FakeSelfie(this.path);

  final String? path;
  int calls = 0;

  @override
  Future<String?> capture(String teacherId) async {
    calls++;
    return path;
  }
}

void main() {
  const school = SchoolSettings(
    schoolName: 'S',
    latitude: 12.0,
    longitude: 77.0,
    radiusMeters: 150,
  );

  // ~100 m north of the school, and ~1.1 km north of it.
  const near = LocationReading(
    latitude: 12.0009,
    longitude: 77.0,
    isMocked: false,
  );
  const far = LocationReading(
    latitude: 12.01,
    longitude: 77.0,
    isMocked: false,
  );

  final today = DateTime(2026, 9, 30, 8);

  Future<CheckResult> run(
    FakeLocation location,
    FakeSelfie selfie, {
    SchoolSettings settings = school,
    SchoolDayStatus day = SchoolDayStatus.approved,
  }) => VerifyTeacherPresence(
    FakeAttendance(day),
    FakeSettings(settings),
    location,
    selfie,
  )(VerifyPresenceParams(teacherId: 't1', day: today));

  test(
    'call: school day not approved → schoolClosed, nothing is asked',
    () async {
      final location = FakeLocation(near);
      final selfie = FakeSelfie('/s.jpg');

      final r = await run(location, selfie, day: SchoolDayStatus.pending);

      expect(r.failure, CheckFailure.schoolClosed);
      expect((location.calls, selfie.calls), (0, 0));
    },
  );

  test('call: school day rejected → schoolClosed', () async {
    final r = await run(
      FakeLocation(near),
      FakeSelfie('/s.jpg'),
      day: SchoolDayStatus.rejected,
    );

    expect(r.failure, CheckFailure.schoolClosed);
  });

  test(
    'call: school location not configured → locationNotConfigured',
    () async {
      final r = await run(
        FakeLocation(near),
        FakeSelfie('/s.jpg'),
        settings: const SchoolSettings(schoolName: 'S'),
      );

      expect(r.failure, CheckFailure.locationNotConfigured);
    },
  );

  test('call: a mocked location is refused', () async {
    final r = await run(
      FakeLocation(
        const LocationReading(latitude: 12, longitude: 77, isMocked: true),
      ),
      FakeSelfie('/s.jpg'),
    );

    expect(r.failure, CheckFailure.mockLocation);
  });

  test('call: outside the radius → outsideSchool with the distance', () async {
    final selfie = FakeSelfie('/s.jpg');

    final r = await run(FakeLocation(far), selfie);

    expect(r.failure, CheckFailure.outsideSchool);
    expect(r.distance, closeTo(1112, 5));
    expect(selfie.calls, 0, reason: 'no selfie when not at school');
  });

  test(
    'call: inside the radius with a selfie → ok with the check point',
    () async {
      final r = await run(FakeLocation(near), FakeSelfie('/s.jpg'));

      expect(r.ok, isTrue);
      expect(r.point?.selfiePath, '/s.jpg');
      expect(r.point?.distanceMeters, closeTo(100, 1));
    },
  );

  test('call: exactly on the boundary is allowed', () async {
    final r = await run(
      FakeLocation(near),
      FakeSelfie('/s.jpg'),
      settings: const SchoolSettings(
        schoolName: 'S',
        latitude: 12.0,
        longitude: 77.0,
        radiusMeters: 101,
      ),
    );

    expect(r.ok, isTrue);
  });

  test('call: selfie cancelled → selfieCancelled', () async {
    final r = await run(FakeLocation(near), FakeSelfie(null));

    expect(r.failure, CheckFailure.selfieCancelled);
  });

  for (final (problem, failure) in [
    (LocationProblem.servicesOff, CheckFailure.servicesOff),
    (LocationProblem.denied, CheckFailure.permissionDenied),
    (LocationProblem.deniedForever, CheckFailure.permissionDeniedForever),
    (LocationProblem.unavailable, CheckFailure.locationUnavailable),
  ]) {
    test('call: $problem → $failure', () async {
      final r = await run(
        FakeLocation(near, problem: problem),
        FakeSelfie('/s.jpg'),
      );

      expect(r.failure, failure);
    });
  }
}
