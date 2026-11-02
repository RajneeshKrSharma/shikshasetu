import '../../../../core/domain/gender.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/registration_repository.dart';

class RegisterOtherParams extends Equatable {
  const RegisterOtherParams({
    required this.name,
    required this.roleTitle,
    required this.phone,
    this.aadhaarMasked,
    this.aadhaarReason,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.vehicleNumber,
  });

  final String name;
  final String roleTitle;
  final String phone;
  final String? aadhaarMasked;
  final String? aadhaarReason;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? address;

  /// The van a driver drives.
  final String? vehicleNumber;

  @override
  List<Object?> get props => [
    name,
    roleTitle,
    phone,
    aadhaarMasked,
    aadhaarReason,
    dateOfBirth,
    gender,
    address,
    vehicleNumber,
  ];
}

class RegisterOther implements UseCase<void, RegisterOtherParams> {
  const RegisterOther(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<void> call(RegisterOtherParams p) => _repository.registerOther(
    name: p.name,
    roleTitle: p.roleTitle,
    phone: p.phone,
    aadhaarMasked: p.aadhaarMasked,
    aadhaarReason: p.aadhaarReason,
    dateOfBirth: p.dateOfBirth,
    gender: p.gender,
    address: p.address,
    vehicleNumber: p.vehicleNumber,
  );
}
