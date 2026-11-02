import 'package:equatable/equatable.dart';

/// A permission the Principal can give.
class Capability extends Equatable {
  const Capability({required this.code, required this.label});

  final String code;
  final String label;

  @override
  List<Object?> get props => [code, label];
}

/// A permission given to a person, with the reason it was given.
class Grant extends Equatable {
  const Grant({
    required this.id,
    required this.userId,
    required this.capability,
    required this.reason,
    required this.isActive,
  });

  final String id;
  final String userId;
  final String capability;
  final String reason;
  final bool isActive;

  @override
  List<Object?> get props => [id, userId, capability, reason, isActive];
}

class GrantDraft extends Equatable {
  const GrantDraft({
    required this.userId,
    required this.capability,
    required this.reason,
  });

  final String userId;
  final String capability;
  final String reason;

  @override
  List<Object?> get props => [userId, capability, reason];
}
