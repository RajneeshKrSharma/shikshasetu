import '../../../../core/server/json.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/entities/student.dart';

class SchoolClassModel extends SchoolClass {
  const SchoolClassModel({
    required super.id,
    required super.name,
    required super.level,
    required super.section,
    required super.isActive,
  });

  factory SchoolClassModel.fromJson(Json json) => SchoolClassModel(
    id: json.string('id'),
    name: json.string('name'),
    level:
        ClassLevel.fromCode(json.stringOrNull('level')) ?? ClassLevel.nursery,
    section: json.string('section'),
    isActive: json.flag('is_active', otherwise: true),
  );
}

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.name,
    required super.rollNumber,
    required super.classId,
    required super.className,
    required super.guardianName,
    required super.usesVan,
    required super.isActive,
  });

  factory StudentModel.fromJson(Json json) => StudentModel(
    id: json.string('id'),
    name: json.string('name'),
    rollNumber: json.string('roll_number'),
    classId: json.string('class_id'),
    className: json.string('class_name'),
    guardianName: json.string('guardian_name'),
    usesVan: json.flag('uses_van'),
    isActive: json.flag('is_active', otherwise: true),
  );
}
