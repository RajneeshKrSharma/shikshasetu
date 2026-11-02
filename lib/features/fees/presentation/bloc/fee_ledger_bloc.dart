import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../sharing/domain/usecases/share_files.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment.dart';
import '../../domain/usecases/create_receipt.dart';
import '../../domain/usecases/get_person_payments.dart';

sealed class FeeLedgerEvent extends Equatable {
  const FeeLedgerEvent();

  @override
  List<Object?> get props => const [];
}

/// Read the person's payments (again, after one was recorded).
final class FeeLedgerLoaded extends FeeLedgerEvent {
  const FeeLedgerLoaded();
}

final class ReceiptRequested extends FeeLedgerEvent {
  const ReceiptRequested({
    required this.account,
    required this.payment,
    required this.schoolName,
  });

  final FeeAccount account;
  final FeePayment payment;
  final String schoolName;

  @override
  List<Object?> get props => [account, payment, schoolName];
}

class FeeLedgerState extends Equatable {
  const FeeLedgerState({
    this.loading = true,
    this.payments = const {},
    this.sharingReceipt = false,
  });

  final bool loading;

  /// Payments by the fee (account id) they were for, newest first.
  final Map<String, List<FeePayment>> payments;
  final bool sharingReceipt;

  List<FeePayment> of(String accountId) => payments[accountId] ?? const [];

  FeeLedgerState copyWith({
    bool? loading,
    Map<String, List<FeePayment>>? payments,
    bool? sharingReceipt,
  }) => FeeLedgerState(
    loading: loading ?? this.loading,
    payments: payments ?? this.payments,
    sharingReceipt: sharingReceipt ?? this.sharingReceipt,
  );

  @override
  List<Object?> get props => [loading, payments, sharingReceipt];
}

/// The payments behind one person's fees, and their receipts.
class FeeLedgerBloc extends Bloc<FeeLedgerEvent, FeeLedgerState> {
  FeeLedgerBloc({
    required this.personId,
    required GetPersonPayments getPayments,
    required CreateReceipt createReceipt,
    required ShareFiles shareFiles,
  }) : _getPayments = getPayments,
       _createReceipt = createReceipt,
       _shareFiles = shareFiles,
       super(const FeeLedgerState()) {
    on<FeeLedgerLoaded>(
      (e, emit) async => emit(
        state.copyWith(loading: false, payments: await _getPayments(personId)),
      ),
    );
    on<ReceiptRequested>(_onReceipt);
  }

  final String personId;
  final GetPersonPayments _getPayments;
  final CreateReceipt _createReceipt;
  final ShareFiles _shareFiles;

  Future<void> _onReceipt(
    ReceiptRequested e,
    Emitter<FeeLedgerState> emit,
  ) async {
    emit(state.copyWith(sharingReceipt: true));
    final path = await _createReceipt(
      CreateReceiptParams(
        schoolName: e.schoolName,
        account: e.account,
        payment: e.payment,
        allPayments: state.of(e.account.id),
      ),
    );
    await _shareFiles(ShareFilesParams([path]));
    emit(state.copyWith(sharingReceipt: false));
  }
}
