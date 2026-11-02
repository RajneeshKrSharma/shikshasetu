import 'package:equatable/equatable.dart';

import 'fee_account.dart';
import 'fee_payment.dart';

/// One payment together with whose fee it was for, so a history can be
/// listed and filtered without opening each account.
class FeePaymentRecord extends Equatable {
  const FeePaymentRecord({
    required this.payment,
    required this.personName,
    required this.group,
    required this.subtitle,
    this.personId,
    this.classSection,
  });

  final FeePayment payment;
  final String personName;
  final FeeGroup group;
  final String? personId;

  /// Class for students, subject for teachers, role for others.
  final String subtitle;
  final String? classSection;

  @override
  List<Object?> get props => [
    payment,
    personName,
    group,
    personId,
    subtitle,
    classSection,
  ];
}
