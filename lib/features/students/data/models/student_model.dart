import '../../../../core/domain/gender.dart';
import '../../domain/entities/student.dart';
import '../dto/student_dto.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.name,
    required super.rollNo,
    required super.classSection,
    super.guardian,
    super.vehicleNumber,
    super.dressSize,
    super.phone,
    super.gender,
    super.dateOfBirth,
    super.address,
    super.aadhaarMasked,
    super.aadhaarReason,
    super.registeredOn,
    super.active,
  });

  factory StudentModel.fromDto(StudentDto d) => StudentModel(
    id: d.id,
    name: d.name,
    rollNo: d.rollNo,
    classSection: d.className,
    guardian: d.guardian ?? '',
    vehicleNumber: (d.vehicleNumber?.isEmpty ?? true) ? null : d.vehicleNumber,
    dressSize: d.dressSize,
    phone: d.phone ?? '',
    gender: Gender.parse(d.gender),
    dateOfBirth: d.dateOfBirth == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.dateOfBirth!),
    address: d.address,
    aadhaarMasked: d.aadhaarMasked ?? '',
    aadhaarReason: d.aadhaarReason,
    registeredOn: DateTime.fromMillisecondsSinceEpoch(d.registeredOn),
    active: d.active,
  );

  /// The row for [s]; [id], [rollNo] and [registeredOn] are the ones the
  /// repository decided for a student being added.
  static StudentDto toDto(
    Student s, {
    required String id,
    required int rollNo,
    required DateTime registeredOn,
  }) => StudentDto(
    id: id,
    name: s.name.trim(),
    rollNo: rollNo,
    className: s.classSection,
    registeredOn: registeredOn.millisecondsSinceEpoch,
    active: s.active,
    guardian: s.guardian.trim(),
    vehicleNumber: s.vehicleNumber,
    dressSize: s.dressSize,
    phone: s.phone,
    aadhaarMasked: s.aadhaarMasked.isEmpty ? null : s.aadhaarMasked,
    aadhaarReason: s.aadhaarReason,
    dateOfBirth: s.dateOfBirth?.millisecondsSinceEpoch,
    gender: s.gender?.name,
    address: s.address,
  );
}
