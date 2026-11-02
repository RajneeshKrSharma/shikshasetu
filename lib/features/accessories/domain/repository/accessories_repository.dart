import '../entities/accessory_issue.dart';
import '../entities/accessory_record.dart';
import '../entities/accessory_kind.dart';
import '../entities/class_accessories.dart';

abstract interface class AccessoriesRepository {
  Future<ClassAccessories> getClass(String className, AccessoryKind kind);

  /// Replaces the pieces of a class's dress (or its books) with [names].
  Future<void> saveItems(
    String className,
    AccessoryKind kind,
    List<String> names,
  );

  /// Notes dress sizes, by student id. An empty size clears it.
  Future<void> saveSizes(Map<String, String> sizes);

  /// Records a handing over and returns it with its receipt number.
  Future<AccessoryIssue> issue({
    required String studentId,
    required AccessoryKind kind,
    required List<String> items,
    required String receivedBy,
    required String issuedBy,
    required DateTime at,
    String? size,
    int quantity = 1,
    String? signaturePath,
    String? photoPath,
  });

  /// Everything given to every student, newest first.
  Future<List<AccessoryRecord>> getRecords();

  /// Everything given to one student, newest first.
  Future<List<AccessoryIssue>> getIssues(String studentId);
}
