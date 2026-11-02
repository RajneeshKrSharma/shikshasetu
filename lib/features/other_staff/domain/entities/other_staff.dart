import '../../../members/domain/entities/member.dart';
import '../../../members/domain/entities/member_kind.dart';

/// A staff member who is neither a teacher nor a student: a driver, a helper,
/// a guard...
class OtherStaff extends Member {
  const OtherStaff({
    required super.id,
    required super.name,
    required this.roleTitle,
    super.phone,
    super.gender,
    super.dateOfBirth,
    super.address,
    super.aadhaarMasked,
    super.aadhaarReason,
    super.registeredOn,
    super.active,
    this.vehicleNumber,
  });

  final String roleTitle;

  /// The van a driver drives.
  final String? vehicleNumber;

  @override
  MemberKind get kind => MemberKind.other;

  @override
  String get subtitle => roleTitle;

  @override
  List<Object?> get props => [...super.props, roleTitle, vehicleNumber];
}
