import 'dart:convert';

import '../../domain/entities/accessory_issue.dart';
import '../../domain/entities/accessory_item.dart';
import '../../domain/entities/accessory_kind.dart';
import '../dto/accessory_dto.dart';

class AccessoryItemModel extends AccessoryItem {
  const AccessoryItemModel({
    required super.id,
    required super.className,
    required super.kind,
    required super.name,
  });

  factory AccessoryItemModel.fromDto(AccessoryItemDto d) => AccessoryItemModel(
    id: d.id,
    className: d.className,
    kind: AccessoryKind.values.byName(d.kind),
    name: d.name,
  );
}

class AccessoryIssueModel extends AccessoryIssue {
  const AccessoryIssueModel({
    required super.id,
    required super.receiptNo,
    required super.studentId,
    required super.kind,
    required super.items,
    required super.receivedBy,
    required super.issuedBy,
    required super.issuedAt,
    super.size,
    super.quantity,
    super.signaturePath,
    super.photoPath,
  });

  factory AccessoryIssueModel.fromDto(AccessoryIssueDto d) =>
      AccessoryIssueModel(
        id: d.id,
        receiptNo: d.receiptNo,
        studentId: d.studentId,
        kind: AccessoryKind.values.byName(d.kind),
        items: [for (final i in jsonDecode(d.items) as List) '$i'],
        size: d.size,
        quantity: d.quantity,
        receivedBy: d.receivedBy,
        issuedBy: d.issuedBy,
        issuedAt: DateTime.fromMillisecondsSinceEpoch(d.issuedAt),
        signaturePath: d.signaturePath,
        photoPath: d.photoPath,
      );

  static AccessoryIssueDto toDto(AccessoryIssue i) => AccessoryIssueDto(
    id: i.id,
    receiptNo: i.receiptNo,
    studentId: i.studentId,
    kind: i.kind.name,
    items: jsonEncode(i.items),
    size: i.size,
    quantity: i.quantity,
    receivedBy: i.receivedBy,
    issuedBy: i.issuedBy,
    issuedAt: i.issuedAt.millisecondsSinceEpoch,
    signaturePath: i.signaturePath,
    photoPath: i.photoPath,
  );
}
