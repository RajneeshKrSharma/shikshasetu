/// A row of the `other_staff` table.
class OtherStaffDto {
  const OtherStaffDto({
    required this.id,
    required this.name,
    required this.roleTitle,
    required this.phone,
    required this.registeredOn,
    this.aadhaarMasked,
    this.aadhaarReason,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.vehicleNumber,
  });

  final String id;
  final String name;
  final String roleTitle;
  final String phone;
  final String? aadhaarMasked;
  final String? aadhaarReason;
  final int registeredOn;
  final int? dateOfBirth;
  final String? gender;
  final String? address;
  final String? vehicleNumber;

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'role_title': roleTitle,
    'phone': phone,
    'aadhaar_masked': aadhaarMasked,
    'aadhaar_reason': aadhaarReason,
    'dob': dateOfBirth,
    'gender': gender,
    'address': address,
    'registered_on': registeredOn,
    'active': 1,
    'vehicle_number': vehicleNumber,
  };
}
