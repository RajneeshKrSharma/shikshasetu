import 'package:equatable/equatable.dart';

import 'accessory_kind.dart';

/// One time dress or books were handed to a student, with who received them
/// and the proof of it.
class AccessoryIssue extends Equatable {
  const AccessoryIssue({
    required this.id,
    required this.receiptNo,
    required this.studentId,
    required this.kind,
    required this.items,
    required this.receivedBy,
    required this.issuedBy,
    required this.issuedAt,
    this.size,
    this.quantity = 1,
    this.signaturePath,
    this.photoPath,
  });

  final String id;

  /// "DR-0042" for dress, "BK-0107" for books.
  final String receiptNo;
  final String studentId;
  final AccessoryKind kind;
  final List<String> items;
  final String? size;
  final int quantity;
  final String receivedBy;
  final String issuedBy;
  final DateTime issuedAt;
  final String? signaturePath;
  final String? photoPath;

  bool get isSigned => signaturePath != null;

  @override
  List<Object?> get props => [
    id,
    receiptNo,
    studentId,
    kind,
    items,
    size,
    quantity,
    receivedBy,
    issuedBy,
    issuedAt,
    signaturePath,
    photoPath,
  ];
}
