/// A row of the `other_staff` table, read whole.
class OtherStaffRecordDto {
  const OtherStaffRecordDto({
    required this.id,
    required this.name,
    required this.roleTitle,
    required this.phone,
    required this.registeredOn,
    required this.active,
    this.aadhaarMasked,
    this.aadhaarReason,
    this.dob,
    this.gender,
    this.address,
    this.vehicleNumber,
  });

  final String id;
  final String name;
  final String roleTitle;
  final String phone;
  final int registeredOn;
  final bool active;
  final String? aadhaarMasked;
  final String? aadhaarReason;
  final int? dob;
  final String? gender;
  final String? address;
  final String? vehicleNumber;

  factory OtherStaffRecordDto.fromMap(Map<String, Object?> m) =>
      OtherStaffRecordDto(
        id: m['id']! as String,
        name: m['name']! as String,
        roleTitle: m['role_title']! as String,
        phone: m['phone']! as String,
        registeredOn: m['registered_on']! as int,
        active: (m['active'] as int? ?? 1) == 1,
        aadhaarMasked: m['aadhaar_masked'] as String?,
        aadhaarReason: m['aadhaar_reason'] as String?,
        dob: m['dob'] as int?,
        gender: m['gender'] as String?,
        address: m['address'] as String?,
        vehicleNumber: m['vehicle_number'] as String?,
      );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'role_title': roleTitle,
    'phone': phone,
    'aadhaar_masked': aadhaarMasked,
    'aadhaar_reason': aadhaarReason,
    'dob': dob,
    'gender': gender,
    'address': address,
    'registered_on': registeredOn,
    'active': active ? 1 : 0,
    'vehicle_number': vehicleNumber,
  };
}
