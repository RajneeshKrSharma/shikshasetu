import '../../domain/entities/staff_member.dart';
import '../dto/staff_dto.dart';

class StaffMemberModel extends StaffMember {
  const StaffMemberModel({
    required super.id,
    required super.name,
    required super.subject,
    required super.active,
    super.classSection,
  });

  factory StaffMemberModel.fromDto(StaffDto d) => StaffMemberModel(
    id: d.id,
    name: d.name,
    subject: d.subject ?? '',
    active: d.active,
    classSection: d.className,
  );
}
