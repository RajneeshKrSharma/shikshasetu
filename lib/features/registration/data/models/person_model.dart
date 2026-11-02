import '../../../../core/domain/gender.dart';
import '../../domain/entities/person.dart';
import '../dto/person_dto.dart';

class PersonModel extends Person {
  const PersonModel({
    required super.id,
    required super.name,
    required super.type,
    required super.phone,
    required super.detail,
    required super.registeredOn,
    super.aadhaarMasked,
    super.aadhaarReason,
    super.guardian,
    super.dateOfBirth,
    super.gender,
    super.address,
  });

  factory PersonModel.fromDto(PersonDto d) => PersonModel(
    id: d.id,
    name: d.name,
    type: PersonType.values.byName(d.type),
    phone: d.phone,
    aadhaarMasked: d.aadhaarMasked,
    aadhaarReason: d.aadhaarReason,
    detail: d.detail,
    guardian: d.guardian,
    dateOfBirth: d.dateOfBirth == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.dateOfBirth!),
    gender: Gender.parse(d.gender),
    address: d.address,
    registeredOn: DateTime.fromMillisecondsSinceEpoch(d.registeredOn),
  );
}
