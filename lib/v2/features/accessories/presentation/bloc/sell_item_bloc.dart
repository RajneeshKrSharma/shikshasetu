import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/accessory.dart';
import '../../domain/usecases/accessories_usecases.dart';

sealed class SellItemEvent extends Equatable {
  const SellItemEvent();

  @override
  List<Object?> get props => const [];
}

final class SellItemStarted extends SellItemEvent {
  const SellItemStarted();
}

final class SellItemSubmitted extends SellItemEvent {
  const SellItemSubmitted(this.itemId, this.quantity);

  final String itemId;
  final int quantity;

  @override
  List<Object?> get props => [itemId, quantity];
}

class SellItemState extends Equatable {
  const SellItemState({
    this.status = ViewStatus.loading,
    this.failure,
    this.items = const [],
    this.busy = false,
    this.sold = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<AccessoryItem> items;
  final bool busy;
  final bool sold;

  SellItemState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<AccessoryItem>? items,
    bool? busy,
    bool? sold,
  }) => SellItemState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    items: items ?? this.items,
    busy: busy ?? this.busy,
    sold: sold ?? this.sold,
  );

  @override
  List<Object?> get props => [status, failure, items, busy, sold];
}

/// Sells something the school stocks to one student.
class SellItemBloc extends Bloc<SellItemEvent, SellItemState> {
  SellItemBloc({
    required String studentId,
    required String classId,
    required GetAccessoryItems getItems,
    required SellAccessory sellAccessory,
  }) : _studentId = studentId,
       _classId = classId,
       _items = getItems,
       _sell = sellAccessory,
       super(const SellItemState()) {
    on<SellItemStarted>(_onStarted);
    on<SellItemSubmitted>(_onSubmitted);
  }

  final String _studentId;
  final String _classId;
  final GetAccessoryItems _items;
  final SellAccessory _sell;

  Future<void> _onStarted(
    SellItemStarted e,
    Emitter<SellItemState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          items: await _items(GetItemsParams(classId: _classId)),
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    SellItemSubmitted e,
    Emitter<SellItemState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _sell(
        AccessorySale(
          studentId: _studentId,
          itemId: e.itemId,
          quantity: e.quantity,
        ),
      );
      emit(state.copyWith(busy: false, sold: true));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
