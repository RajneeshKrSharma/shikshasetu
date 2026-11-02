import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/exams/domain/entities/scanned_question.dart';
import 'package:shiksha_setu/features/exams/domain/repository/photo_picker_repository.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/pick_photo.dart';
import 'package:shiksha_setu/features/settings/data/repository/settings_repository_impl.dart';
import 'package:shiksha_setu/features/settings/domain/usecases/get_school_settings.dart';
import 'package:shiksha_setu/features/settings/domain/usecases/save_accent_color.dart';
import 'package:shiksha_setu/features/settings/domain/usecases/save_school_logo.dart';
import 'package:shiksha_setu/features/settings/domain/usecases/save_theme_color.dart';
import 'package:shiksha_setu/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late SettingsBloc bloc;
  String? pickedPath;
  late Directory docs;
  late File picture;

  setUp(() async {
    database = await openTestDatabase();
    docs = await Directory.systemTemp.createTemp('logo_docs');
    picture = File('${docs.path}/picked.png')..writeAsBytesSync([1, 2, 3]);
    pickedPath = picture.path;
    final repository = SettingsRepositoryImpl(
      database,
      documentsDirectory: () async => docs,
    );
    bloc = SettingsBloc(
      getSchoolSettings: GetSchoolSettings(repository),
      saveThemeColor: SaveThemeColor(repository),
      saveAccentColor: SaveAccentColor(repository),
      saveSchoolLogo: SaveSchoolLogo(repository),
      pickPhoto: PickPhoto(_FakePicker(() => pickedPath)),
    );
  });

  tearDown(() async {
    await bloc.close();
    await database.close();
    await docs.delete(recursive: true);
  });

  test('picking a color puts it in the state', () async {
    bloc.add(const ThemeColorChanged(0xFF2E7D32));
    await bloc.stream.firstWhere((s) => s.settings.themeColor != null);
    expect(bloc.state.settings.themeColor, 0xFF2E7D32);
  });

  test('the accent color is kept apart from the main color', () async {
    bloc.add(const ThemeColorChanged(0xFF2E7D32));
    bloc.add(const AccentColorChanged(0xFFD35400));
    await bloc.stream.firstWhere((s) => s.settings.accentColor != null);
    expect(bloc.state.settings.themeColor, 0xFF2E7D32);
    expect(bloc.state.settings.accentColor, 0xFFD35400);
  });

  test('choosing a logo keeps a copy and puts its path in the state', () async {
    bloc.add(const LogoPickRequested());
    await bloc.stream.firstWhere((s) => s.settings.logoPath != null);

    final path = bloc.state.settings.logoPath!;
    expect(path, isNot(picture.path));
    expect(File(path).readAsBytesSync(), [1, 2, 3]);
    expect(path, startsWith(docs.path));
  });

  test('a cancelled pick changes nothing', () async {
    pickedPath = null;
    bloc.add(const LogoPickRequested());
    bloc.add(const SettingsLoaded());
    await bloc.stream.first;

    expect(bloc.state.settings.logoPath, isNull);
  });

  test('replacing the logo removes the old copy', () async {
    bloc.add(const LogoPickRequested());
    await bloc.stream.firstWhere((s) => s.settings.logoPath != null);
    final first = bloc.state.settings.logoPath!;

    bloc.add(const LogoPickRequested());
    await bloc.stream.firstWhere(
      (s) => s.settings.logoPath != null && s.settings.logoPath != first,
    );

    expect(File(first).existsSync(), isFalse);
    expect(File(bloc.state.settings.logoPath!).existsSync(), isTrue);
  });

  test('removing the logo deletes the copy and clears the path', () async {
    bloc.add(const LogoPickRequested());
    await bloc.stream.firstWhere((s) => s.settings.logoPath != null);
    final path = bloc.state.settings.logoPath!;

    bloc.add(const LogoRemoved());
    await bloc.stream.firstWhere((s) => s.settings.logoPath == null);

    expect(File(path).existsSync(), isFalse);
  });
}

class _FakePicker implements PhotoPickerRepository {
  _FakePicker(this.path);

  final String? Function() path;

  @override
  Future<String?> pick(PhotoSource source) async => path();
}
