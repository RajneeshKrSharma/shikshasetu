import '../../../../core/domain/gender.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/registration_repository.dart';

class RegisterTeacherParams extends Equatable {
  const RegisterTeacherParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.password,
    this.aadhaarMasked,
    this.aadhaarReason,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  final String name;
  final String email;
  final String phone;
  final String subject;
  final String? aadhaarMasked;
  final String? aadhaarReason;
  final String password;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? address;

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    subject,
    aadhaarMasked,
    aadhaarReason,
    password,
    dateOfBirth,
    gender,
    address,
  ];
}

class RegisterTeacher implements UseCase<void, RegisterTeacherParams> {
  const RegisterTeacher(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<void> call(RegisterTeacherParams p) => _repository.registerTeacher(
    name: p.name,
    email: p.email,
    phone: p.phone,
    subject: p.subject,
    aadhaarMasked: p.aadhaarMasked,
    aadhaarReason: p.aadhaarReason,
    password: p.password,
    dateOfBirth: p.dateOfBirth,
    gender: p.gender,
    address: p.address,
  );
}
