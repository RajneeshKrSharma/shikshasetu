import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/school_restorer.dart';
import '../dto/user_dto.dart';
import '../local/user_profile_writer.dart';
import 'api_client.dart';

/// Puts the signed-in person's profile and the school's name from the server
/// onto this phone. (The rest of the school's data comes with sync, which the
/// server does not offer yet.)
class ApiSchoolRestorer implements SchoolRestorer {
  ApiSchoolRestorer(
    this._database,
    this._api, [
    this._profiles = const UserProfileWriter(),
  ]);

  final AppDatabase _database;
  final ApiClient _api;
  final UserProfileWriter _profiles;

  Database get _db => _database.db;

  @override
  Future<void> restoreForPrincipal() => _restore('principal');

  @override
  Future<void> restoreForTeacher() => _restore('teacher');

  /// [role] must be the signed-in person's role; otherwise this school is not
  /// theirs to restore as that role.
  Future<void> _restore(String role) async {
    final me = await _api.send('GET', '/auth/me/');
    if (!me.ok) throw const AuthException(AuthFailure.unavailable);
    if (me.json['role'] != role) {
      throw const AuthException(AuthFailure.schoolNotFound);
    }
    final school = await _api.send('GET', '/school/');
    if (!school.ok) throw const AuthException(AuthFailure.unavailable);
    final joined = DateTime.parse(me.json['joined_on'] as String);
    final dto = UserDto(
      id: me.json['id'] as String,
      name: me.json['name'] as String,
      email: (me.json['email'] as String).toLowerCase(),
      role: role,
      phone: (me.json['phone'] as String?) ?? '',
      employeeId: me.json['employee_id'] as String,
      joinedOn: joined.millisecondsSinceEpoch,
      subject: _blankToNull(me.json['subject']),
      aadhaarMasked: _blankToNull(me.json['aadhaar_masked']),
      active: true,
    );
    await _db.transaction((txn) async {
      await _profiles.save(txn, dto);
      final name = (school.json['school_name'] as String?) ?? '';
      if (name.isNotEmpty) {
        await txn.insert('app_settings', {
          'key': 'school_name',
          'value': name,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await txn.insert('app_settings', {
        'key': 'school_registered_on',
        'value': '${joined.millisecondsSinceEpoch}',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    });
  }

  static String? _blankToNull(Object? v) =>
      (v is String && v.isNotEmpty) ? v : null;
}
