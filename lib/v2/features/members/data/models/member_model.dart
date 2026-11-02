import '../../../../core/server/json.dart';
import '../../domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.name,
    required super.email,
    required super.jobTitle,
    required super.isActive,
  });

  factory MemberModel.fromJson(Json j) => MemberModel(
    id: j.string('id'),
    name: j.string('name'),
    email: j.string('email'),
    jobTitle: j.string('job_title'),
    isActive: j.flag('is_active', otherwise: true),
  );
}
