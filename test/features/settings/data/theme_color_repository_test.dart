import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/settings/data/repository/settings_repository_impl.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late SettingsRepositoryImpl repository;

  setUp(() async {
    database = await openTestDatabase();
    repository = SettingsRepositoryImpl(database);
  });

  tearDown(() => database.close());

  test('there is no theme color until one is picked', () async {
    expect((await repository.get()).themeColor, isNull);
  });

  test('a picked color is saved and read back', () async {
    await repository.setThemeColor(0xFF1F4E79);
    expect((await repository.get()).themeColor, 0xFF1F4E79);
  });

  test('picking the default clears the saved color', () async {
    await repository.setThemeColor(0xFF1F4E79);
    await repository.setThemeColor(null);
    expect((await repository.get()).themeColor, isNull);
  });

  test(
    'the accent color is saved apart from the main color and can reset',
    () async {
      await repository.setThemeColor(0xFF1F4E79);
      await repository.setAccentColor(0xFFD35400);
      final saved = await repository.get();
      expect(saved.themeColor, 0xFF1F4E79);
      expect(saved.accentColor, 0xFFD35400);
      await repository.setAccentColor(null);
      expect((await repository.get()).accentColor, isNull);
      expect((await repository.get()).themeColor, 0xFF1F4E79);
    },
  );
}
