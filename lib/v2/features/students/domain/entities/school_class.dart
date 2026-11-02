import 'package:equatable/equatable.dart';

/// The levels a class can be, lowest first.
enum ClassLevel {
  nursery('nursery'),
  lkg('lkg'),
  ukg('ukg'),
  one('1'),
  two('2'),
  three('3'),
  four('4'),
  five('5'),
  six('6'),
  seven('7'),
  eight('8');

  const ClassLevel(this.code);

  final String code;

  static ClassLevel? fromCode(String? code) {
    for (final l in values) {
      if (l.code == code) return l;
    }
    return null;
  }
}

/// A level and, when the school has more than one of it, a section: 5-A.
class SchoolClass extends Equatable {
  const SchoolClass({
    required this.id,
    required this.name,
    required this.level,
    required this.section,
    this.isActive = true,
  });

  final String id;

  /// What the server calls it, such as "5-A" or "Nursery".
  final String name;
  final ClassLevel level;
  final String section;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, level, section, isActive];
}
