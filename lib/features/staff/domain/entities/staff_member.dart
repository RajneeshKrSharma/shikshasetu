import 'package:equatable/equatable.dart';

class StaffMember extends Equatable {
  const StaffMember({
    required this.id,
    required this.name,
    required this.subject,
    required this.active,
    this.classSection,
  });

  final String id;
  final String name;
  final String subject;
  final bool active;

  /// Class this teacher is the class teacher of, if any.
  final String? classSection;

  @override
  List<Object?> get props => [id, name, subject, active, classSection];
}
