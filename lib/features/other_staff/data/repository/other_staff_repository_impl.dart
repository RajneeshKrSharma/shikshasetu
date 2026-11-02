import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/other_staff.dart';
import '../../domain/repository/other_staff_repository.dart';
import '../dto/other_staff_record_dto.dart';
import '../models/other_staff_model.dart';

class OtherStaffRepositoryImpl implements OtherStaffRepository {
  OtherStaffRepositoryImpl(this._database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _database;
  final DateTime Function() _clock;

  @override
  Future<OtherStaff?> get(String id) async {
    final rows = await _database.db.query(
      'other_staff',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty
        ? null
        : OtherStaffModel.fromDto(OtherStaffRecordDto.fromMap(rows.first));
  }

  @override
  Future<OtherStaff> add(OtherStaff draft) async {
    final dto = OtherStaffModel.toDto(
      draft,
      id: const Uuid().v4(),
      registeredOn: _clock(),
    );
    await _database.db.insert('other_staff', dto.toMap());
    return OtherStaffModel.fromDto(dto);
  }

  @override
  Future<void> update(OtherStaff member) async {
    final map = OtherStaffModel.toDto(
      member,
      id: member.id,
      registeredOn: member.registeredOn ?? _clock(),
    ).toMap();
    // The registration day, Aadhaar and active flag are not edited here.
    map
      ..remove('id')
      ..remove('registered_on')
      ..remove('aadhaar_masked')
      ..remove('aadhaar_reason')
      ..remove('active');
    await _database.db.update(
      'other_staff',
      map,
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }
}
