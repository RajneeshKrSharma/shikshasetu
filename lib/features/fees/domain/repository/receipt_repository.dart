import '../entities/fee_account.dart';
import '../entities/fee_payment.dart';

abstract interface class ReceiptRepository {
  /// Writes a receipt file for [payment] and returns its path.
  Future<String> create({
    required String schoolName,
    required FeeAccount account,
    required FeePayment payment,
    required int balanceAfter,
  });
}
