import 'package:equatable/equatable.dart';

import '../../../../core/domain/gender.dart';
import 'member_kind.dart';

/// What every person in the school has, whatever their group. A student, a
/// teacher and another staff member each extend this and add what is theirs.
abstract class Member extends Equatable {
  const Member({
    required this.id,
    required this.name,
    this.phone = '',
    this.gender,
    this.dateOfBirth,
    this.address,
    this.aadhaarMasked = '',
    this.aadhaarReason,
    this.registeredOn,
    this.active = true,
  });

  /// Empty until the person is saved for the first time.
  final String id;
  final String name;
  final String phone;
  final Gender? gender;
  final DateTime? dateOfBirth;
  final String? address;

  /// Only the masked form (e.g. "XXXX XXXX 1234") is ever kept; empty when
  /// no Aadhaar number was given.
  final String aadhaarMasked;

  /// Why there is no Aadhaar number, when there is none.
  final String? aadhaarReason;

  /// Null until the person is saved.
  final DateTime? registeredOn;

  /// A person who has left is made inactive, never deleted, so what was
  /// recorded about them stays.
  final bool active;

  MemberKind get kind;

  /// The one line shown under the name: class, subject or role.
  String get subtitle;

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    gender,
    dateOfBirth,
    address,
    aadhaarMasked,
    aadhaarReason,
    registeredOn,
    active,
  ];
}
