import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repository/attendance_repository.dart';
import '../models/attendance_models.dart';

class ServerAttendanceRepository implements AttendanceRepository {
  ServerAttendanceRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<RosterLine>> roster(String classId, DateTime day) async => [
    for (final l in jsonObjects(
      await _client.send(
        'GET',
        '/attendance/students/',
        query: {'class_id': classId, 'day': WireFormat.day(day)},
      ),
    ))
      AttendanceModels.rosterLine(l),
  ];

  @override
  Future<List<RosterLine>> markRoster(
    String classId,
    DateTime day,
    List<RosterLine> lines,
  ) async => [
    for (final l in jsonObjects(
      await _client.send(
        'PUT',
        '/attendance/students/',
        body: {
          'class_id': classId,
          'day': WireFormat.day(day),
          'marks': [
            for (final line in lines)
              if (line.mark != null)
                {'student_id': line.studentId, 'status': line.mark!.code},
          ],
        },
      ),
    ))
      AttendanceModels.rosterLine(l),
  ];

  @override
  Future<List<StudentTally>> report(
    String classId,
    DateTime from,
    DateTime to,
  ) async => [
    for (final t in jsonObjects(
      await _client.send(
        'GET',
        '/attendance/students/report/',
        query: {
          'class_id': classId,
          'from': WireFormat.day(from),
          'to': WireFormat.day(to),
        },
      ),
    ))
      AttendanceModels.tally(t),
  ];

  @override
  Future<WorkRecord> checkIn() async => AttendanceModels.record(
    jsonObject(await _client.send('POST', '/attendance/check-in/')),
  );

  @override
  Future<WorkRecord> checkOut() async => AttendanceModels.record(
    jsonObject(await _client.send('POST', '/attendance/check-out/')),
  );

  @override
  Future<List<WorkRecord>> mine(DateTime from, DateTime to) async => [
    for (final r in jsonObjects(
      await _client.send(
        'GET',
        '/attendance/me/',
        query: {'from': WireFormat.day(from), 'to': WireFormat.day(to)},
      ),
    ))
      AttendanceModels.record(r),
  ];

  @override
  Future<DayBoard> board(DateTime day, {String? role}) async =>
      AttendanceModels.board(
        jsonObject(
          await _client.send(
            'GET',
            '/attendance/people/',
            query: {'day': WireFormat.day(day), 'role': role},
          ),
        ),
      );

  @override
  Future<void> correct(CorrectionDraft d) => _client.send(
    'PUT',
    '/attendance/records/',
    body: {
      'person_id': d.personId,
      'day': WireFormat.day(d.day),
      'checked_in_at': WireFormat.minutes(d.checkedInAt),
      'checked_out_at': d.checkedOutAt == null
          ? null
          : WireFormat.minutes(d.checkedOutAt!),
    },
  );
}
