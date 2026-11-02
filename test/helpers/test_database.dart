import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/core/data/local/password_hasher.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Fewer rounds so tests stay fast; the algorithm is identical.
const fastHasher = PasswordHasher(iterations: 10);

/// A fresh, empty in-memory database with the real schema.
Future<AppDatabase> openTestDatabase() async {
  sqfliteFfiInit();
  final db = await databaseFactoryFfi.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: AppDatabase.schemaVersion,
      onConfigure: AppDatabase.configure,
      onCreate: AppDatabase.create,
    ),
  );
  return AppDatabase(db);
}

/// Inserts a teacher directly and returns the id.
Future<String> insertTeacher(
  AppDatabase database,
  String id, {
  String name = 'Teacher',
  bool active = true,
  String subject = 'Maths',
}) async {
  await database.db.insert('users', {
    'id': id,
    'name': name,
    'email': '$id@school.test',
    'role': 'teacher',
    'phone': '9000000000',
    'employee_id': id,
    'joined_on': 0,
    'subject': subject,
    'password_hash': 'x',
    'password_salt': 'y',
    'active': active ? 1 : 0,
  });
  return id;
}

Future<void> insertStudent(
  AppDatabase database,
  String id,
  String className, {
  int roll = 1,
}) => database.db.insert('students', {
  'id': id,
  'name': 'Student $id',
  'roll_no': roll,
  'class_name': className,
  'registered_on': 0,
});
