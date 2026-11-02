import '../../../../core/domain/gender.dart';
import '../../domain/entities/other_staff.dart';
import '../dto/other_staff_record_dto.dart';

class OtherStaffModel extends OtherStaff {
  const OtherStaffModel({
    required super.id,
    required super.name,
    required super.roleTitle,
    super.phone,
    super.gender,
    super.dateOfBirth,
    super.address,
    super.aadhaarMasked,
    super.aadhaarReason,
    super.registeredOn,
    super.active,
    super.vehicleNumber,
  });

  factory OtherStaffModel.fromDto(OtherStaffRecordDto d) => OtherStaffModel(
    id: d.id,
    name: d.name,
    roleTitle: d.roleTitle,
    phone: d.phone,
    gender: Gender.parse(d.gender),
    dateOfBirth: d.dob == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.dob!),
    address: d.address,
    aadhaarMasked: d.aadhaarMasked ?? '',
    aadhaarReason: d.aadhaarReason,
    registeredOn: DateTime.fromMillisecondsSinceEpoch(d.registeredOn),
    active: d.active,
    vehicleNumber: (d.vehicleNumber?.isEmpty ?? true) ? null : d.vehicleNumber,
  );

  static OtherStaffRecordDto toDto(
    OtherStaff s, {
    required String id,
    required DateTime registeredOn,
  }) => OtherStaffRecordDto(
    id: id,
    name: s.name.trim(),
    roleTitle: s.roleTitle.trim(),
    phone: s.phone,
    registeredOn: registeredOn.millisecondsSinceEpoch,
    active: s.active,
    aadhaarMasked: s.aadhaarMasked.isEmpty ? null : s.aadhaarMasked,
    aadhaarReason: s.aadhaarReason,
    dob: s.dateOfBirth?.millisecondsSinceEpoch,
    gender: s.gender?.name,
    address: s.address,
    vehicleNumber: s.vehicleNumber,
  );
}
