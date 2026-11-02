import 'package:equatable/equatable.dart';

import 'fee_payment.dart';

/// Why a payment cannot be recorded as it is.
enum PaymentProblem {
  amountInvalid,
  amountExceeds,
  referenceMissing,
  proofMissing,
}

class PaymentException implements Exception {
  const PaymentException(this.problem);

  final PaymentProblem problem;
}

/// A payment about to be recorded, and what it must have to be accepted.
class PaymentDraft extends Equatable {
  const PaymentDraft({
    required this.amount,
    required this.mode,
    this.reference,
    this.proofPath,
  });

  final int amount;
  final PaymentMode mode;
  final String? reference;
  final String? proofPath;

  /// What is wrong with it, given how much is still owed; null if nothing.
  PaymentProblem? problem({required int pending}) {
    if (amount <= 0) return PaymentProblem.amountInvalid;
    if (amount > pending) return PaymentProblem.amountExceeds;
    if (mode.needsReference && (reference?.trim().isEmpty ?? true)) {
      return PaymentProblem.referenceMissing;
    }
    if (mode.needsProof && proofPath == null) {
      return PaymentProblem.proofMissing;
    }
    return null;
  }

  @override
  List<Object?> get props => [amount, mode, reference, proofPath];
}
