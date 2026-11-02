import '../../../../core/money.dart';
import '../entities/fees.dart';

abstract interface class FeesRepository {
  Future<List<FeeStructureLine>> structure(String classId);

  Future<void> setAmount(String classId, FeeHead head, Money amount);

  Future<List<FeeStatement>> accounts({
    String? classId,
    String query = '',
    bool onlyDue = false,
  });

  Future<FeeStatement> studentFees(String studentId);

  Future<void> receive({
    required String studentId,
    required FeeHead head,
    required Money amount,
    DateTime? paidOn,
    String note = '',
  });
}
