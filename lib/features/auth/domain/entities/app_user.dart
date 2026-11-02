import 'package:equatable/equatable.dart';

enum UserRole { principal, teacher }

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.employeeId,
    required this.joinedOn,
    this.subject,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;
  final String employeeId;
  final DateTime joinedOn;
  final String? subject;

  bool get isPrincipal => role == UserRole.principal;

  /// Teachers keep their own unit-wise question bank.
  bool get ownsQuestionBank => !isPrincipal;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    phone,
    employeeId,
    joinedOn,
    subject,
  ];
}
