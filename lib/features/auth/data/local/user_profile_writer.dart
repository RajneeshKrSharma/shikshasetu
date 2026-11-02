import 'package:sqflite/sqflite.dart';

import '../dto/user_dto.dart';

/// Saves a person's profile on this phone. Updates the row already there for
/// that account (found by id, else by email) instead of adding a second one,
/// so rows that point at it, such as a class teacher, are kept.
class UserProfileWriter {
  const UserProfileWriter();

  Future<void> save(DatabaseExecutor db, UserDto dto) async {
    final values = dto.toMap();
    final byId = await db.query('users', where: 'id = ?', whereArgs: [dto.id]);
    if (byId.isNotEmpty) {
      await db.update('users', values, where: 'id = ?', whereArgs: [dto.id]);
      return;
    }
    final byEmail = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [dto.email],
    );
    if (byEmail.isNotEmpty) {
      values.remove('id');
      await db.update(
        'users',
        values,
        where: 'email = ?',
        whereArgs: [dto.email],
      );
      return;
    }
    await db.insert('users', values);
  }
}
