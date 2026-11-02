import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/accessory_issue.dart';
import '../entities/accessory_kind.dart';
import '../entities/accessory_record.dart';
import '../entities/class_accessories.dart';
import '../entities/issue_draft.dart';
import '../repository/accessories_repository.dart';

class ClassAccessoriesParams extends Equatable {
  const ClassAccessoriesParams(this.className, this.kind);

  final String className;
  final AccessoryKind kind;

  @override
  List<Object?> get props => [className, kind];
}

class GetClassAccessories
    implements UseCase<ClassAccessories, ClassAccessoriesParams> {
  const GetClassAccessories(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<ClassAccessories> call(ClassAccessoriesParams p) =>
      _repository.getClass(p.className, p.kind);
}

class SaveAccessoryItemsParams extends Equatable {
  const SaveAccessoryItemsParams(this.className, this.kind, this.names);

  final String className;
  final AccessoryKind kind;
  final List<String> names;

  @override
  List<Object?> get props => [className, kind, names];
}

/// Saves the pieces of a class's set, dropping blanks and repeats.
class SaveAccessoryItems implements UseCase<void, SaveAccessoryItemsParams> {
  const SaveAccessoryItems(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<void> call(SaveAccessoryItemsParams p) {
    final seen = <String>{};
    final names = [
      for (final n in p.names)
        if (n.trim().isNotEmpty && seen.add(n.trim().toLowerCase())) n.trim(),
    ];
    return _repository.saveItems(p.className, p.kind, names);
  }
}

class SaveDressSizes implements UseCase<void, Map<String, String>> {
  const SaveDressSizes(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<void> call(Map<String, String> sizes) => _repository.saveSizes(sizes);
}

class IssueAccessoriesParams extends Equatable {
  const IssueAccessoriesParams({
    required this.studentId,
    required this.draft,
    required this.issuedBy,
    required this.at,
    this.quantity = 1,
    this.photoPath,
  });

  final String studentId;
  final IssueDraft draft;
  final String issuedBy;
  final DateTime at;
  final int quantity;
  final String? photoPath;

  @override
  List<Object?> get props => [
    studentId,
    draft,
    issuedBy,
    at,
    quantity,
    photoPath,
  ];
}

/// Hands dress or books to a student, if it is complete: the pieces, who
/// received them, their signature, and a dress's size. Throws
/// [IssueException] otherwise.
class IssueAccessories
    implements UseCase<AccessoryIssue, IssueAccessoriesParams> {
  const IssueAccessories(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<AccessoryIssue> call(IssueAccessoriesParams p) {
    final problem = p.draft.problem;
    if (problem != null) throw IssueException(problem);
    return _repository.issue(
      studentId: p.studentId,
      kind: p.draft.kind,
      items: p.draft.items,
      receivedBy: p.draft.receivedBy.trim(),
      issuedBy: p.issuedBy,
      at: p.at,
      size: p.draft.size?.trim(),
      quantity: p.quantity,
      signaturePath: p.draft.signaturePath,
      photoPath: p.photoPath,
    );
  }
}

class GetStudentIssues implements UseCase<List<AccessoryIssue>, String> {
  const GetStudentIssues(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<List<AccessoryIssue>> call(String studentId) =>
      _repository.getIssues(studentId);
}

class GetAccessoryRecords implements UseCase<List<AccessoryRecord>, NoParams> {
  const GetAccessoryRecords(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<List<AccessoryRecord>> call(NoParams params) =>
      _repository.getRecords();
}
