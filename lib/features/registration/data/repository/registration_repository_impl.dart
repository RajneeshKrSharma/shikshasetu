import '../../../../core/domain/gender.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../auth/data/dto/user_dto.dart';
import '../../../auth/domain/repository/account_service.dart';
import '../../domain/entities/person.dart';
import '../../domain/repository/registration_repository.dart';
import '../dto/other_staff_dto.dart';
import '../dto/person_dto.dart';
import '../models/person_model.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  RegistrationRepositoryImpl(this._database, this._accounts);

  final AppDatabase _database;
  final AccountService _accounts;

  Database get _db => _database.db;

  @override
  Future<List<Person>> getPeople() async {
    final students = await _db.query('students');
    final teachers = await _db.query('users', where: "role = 'teacher'");
    final others = await _db.query('other_staff');

    final people = [
      for (final r in students)
        PersonModel.fromDto(PersonDto.fromStudentRow(r)),
      for (final r in teachers)
        PersonModel.fromDto(PersonDto.fromTeacherRow(r)),
      for (final r in others) PersonModel.fromDto(PersonDto.fromOtherRow(r)),
    ]..sort((a, b) => b.registeredOn.compareTo(a.registeredOn));
    return people;
  }

  @override
  Future<void> registerTeacher({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String password,
    String? aadhaarMasked,
    String? aadhaarReason,
    DateTime? dateOfBirth,
    Gender? gender,
    String? address,
  }) async {
    final normalized = email.trim().toLowerCase();
    final taken = await _db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalized],
    );
    if (taken.isNotEmpty) {
      throw const RegistrationException(RegistrationFailure.emailTaken);
    }
    final count = await _db.rawQuery(
      "SELECT COUNT(*) AS n FROM users WHERE role = 'teacher'",
    );
    final n = (count.first['n']! as int) + 1;
    // The teacher's online login; its id becomes the profile id.
    final id = await _accounts.createFor(
      email: normalized,
      password: password,
      name: name.trim(),
      phone: phone,
      subject: subject,
    );
    final dto = UserDto(
      id: id,
      name: name.trim(),
      email: normalized,
      role: 'teacher',
      phone: phone,
      employeeId: 'T-${n.toString().padLeft(3, '0')}',
      joinedOn: DateTime.now().millisecondsSinceEpoch,
      subject: subject,
      aadhaarMasked: aadhaarMasked,
      active: true,
    );
    await _db.insert('users', {
      ...dto.toMap(),
      'aadhaar_reason': aadhaarReason,
      'dob': dateOfBirth?.millisecondsSinceEpoch,
      'gender': gender?.name,
      'address': address,
    });
  }

  @override
  Future<void> registerOther({
    required String name,
    required String roleTitle,
    required String phone,
    String? aadhaarMasked,
    String? aadhaarReason,
    DateTime? dateOfBirth,
    Gender? gender,
    String? address,
    String? vehicleNumber,
  }) => _db.insert(
    'other_staff',
    OtherStaffDto(
      id: const Uuid().v4(),
      name: name.trim(),
      roleTitle: roleTitle.trim(),
      phone: phone,
      aadhaarMasked: aadhaarMasked,
      aadhaarReason: aadhaarReason,
      registeredOn: DateTime.now().millisecondsSinceEpoch,
      dateOfBirth: dateOfBirth?.millisecondsSinceEpoch,
      gender: gender?.name,
      address: address,
      vehicleNumber: vehicleNumber,
    ).toMap(),
  );
}
