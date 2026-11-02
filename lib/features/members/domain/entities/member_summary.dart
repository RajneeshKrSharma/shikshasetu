import 'package:equatable/equatable.dart';

import 'member_kind.dart';

/// A fact shown on a person's card. The screen words each one in the app's
/// language; the data layer only says which fact it is.
enum SummaryField {
  className,
  rollNo,
  subject,
  role,
  vehicleNumber,
  classTeacherOf,
}

class SummaryPart extends Equatable {
  const SummaryPart(this.field, this.value);

  final SummaryField field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}

/// One person as a list shows them: enough to find them and open them.
class MemberSummary extends Equatable {
  const MemberSummary({
    required this.id,
    required this.name,
    required this.kind,
    this.parts = const [],
    this.group,
    this.active = true,
  });

  final String id;
  final String name;
  final MemberKind kind;

  /// What the card says about the person, in order.
  final List<SummaryPart> parts;

  /// What the list can be narrowed by: the class of a student, the role of
  /// other staff. Null when the kind has no such grouping.
  final String? group;
  final bool active;

  @override
  List<Object?> get props => [id, name, kind, parts, group, active];
}
