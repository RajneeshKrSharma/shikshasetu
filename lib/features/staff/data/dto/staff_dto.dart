/// A teacher's `users` row joined with the class they lead.
class StaffDto {
  const StaffDto({
    required this.id,
    required this.name,
    required this.active,
    this.subject,
    this.className,
  });

  final String id;
  final String name;
  final bool active;
  final String? subject;
  final String? className;

  factory StaffDto.fromMap(Map<String, Object?> m) => StaffDto(
    id: m['id']! as String,
    name: m['name']! as String,
    active: (m['active']! as int) == 1,
    subject: m['subject'] as String?,
    className: m['class_name'] as String?,
  );
}
