import '../../../../core/domain/gender.dart';
import '../entities/person.dart';

enum RegistrationFailure { emailTaken }

class RegistrationException implements Exception {
  const RegistrationException(this.failure);
  final RegistrationFailure failure;
}

abstract interface class RegistrationRepository {
  /// Students, teachers and other staff, newest first.
  Future<List<Person>> getPeople();

  /// Creates the teacher and their login. Throws [RegistrationException]
  /// when [email] is already used.
  Future<void> registerTeacher({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String password,
    String? aadhaarMasked,
    String? aadhaarReason,
    DateTime? dateOfBirth,
    Gender? gender,
    String? address,
  });

  Future<void> registerOther({
    required String name,
    required String roleTitle,
    required String phone,
    String? aadhaarMasked,
    String? aadhaarReason,
    DateTime? dateOfBirth,
    Gender? gender,
    String? address,
    String? vehicleNumber,
  });
}
