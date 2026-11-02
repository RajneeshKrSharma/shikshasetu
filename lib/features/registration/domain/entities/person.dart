import 'package:equatable/equatable.dart';

import '../../../../core/domain/gender.dart';

enum PersonType { student, teacher, other }

class Person extends Equatable {
  const Person({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.detail,
    required this.registeredOn,
    this.aadhaarMasked = '',
    this.aadhaarReason,
    this.guardian,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  final String id;
  final String name;
  final PersonType type;
  final String phone;

  /// Only the masked form (e.g. "XXXX XXXX 1234") is ever stored; empty when
  /// no Aadhaar number was given.
  final String aadhaarMasked;

  /// Why there is no Aadhaar number, when there is none.
  final String? aadhaarReason;

  /// Class for students, subject for teachers, role for others.
  final String detail;
  final String? guardian;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? address;
  final DateTime registeredOn;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    phone,
    aadhaarMasked,
    aadhaarReason,
    detail,
    guardian,
    dateOfBirth,
    gender,
    address,
    registeredOn,
  ];
}
