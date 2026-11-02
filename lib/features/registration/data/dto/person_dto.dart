/// One person in the registry, read from any of the three source tables.
class PersonDto {
  const PersonDto({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.aadhaarMasked,
    required this.detail,
    required this.registeredOn,
    this.guardian,
    this.aadhaarReason,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  final String id;
  final String name;
  final String type;
  final String phone;
  final String aadhaarMasked;
  final String detail;
  final int registeredOn;
  final String? guardian;
  final String? aadhaarReason;
  final int? dateOfBirth;
  final String? gender;
  final String? address;

  factory PersonDto.fromStudentRow(Map<String, Object?> r) => PersonDto(
    id: r['id']! as String,
    name: r['name']! as String,
    type: 'student',
    phone: (r['phone'] as String?) ?? '',
    aadhaarMasked: (r['aadhaar_masked'] as String?) ?? '',
    detail: r['class_name']! as String,
    guardian: r['guardian'] as String?,
    registeredOn: r['registered_on']! as int,
    aadhaarReason: r['aadhaar_reason'] as String?,
    dateOfBirth: r['dob'] as int?,
    gender: r['gender'] as String?,
    address: r['address'] as String?,
  );

  factory PersonDto.fromTeacherRow(Map<String, Object?> r) => PersonDto(
    id: r['id']! as String,
    name: r['name']! as String,
    type: 'teacher',
    phone: r['phone']! as String,
    aadhaarMasked: (r['aadhaar_masked'] as String?) ?? '',
    detail: (r['subject'] as String?) ?? '',
    registeredOn: r['joined_on']! as int,
    aadhaarReason: r['aadhaar_reason'] as String?,
    dateOfBirth: r['dob'] as int?,
    gender: r['gender'] as String?,
    address: r['address'] as String?,
  );

  factory PersonDto.fromOtherRow(Map<String, Object?> r) => PersonDto(
    id: r['id']! as String,
    name: r['name']! as String,
    type: 'other',
    phone: r['phone']! as String,
    aadhaarMasked: (r['aadhaar_masked'] as String?) ?? '',
    detail: r['role_title']! as String,
    registeredOn: r['registered_on']! as int,
    aadhaarReason: r['aadhaar_reason'] as String?,
    dateOfBirth: r['dob'] as int?,
    gender: r['gender'] as String?,
    address: r['address'] as String?,
  );
}
