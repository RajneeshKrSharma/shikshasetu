import '../../../../core/data/local/day_key.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/domain/repository/exams_repository.dart';
import '../../../bills/domain/entities/staff_bill.dart';
import '../../../bills/domain/repository/bills_repository.dart';
import '../../domain/entities/approval_request.dart';
import '../../domain/repository/approvals_repository.dart';
import '../../../staff/domain/repository/staff_repository.dart';
import '../../../teaching/domain/entities/teaching_assignment.dart';
import '../../../teaching/domain/repository/teaching_repository.dart';
import '../dto/approval_dto.dart';
import '../models/approval_request_model.dart';

/// Gathers approval requests from the features that raise them: question
/// papers (Exams), subjects teachers ask for (Teaching) and staff bills.
class ApprovalsRepositoryImpl implements ApprovalsRepository {
  ApprovalsRepositoryImpl(
    this._exams,
    this._teaching,
    this._staff,
    this._bills,
  );

  final ExamsRepository _exams;
  final TeachingRepository _teaching;
  final StaffRepository _staff;
  final BillsRepository _bills;

  static const _examPaper = 'examPaper';
  static const _teachingSubject = 'teachingSubject';
  static const _staffBill = 'staffBill';

  @override
  Future<List<ApprovalRequest>> getRequests(DateTime today) async {
    final papers = await _exams.getPapers();
    final assignments = await _teaching.getAll();
    final names = {for (final s in await _staff.getStaff()) s.id: s.name};
    final bills = await _bills.getBills();
    return [
      // Subjects teachers asked to teach. (What the Principal allotted
      // directly was never a request.)
      for (final a in assignments)
        if (a.requestedByTeacher)
          ApprovalRequestModel.fromDto(
            ApprovalDto(
              category: _teachingSubject,
              day: dayKey(a.requestedAt),
              status: a.status.name,
              refId: a.id,
              title: '${a.subject} · ${a.className}',
              detail: names[a.teacherId] ?? '',
            ),
          ),
      // Only papers that were actually sent for approval: a draft is not a
      // request, and a paper the Principal approved themselves never was.
      for (final p in papers)
        if (p.submittedAt != null && p.status != PaperStatus.draft)
          ApprovalRequestModel.fromDto(
            ApprovalDto(
              category: _examPaper,
              day: dayKey(p.submittedAt!),
              status: switch (p.status) {
                PaperStatus.submitted => 'pending',
                PaperStatus.changesRequested => 'rejected',
                _ => 'approved',
              },
              refId: p.id,
              title: p.title,
              detail: '${p.subject} · ${p.classSection}',
            ),
          ),
      // Fuel bills waiting to be approved, so they can be paid.
      for (final b in bills)
        ApprovalRequestModel.fromDto(
          ApprovalDto(
            category: _staffBill,
            day: dayKey(b.date),
            status: switch (b.status) {
              BillStatus.pending => 'pending',
              BillStatus.approved => 'approved',
              BillStatus.rejected => 'rejected',
            },
            refId: b.id,
            title:
                '${b.kind == FuelKind.diesel ? 'Diesel' : 'Petrol'} · '
                '₹${b.amount}',
            detail: [
              b.staffName,
              if (b.vehicleNumber != null) b.vehicleNumber!,
            ].join(' · '),
          ),
        ),
    ];
  }

  @override
  Future<void> decide(
    ApprovalRequest request,
    ApprovalStatus status,
    String decidedBy,
  ) {
    switch (request.category) {
      case ApprovalCategory.teachingSubject:
        return _teaching.decide(request.refId!, switch (status) {
          ApprovalStatus.pending => AssignmentStatus.pending,
          ApprovalStatus.approved => AssignmentStatus.approved,
          ApprovalStatus.rejected => AssignmentStatus.rejected,
        });
      case ApprovalCategory.staffBill:
        return _bills.decide(request.refId!, switch (status) {
          ApprovalStatus.pending => BillStatus.pending,
          ApprovalStatus.approved => BillStatus.approved,
          ApprovalStatus.rejected => BillStatus.rejected,
        }, DateTime.now());
      case ApprovalCategory.examPaper:
        // Sending a paper back normally goes through the paper itself, where
        // the reason is asked for; this keeps the contract complete.
        return _exams.setStatus(request.refId!, switch (status) {
          ApprovalStatus.pending => PaperStatus.submitted,
          ApprovalStatus.approved => PaperStatus.approved,
          ApprovalStatus.rejected => PaperStatus.changesRequested,
        });
    }
  }
}
