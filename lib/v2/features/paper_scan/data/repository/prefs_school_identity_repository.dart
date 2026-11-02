import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/school_identity.dart';
import '../../domain/repository/school_identity_repository.dart';

/// Keeps the school name in the phone's preferences and the logo as a file in
/// the app's own folder, so it survives the original picture being deleted.
class PrefsSchoolIdentityRepository implements SchoolIdentityRepository {
  static const _nameKey = 'paper_scan.school_name';
  static const _logoKey = 'paper_scan.logo_path';

  @override
  Future<SchoolIdentity> load() async {
    final prefs = await SharedPreferences.getInstance();
    final logo = prefs.getString(_logoKey);
    return SchoolIdentity(
      name: prefs.getString(_nameKey) ?? '',
      logoPath: logo != null && await File(logo).exists() ? logo : null,
    );
  }

  @override
  Future<SchoolIdentity> save(SchoolIdentity identity) async {
    final prefs = await SharedPreferences.getInstance();
    final logo = await _keepLogo(identity.logoPath);
    await prefs.setString(_nameKey, identity.name.trim());
    if (logo == null) {
      await prefs.remove(_logoKey);
    } else {
      await prefs.setString(_logoKey, logo);
    }
    return SchoolIdentity(name: identity.name.trim(), logoPath: logo);
  }

  Future<String?> _keepLogo(String? path) async {
    if (path == null) return null;
    final folder = await getApplicationDocumentsDirectory();
    if (p.isWithin(folder.path, path)) return path;
    final source = File(path);
    if (!await source.exists()) return null;
    final target = p.join(folder.path, 'school_logo${p.extension(path)}');
    await source.copy(target);
    return target;
  }
}
