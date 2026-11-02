import 'package:equatable/equatable.dart';

/// How a payment was made.
enum PaymentMode {
  cash,
  upi,
  cheque,
  bank;

  /// Anything but cash leaves a reference (UPI id, cheque number, UTR).
  bool get needsReference => this != cash;

  /// Anything but cash must come with a photo as proof.
  bool get needsProof => this != cash;
}

class FeePayment extends Equatable {
  const FeePayment({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.paidAt,
    this.mode = PaymentMode.cash,
    this.reference,
    this.proofPath,
  });

  final int id;
  final String accountId;
  final int amount;
  final DateTime paidAt;
  final PaymentMode mode;

  /// UPI id, cheque number or bank reference.
  final String? reference;

  /// A photo of the proof (a screenshot, a cheque, the receipt book).
  final String? proofPath;

  String get receiptNo => 'R-${id.toString().padLeft(5, '0')}';

  bool get hasProof => proofPath != null;

  @override
  List<Object?> get props => [
    id,
    accountId,
    amount,
    paidAt,
    mode,
    reference,
    proofPath,
  ];
}
