import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repository/account_service.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/school_profile_service.dart';
import '../../domain/repository/school_restorer.dart';
import '../dto/user_dto.dart';
import '../models/user_model.dart';

/// Who may sign in is decided online (the login service); the person's profile and
/// role come from the `users` table on this phone.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._database,
    this._accounts,
    this._restorer,
    this._school,
  );

  final AppDatabase _database;
  final AccountService _accounts;
  final SchoolRestorer _restorer;
  final SchoolProfileService _school;

  Database get _db => _database.db;

  @override
  Future<String> schoolName() async {
    final rows = await _db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['school_name'],
    );
    return rows.isEmpty ? '' : rows.first['value']! as String;
  }

  @override
  Future<void> nameSchool(String name) async {
    await _school.saveName(name);
    await _db.insert('app_settings', {
      'key': 'school_name',
      'value': name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    await _accounts.signIn(email, password);
    return _openProfile(email);
  }

  /// The profile of the account that just signed in. A phone that does not
  /// have this person yet is given them (and the school's name) from the
  /// server.
  Future<AppUser> _openProfile(String email) async {
    var dto = await _signedInProfile(email);
    if (dto == null) {
      await _restoreSchool();
      dto = await _signedInProfile(email);
    }
    if (dto == null) return _reject(AuthFailure.profileMissing);
    if (!dto.active) return _reject(AuthFailure.inactiveAccount);
    return UserModel.fromDto(dto);
  }

  /// Brings the profile onto this phone: as the Principal, else as a teacher
  /// the Principal added. Signs out again if neither fits.
  Future<void> _restoreSchool() async {
    try {
      try {
        await _restorer.restoreForPrincipal();
      } on AuthException catch (e) {
        if (e.failure != AuthFailure.schoolNotFound) rethrow;
        await _restorer.restoreForTeacher();
      }
    } on AuthException {
      await _accounts.signOut();
      rethrow;
    }
  }

  @override
  Future<AppUser?> restoreSession() async {
    final email = _accounts.signedInEmail;
    if (email == null) return null;
    final dto = await _signedInProfile(email);
    // A deactivated or removed account must not stay signed in.
    if (dto == null || !dto.active) {
      await _accounts.signOut();
      return null;
    }
    return UserModel.fromDto(dto);
  }

  @override
  Future<void> requestEmailChange({
    required String password,
    required String newEmail,
  }) => _accounts.requestEmailChange(
    password: password,
    newEmail: newEmail.trim().toLowerCase(),
  );

  @override
  Future<AppUser?> syncVerifiedEmail() async {
    final uid = _accounts.signedInUid;
    final email = (await _accounts.currentEmail())?.toLowerCase();
    if (uid == null || email == null) return null;
    final before = await _profileById(uid);
    if (before == null || before.email.toLowerCase() == email) return null;
    final after = await _signedInProfile(email);
    return after == null ? null : UserModel.fromDto(after);
  }

  @override
  Future<void> signOut() async {
    await _accounts.signOut();
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String current,
    required String next,
  }) => _accounts.changePassword(current: current, next: next);

  @override
  Future<AppUser> updateProfile({
    required String userId,
    required String name,
    required String phone,
  }) async {
    await _db.update(
      'users',
      {'name': name.trim(), 'phone': phone.trim()},
      where: 'id = ?',
      whereArgs: [userId],
    );
    final rows = await _db.query('users', where: 'id = ?', whereArgs: [userId]);
    return UserModel.fromDto(UserDto.fromMap(rows.first));
  }

  /// The profile of the signed-in account. Found by account id, which does not
  /// change, so an email change does not lose it; the stored email is then
  /// brought in line with the account's.
  Future<UserDto?> _signedInProfile(String accountEmail) async {
    final uid = _accounts.signedInUid;
    final dto =
        (uid == null ? null : await _profileById(uid)) ??
        await _profileOf(accountEmail);
    if (dto == null) return null;
    final email = accountEmail.trim().toLowerCase();
    if (dto.email.toLowerCase() == email) return dto;
    await _db.update(
      'users',
      {'email': email},
      where: 'id = ?',
      whereArgs: [dto.id],
    );
    return _profileById(dto.id);
  }

  Future<UserDto?> _profileById(String id) async {
    final rows = await _db.query('users', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : UserDto.fromMap(rows.first);
  }

  Future<UserDto?> _profileOf(String email) async {
    final rows = await _db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    return rows.isEmpty ? null : UserDto.fromMap(rows.first);
  }

  /// Signs out of the online account again, then fails.
  Future<Never> _reject(AuthFailure failure) async {
    await _accounts.signOut();
    throw AuthException(failure);
  }
}
