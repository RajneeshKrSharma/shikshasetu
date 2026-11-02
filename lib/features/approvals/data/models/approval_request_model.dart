import '../../domain/entities/approval_request.dart';
import '../dto/approval_dto.dart';

class ApprovalRequestModel extends ApprovalRequest {
  const ApprovalRequestModel({
    required super.category,
    required super.date,
    required super.status,
    super.refId,
    super.title,
    super.detail,
  });

  factory ApprovalRequestModel.fromDto(ApprovalDto d) => ApprovalRequestModel(
    category: ApprovalCategory.values.byName(d.category),
    date: DateTime.parse(d.day),
    status: ApprovalStatus.values.byName(d.status),
    refId: d.refId,
    title: d.title,
    detail: d.detail,
  );
}
