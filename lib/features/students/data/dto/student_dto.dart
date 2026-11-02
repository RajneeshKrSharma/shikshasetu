/// A row of the `students` table.
class StudentDto {
  const StudentDto({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.className,
    required this.registeredOn,
    this.active = true,
    this.vehicleNumber,
    this.dressSize,
    this.guardian,
    this.phone,
    this.aadhaarMasked,
    this.aadhaarReason,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  final String id;
  final String name;
  final int rollNo;
  final String className;
  final int registeredOn;
  final bool active;
  final String? vehicleNumber;
  final String? dressSize;
  final String? guardian;
  final String? phone;
  final String? aadhaarMasked;
  final String? aadhaarReason;
  final int? dateOfBirth;
  final String? gender;
  final String? address;

  factory StudentDto.fromMap(Map<String, Object?> m) => StudentDto(
    id: m['id']! as String,
    name: m['name']! as String,
    rollNo: m['roll_no']! as int,
    className: m['class_name']! as String,
    registeredOn: m['registered_on']! as int,
    active: (m['active'] as int? ?? 1) == 1,
    vehicleNumber: m['vehicle_number'] as String?,
    dressSize: m['dress_size'] as String?,
    guardian: m['guardian'] as String?,
    phone: m['phone'] as String?,
    aadhaarMasked: m['aadhaar_masked'] as String?,
    aadhaarReason: m['aadhaar_reason'] as String?,
    dateOfBirth: m['dob'] as int?,
    gender: m['gender'] as String?,
    address: m['address'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'roll_no': rollNo,
    'class_name': className,
    'guardian': guardian,
    'phone': phone,
    'aadhaar_masked': aadhaarMasked,
    'aadhaar_reason': aadhaarReason,
    'dob': dateOfBirth,
    'gender': gender,
    'address': address,
    'registered_on': registeredOn,
    'active': active ? 1 : 0,
    'vehicle_number': vehicleNumber,
    'dress_size': dressSize,
  };
}
