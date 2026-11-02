import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/school_profile_service.dart';
import 'api_client.dart';

class ApiSchoolProfileService implements SchoolProfileService {
  ApiSchoolProfileService(this._api);

  final ApiClient _api;

  @override
  Future<void> saveName(String name) async {
    final r = await _api.send('PATCH', '/school/', body: {'school_name': name});
    if (!r.ok) {
      final message = r.json['message'];
      throw AuthException(
        AuthFailure.unavailable,
        message: message is String ? message : null,
      );
    }
  }
}
