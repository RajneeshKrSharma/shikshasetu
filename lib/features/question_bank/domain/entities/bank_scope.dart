import 'package:equatable/equatable.dart';

/// One teacher's bank for one subject of one class.
class BankScope extends Equatable {
  const BankScope({
    required this.teacherId,
    required this.classSection,
    required this.subject,
  });

  final String teacherId;
  final String classSection;
  final String subject;

  @override
  List<Object?> get props => [teacherId, classSection, subject];
}
