/// A row of the `accessory_items` table.
class AccessoryItemDto {
  const AccessoryItemDto({
    required this.id,
    required this.className,
    required this.kind,
    required this.name,
    required this.position,
  });

  final String id;
  final String className;
  final String kind;
  final String name;
  final int position;

  factory AccessoryItemDto.fromMap(Map<String, Object?> m) => AccessoryItemDto(
    id: m['id']! as String,
    className: m['class_name']! as String,
    kind: m['kind']! as String,
    name: m['name']! as String,
    position: m['position']! as int,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'class_name': className,
    'kind': kind,
    'name': name,
    'position': position,
  };
}

/// A row of the `accessory_issues` table. [items] is a JSON list.
class AccessoryIssueDto {
  const AccessoryIssueDto({
    required this.id,
    required this.receiptNo,
    required this.studentId,
    required this.kind,
    required this.items,
    required this.quantity,
    required this.receivedBy,
    required this.issuedBy,
    required this.issuedAt,
    this.size,
    this.signaturePath,
    this.photoPath,
  });

  final String id;
  final String receiptNo;
  final String studentId;
  final String kind;
  final String items;
  final int quantity;
  final String receivedBy;
  final String issuedBy;
  final int issuedAt;
  final String? size;
  final String? signaturePath;
  final String? photoPath;

  factory AccessoryIssueDto.fromMap(Map<String, Object?> m) =>
      AccessoryIssueDto(
        id: m['id']! as String,
        receiptNo: m['receipt_no']! as String,
        studentId: m['student_id']! as String,
        kind: m['kind']! as String,
        items: m['items']! as String,
        quantity: (m['quantity'] as int?) ?? 1,
        receivedBy: m['received_by']! as String,
        issuedBy: m['issued_by']! as String,
        issuedAt: m['issued_at']! as int,
        size: m['size'] as String?,
        signaturePath: m['signature_path'] as String?,
        photoPath: m['photo_path'] as String?,
      );

  Map<String, Object?> toMap() => {
    'id': id,
    'receipt_no': receiptNo,
    'student_id': studentId,
    'kind': kind,
    'items': items,
    'size': size,
    'quantity': quantity,
    'received_by': receivedBy,
    'signature_path': signaturePath,
    'photo_path': photoPath,
    'issued_by': issuedBy,
    'issued_at': issuedAt,
  };
}
