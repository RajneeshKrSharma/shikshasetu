import 'package:equatable/equatable.dart';

/// Someone a fee can be assigned to.
class FeePerson extends Equatable {
  const FeePerson({
    required this.id,
    required this.name,
    required this.subtitle,
  });

  final String id;
  final String name;
  final String subtitle;

  @override
  List<Object?> get props => [id, name, subtitle];
}
