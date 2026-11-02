import '../../../../core/domain/gender.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/entities/member_kind.dart';

class Student extends Member {
  const Student({
    required super.id,
    required super.name,
    required this.rollNo,
    required this.classSection,
    this.guardian = '',
    this.vehicleNumber,
    this.dressSize,
    super.phone,
    super.gender,
    super.dateOfBirth,
    super.address,
    super.aadhaarMasked,
    super.aadhaarReason,
    super.registeredOn,
    super.active,
  });

  /// A student not yet saved; the roll number is given when they are.
  const Student.draft({
    required super.name,
    required this.classSection,
    required this.guardian,
    required super.phone,
    this.vehicleNumber,
    super.gender,
    super.dateOfBirth,
    super.address,
    super.aadhaarMasked,
    super.aadhaarReason,
  }) : rollNo = 0,
       dressSize = null,
       super(id: '');

  final int rollNo;
  final String classSection;
  final String guardian;

  /// The van the student travels by, when they do.
  final String? vehicleNumber;

  /// The size noted for their dress, when it has been.
  final String? dressSize;

  @override
  MemberKind get kind => MemberKind.student;

  @override
  String get subtitle => classSection;

  /// The same student with the details that can be edited replaced.
  Student edited({
    required String name,
    required String classSection,
    required String guardian,
    required String phone,
    required String? vehicleNumber,
    required Gender? gender,
    required DateTime? dateOfBirth,
    required String? address,
  }) => Student(
    id: id,
    name: name,
    rollNo: rollNo,
    classSection: classSection,
    guardian: guardian,
    vehicleNumber: vehicleNumber,
    dressSize: dressSize,
    phone: phone,
    gender: gender,
    dateOfBirth: dateOfBirth,
    address: address,
    aadhaarMasked: aadhaarMasked,
    aadhaarReason: aadhaarReason,
    registeredOn: registeredOn,
    active: active,
  );

  @override
  List<Object?> get props => [
    ...super.props,
    rollNo,
    classSection,
    guardian,
    vehicleNumber,
    dressSize,
  ];
}
