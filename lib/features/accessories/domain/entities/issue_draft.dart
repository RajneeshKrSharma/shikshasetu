import 'package:equatable/equatable.dart';

import 'accessory_kind.dart';

/// Why dress or books cannot be handed over as it stands.
enum IssueProblem { noItems, receiverMissing, signatureMissing, sizeMissing }

class IssueException implements Exception {
  const IssueException(this.problem);

  final IssueProblem problem;
}

/// A handing over about to be recorded, and what it must have to count: the
/// pieces, who received them, their signature, and for a dress its size.
class IssueDraft extends Equatable {
  const IssueDraft({
    required this.kind,
    required this.items,
    required this.receivedBy,
    this.size,
    this.signaturePath,
  });

  final AccessoryKind kind;
  final List<String> items;
  final String receivedBy;
  final String? size;
  final String? signaturePath;

  IssueProblem? get problem {
    if (items.isEmpty) return IssueProblem.noItems;
    if (receivedBy.trim().isEmpty) return IssueProblem.receiverMissing;
    if (kind == AccessoryKind.dress && (size?.trim().isEmpty ?? true)) {
      return IssueProblem.sizeMissing;
    }
    if (signaturePath == null) return IssueProblem.signatureMissing;
    return null;
  }

  @override
  List<Object?> get props => [kind, items, receivedBy, size, signaturePath];
}
