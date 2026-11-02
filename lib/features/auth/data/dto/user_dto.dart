/// A row of the `users` table.
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.employeeId,
    required this.joinedOn,
    required this.active,
    this.subject,
    this.aadhaarMasked,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String employeeId;
  final int joinedOn;
  final String? subject;
  final String? aadhaarMasked;
  final bool active;

  factory UserDto.fromMap(Map<String, Object?> m) => UserDto(
    id: m['id']! as String,
    name: m['name']! as String,
    email: m['email']! as String,
    role: m['role']! as String,
    phone: m['phone']! as String,
    employeeId: m['employee_id']! as String,
    joinedOn: m['joined_on']! as int,
    subject: m['subject'] as String?,
    aadhaarMasked: m['aadhaar_masked'] as String?,
    active: (m['active']! as int) == 1,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'phone': phone,
    'employee_id': employeeId,
    'joined_on': joinedOn,
    'subject': subject,
    'aadhaar_masked': aadhaarMasked,
    // Passwords are kept by the login service, not here; these columns predate that and
    // are still NOT NULL, so they are filled with empty values.
    'password_hash': '',
    'password_salt': '',
    'active': active ? 1 : 0,
  };
}
